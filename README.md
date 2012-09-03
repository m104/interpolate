# Interpolate

## Author

Adam Collins [adam@m104.us]


## Description

Interpolate is a library for generic linear interpolation objects. Useful for
such things as calculating linear motion between locations (or arrays of
locations), multi-channel color gradients, piecewise functions, or even just
placing values within intervals.


## General Usage

Interpolation generators can be created with the Interpolate::Points class,
given a Hash of "key points" and associated key values.

By default, the key values should be able to calculate their own blending
function (by defining an +interpolate+ instance method). Alternatively, the
Interpolate::Points object can be passed a block that takes three arguments: the
lower value, the higher value, and the balance ratio between the two.

Here's an example for placing values within one of seven buckets, accomplished
with the help of a `floor` blending function:

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



## Array-based Interpolate::Points

Aside from single value gradient points, you can interpolate over uniformly
sized arrays.  Between two interpolation points, let's say _a_ and _b_, the
final result will be _c_ where _c[0]_ is the interpolation of _a[0]_ and _b[0]_
and _c[1]_ is interpolated between _a[1]_ and _b[1]_ and so on up to _c[n]_.

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

    path = Interpolate::Points.new(time_frames)

    # play the actor's positions in time increments of 0.25
    (0).step(6, 0.25) do |time|
      position = path.at(time)
      puts ">> At #{time}s, actor is at:"
      p position
    end


## Nested Array Interpolate::Points

As long as each top level array is uniformly sized in the first dimension
and each nested array is uniformly sized in the second dimension (and so
on...), multidimensional interpolation point values will just work.

Here's an example of a set of 2D points being morphed:

    require 'rubygems'
    require 'interpolate'
    require 'pp'


    # a number of sets 2D vertices, each set corresponding to a particular
    # shape on the grid
    time_frames = {
      0 => [[0, 0], [1, 0], [2, 0], [3, 0], [4, 0]], # a horizontal line
      1 => [[0, 0], [1, 0], [3, 0], [0, 4], [0, 0]], # a triangle
      2 => [[0, 0], [1, 0], [1, 1], [0, 1], [0, 0]], # a square
      3 => [[0, 0], [1, 0], [2, 0], [3, 0], [4, 0]], # a horizontal line, again
      4 => [[0, 0], [0, 1], [0, 2], [0, 3], [0, 4]]  # a vertical line
    }


    paths = Interpolate::Points.new(time_frames)

    # show the vertex positions in time increments of 0.25
    (0).step(4, 0.25) do |time|
      points = paths.at(time)
      puts ">> At #{time}s, points are:"
      p points
    end



## Other Interpolations

For other classes of value objects, you'll need to implement a blending
function.  Here's an example using an RGB color gradient with the help of the
'color' gem:


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


## License

(The MIT License)

Copyright (c) 2008-2012 Adam Collins [adam@m104.us]

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
