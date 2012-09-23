require "metarake/version"

# A Rake extension to build multiple separate projects, which are
# published outside the repository.
module MetaRake
  # Builder mixin modules for {MetaRake::Task}
  module Builder ; end

  # Publisher mixin modules for {MetaRake::Task}
  module Publisher ; end

  # Magic glue to be included in Publisher and Builder classes via extend.
  module Magic
    # Add modules' ClassMethods submodule to the class it's being included in.
    def included(base)
      base.extend(self::ClassMethods) if defined?(self::ClassMethods)
    end
  end
end

require 'metarake/task'
require 'metarake/builder/rake'
require 'metarake/publisher/directory'
