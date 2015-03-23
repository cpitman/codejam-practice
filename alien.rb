#!/usr/bin/env ruby

require 'rubygems'
require 'marmalade'

class TestCase
  def pattern_to_regex pattern
    Regexp.new(pattern.gsub('(', '[').gsub(')',']'))
  end

  def count_possible dictionary, pattern
    dictionary.count { |word| pattern.match word }
  end
end

Marmalade.jam do

  # This assumes your input file has the number of test cases as the first line.
  #read_num_cases

  read [:word_length, :dict_length, :num_cases], :type => :int
  read :dictionary, :count => @dict_length

  dictionary = @dictionary
  test_cases do
    read :pattern
    run_case do
      puts count_possible(dictionary, (pattern_to_regex @pattern))
    end
  end

end
