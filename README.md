# Metarake

Metarake is a Rake extension to build multiple separate projects,
which are published outside the repository.

Usually, Metarake's Rakefile lives in the directory that contains
subdirectories with separate projects, each with their own build
script (`Rakefile`, `Makefile`, `build.xml`, you name it). What
metarake does, is:

 - Discover the projects,
 - Discover their build targets,
 - Verify whether those targets are already published,
 - Build all unpublished targets and publish them.

Each of these steps can be customized. A sample custom class is
provided for building Debian packages and publishing them in an Apt
repository.

## Installation

Add this line to your application's Gemfile:

    gem 'metarake'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install metarake

## Usage

Sample rakefiles are included in the `examples/` directory, and
detailed API documentation can be found at
http://rdoc.info/github/3ofcoins/metarake/.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
