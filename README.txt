= Interpolate

== Author

Adam Collins [adam.w.collins@gmail.com]


== Description

Library for generic Interpolation objects. Useful for such things as generating
linear motion between points (or arrays of points), multi-channel color
gradients, piecewise functions, or even just placing values within intervals.


== General Usage

Specify the interpolation as a Hash, where keys represent numeric points
along the gradient and values represent the known values along that gradient.

Here's an example for determining where, in a range of seven zones, each value
of a set falls into:

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


== Non-Numeric Gradients

For non-Numeric gradient value objects, you'll need to implement +interpolate+
for the class in question.  Here's an example using an RGB color gradient with
the help of the 'color' gem:

  require 'rubygems'
  require 'interpolate'
  require 'color'

  # we need to implement +interpolate+ for Color::RGB
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


== Array-based Interpolations

Aside from single value gradient points, you can interpolate over uniformly sized
arrays.  Between two interpolation points, let's say +a+ and +b+, the final result
will be +c+ where <tt>c[0]</tt> is the interpolation of <tt>a[0]</tt> and
<tt>b[0]</tt> and <tt>c[1]</tt> is interpolated between <tt>a[1]</tt> and
<tt>b[1]</tt> and so on up to <tt>c[n]</tt>.

Here is an example:

  require 'rubygems'
  require 'interpolate'
  require 'pp'

  # a non-linear set of multi-dimensional points;
  # perhaps the location of some actor in relation to time
  time_frames = {
    0 => [0, 0, 0],
    1 => [1, 0, 0],
    2 => [0, 1, 0],
    3 => [0, 0, 2],
    4 => [3, 0, 1],
    5 => [1, 2, 3],
    6 => [0, 0, 0]
  }

  path = Interpolation.new(time_frames)

  # play the actors positions in time increments of 0.25
  (0).step(6, 0.25) do |time|
    position = path.at(time)
    puts ">> At #{time}s, actor is at:"
    p position
  end


== Nested Array Interpolations

As long as each top level array is uniformly sized in the first dimension
and each nested array is uniformly sized in the second dimension (and so
on...), multidimensional interpolation point values will just work.

Here's an example of a set of 2D points being morphed:

  require 'rubygems'
  require 'interpolate'
  require 'pp'


  # a non-linear set of 2D vertexes;
  # the shape changes at each frame
  time_frames = {
    0 => [[0, 0], [1, 0], [2, 0], [3, 0], [4, 0]], # a horizontal line
    1 => [[0, 0], [1, 0], [3, 0], [0, 4], [0, 0]], # a triangle
    2 => [[0, 0], [1, 0], [1, 1], [0, 1], [0, 0]], # a square
    3 => [[0, 0], [1, 0], [2, 0], [3, 0], [4, 0]], # a horizontal line, again
    4 => [[0, 0], [0, 1], [0, 2], [0, 3], [0, 4]]  # a vertical line
  }


  paths = Interpolation.new(time_frames)

  # show the vertex positions in time increments of 0.25
  (0).step(4, 0.25) do |time|
    points = paths.at(time)
    puts ">> At #{time}s, points are:"
    p points
  end


== License

(The MIT License)

Copyright (c) 2008 Adam Collins [adam.w.collins@gmail.com]

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
