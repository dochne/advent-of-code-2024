#!/usr/bin/env ruby

rules, update = STDIN.read.split("\n\n")
  .map{_1.lines(chomp: true)}
  .yield_self do |rules, updates|
    [rules.map{_1.split("|").map(&:to_i)}, updates.map{_1.split(",").map(&:to_i)}]
  end
  .yield_self do |rules, updates|
    [
      rules.each_with_object(Hash.new{|h, k| h[k] = []}) {|rule, acc| acc[rule[0]] << rule[1]},
      updates
    ]
  end
  .yield_self do |rules, updates|
    updates.map do |update|
      update.sort do |a, b|
        next -1 if rules[a].include?(b)
        next 1 if rules[b].include?(a)
        0
      end
      .yield_self do |sorted|
        sorted != update ? sorted[(sorted.length / 2)] : 0
      end
    end
  end
  .sum
  .tap { p(_1) }
