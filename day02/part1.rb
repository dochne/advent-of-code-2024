#!/usr/bin/env ruby

STDIN.read.lines(chomp: true)
    .map{_1.split(" ").map(&:to_i)}
    .filter do |value|
        value == value.sort || value == value.sort.reverse
    end
    .filter do |value|
        value.each_cons(2).all? do |a, b|
            next (a - b).abs > 0 && (a - b).abs <= 3
        end
    end
    .length
    .tap{p _1}

