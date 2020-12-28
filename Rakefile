require "bundler/setup"
require "bundler/gem_tasks"
require "rake/clean"
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

CLEAN.include "ext/zopfli.#{DLEXT}", "lib/zopfli.#{DLEXT}"
CLEAN.include "ext/*"
CLEAN.exclude "ext/extconf.rb", "ext/zopfli.c"

RSpec::Core::RakeTask.new(:spec)
task :spec => "ext/zopfli.#{DLEXT}"
task :default => :spec
