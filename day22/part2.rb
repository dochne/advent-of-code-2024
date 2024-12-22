#!/usr/bin/env ruby

Solution = Struct.new(:values, :deltas)

def solve(v, n)
    values = [v]
    while n > 0
        r = v * 64
        v = v ^ r # mix 
        v = v % 16777216 # prune

        r = v / 32
        v = v ^ r # mix
        v = v % 16777216 # prune

        r = v * 2048
        v = v ^ r # mix
        v = v % 16777216 # prune
        n -= 1
        values << v % 10
    end
    values.each_cons(2).reduce(Solution.new([], [])) do |acc, (n1, n2)|
        acc.values << n2 % 10
        acc.deltas << (n2 % 10) - (n1 % 10)
        acc
    end
end

STDIN.read.lines(chomp: true)
    .reduce(Hash.new{|h,k| h[k] = []}) do |tally, value|
        buyer_tally = {}
        solution = solve(value.to_i, 2000)
        solution.deltas.each_with_index
        .each_cons(4) do |n1, n2, n3, n4|
            hash = "#{n1[0]},#{n2[0]},#{n3[0]},#{n4[0]}"
            index = n4[1]
            buyer_tally[hash] = solution.values[index] if buyer_tally[hash].nil?
        end
        buyer_tally.to_a.each {|k, v| tally[k] << v}
        tally
    end
    .yield_self do |tally|
        tally.to_a.sort_by{_1[1].sum}.last[1]
    end
    .sum
    .tap{p(_1)}
