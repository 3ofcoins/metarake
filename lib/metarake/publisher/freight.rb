require 'mixlib/shellout'

# Metarake publisher that pushes `.deb` Debian packages to a Freight
# apt repository (https://github.com/rcrowley/freight).
module MetaRake::Publisher::Freight
  extend MetaRake::Magic

  module ClassMethods
    # Path of Freight configuration file
    attr_accessor :freight_conf_path

    # Distribution to use when publishing to / searching in the Freight repository
    attr_accessor :freight_distro

    # Command to run Freight (default: "freight")
    attr_accessor :freight_command

    # @return [Hash] freight config, plus some random shell environment.
    def freight_varlib
      @freight_varlib ||=
        begin
          raise "#{self}.freight_conf_path is not set" unless freight_conf_path
          conf = Mixlib::ShellOut.new('env', '-i', '/bin/sh', '-c', ". #{freight_conf_path} ; echo $VARLIB")
          conf.run_command.error!
          conf.stdout.strip
        end
    end
  end

  # True if all project targets are added to the repository
  def published?
    raise "#{self.class}.freight_distro is not set" unless self.class.freight_distro
    self.targets.map { |tgt| File.exist?(File.join(
          self.class.freight_varlib, 'apt', self.class.freight_distro,
          tgt)) }.all?
  end

  # Add files to the freight repo and publish them
  def publish!
    self.targets.each do |tgt|
      sh *(freight_command('add') + [
          File.join(self.to_s, tgt),
          "apt/#{self.class.freight_distro}" ])
    end
    sh *(freight_command('cache'))
  end

  private
  def freight_command(subcmd)
    cmd = self.class.freight_command || 'freight'
    cmd = cmd.split if cmd.respond_to?(:split)
    cmd + [ subcmd, '-c', self.class.freight_conf_path ]
  end
end
