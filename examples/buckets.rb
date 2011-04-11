require 'rubygems'
require 'interpolate'

# min_value => bucket
buckets = {
  0.000 => 1,
  0.427 => 2,
  1.200 => 3,
  3.420 => 4,
  27.50 => 5,
  45.20 => 6,
  124.4 => 7,
}

bucketizer = Interpolation.new(buckets)

values = [
  -20.2,
  0.234,
  65.24,
  9.234,
  398.4,
  4000
]

values.each do |value|
  bucket = bucketizer.at(value).floor
  puts "A value of #{value} falls into bucket #{bucket}"
end



