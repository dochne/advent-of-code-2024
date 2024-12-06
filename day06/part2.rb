#!/usr/bin/env ruby
require "matrix"
require "set"

VECTORS = [Vector[0, -1], Vector[1, 0], Vector[0, 1], Vector[-1, 0]]

def will_loop?(grid, pos, vector_idx)
    start_pos = pos + VECTORS[vector_idx]
    begin
        grid[start_pos] = "#"
        rotation_points = Set.new
        while true do
            current_vector = Vector[pos[0], pos[1], vector_idx]
            next_pos = pos + VECTORS[vector_idx]
            next_cell = grid[next_pos]

            return true if rotation_points.include?(current_vector)
            return false if next_cell.nil?
            pos += VECTORS[vector_idx] if next_cell == "."
            if next_cell == "#"
                rotation_points.add(current_vector)
                vector_idx = (vector_idx + 1) % 4 
            end
        end
    ensure
        grid[start_pos] = "."
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
        # visited = Set.new
        visited = 0
        loops = 0
        pos = grid.find{|k, v| v == '^'}[0]
        grid[pos] = "."
        vector_idx = 0
        while true do
            next_cell = grid[pos + VECTORS[vector_idx]]
            break loops if next_cell.nil?
            
            if next_cell == "."
                loops += 1 if will_loop?(grid, pos, vector_idx)
            end

            pos += VECTORS[vector_idx] if next_cell == "."
            vector_idx = (vector_idx + 1) % 4 if next_cell == "#"
            visited += 1
            p(visited) 
        end
    end
    .tap{p(_1)}

    # what we want to know really, is if I turned right here, would I hit a position I'd already been in before that had a # in it
    # visited would need to be on the stack
    # the fastest way is actually say to say "am I in this position with this direction again"
    # incorrect - you can loop into something with no exit
