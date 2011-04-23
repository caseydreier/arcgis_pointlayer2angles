require 'test/unit'

# Make sure our lib is in our load path
$: << File.expand_path(File.dirname(__FILE__) + "/../lib")

require 'pointlayer'

class NumericTest < Test::Unit::TestCase
  # Test our extentions of the Math module

  def test_to_degrees
    assert_equal 90.0, (Math::PI/2).to_degrees
    assert_equal 0, 0.to_degrees
  end
end

class PointLayer::LineTest < Test::Unit::TestCase
  def test_new_line
    point1 = PointLayer::Point.new(1,1)
    point2 = PointLayer::Point.new(2,2)
    line   = PointLayer::Line.new(point1, point2)
    assert_equal line.point1, point1
    assert_equal line.point2, point2
  end

  def test_delta_x
    point1 = PointLayer::Point.new(1,1)
    point2 = PointLayer::Point.new(2,2)
    line   = PointLayer::Line.new(point1, point2)
    assert_equal 1, line.delta_x

    point1 = PointLayer::Point.new(-5.0,-2.0)
    point2 = PointLayer::Point.new(-3.0,0.0)
    line   = PointLayer::Line.new(point1, point2)
    assert_equal 2, line.delta_x
  end

  def test_delta_y
    point1 = PointLayer::Point.new(1,1)
    point2 = PointLayer::Point.new(2,2)
    line   = PointLayer::Line.new(point1, point2)
    assert_equal 1, line.delta_y

    point1 = PointLayer::Point.new(-5.0,-2.0)
    point2 = PointLayer::Point.new(-3.0,0.0)
    line   = PointLayer::Line.new(point1, point2)
    assert_equal 2, line.delta_y
  end

  def test_slope
    point1 = PointLayer::Point.new(1,1)
    point2 = PointLayer::Point.new(2,2)
    line   = PointLayer::Line.new(point1, point2)
    assert_equal 1, line.slope
  end

  def test_angle_to_horizontal
    # 45 deg line
    point1 = PointLayer::Point.new(1,1)
    point2 = PointLayer::Point.new(2,2)
    line   = PointLayer::Line.new(point1, point2)
    assert_equal (Math::PI/4), line.angle_to_horizontal

    # Vertical line
    point1 = PointLayer::Point.new(1,1)
    point2 = PointLayer::Point.new(1,2)
    line   = PointLayer::Line.new(point1, point2)
    assert_equal (Math::PI/2), line.angle_to_horizontal

    # Horizontal line
    point1 = PointLayer::Point.new(1,1)
    point2 = PointLayer::Point.new(2,1)
    line   = PointLayer::Line.new(point1, point2)
    assert_equal 0, line.angle_to_horizontal

    # 60 deg
    point1 = PointLayer::Point.new(0.0,0.0)
    point2 = PointLayer::Point.new((1.0/2.0),(Math::sqrt(3)/2))
    line   = PointLayer::Line.new(point1, point2)
    assert_equal (Math::PI/3), line.angle_to_horizontal

    # 120 deg
    point1 = PointLayer::Point.new(0.0,0.0)
    point2 = PointLayer::Point.new(-(1.0/2.0),(Math::sqrt(3)/2))
    line   = PointLayer::Line.new(point1, point2)
    expected = 2.0 * Math::PI / 3.0
    # Not exactly equal due some some issues with Ruby's math library.
    # Diffirence is miniscule on the scale we care about here, so assert
    # it's miniscule.
    assert (expected - line.angle_to_horizontal).abs < 5e-15
  end

  def test_angle_to_vertical
    # 45 deg line
    point1 = PointLayer::Point.new(1,1)
    point2 = PointLayer::Point.new(2,2)
    line   = PointLayer::Line.new(point1, point2)
    assert_equal (Math::PI/4), line.angle_to_vertical

    # Vertical line
    point1 = PointLayer::Point.new(1,1)
    point2 = PointLayer::Point.new(1,2)
    line   = PointLayer::Line.new(point1, point2)
    assert_equal 0, line.angle_to_vertical

    # Horizontal line
    point1 = PointLayer::Point.new(1,1)
    point2 = PointLayer::Point.new(2,1)
    line   = PointLayer::Line.new(point1, point2)
    assert_equal (Math::PI/2), line.angle_to_vertical

    # 60 deg (to horizontal)
    point1 = PointLayer::Point.new(0.0,0.0)
    point2 = PointLayer::Point.new((1.0/2.0),(Math::sqrt(3)/2))
    line   = PointLayer::Line.new(point1, point2)
    # Not exactly equal due some some issues with Ruby's math library.
    # Diffirence is miniscule on the scale we care about here, so assert
    # it's miniscule.
    assert ((Math::PI/6) - line.angle_to_vertical).abs < 5e-15

    # Line with negative x pos.
    #                 |
    #           *     |
    #                 |
    #   --------------*--------------
    #                 |
    #                 |
    #                 |
    # Should calculate this as 135 degrees, not -45 deg from vertical
    point1 = PointLayer::Point.new(0,0)
    point2 = PointLayer::Point.new(-1, 1)
    line   = PointLayer::Line.new(point1, point2)
    assert_equal (3.0 * Math::PI/4.0), line.angle_to_vertical

    # Line with negative x and y pos.
    #                 |
    #                 |
    #                 |
    #   --------------|--------------
    #               * |
    #           *     |
    #                 |
    point1 = PointLayer::Point.new(-1,-1)
    point2 = PointLayer::Point.new(-2, -2)
    line   = PointLayer::Line.new(point1, point2)
    assert_equal 225, line.angle_to_vertical.to_degrees

    # Line with pos x and neg y.
    #                 |
    #                 |
    #                 |
    #   --------------|--------------
    #                 | *
    #                 |   *
    #                 |
    point1 = PointLayer::Point.new(2, -2)
    point2 = PointLayer::Point.new(1,-1)
    line   = PointLayer::Line.new(point1, point2)
    assert_equal 135.0, line.angle_to_vertical.to_degrees
  end


end


class PointLayer::PointTest < Test::Unit::TestCase
  def test_new_point
    point = PointLayer::Point.new(2,1)
    assert_equal 2, point.x
    assert_equal 1, point.y
  end

  def test_addition
    point1 = PointLayer::Point.new(1,1)
    point2 = PointLayer::Point.new(2,2)
    point3 = point1 + point2
    assert_equal 3, point3.x
    assert_equal 3, point3.y

    point1 = PointLayer::Point.new(-1.0,1)
    point2 = PointLayer::Point.new(1.0, -10)
    point3 = point1 + point2
    assert_equal 0, point3.x
    assert_equal -9, point3.y
  end

  def test_subtraction
    point1 = PointLayer::Point.new(1,1)
    point2 = PointLayer::Point.new(2,2)
    point3 = point1 - point2
    assert_equal -1, point3.x
    assert_equal -1, point3.y

    point1 = PointLayer::Point.new(-1.0,1)
    point2 = PointLayer::Point.new(1.0, -10)
    point3 = point1 - point2
    assert_equal -2.0, point3.x
    assert_equal 11, point3.y
  end

end