#!/usr/bin/env ruby

require 'rubygems'
require 'marmalade'

class TestCase
  NORTH = [0,-1]
  SOUTH = [0,1]
  EAST  = [1,0]
  WEST  = [-1,0]

  def get_elevation_at elevations, coord, direction
    target = [coord[0] + direction[0], coord[1] + direction[1]]
    return {:elev => 100000, :coord => target} if target[0] < 0 || target[0] >= elevations[0].length || target[1] < 0 || target[1] >= elevations.length
    return {:elev => elevations[target[1]][target[0]], :coord => target}
  end

  def downhill elevations, coord
    current = {:elev => elevations[coord[1]][coord[0]], :coord => coord}
    [NORTH,WEST,EAST,SOUTH].each do |direction|
      result = get_elevation_at elevations, coord, direction
      if result[:elev] < current[:elev] then
        current = result
      end
    end
    return current[:coord]
  end

  def follow_mapping mapping, entry
    result = entry
    result = mapping[result] while mapping[result]

    result
  end

  def map_to_letter mapping, entry
    entry = follow_mapping mapping, entry
    return @letter_mapping[entry] if @letter_mapping[entry]

    @letter_mapping[entry] = @next_letter
    @next_letter = @next_letter.next

    return @letter_mapping[entry]
  end

  def solve elevations
    next_int_label = 1
    mapping = {}
    region_grid = Array.new(elevations.length) { |index| Array.new(elevations[0].length) }
    (0...elevations[0].length).each do |x|
      (0...elevations.length).each do |y|
        coord = [x,y]
        goes_to = downhill elevations, coord
        if goes_to === coord then
          if region_grid[y][x].nil? then
            region_grid[y][x] = next_int_label
            next_int_label += 1
          end
        else
          if region_grid[y][x].nil? then
            if region_grid[goes_to[1]][goes_to[0]].nil? then
              region_grid[y][x] = next_int_label
              region_grid[goes_to[1]][goes_to[0]] = next_int_label
              next_int_label += 1
            else
              region_grid[y][x] = region_grid[goes_to[1]][goes_to[0]]
            end
          else
            if region_grid[goes_to[1]][goes_to[0]].nil? then
              region_grid[goes_to[1]][goes_to[0]] = region_grid[y][x]
            else
              mapping[region_grid[y][x]] = region_grid[goes_to[1]][goes_to[0]]
            end
          end
        end
      end
    end
    @next_letter = 'a'
    @letter_mapping = {}

    region_grid.map! { |row|
      row.map! { |cell| map_to_letter mapping, cell }
    }
  
    region_grid      
  end

  def format_grid grid
    grid.map { |row| row.join ' ' }.join "\n"
  end
end

Marmalade.jam do

  read_num_cases

  test_cases do
    # read information about the test case here.
    read [:height, :width], :type => :int
    read :grid, :type => :int, :count => @height, :split => true
    run_case do
      puts "\n" + (format_grid(solve @grid))
    end
  end

end
