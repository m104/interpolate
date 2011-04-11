require 'rubygems'
require 'color'
require 'interpolate'

# we need to implement +interpolate+ for Color::RGB
# in order for Interpolation to work properly
#
# fortunately, Color::RGB includes +mix_with+, which is almost
# functionally identical to +interpolate+
class Color::RGB
  def interpolate(other, balance)
    mix_with(other, balance * 100.0)
  end
end

# a nice weathermap-style color gradient
points = {
  1 => Color::RGB::White,
  2 => Color::RGB::Lime,
# 3 => ? (between Lime and Yellow; Interpolate will figure it out)
  4 => Color::RGB::Yellow,
  5 => Color::RGB::Orange,
  6 => Color::RGB::Red,
  7 => Color::RGB::Magenta
}

gradient = Interpolation.new(points)

# what are the colors of the gradient from 1 to 7
# in increments of 0.2?
(1).step(7, 0.2) do |value|
  color = gradient.at(value)
  puts "A value of #{value} means #{color.html}"
end


