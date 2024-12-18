#!/usr/bin/env ruby
require "matrix"

INSTRUCTIONS = { "<" => Vector[-1, 0], ">" => Vector[1, 0], "^" => Vector[0, -1], "v" => Vector[0, 1]}

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

    def next_cells(cells, vector)
        cells.reduce(Set.new) do |acc, cell|
            next acc if self.grid[cell + vector].nil?
            acc << cell + vector
            if vector == Vector[0, -1] || vector == Vector[0, 1]
                if self.grid[cell + vector] == "]"
                    acc << cell + vector + Vector[-1, 0]
                elsif self.grid[cell + vector] == "["
                    acc << cell + vector + Vector[1, 0]
                end
            end
            acc
        end
    end

    def move(cells, vector)
        return false if cells.any?{|cell| self.grid[cell + vector] == "#"}
        return false unless cells.all?{|cell| self.grid[cell + vector].nil?} || self.move(next_cells(cells, vector), vector)

        cells.each do |cell|
            self.grid[cell + vector] = self.grid[cell]
            self.grid.delete(cell)
        end
    end

    def find(value)
        self.grid.find {|index, v| v == value}.first
    end

    def display
        width, height = [self.grid.keys.map{_1[0]}.max, self.grid.keys.map{_1[1]}.max]
        (0...height + 1).each do |row_idx|
            (0...width + 1).each do |col_idx|
                value = self.grid[Vector[col_idx, row_idx]] || "."
                print value == "@" ? "\033[31m@\033[0m" : value
            end
            print "\n"
        end
    end

    def score
        self.grid
            .to_a
            .filter {_1[1] == "["}
            .map{_1[0]}
            .map{(_1[1] * 100) + _1[0]}
            .sum
    end
}

STDIN.read.split("\n\n")
    .yield_self do |(lines, instructions)|
        grid = Grid.new(
            lines
                .gsub("#", "##")
                .gsub("O", "[]")
                .gsub(".", "..")
                .gsub("@", "@.")
                .lines(chomp: true)
        )
        
        pos = grid.find("@")
        instructions.split("")
            .map{INSTRUCTIONS[_1]}
            .filter{_1 != nil}
            .each do |dir|
                pos += dir if grid.move([pos], dir)
                # grid.display
            end
            
        grid.score
    end
    .tap{p(_1)}

