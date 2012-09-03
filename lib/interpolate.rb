require 'interpolate/base'
require 'interpolate/add/core'

# deprecated as of 0.3.0; use Interpolate::Points instead
class Interpolation
  class << self
    # metaclass :new override method to return an instance of
    # Interpolate::Points
    def new(*args)
      warn "::Interpolation has been deprecated as of 0.3.0; use Interpolate::Points"
      Interpolate::Points.new(*args)
    end
  end
end

