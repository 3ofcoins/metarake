require 'rake/file_utils'

module MetaRake::Publisher::Directory
  extend MetaRake::Magic
  include FileUtils

  module ClassMethods
    # Path, in which the targets are published.
    attr_accessor :publish_path
  end

  # @return class attribute @publish_path
  # @raises @ValueError if `publish_path` is unset
  def publish_path
    self.class.publish_path or raise ValueError, "#{self.class}.publish_path is not set"
  end

  # True if all project targets are copied to the publish path
  def published?
    self.targets.map { |tgt| File.exist?(File.join(
          self.publish_path, self.to_s, tgt)) }.all?
  end

  # Copy all the project targets to the publish path
  def publish!
    mkdir_p File.join(self.publish_path, self.to_s)
    self.targets.each do |tgt|
      install File.join(self.to_s, tgt), File.join(self.publish_path, self.to_s, tgt)
    end
  end
end
