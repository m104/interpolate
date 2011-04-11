require 'jeweler'
require 'rake'

require './lib/interpolate/interpolation'

Jeweler::Tasks.new do |g|
  doc_sections = File.read('README.md').delete("\r").split(/^## /)

  g.name = 'interpolate'
  g.summary = 'Create linear interpolations from key points and values'
  g.description = doc_sections[2].chomp.chomp # mmmm... tasty!
  g.email = 'adam@m104.us'
  g.homepage = "http://github.com/m104/interpolate"
  g.authors = ["Adam Collins"]
  g.version = Interpolation::VERSION
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.test_files = FileList.new('test/test_*.rb') do |list|
    list.exclude 'test/test_helper.rb'
  end
  test.libs << 'test'
  test.verbose = true
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = 'interpolate'
  rdoc.rdoc_files.include('README.markdown')
  rdoc.rdoc_files.include('lib/**/*.rb')
end


