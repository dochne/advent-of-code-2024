#!/usr/bin/env ruby

input = STDIN.read.lines(chomp: true)
  .map{_1.split(" ")}
  .each_with_object([[], []]).each do |value, acc|
    acc[0] << value[0].to_i
    acc[1] << value[1].to_i
  end
  .yield_self {|value| value.map{_1.sort}}
  .yield_self do |value|
    response = []
    value[0].each_with_index do |n, i|
      response << [n, value[1][i]].max - [n, value[1][i]].min
    end
    response
  end
  .sum

p(input)
# p(input)
