#!/usr/bin/env ruby
require "matrix"
require "set"

vectors = [Vector[0, -1], Vector[1, 0], Vector[0, 1], Vector[-1, 0], ]

STDIN.read.lines(chomp: true)
    .each_with_index
    .reduce(Hash.new) do |acc, (cell, row_idx)|
        cell.split("")
            .each_with_index
            .reduce(acc) do |acc, (value, col_idx)|
                acc[Vector[col_idx, row_idx]] = value
                acc
            end
        acc
    end
    .yield_self do |grid|
        visited = Set.new
        pos = grid.find{|k, v| v == '^'}[0]
        grid[pos] = "."
        vector_idx = 0
        while true do
            case (grid[pos + vectors[vector_idx]])
                when nil then break visited.length
                when "." then pos += vectors[vector_idx]
                when "#" then vector_idx = (vector_idx + 1) % 4
            end
            visited.add(pos)
        end
    end
    .tap{p(_1)}

