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
end