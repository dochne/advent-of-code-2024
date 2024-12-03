#!/usr/bin/env ruby

input = STDIN.read.lines(chomp: true)
    .join("")
    .split("mul")
    .reduce(0) do |acc, instruction|
        if matches = instruction.match(/^\((\d{1,3}),(\d{1,3})\)/)
            acc += matches[1].to_i * matches[2].to_i
        end
        acc
    end
    .tap{p(_1)}


