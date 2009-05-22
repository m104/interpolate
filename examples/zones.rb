require 'rubygems'
require 'interpolate'

points = {
  0.000 => 0,
  0.427 => 1,
  1.200 => 2,
  3.420 => 3,
  27.50 => 4,
  45.20 => 5,
  124.4 => 6,
}

zones = Interpolation.new(points)

values = [
  -20.2,
  0.234,
  65.24,
  9.234,
  398.4,
  4000
]

values.each do |value|
  zone = zones.at(value).floor
  puts "A value of #{value} falls into zone #{zone}"
end
