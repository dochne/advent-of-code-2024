#!/usr/bin/env ruby

STDIN.read.split("\n\n")
  .map{_1.lines(chomp: true)}
  .yield_self do |rules, updates|
    [rules.map{_1.split("|").map(&:to_i)}, updates.map{_1.split(",").map(&:to_i)}]
  end
  .yield_self do |rules, updates|
    updates.filter do |update|
      rules.all? do |rule|
        (idx_a, idx_b) = [update.find_index(rule[0]), update.find_index(rule[1])]
        idx_a == nil || idx_b == nil || idx_a < idx_b
      end
    end
  end
  .yield_self do |updates|
    updates.map{|update| update[(update.length / 2)]}
  end
  .sum
  .tap { p(_1) }

