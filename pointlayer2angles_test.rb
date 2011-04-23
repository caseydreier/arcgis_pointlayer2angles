require 'test/unit'
require 'pointlayer2angles'

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