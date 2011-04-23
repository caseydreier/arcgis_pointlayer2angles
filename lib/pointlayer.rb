# Ensure our load path knows about this directory.
$: << File.dirname(__FILE__)

require 'point'
require 'line'
require 'file_reader'
require 'class_extensions'

module PointLayer
end

# Extend the Numeric class with our custom extensions.
class Numeric
  include PointLayer::NumericClassExtensions
end