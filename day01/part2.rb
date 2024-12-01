#!/usr/bin/env ruby

input = STDIN.read.lines(chomp: true)
  .map{_1.split(" ")}
  .each_with_object([[], []]).each do |value, acc|
    acc[0] << value[0].to_i
    acc[1] << value[1].to_i
  end
  .yield_self do |(left, right)|
    multipliers = right.tally
    left.map{|n| n *  (multipliers[n] || 0)}
  end
  .sum

p(input)