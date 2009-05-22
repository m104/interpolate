require 'rubygems'
require 'hoe'
$:.unshift(File.dirname(__FILE__) + "/lib")
require 'interpolate'

Hoe.new('Interpolate', Interpolation::VERSION) do |p|
  p.name = "interpolate"
  p.author = "Adam Collins"
  p.email = 'adam.w.collins@gmail.com'
  p.url = "http://interpolate.rubyforge.org"
  p.description = File.read('README.txt').delete("\r").split(/^== /)[2].chomp.chomp
  p.summary = p.description
  p.changes = File.read('History.txt').delete("\r").split(/^== /)[1].chomp
  p.remote_rdoc_dir = '' # Release to root
end

desc "Release and publish documentation"
task :repubdoc => [:release, :publish_docs]

