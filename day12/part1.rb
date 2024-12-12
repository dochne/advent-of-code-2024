#!/usr/bin/env ruby

require "matrix"

VECTORS = [Vector[0, 1], Vector[0, -1], Vector[-1, 0], Vector[1, 0]]

Region = Struct.new(:cells, :perimeter)

def visit(grid, cell, region, value)
    return region if region.cells.include? cell
    if grid[cell] != value
        region.perimeter += 1
        return region
    end
    region.cells << cell
    VECTORS.reduce(region) do |acc, vector|
        visit(grid, cell + vector, region, value)
    end
end

STDIN.read.lines(chomp: true)
    .each_with_index
    .yield_self do |grid|
        grid.reduce({}) do |acc, (cell, row_idx)|
            cell.split("")
                .each_with_index
                .reduce(acc) do |acc, (value, col_idx)|
                    acc[Vector[col_idx, row_idx]] = value
                    acc
                end
            acc
        end
    end
    .yield_self do |grid|
        grid.reduce([]) do |acc, (cell, value)|
            next acc if acc.any? {|region| region.cells.include? cell}
            acc << visit(grid, cell, Region.new([], 0), value)
            acc
        end
    end
    .reduce(0) do |acc, region|
        acc + region.perimeter * region.cells.length
    end
    .tap{p(_1)}