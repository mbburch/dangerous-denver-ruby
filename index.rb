require 'csv'

class Danger

  def parse_data(filename)
    data = []
    CSV.foreach(filename, headers: :true,
                          header_converters: :symbol) do |row|
      data << row.to_h
    end
    data
  end

  def group_by_attribute(filename, attribute, optional_filter)
    data = parse_data(filename)
    if optional_filter
      data = data.reject do |incident|
        incident[:offense_category_id] == optional_filter
      end
    end

    grouped = data.group_by do |incident|
      incident[attribute]
    end
    grouped.shift

    counted = grouped.map do |key, incidents|
      [key, incidents.count]
    end

    sorted = counted.sort_by do |incident_count|
      -incident_count[1]
    end

    puts sorted[0..4]

  end
end

danger = Danger.new
danger.group_by_attribute('data/traffic-accidents.csv', :incident_address, nil)
danger.group_by_attribute('data/traffic-accidents.csv', :neighborhood_id, nil)
danger.group_by_attribute('data/crime.csv', :neighborhood_id, 'traffic-accident')





