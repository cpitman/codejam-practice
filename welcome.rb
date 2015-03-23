#!/usr/bin/env ruby

require 'rubygems'
require 'marmalade'

class TestCase
  TARGET  = 'welcome to code jam'
  
  def count_sequences line
    substring_counts = Array.new(TARGET.length) { 0 }
    char_map = Hash.new([])
    target_chars = TARGET.chars
    target_chars.each_with_index do |target_char, index|
      char_map[target_char] = char_map[target_char] + [index]
    end

    line.each_char do |character|
      indexes = char_map[character]
      indexes.each do |index|
        if index == 0
          substring_counts[0] += 1
        else
          substring_counts[index] = (substring_counts[index] + substring_counts[index - 1]) % 10000
        end
      end
    end

    substring_counts[TARGET.length - 1]
  end

end

Marmalade.jam do

  read_num_cases

  test_cases do
    # read information about the test case here.
    read :line
    run_case do
      puts count_sequences(@line).to_s.rjust(4, '0')
    end
  end

end
