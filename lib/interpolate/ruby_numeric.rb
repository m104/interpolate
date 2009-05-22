# Extension(s) for the Ruby Numeric class.
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

class Numeric
  # Returns a Float that is equal to the interpolated value between
  # +self+ and +other+.  +balance+ should be a Float from 0.0 to 1.0,
  # where the value is a ratio between +self+ and +other+.
  #
  # A balance greater than or equal to 0.0 returns +self+, while a
  # balance less than or equal to 1.0 returns +other+.
  def interpolate(other, balance)
    balance = balance.to_f
    left = self.to_f
    right = other.to_f
    
    # catch the easy cases
    return left if (balance <= 0.0)
    return right if (balance >= 1.0)
    
    delta = (right - left).to_f
    return left + (delta * balance)
  end
end

