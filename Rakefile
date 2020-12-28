require "bundler/setup"
require "bundler/gem_tasks"
require "rake/clean"
require "rake/testtask"
require "rbconfig"

DLEXT = RbConfig::CONFIG["DLEXT"]

file "ext/zopfli.#{DLEXT}" => Dir.glob("ext/*{.rb,.c,.h}") do
  Dir.chdir("ext") do
    ruby "extconf.rb"
    sh "make"
  end
  cp "ext/zopfli.#{DLEXT}", "lib"
end

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.test_files = FileList["test/**/*_test.rb"]
  t.warning = true
  t.verbose = true
end

CLEAN.include "ext/zopfli.#{DLEXT}", "lib/zopfli.#{DLEXT}"
CLEAN.include "ext/*"
CLEAN.exclude "ext/extconf.rb", "ext/zopfli.c"

task :test => "ext/zopfli.#{DLEXT}"
task :default => :test
