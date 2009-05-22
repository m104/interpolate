#!/usr/bin/env ruby1.8 -w

require 'test/unit'
require 'lib/interpolate'


class InterpolationTest < Test::Unit::TestCase

  DELTA = 1e-7

  def setup
    decimal_points = {
      0 => 0,
      1 => 0.1,
      2 => 0.2,
      3 => 0.3,
      4 => 0.4,
      5 => 0.5,
      6 => 0.6,
      7 => 0.7,
      8 => 0.8,
      9 => 0.9,
      10 => 1
    }.freeze

    array_points = {
      100 => [1,   10,  100],
      200 => [5,   50,  500],
      500 => [10, 100, 1000]
    }.freeze

    @dec_gradient = Interpolation.new(decimal_points).freeze
    @array_gradient = Interpolation.new(array_points).freeze
  end


  def test_bad_points
    bad_points = {
      0 => 4.2,
      1 => "hello", # not allowed by default
      2 => 3.4,
      3 => 4.8
    }

    assert_raise ArgumentError do
      gradient = Interpolation.new(bad_points)
    end

  end

  def test_lower_bounds
    assert_equal(@dec_gradient.at(0), 0)
    assert_equal(@dec_gradient.at(-1), 0)
    assert_equal(@dec_gradient.at(-10), 0)
    assert_equal(@dec_gradient.at(-100), 0)
  end

  def test_upper_bounds
    assert_equal(@dec_gradient.at(10), 1)
    assert_equal(@dec_gradient.at(100), 1)
    assert_equal(@dec_gradient.at(1000), 1)
  end

  def test_midpoints
    assert_in_delta(@dec_gradient.at(1.5), 0.15, DELTA)
    assert_in_delta(@dec_gradient.at(2.5), 0.25, DELTA)
    assert_in_delta(@dec_gradient.at(3.5), 0.35, DELTA)
    assert_in_delta(@dec_gradient.at(4.5), 0.45, DELTA)
    assert_in_delta(@dec_gradient.at(5.5), 0.55, DELTA)
    assert_in_delta(@dec_gradient.at(6.5), 0.65, DELTA)
    assert_in_delta(@dec_gradient.at(7.5), 0.75, DELTA)
    assert_in_delta(@dec_gradient.at(8.5), 0.85, DELTA)
    assert_in_delta(@dec_gradient.at(9.5), 0.95, DELTA)
  end

  def test_precision
    assert_in_delta(@dec_gradient.at(1.5555), 0.15555, DELTA)
    assert_in_delta(@dec_gradient.at(2.5678), 0.25678, DELTA)
    assert_in_delta(@dec_gradient.at(3.5701), 0.35701, DELTA)
  end

  def test_gradient_merge
    new_points = {
      11 => 1.1,
      12 => 1.2,
      13 => 1.3,
      14 => 1.4,
      15 => 1.5,
      16 => 1.6,
      17 => 1.7,
      18 => 1.8,
      19 => 1.9,
      20 => 2
    }

    original = @dec_gradient.dup
    expanded = original.merge(new_points)

    assert_equal(original.at(5), 0.5)
    assert_equal(expanded.at(5), 0.5)

    assert_equal(original.at(15), 1)
    assert_equal(expanded.at(15), 1.5)
  end

  def test_gradient_merge!
    new_points = {
      11 => 1.1,
      12 => 1.2,
      13 => 1.3,
      14 => 1.4,
      15 => 1.5,
      16 => 1.6,
      17 => 1.7,
      18 => 1.8,
      19 => 1.9,
      20 => 2
    }

    original = @dec_gradient.dup
    expanded = original.dup
    expanded.merge!(new_points)

    assert_equal(original.at(5), 0.5)
    assert_equal(expanded.at(5), 0.5)

    assert_equal(original.at(15), 1)
    assert_equal(expanded.at(15), 1.5)
  end

  def test_array_values
    assert_equal(@array_gradient.at(150), [3, 30, 300])
    assert_equal(@array_gradient.at(200), [5, 50, 500])
    assert_equal(@array_gradient.at(350), [7.5, 75, 750])
  end
  
  def test_frozen_points
    a = @array_gradient.at(200)
    assert_nothing_raised RuntimeError do
      a[0] = 10
      a[1] = 70
      a[2] = 100
    end
  end

end

