require 'rake/task'
require 'rake/file_utils'

module MetaRake
  # An abstract Rake task that builds a project if it is not
  # published.  The individual methods need to be implemented in
  # a subclass. Concrete implementation are provided in
  # {MetaRake::Builder} and {MetaRake::Publisher} modules. Complete
  # sample Rakefiles are included in the {file:examples examples
  # directory}.
  class Task < Rake::Task
    include FileUtils

    class << self
      # @abstract Discover projects to build.
      # @return [Enumerable] discovered project names
      def projects
        raise NotImplementedError
      end

      # Discover projects and build tasks for them.
      #
      # @return [Enumerable] tasks defined for each of projects returned by {#projects}
      # @see #projects
      def discover!
        projects.map do |prj|
          t = Rake.application.define_task(self, prj)
          t.comment = "Build #{prj}"
          t
        end
      end
    end

    # @abstract Check whether the project has been published
    # @return [TrueClass, FalseClass] True if project is already published and doesn't need to be rebuilt.
    def published?
      raise NotImplementedError
    end

    # @abstract Publishes the project
    # Runs after the project has been built in order to publish the build artifacts.
    def publish!
      raise NotImplementedError
    end

    # @abstract Array of project's targets
    def targets
      raise NotImplementedError
    end

    # Automatically add action calling the {#build} method if it's dtefined.
    def initialize(*args)
      super
      @actions << lambda { |t| t.build } if self.respond_to?(:build)
    end

    # Project is "needed" only if it's not published.
    def needed?
      !self.published?
    end

    # Publish the project after executing the task.
    def execute(*args)
      super
      if application.options.dryrun
        $stderr.puts "** Publish (dry run) #{name}"
      else
        self.publish!
      end
    end
  end
end
