#!/usr/bin/env ruby

left, right = STDIN.read.lines(chomp: true)
  .map{_1.split(" ").map(&:to_i)}
  .transpose
  .map(&:sort)

left
  .each_index
  .map {|i| [left[i], right[i]].max - [left[i], right[i]].min}
  .sum
  .tap{p _1}
