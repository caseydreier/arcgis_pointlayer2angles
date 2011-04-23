
# Given a text file with the following structure:
#  OBJECTID1,ORIG_FID1,POINT_X,POINT_Y
#  OBJECTID2,ORIG_FID1,POINT_X,POINT_Y
#
# This script will output the following:
# ORIG_FID,POINT_X1,POINT_Y1,POINT_X2,POINT_X2,RAD,DEG
#
# where the angles are measured in radians.
#
# Example usage:
#   pointlayer2angles point_layer_file.txt > angle_file.txt
#

require 'rdoc/usage'
def print_usage
  puts "Usage: \t#{$0} points_layer_file.txt > angle_file.txt" #$0 is the name of this file
end


# Make sure we have proper number of args for this file #
if ARGV.size < 1
  RDoc::usage(1)
end

module PointLayer

  # The FileReader class is responsible for reading in the contents of a PointsLayer file
  # and returning enough data to create Line objects.
  # There is only one public method beyond the initializer, which iterates through a provided
  # file and returns an array of hashes for consumption.
  # You can create subclass FileReader for any different type of file needed, and use it
  # in your own scripts to read in data.
  #
  # Usage:
  #    reader = PointLayer::FileReader.new(:file => 'point_data.txt')
  #    reader.each do |line_data|
  #      puts "(#{line_data[:x1]}, #{line_data[:y1]}), (#{line_data[:x2]}, #{line_data[:y2]})"
  #    end
  class FileReader

    # Options:
    #   x-index: The numeric column of data in the text file that corresponds to the x value of the point.
    #   y-index: The numeric column of data in the text file that corresponds to the y value
    #   group_index: The column that holds the object id of the line
    #   start_line: if the data file has a header, tell the class which line to start reading in data
    #   separator: defaults to a comma
    def initialize(options={})
      default_options = {:x_index => 2, :y_index => 3, :group_index => 1, :start_line => 1, :separator => ','}
      options = default_options.merge(options)
      options.each do |k,v|
        self.send("#{k}=",v)
      end
    end

    # Iterates through the file provided at object initialization.
    # Takes a block and exposes a variable inside it that contains the current
    # point data in a hash with the following structure:
    #    {:x1 => x1_value, :y1 => y1_value, :x2 => x2_value, :y2 => y2_value, :group => line_object_value}
    def each
      raise "Pass a block" unless block_given?
      counter = 0;
      last_fileline = nil
      File.open(file).each do |current_fileline|
        if counter >= start_line.to_i
          if counter%2 == 0 && (counter - start_line) > 0 # we needs groups of two to read in two points.
            line_data = get_line_data(last_fileline, current_fileline)
            yield(line_data)
          end
        end
        last_fileline = current_fileline
        counter = counter + 1
      end
      nil
    end

    private

    def get_line_data(line1, line2)
      line1_array = line1.split(separator).map {|item| item.to_s.strip.downcase }
      line2_array = line2.split(separator).map {|item| item.to_s.strip.downcase }
      raise "line mismatch #{line1_array.inspect}, #{line2_array.inspect}" unless line1_array[group_index] == line2_array[group_index]
      {
        :group => line1_array[group_index],
        :x1 => line1_array[x_index].to_f,
        :y1 => line1_array[y_index].to_f,
        :x2 => line2_array[x_index].to_f,
        :y2 => line2_array[y_index].to_f
       }
    end

    attr_accessor :file, :x_index, :y_index, :group_index, :start_line, :separator
  end

  class Line
    attr_accessor :point1, :point2

    # A line class needs two points to define it.
    def initialize(point1,point2)
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

end

# Extend numeric so we can convert to degrees readily.
class Numeric
  def to_degrees
    self * (180.0/Math::PI)
  end
end

points_file = ARGV[0]

# Read the File and output Line Data to STDOUT
points_data = PointLayer::FileReader.new(:file => points_file)

puts "ORIG_FID,POINT_X1,POINT_Y1,POINT_X2,POINT_X2,RAD,DEG"
points_data.each do |line_data|
  line = PointLayer::Line.new(PointLayer::Point.new(line_data[:x1], line_data[:y1]), PointLayer::Point.new(line_data[:x2], line_data[:y2]))
  puts "#{line_data[:group]},#{line_data[:x1]},#{line_data[:y1]},#{line_data[:x2]},#{line_data[:y2]},#{line.angle_to_vertical},#{line.angle_to_vertical.to_degrees}"
end
