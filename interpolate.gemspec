# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path('../lib/', __FILE__)
require 'interpolate/version'

Gem::Specification.new do |gem|
  gem.required_rubygems_version = '>= 1.3.6'

  # Gem metadata
  gem.name        = 'interpolate'
  gem.version     = Interpolate::VERSION
  gem.platform    = Gem::Platform::RUBY

  gem.summary     = 'Create arbitrary interpolations from key points and values'
  gem.description = 'Interpolate is a library for generic linear interpolation objects. Useful for such things as calculating linear motion between locations (or arrays of locations), multi-channel color gradients, piecewise functions, or even just placing values within intervals.'

  gem.authors     = ['Adam Collins']
  gem.email       = ['adam@m104.us']
  gem.homepage    = 'http://github.com/m104/interpolate'

  # Dependencies
  gem.require_paths = ['lib']
  #gem.add_development_dependency "rspec"
  #gem.add_runtime_dependency "whatever"

  # Manifest
  all_files      = `git ls-files`.split("\n")
  gem.files      = all_files
  gem.test_files = all_files.grep(/^test\//)
end

