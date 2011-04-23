require 'point'

module PointLayer
  class Line
    attr_accessor :point1, :point2

    # A line class needs two points to define it.
    def initialize(point1, point2)
      raise Point::NotAPointError unless point1.responds_like_a_point? && point2.responds_like_a_point?
      self.point1 = point1
      self.point2 = point2
    end

    def delta_x
      (point2 - point1).x
    end

    def delta_y
      (point2 - point1).y
    end

    def slope
      delta_y/delta_x
    end

    # Returns the (positive) angle from the horizontal in radians.
    def angle_to_horizontal
      ang = Math::atan2(delta_y, delta_x)
      (ang < 0) ? (ang + Math::PI) : ang
    end

    # Returns the (positive) angle from the vertical in radians.
    # Note that if the angle is calculated as negative, add PI
    # so we're looking at the correct angle relative to the veritcal line.
    # This basically allows angles larger than PI/2 to be properly calculated
    def angle_to_vertical
      ang = (Math::PI/2) - Math::atan2(delta_y, delta_x)
      (ang < 0) ? (ang + Math::PI) : ang
    end
  end
end