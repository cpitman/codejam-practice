#!/usr/bin/env ruby

require 'rubygems'
require 'marmalade'

class TestCase
  # Any methods you want to call in your individual cases can be defined here.
end

Marmalade.jam do

  # This assumes your input file has the number of test cases as the first line.
  read_num_cases

  test_cases do
    read :words, :split => true
    run_case do
      puts @words.reverse.join(' ')
    end
  end

end
