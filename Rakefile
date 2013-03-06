require "bundler/gem_tasks"
require "rake/testtask"
require "rbconfig"

DLEXT = RbConfig::CONFIG["DLEXT"]

file "ext/zopfli.#{DLEXT}" => Dir.glob("ext/*{.rb,.c}") do
  Dir.chdir("ext") do
     ruby "extconf.rb"
     sh "make"
  end
  cp "ext/zopfli.#{DLEXT}", "lib"
end

task :clean do
  files = Dir["ext/*"] - ["ext/extconf.rb", "ext/zopfli.c"]
  files+= ["ext/zopfli.#{DLEXT}", "lib/zopfli.#{DLEXT}"]
  rm_rf(files) unless files.empty?
end

Rake::TestTask.new do |t|
  t.warning = true
  t.verbose = true
end
task :test => "ext/zopfli.#{DLEXT}"
