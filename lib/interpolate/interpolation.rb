# Library for generic linear interpolation objects. Useful for such things as
# generating linear motion between points (or arrays of points), multi-channel
# color gradients, piecewise functions, or even just placing values within
# intervals.
#
# The only requirement is that each interpolation point value must be able to
# calculate an interpolation, given a "balance" ratio, with its neighbor
# value(s). Numeric objects and uniformly sized arrays are automatically endowed
# with this ability by this gem, but other classes will require an
# implementation of +interpolate+. See the example color.rb in the examples
# directory for a brief demonstration using Color::RGB objects provided by the
# 'color' gem.
#
# Interpolation objects are constructed with a Hash object, wherein each key is
# a Numeric and each value is an object which responds to +interpolate+.  Value
# objects are responsible for determining the resulting value based on its
# neighbor value and the balance ratio between the two points.
#
# At or below the lower bounds of the interpolation, the result will be equal to
# the value of the lower bounds interpolation point.  At or above the upper
# bounds of the interpolation, the result will be equal to the value of the
# upper bounds interpolation point.
#
#
# ==Author
#
# {Adam Collins}[mailto:adam@m104.us]
#
#
# ==License
#
# Licensed under the MIT license.
#

class Interpolation
  VERSION = '0.2.4'

  # creates an Interpolation object with Hash object that specifies
  # each point location (Numeric) and value (up to you)
  def initialize(points = {})
    @points = {}
    merge!(points)
  end

  # creates an Interpolation object from the receiver object,
  # merged with the interpolated points you specify
  def merge(points = {})
    Interpolation.new(points.merge(@points))
  end

  # merges the Interpolation points with the receiver object
  def merge!(points = {})
    @points.merge!(points)
    normalize_data
  end

  # returns the interpolated value of the receiver object at the point specified
  def at(point)
    # deal with the two out-of-bounds cases first
    if (point <= @min_point)
      return @data.first.last
    elsif (point >= @max_point)
      return @data.last.last
    end

    # go through the interpolation intervals, in order, to determine
    # into which this point falls
    1.upto(@data.length - 1) do |interval|
      left = @data.at(interval - 1)
      right = @data.at(interval)
      interval_range = left.first..right.first

      if (interval_range.include?(point))
        # what are the points in question?
        left_point = left.first.to_f
        right_point = right.first.to_f

        # what are the values in question?
        left_value = left.last
        right_value = right.last

        # span: difference between the left point and right point
        # balance: ratio of right point to left point
        span = right_point - left_point
        balance = (point.to_f - left_point) / span

        # catch the cases where the point in quesion is
        # on one of the interval's endpoints
        return left_value if (balance == 0.0)
        return right_value if (balance == 1.0)

        # otherwise, we need to interpolate
        return left_value.interpolate(right_value, balance)
      end
    end

    # we shouldn't get to this point
    raise "couldn't come up with a value for some reason!"
  end

  private

  def normalize_data # :nodoc:
    @data = @points.sort
    @min_point = @data.first.first
    @max_point = @data.last.first

    # make sure that all values respond_to? :interpolate
    @data.each do |point|
      value = point.last
      unless value.respond_to?(:interpolate)
        raise ArgumentError, "found an interpolation point that doesn't respond to :interpolate"
      end
    end
  end

end


