#!/usr/bin/env ruby
require "matrix"
require "set"

VECTORS = [Vector[0, -1], Vector[1, 0], Vector[0, 1], Vector[-1, 0]]

def will_loop?(grid, pos, vector_idx)
    pos -= VECTORS[vector_idx]
    rotation_points = Set.new
    while true do
        current_vector = Vector[pos[0], pos[1], vector_idx]
        next_pos = pos + VECTORS[vector_idx]
        next_cell = grid[next_pos]

        return true if rotation_points.include?(current_vector)
        return false if next_cell.nil?
        pos += VECTORS[vector_idx] if next_cell == "." || next_cell == "^"
        if next_cell == "#"
            rotation_points.add(current_vector)
            vector_idx = (vector_idx + 1) % 4 
        end
    end
end

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
        [grid, grid.find{|k, v| v == '^'}[0]]
    end
    .yield_self do |grid, starting_pos|
        pos = starting_pos
        path = Hash.new
        vector_idx = 0
        until grid[pos + VECTORS[vector_idx]].nil? do
            if grid[pos + VECTORS[vector_idx]] == "#"
                vector_idx = (vector_idx + 1) % 4
            else
                pos += VECTORS[vector_idx]
            end
            path[pos] = vector_idx if path[pos].nil?
        end
        [grid, path]
    end
    .yield_self do |grid, path|
        path.reduce(0) do |acc, (pos, vector_idx)|
            next acc if grid[pos] != "."
            grid[pos] = "#"
            acc += 1 if will_loop?(grid, pos, vector_idx)
            grid[pos] = "."
            acc
        end
    end
    .tap{p(_1)}