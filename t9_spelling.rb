#!/usr/bin/env ruby

require 'rubygems'
require 'marmalade'

module Marmalade
# A class to help parsing out values from a Code Jam input file
  class FileReader
    private
    def read_line(file_handle, options)
      if (options[:strip].nil? ? true : options[:strip])
        line = (file_handle.gets || '').strip
      else
        line = (file_handle.gets || '').gsub(/\n/,'')
      end
      integers = [:int, :integer].include?(options[:type])
      if options[:split]
        line_a = line.split(' ')
        if integers
          line_a = line_a.map(&:to_i)
        end
        line_a
      elsif integers
        line = line.to_i
      else
        line
      end
    end
  end
end

class TestCase
  KEYS = {2 => 'abc', 3 => 'def', 4 => 'ghi', 5 => 'jkl', 6 => 'mno', 7 => 'pqrs', 8 => 'tuv', 9 => 'wxyz', 0 => ' '}
  CODES = Hash[*KEYS.each_pair.map { |digit, letters| letters.chars.each_with_index.map { |letter, index| [letter, digit.to_s*(index+1)]}.to_a}.to_a.flatten]

  def solve target
    sequences = target.each_char.map { |character| CODES[character] }
    result = ''
    sequences.each { |seq|
      if result.length > 0 && result[result.length-1] == seq[0] then
        result += ' ' + seq
      else
        result += seq
      end
    }

    result
  end
end

Marmalade.jam do

  # This assumes your input file has the number of test cases as the first line.
  read_num_cases

  test_cases do
    read :target, :strip => false
    run_case do
      puts solve(@target)
    end
  end

end
