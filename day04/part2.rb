#!/usr/bin/env ruby

require 'matrix'
vectors = []
[-1, 0, 1].each do |x|
    [-1, 0, 1].each do |y|
        vectors << Vector[x, y]
    end
end

word = 'XMAS'.split("")

grid = STDIN.read.lines(chomp: true)
    .map{_1.split("")}

grid
    .each_index
    .reduce(0) do |acc, row_idx|
        # row.reduce(cell)
        acc += grid[row_idx]
            .each_index
            .reduce(0) do |acc, col_idx|
                pos = Vector[col_idx, row_idx]
                new_bec = vectors.filter do |vector|
                    word.each_with_index.all? do |letter, idx|
                        pos + (vector * idx) == letter
                    end
                end
                acc += new_bec.length
            end
    end
    .tap{p _1}

# p(grid)
