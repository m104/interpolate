# Interpolate is a library for generic linear interpolation objects. Useful for
# such things as calculating linear motion between locations (or arrays of
# locations), multi-channel color gradients, piecewise functions, or even just
# placing values within intervals.
#
# Interpolation generators can be created with the Interpolate::Points class,
# given a set of interpolation "key points" and associated key values. By
# default, the key values should be able to calculate their own blending
# function (by defining an +interpolate+ instance method). Alternatively, the
# Interpolate::Points object can be passed a block that takes three arguments:
# the lower value, the higher value, and the balance ratio between the two.
#
# For the balance ratio, 0.0 means 100% of the lower value and a balance ratio
# of 1.0 means 100% of the higher value. A balance ratio of 0.5 means that the
# Interpolate::Points object has determined that the interpolated value should
# be a 50%/50% mixture of the lower and higher values.  It is up to the blending
# function to determine how to calculate the interpolated value.
#
# A Interpolate::Points objects is constructed with a Hash object, wherein each
# key is a Numeric and each value is an object (which itself may respond to
# +interpolate+). If any of the value objects do not respond to +interpolate+, a
# blending function (+blend_with+) must be used to determine the interpolated
# values.
#
# The default blending function, Interpolate::Points::DEFAULT_BLEND, simply
# calls the +interpolate+ method on the lower key value with the arguments of 1)
# the higher key value and 2) the balance ratio.
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

module Interpolate

  class Points
    attr_reader :points

    # default blending function, which delegates to the :interpolate method on
    # each given value object
    DEFAULT_BLEND = lambda { |value, other, balance|
      unless value.respond_to? :interpolate
        raise "found an object (#{value.inspect}) that doesn't respond to :interpolate"
      end
      value.interpolate(other, balance)
    }

    # creates an Interpolate::Points object with an optional Hash object that
    # specifies key points (Numeric) and associated value objects
    #
    # the blend_with Proc can also be given when creating a new
    # Interpolate::Points object
    def initialize(points = {}, &block)
      @points = {}
      @blend_with = block
      merge!(points)
    end

    # define the blending function to use with this Interpolate::Points object
    #
    # setting this to +nil+ will reset the blending behavior back to calling
    # the default blending function
    def blend_with(&block)
      @blend_with = block
    end

    # returns a new Interpolate::Points object with the given key points merged
    # with the original points
    def merge(points = {})
      Points.new(points.merge(@points))
    end

    # merges the given key points with the original points
    def merge!(points = {})
      # points must be a Hash
      raise ArgumentError, "key points must be a Hash object" unless points.is_a? Hash
      # ensure the points are all keyed Numeric-ally
      points.each do |key, value|
        raise ArgumentError, "found a point key that is not a Numeric object: #{key.inspect}" unless key.is_a? Numeric
      end

      @points.merge!(points)
      normalize_data
      self
    end

    # returns the interpolated value at the Numeric point specified, optionally
    # using a given block as the blending function
    #
    # if no key points have been specified, the return value is +nil+
    #
    # if one key point has been specified, the return value is the value
    # of that key point
    #
    # if the given point falls outside the interpolation key range (lower than
    # the lowest key point or higher than the highest key point), the nearest
    # point value is used; in other words, no extrapolation is performed
    #
    # otherwise, the interpolated value is calculated in accordance with the
    # first of:
    #
    #   * the given block
    #   * the stored blending function, :blend_with
    #   * a call to :interpolate on a key value object
    #
    def at(point, &block)
      # obvious cases first
      if @sorted.empty?
        # no key points
        return nil
      elsif @sorted.size == 1
        # one key point
        return @sorted.first.last
      end

      # out-of-bounds cases next
      if point <= @min_point
        # lower than lowest key point
        return @sorted.first.last
      elsif point >= @max_point
        # higher than highest key point
        return @sorted.last.last
      end

      # binary search to find the right interpolation key point/value interval
      left = 0
      right = @sorted.length - 2 # highest point will be included
      low_point = nil
      low_value = nil
      high_point = nil
      high_value = nil

      while left <= right
        middle = (right - left) / 2 + left

        (low_point, low_value) = @sorted[middle]
        (high_point, high_value) = @sorted[middle + 1]

        break if low_point <= point and point <= high_point

        if point < low_point
          right = middle - 1
        else
          left = middle + 1
        end
      end

      # determine the balance ratio
      span = high_point - low_point
      balance = (point.to_f - low_point) / span

      # choose and call the blending function
      blend = block || @blend_with || DEFAULT_BLEND
      blend.call(low_value, high_value, balance)
    end

    alias :[] :at

    private

    def normalize_data # :nodoc:
      @sorted = @points.sort
      unless @sorted.empty?
        @min_point = @sorted.first.first
        @max_point = @sorted.last.first
      end
    end

  end # class Points

end # module Interpolate


