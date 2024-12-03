#!/usr/bin/env ruby

input = STDIN.read.lines(chomp: true)
    .join("")
    .scan(/(mul|don't|do)(?:\((\d{1,3}),(\d{1,3})\))?/)
    .each_with_object([0, 1]) do |row, acc|
        case row[0]
        when "do" then acc[1] = 1
        when "don't" then acc[1] = 0
        when "mul" then acc[0] += acc[1] * (row[1].to_i * row[2].to_i)
        end
    end
    .tap{p(_1[0])}