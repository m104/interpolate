require 'rubygems'
require 'interpolate'
require 'color'


# we need to implement :interpolate for Color::RGB
# in order for Interpolation to work
class Color::RGB
  def interpolate(other, balance)
    mix_with(other, balance * 100.0)
  end
end

# a nice weathermap-style color gradient
points = {
  0 => Color::RGB::White,
  1 => Color::RGB::Lime,
# 2 => ? (something between Lime and Yellow)
  3 => Color::RGB::Yellow,
  4 => Color::RGB::Orange,
  5 => Color::RGB::Red,
  6 => Color::RGB::Magenta,
  7 => Color::RGB::DarkGray
}


gradient = Interpolation.new(points)

# what are the colors of the gradient from 0 to 7
# in increments of 0.2?
(0).step(7, 0.2) do |value|
  color = gradient.at(value)
  puts "A value of #{value} means #{color.html}"
end

