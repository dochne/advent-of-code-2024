#!/usr/bin/env ruby

left, right = STDIN.read.lines(chomp: true)
  .map{_1.split(" ").map(&:to_i)}
  .transpose

tally = right.tally  

left
  .map{|n| n * (tally[n] || 0)}
  .sum
  .tap{p _1}
