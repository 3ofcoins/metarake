require 'rake/task'
require 'rake/file_utils'

module MetaRake
  class Task < Rake::Task
    include FileUtils

    class << self
      attr_accessor :dir_targets_filter, :task_name_prefix, :build_command

      def dirs
        Dir['*/Rakefile'].map { |rakefile| File.dirname(rakefile) }
      end

      def dir_targets(dir)
        Dir.chdir dir do
          targets = []
          `rake -T`.lines.map { |ln| ln.split[1] }.each do |target|
            targets << target if case dir_targets_filter
                                 when nil    ; true
                                 when Regexp ; dir_targets_filter =~ target
                                 when Proc   ; dir_targets_filter.call(target)
                                 when String ; target.include?(dir_targets_filter)
                                 end
          end
          targets
        end
      end

      def discover!
        dirs.map do |dir|
          t = Rake.application.define_task(self, dir)
          t.comment = "Build everything in #{dir}"
          t
        end
      end
    end

    attr_accessor :targets
    attr_reader :dir, :targets

    def initialize(*args)
      super

      @dir = self.to_s
      @targets = self.class.dir_targets(dir)

      targets.each do |tgt|
        tgt_f = application.define_task(Rake::FileTask, File.join(dir, tgt))
        tgt_f.comment = "Build #{tgt} in #{dir}"
        tgt_f.enhance([self])
      end
    end

    def execute(args=nil)
      Dir.chdir(dir) do
        print "(in #{dir}/) "
        build_command = self.class.build_command || %w{rake}
        build_command = build_command.split if build_command.respond_to?(:split)
        sh *(build_command+targets)
        self.publish!
      end
    end

    def needed?
      !self.published?
    end

    def published?
      raise NotImplementedError
    end

    def publish!
      raise NotImplementedError
    end
  end
end
