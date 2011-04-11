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


paths = Interpolation.new(time_frames)

# show the vertex positions in time increments of 0.25
(0).step(4, 0.25) do |time|
  points = paths.at(time)
  puts ">> At #{time}s, points are:"
  p points
end


