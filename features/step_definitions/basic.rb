Given(/^subdirector(?:y|ies) ("[^"]*"(?:, "[^"]*")*)$/) do |subdirectories|
  subdirectories.
    split(/,\s*/).
    map { |sd| sd.gsub(/^"|"$/, '') }.
    each { |sd| FileUtils::mkdir_p(sd) }
end

Given /^following files:$/ do |table|
  table.hashes.each do |ff|
    FileUtils::mkdir_p(File.dirname(ff[:path]))
    if ff[:source]
      FileUtils::cp(File.join(@orig_wd, ff[:source]), ff[:path])
    elsif ff[:content]
      File.open(ff[:path], 'w') { |f| f.puts(ff[:content]) }
    else
      FileUtils::touch(ff[:path])
    end
  end
end

When /^I run "(.*?)"$/ do |command|
  @shellout = Mixlib::ShellOut.new(command)
  @shellout.run_command
end

Then /^the command succeeds$/ do
  @shellout.error!
end

Then /^following files exist:$/ do |table|
  table.hashes.each do |ff|
    File.exist?(ff[:path]).should be true
    File.read(ff[:path]).should include ff[:content] if ff[:content]
  end
end

Then /^following files do not exist:$/ do |table|
  table.hashes.each do |ff|
    File.exist?(ff[:path]).should be false
  end
end

