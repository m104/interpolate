#!/usr/bin/env ruby

$LOAD_PATH.unshift File.expand_path('../lib')

require 'test/unit'
require 'interpolate'


class InterpolationTest < Test::Unit::TestCase
  # acceptable delta; floating point values won't be exact
  DELTA = (1.0 - (1.2 - 0.1 - 0.1)) * 100.0

  def setup
    # NOTE changing these stock points will alter later tests!
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

    @dec_gradient = Interpolate::Points.new(decimal_points).freeze
    @array_gradient = Interpolate::Points.new(array_points).freeze

    @floor_func = Proc.new{|low, high, bal| low }
    @ceil_func  = Proc.new{|low, high, bal| high }
  end


  def test_point_counts
    assert_equal(11, @dec_gradient.points.size)
    assert_equal(3, @array_gradient.points.size)
  end


  def test_overlapping_points
    gradient = @dec_gradient.dup

    # one point added, non-overlapping
    gradient.merge!(11 => 1.1)
    assert_equal(12, gradient.points.size)

    # one point added, overlapping
    gradient.merge!(8 => 1.2)
    assert_equal(12, gradient.points.size)

    # verify overlapping point change
    assert_in_delta(1.2, gradient.at(8), DELTA)
  end


  def test_bad_point
    bad_points = {
      0   => 0,
      'h' => 3,  # non-Numeric key point not allowed
      2   => 5,
      3   => 10
    }

    assert_raise ArgumentError do
      gradient = Interpolate::Points.new(bad_points)
    end

    assert_raise ArgumentError do
      gradient = Interpolate::Points.new
      gradient.merge(bad_points)
    end
  end


  def test_lower_bounds
    assert_equal(0, @dec_gradient.at(0))
    assert_equal(0, @dec_gradient.at(-1))
    assert_equal(0, @dec_gradient.at(-10))
    assert_equal(0, @dec_gradient.at(-100))
  end


  def test_upper_bounds
    assert_equal(1, @dec_gradient.at(10))
    assert_equal(1, @dec_gradient.at(50))
    assert_equal(1, @dec_gradient.at(100))
    assert_equal(1, @dec_gradient.at(500))
  end


  def test_midpoints
    1.5.step(9.5, 1.0) do |point|
      assert_in_delta(point / 10.0, @dec_gradient.at(point), DELTA)
    end
  end


  def test_precision
    [
      0.12343232,
      0.35583519,
      0.54363462,
      0.67658245,
      0.89234124
    ].each do |point|
      assert_in_delta(point / 10.0, @dec_gradient.at(point), DELTA)
    end
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

    base = @dec_gradient.dup
    expanded = base.merge(new_points)

    assert_equal(0.5, base.at(5))
    assert_equal(0.5, expanded.at(5))

    assert_equal(1.0, base.at(15))
    assert_equal(1.5, expanded.at(15))
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

    base = @dec_gradient.dup
    expanded = base.merge(new_points)

    # should match (original range)
    assert_equal(0.5, base.at(5))
    assert_equal(0.5, expanded.at(5))

    # should be different (expanded range)
    assert_equal(1.0, base.at(15))
    assert_equal(1.5, expanded.at(15))
  end


  def test_array_values
    assert_equal([3, 30, 300], @array_gradient.at(150))
    assert_equal([5, 50, 500], @array_gradient.at(200))
    assert_equal([7.5, 75, 750], @array_gradient.at(350))
  end


  def test_frozen_points
    a = @array_gradient.at(200)
    assert_nothing_raised RuntimeError do
      a[0] = 10
      a[1] = 70
      a[2] = 100
    end
  end


  def test_stored_blend_function
    gradient = @dec_gradient.dup

    # floor function
    gradient.blend_with(&@floor_func)
    0.5.step(9.5, 1.0) do |point|
      assert_in_delta((point - 0.5) / 10.0, gradient.at(point), DELTA)
    end

    # ceiling
    gradient.blend_with(&@ceil_func)
    0.5.step(9.5, 1.0) do |point|
      assert_in_delta((point + 0.5) / 10.0, gradient.at(point), DELTA)
    end
  end


  def test_given_blend_function
    gradient = @dec_gradient.dup

    # floor
    0.5.step(9.5, 1.0) do |point|
      assert_in_delta((point - 0.5) / 10.0, gradient.at(point, &@floor_func), DELTA)
    end

    # ceiling
    0.5.step(9.5, 1.0) do |point|
      assert_in_delta((point + 0.5) / 10.0, gradient.at(point, &@ceil_func), DELTA)
    end
  end

end

