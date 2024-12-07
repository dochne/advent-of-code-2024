#!/usr/bin/env ruby

def recurse?(acc, operations, total)
    operations = operations.clone
    # print("Acc ", acc, " operations" ,operations, " total ", total, "\n")
    return acc == total if operations.length == 0
    value = operations.shift
    [:+, :*].each do |op|
        return true if recurse?(acc.send(op, value), operations, total)
    end
    false
end

STDIN.read.lines(chomp: true)
    .map{_1.split(":").yield_self {|t, o| [t.to_i, o.split(" ").map(&:to_i)]}}
    .filter do |total, operations|
        recurse?(0, operations, total)
    end
    .map { _1[0] }
    .sum
    .tap{p(_1)}


# 190: 10 19
# 3267: 81 40 27
# 83: 17 5
# 156: 15 6
# 7290: 6 8 6 15
# 161011: 16 10 13
# 192: 17 8 14
# 21037: 9 7 18 13
# 292: 11 6 16 20