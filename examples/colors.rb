require 'rubygems'
require 'interpolate'
require 'color'

# a nice weathermap-style color gradient
points = {
  1 => Color::RGB::Cyan,
  2 => Color::RGB::Lime,
# 3 => ? (between Lime and Yellow; Interpolate will figure it out)
  4 => Color::RGB::Yellow,
  5 => Color::RGB::Orange,
  6 => Color::RGB::Red,
  7 => Color::RGB::Magenta,
  8 => Color::RGB::White,
}

# we need to implement a blending function in order for Interpolate::Points to
# work properly
#
# fortunately, Color::RGB includes +mix_with+, which is almost functionally
# identical to what we need

gradient = Interpolate::Points.new(points)
gradient.blend_with {|color, other, balance|
  color.mix_with(other, balance * 100.0)
}

# what are the colors of the gradient from 1 to 8
# in increments of 0.2?
(1).step(7, 0.2) do |value|
  color = gradient.at(value)
  puts "A value of #{value.round(3)} means #{color.html}"
end


