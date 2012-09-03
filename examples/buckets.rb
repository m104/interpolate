require 'rubygems'
require 'interpolate'

# min_value => bucket
buckets = {
  0.000 => 1,
  0.500 => 2,
  1.250 => 3,
  7.725 => 4,
  28.85 => 5,
  50.00 => 6,
  127.5 => 7
}

values = [
  -20.2,
  0.234,
  65.24,
  9.234,
  398.4,
  4000
]

# using Interpolate::Points to place values within discrete intervals
bucketizer = Interpolate::Points.new(buckets)
# the blending function will mimic the mathematical floor function
bucketizer.blend_with {|low, high, balance| low }

values.each do |value|
  bucket = bucketizer.at(value).floor
  puts "A value of #{value} falls into bucket #{bucket}"
end



