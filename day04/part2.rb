#!/usr/bin/env ruby

require 'matrix'

vectors = [
    [Vector[-1, -1], Vector[1, 1]],
    [Vector[1, -1], Vector[-1, 1]]
]

STDIN.read.lines(chomp: true)
    .each_with_index
    .reduce({}) do |acc, (row, row_idx)|
        row.split("").each_with_index.reduce(acc) do |acc, (value, col_idx)|
            acc[Vector[col_idx, row_idx]] = value
            acc
        end
    end
    .yield_self do |grid|
        grid.reduce(0) do |count, (cell)|
            next count if grid[cell] != 'A'
            count += 1 if vectors.all? do |(vector1, vector2)|
                [grid[cell + vector1] || "|", grid[cell + vector2] || "|"].map(&:ord).sum == 160
            end
            count
        end
    end
    .tap{p _1}