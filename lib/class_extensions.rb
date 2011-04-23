module PointLayer
  module NumericClassExtensions
    # Extend numeric so we can convert to degrees readily.
    def to_degrees
      self * (180.0/Math::PI)
    end
  end
end