$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'interpolate'

desc 'Build the gem'
task :build do
  system 'gem build interpolate.gemspec'
end

desc 'Release the gem'
task :release => :build do
  system "gem push interpolate-#{Interpolation::VERSION}"
end

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
end

task :default => :test

