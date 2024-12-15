#!/usr/bin/env ruby
require "matrix"

Grid = Struct.new(:grid) {
    def initialize(lines)
        self.grid = lines.each_with_index.reduce({}) do |acc, (cell, row_idx)|
            cell.split("")
                .each_with_index
                .reduce(acc) do |acc, (value, col_idx)|
                    next acc if value == "."
                    acc[Vector[col_idx, row_idx]] = value
                    acc
                end
            acc
        end
    end

    def move(cell, vector)
        return nil if self.grid[cell + vector] == "#"

        if self.grid[cell + vector].nil? || self.move(cell + vector, vector)    
            self.grid[cell + vector] = self.grid[cell]
            self.grid.delete(cell)
            cell + vector
        end
    end

    def find(value)
        self.grid.find {|index, v| v == value}.first
    end

    def display
        width, height = [self.grid.keys.map{_1[0]}.max, self.grid.keys.map{_1[1]}.max]
        (0...height + 1).each do |row_idx|
            print((0...width + 1).map{|col_idx| self.grid[Vector[col_idx, row_idx]] || '.'}.join(""), "\n")
        end
    end

    def score
        self.grid
            .to_a
            .filter {_1[1] == "O"}
            .map{_1[0]}
            .map{(_1[1] * 100) + _1[0]}
            .sum
    end
}

STDIN.read.split("\n\n")
    .yield_self do |(lines, instructions)|
        grid = Grid.new(lines.lines(chomp: true))
        pos = grid.find("@")
        grid.display

        instructions.strip.split("").each do |instruction|
            dir = case instruction
            when "<" then Vector[-1, 0]
            when ">" then Vector[1, 0]
            when "^" then Vector[0, -1]
            when "v" then Vector[0, 1]
            end

            next if dir.nil?
            
            new_pos = grid.move(pos, dir)
            pos = new_pos unless new_pos.nil?
        end
        grid.display

        p(grid.score)
    end

