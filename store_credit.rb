#!/usr/bin/env ruby

require 'rubygems'
require 'marmalade'

class TestCase
  def solve item_prices, credit
    sorted_prices = item_prices.sort
    start_index = 0
    end_index = item_prices.length - 1

    while start_index < end_index do
      sum = sorted_prices[start_index] + sorted_prices[end_index]
      if sum == credit then
        first_index = item_prices.find_index(sorted_prices[start_index]) + 1
        second_index = item_prices.find_index(sorted_prices[end_index]) + 1
        if second_index == first_index then
          second_index = first_index + item_prices.drop(first_index).find_index(sorted_prices[end_index]) + 1
        end

        return [first_index, second_index].sort
      elsif sum < credit then
        start_index += 1
      else
        end_index -= 1
      end
    end
  end
end

Marmalade.jam do

  read_num_cases

  test_cases do
    # read information about the test case here.
    read :credit, :type => :int
    read :item_count, :type => :int
    read :item_prices, :split => true, :type => :int

    run_case do
      puts solve(@item_prices, @credit).join(' ')
    end
  end

end
