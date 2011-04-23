# Given a text file with the following structure:
#  OBJECTID,ORIG_FID,POINT_X,POINT_Y
#
# This script will output the following:
# ORIG_FID, POINT_X, POINT_Y, ANGLE_FROM_VERTICAL
#
# where the angles are measured in radians.
#
# Example usage:
#   pointlayer2angles point_layer_file.txt > angle_file.txt
#

module PointLayer

  class Point < Struct.new(:x, :y)
    class NotAPointError < StandardError; end;

    # Helper methods for adding and subtracting points from each other.
    # Point.new(1,3) + Point(1,1) == Point(2,4)
    ['-','+'].each do |operator|
      class_eval <<-"END"
        def #{operator}(point)
          raise Point::NotAPointError unless point.responds_like_a_point?
          Point.new(self.x.send("#{operator}".to_sym, point.x), self.y.send("#{operator}".to_sym, point.y))
        end  
      END
    end

    # Doesn't have to be a Point object, but it has to quack like one.
    def responds_like_a_point?
      respond_to?(:x) && respond_to?(:y)
    end
    
  end

  class Statistics
    def initializer()
      
    end
  end
end
