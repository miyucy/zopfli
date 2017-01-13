require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rbconfig"

DLEXT = RbConfig::CONFIG["DLEXT"]

file "ext/zopfli.#{DLEXT}" => Dir.glob("ext/*{.rb,.c,.h}") do
  Dir.chdir("ext") do
    ruby "extconf.rb"
    sh "make"
  end
  cp "ext/zopfli.#{DLEXT}", "lib"
end

task :clean do
  files = Dir["ext/*"] - ["ext/extconf.rb", "ext/zopfli.c"]
  files += ["ext/zopfli.#{DLEXT}", "lib/zopfli.#{DLEXT}"]
  rm_rf(files) unless files.empty?
end

RSpec::Core::RakeTask.new(:spec)
task :spec => "ext/zopfli.#{DLEXT}"
task :default => :spec
