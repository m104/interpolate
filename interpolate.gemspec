# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{interpolate}
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Adam Collins"]
  s.date = %q{2009-05-22}
  s.description = %q{Description

Library for generic Interpolation objects. Useful for such things as generating
linear motion between points (or arrays of points), multi-channel color
gradients, piecewise functions, or even just placing values within intervals.
}
  s.email = %q{adam@m104.us}
  s.extra_rdoc_files = [
    "LICENSE.txt",
     "README.markdown"
  ]
  s.files = [
    ".gitignore",
     "History.txt",
     "LICENSE.txt",
     "Manifest.txt",
     "Rakefile",
     "VERSION",
     "examples/arrays.rb",
     "examples/colors.rb",
     "examples/nested.rb",
     "examples/zones.rb",
     "lib/interpolate.rb",
     "lib/interpolate/interpolation.rb",
     "lib/interpolate/ruby_array.rb",
     "lib/interpolate/ruby_numeric.rb",
     "test/test_all.rb"
  ]
  s.homepage = %q{http://github.com/m104/interpolate}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{Create linear interpolations from key points and values}
  s.test_files = [
    "test/test_all.rb",
     "examples/arrays.rb",
     "examples/colors.rb",
     "examples/nested.rb",
     "examples/zones.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
