#!/usr/bin/env ruby

def recurse?(acc, operations, total)    
    return acc == total if operations.length == 0
    value, operations = [operations.first, operations.drop(1)]

    recurse?(acc + value, operations, total) ||
        recurse?((acc.to_s + value.to_s).to_i, operations, total) ||
        (value != 0 && recurse?(acc * value, operations, total))
end

STDIN.read.lines(chomp: true)
    .map{_1.split(":").yield_self {|t, o| [t.to_i, o.split(" ").map(&:to_i)]}}
    .filter {|total, operations| recurse?(0, operations, total)}
    .map { _1[0] }
    .sum
    .tap{p(_1)}
