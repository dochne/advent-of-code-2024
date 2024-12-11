#!/usr/bin/env ruby

$cache = {}

def memoize(key, &block)
    $cache[key] ||= block.call
end

def solve(number, depth)
    return 1 if depth == 0
    memoize("#{number}/#{depth}") do
        s = number.to_s
        if number == 0
            solve(1, depth - 1)
        elsif s.length % 2 == 0
            [s.to_s[0, s.length / 2], s.to_s[s.length / 2, s.length]]
                .map{solve(_1.to_i, depth - 1)}
                .sum
        else
            solve(number * 2024, depth - 1)
        end
    end
end

STDIN.read.lines(chomp: true)
    .first
    .split(" ")
    .map{solve(_1.to_i, 75)}
    .sum
    .tap{p(_1)}