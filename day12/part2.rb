#!/usr/bin/env ruby

require "matrix"

VECTORS = [Vector[0, 1], Vector[-1, 0], Vector[0, -1], Vector[1, 0]]

Region = Struct.new(:cells, :walls)
Wall = Struct.new(:cells, :dir)

def visit(grid, cell, region, value, direction)
    return region if region.cells.include? cell
    if grid[cell] != value
        region.walls[direction] << cell
        return region
    end
    region.cells << cell
    VECTORS.each_with_index.reduce(region) do |acc, (vector, index)|
        visit(grid, cell + vector, region, value, index)
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
            acc << visit(grid, cell, Region.new([], Hash.new{|h, k| h[k] = []}), value, nil)
            acc
        end
    end
    .reduce(0) do |acc, region|
        num_walls = region.walls.reduce(0) do |acc, (direction, walls)|
            offset = direction % 2 == 0 ? Vector[1, 0] : Vector[0, 1]
            walls.reduce(walls.length) do |acc, wall|
                acc -= 1 if walls.include? wall + offset
                acc
            end + acc
        end
        acc += region.cells.length * num_walls
    end
    .tap{p(_1)}