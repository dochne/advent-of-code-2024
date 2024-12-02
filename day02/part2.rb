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
        is_valid(value) || value.each_with_index.any? do |_, i|
            new_value = value.clone
            new_value.delete_at(i)
            is_valid(new_value) 
        end
    end
    .length

p(input)
