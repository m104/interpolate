# Extension(s) for the Ruby Array class.
#
#
# ==Author
#
# {Adam Collins}[mailto:adam.w.collins@gmail.com]
#
#
# ==License
#
# Licensed under the MIT license.
#

class Array
  # Returns a new Array in which each element is the interpolated value
  # between +self+ and +other+.  +balance+ should be a Float from 0.0
  # to 1.0 where the value is a ratio between +self+ and +other+.  +self+
  # and +other+ should be arrays of equal, non-zero length.
  #
  # Between two interpolation points, let's say +a+ and +b+, the final result
  # will be +c+ where <tt>c[0]</tt> is the interpolation of <tt>a[0]</tt> and
  # <tt>b[0]</tt> and <tt>c[1]</tt> is interpolated between <tt>a[1]</tt> and
  # <tt>b[1]</tt> and so on, up to <tt>c[c.length - 1]</tt>.
  #
  # This method is intentionally abstract to allow for the interpolation
  # of nested arrays.  In this case, both arrays need to have the same array
  # structure (same number of dimensions, equal length in each dimension),
  # but the contents can, of course, be different.
  #
  # A balance less than or equal to 0.0 returns +self+, while a
  # balance greater than or equal to 1.0 returns +other+.
  def interpolate(other, balance)
    if (self.length < 1) then
      raise ArgumentError, "cannot interpolate empty array"
    end

    if self.length != other.length then
      raise ArgumentError, "cannot interpolate between arrays of different length"
    end

    # catch the easy cases
    return self.dup if (balance <= 0.0)
    return other.dup if (balance >= 1.0)

    final = Array.new

    self.each_with_index do |value, index|
      unless value.respond_to? :interpolate then
        raise "array element does not respond to :interpolate"
      end

      final[index] = value.interpolate(other[index], balance)
    end

    final
  end
end
