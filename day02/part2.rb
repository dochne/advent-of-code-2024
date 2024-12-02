#!/usr/bin/env ruby

def is_valid(value)
    return false unless value == value.sort || value == value.sort.reverse
    value.each_cons(2).all? do |a, b|
        0 < (a - b).abs && (a - b).abs <= 3
    end
end

input = STDIN.read.lines(chomp: true)
    .map{_1.split(" ").map(&:to_i)}
    .filter do |value|
        is_valid(value) || value.each_index.any? do |i|
            is_valid(value.clone.tap{_1.delete_at(i)}) 
        end
    end
    .length

p(input)
