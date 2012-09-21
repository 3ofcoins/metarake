require 'fileutils'
require 'tmpdir'

require 'rspec/expectations'
require 'mixlib/shellout'


# Run each test in a temporary directory, initialized as a git repository
FileUtils::mkdir_p 'tmp'

Before do
  @orig_wd = Dir.getwd
  @tmp_wd = Dir.mktmpdir(nil, 'tmp')
  Dir.chdir(@tmp_wd)
end

After do
  Dir::chdir(@orig_wd)
  if ENV['DEBUG']
    puts "Keeping working directory #{@tmp_wd} for debugging"
  else
    FileUtils::rm_rf(@tmp_wd)
  end
  @tmp_wd = nil
end
