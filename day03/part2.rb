#!/usr/bin/env ruby

input = STDIN.read.lines(chomp: true)
    .join("")
    .scan(/(mul|don't|do)(?:\((\d{1,3}),(\d{1,3})\))?/)
    .reduce([0, 1]) do |acc, row|
        case row[0]
        when "do"
            [acc[0], 1]
        when "don't"
            [acc[0], 0]
        when "mul"
            [acc[0] + (row[1].to_i * row[2].to_i * acc[1]), acc[1]]
        end
    end
    .tap{p(_1[0])}


