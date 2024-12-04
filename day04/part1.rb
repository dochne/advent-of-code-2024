#!/usr/bin/env ruby

require 'matrix'
vectors = []
[-1, 0, 1].each do |x|
    [-1, 0, 1].each do |y|
        vectors << Vector[x, y]
    end
end

word = 'XMAS'.split("")

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
            vectors.filter do |vector|
                word.each_with_index.all? do |letter, idx|
                    grid[cell + (vector * idx)] == letter
                end
            end
            .length + count
        end
    end
    .tap{p _1}