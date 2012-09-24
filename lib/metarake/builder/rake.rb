require 'mixlib/shellout'

module MetaRake::Builder::Rake
  extend MetaRake::Magic

  module ClassMethods
    # Command that should be used to run Rake for projects (default: `'rake'`)
    attr_accessor :rake_command

    # Filter for discovered target names.
    # @see Metarake::Builder::Rake#project_target?
    attr_accessor :target_filter

    # Projects are subdirectories that have a Rakefile.
    def projects
      Dir['*/Rakefile'].map { |rakefile| File.dirname(rakefile) }
    end
  end

  # Create a sub-task for each of project targets.
  def initialize(*args)
    super

    self.targets.each do |tgt|
      tgt_f = application.define_task(Rake::FileTask, File.join(self.to_s, tgt))
      tgt_f.comment = "Build #{tgt} in #{self}"
      tgt_f.enhance([self])
    end
  end

  # Decide, whether a target listed by `rake -T` is a project target.
  #
  # Default implementation decides based on
  # {MetaRake::Builder::Rake.target_filter}, based on its
  # type. When target_filter is a:
  # 
  # [nil] All targets returned by `rake -T` are project targets (default)
  # [Regex] Targets whose names match the regular expression are
  #         project targets
  # [String] Targets whose names include the string are project targets
  # [Proc] It is called with a target name as an argument; if it returns
  #        true, the target is a project target.
  def project_target?(target_name)
    case self.class.target_filter
    when nil    ; true
    when Regexp ; self.class.target_filter =~ target
    when Proc   ; self.class.target_filter.call(target)
    when String ; target.include?(self.class.target_filter)
    end
  end

  # @return [Array] Project target names, as returned by `rake -T`
  #                 and filtered by {#project_target?}
  def targets
    @targets ||= 
      begin
        cmd = Mixlib::ShellOut.new(rake_command+['-T'], :cwd => self.to_s)
        cmd.run_command.error!
        cmd.stdout.lines.
          map { |ln| tgt=ln.split[1] ; tgt if self.project_target?(tgt) }.
          compact
      end
  end

  def build
    Dir.chdir(self.to_s) do
      print "[#{self}/] "
      sh *(rake_command+targets)
    end
  end

  private
  def rake_command
    cmd = self.class.rake_command || 'rake'
    cmd = cmd.split if cmd.respond_to?(:split)
    cmd
  end
end # MetaRake::Builder::Rake
