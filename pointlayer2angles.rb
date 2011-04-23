#!/usr/bin/env ruby
# 
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
require 'lib/pointlayer.rb'
require 'rdoc/usage'
def print_usage
  puts "Usage: \t#{$0} points_layer_file.txt > angle_file.txt" #$0 is the name of this file
end

# Make sure we have proper number of args for this file #
if ARGV.size < 1
  RDoc::usage(1)
end

points_file = ARGV[0]

# Read the File and output Line Data to STDOUT
points_data = PointLayer::FileReader.new(:file => points_file)

puts "ORIG_FID,POINT_X1,POINT_Y1,POINT_X2,POINT_X2,RAD,DEG"
points_data.each do |line_data|
  line = PointLayer::Line.new(PointLayer::Point.new(line_data[:x1], line_data[:y1]), PointLayer::Point.new(line_data[:x2], line_data[:y2]))
  puts "#{line_data[:group]},#{line_data[:x1]},#{line_data[:y1]},#{line_data[:x2]},#{line_data[:y2]},#{line.angle_to_vertical},#{line.angle_to_vertical.to_degrees}"
end