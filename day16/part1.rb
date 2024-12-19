#!/usr/bin/env ruby

require "matrix"
require_relative "../helpers/dijkstra.rb"

DIRECTIONS = [Vector[-1, 0], Vector[0, -1], Vector[1, 0], Vector[0, 1]]
CLOCKWISE = DIRECTIONS.each_with_index.each_with_object(Hash.new) {|(dir, i), acc| acc[dir] = DIRECTIONS[(i + 1) % 4]}
ANTI_CLOCKWISE = DIRECTIONS.each_with_index.each_with_object(Hash.new) {|(dir, i), acc| acc[dir] = DIRECTIONS[(i + 3) % 4]}

Grid = Struct.new(:grid) do
  def initialize(lines)
      @grid = lines.each_with_index.reduce({}) do |acc, (cell, row_idx)|
          cell.split("")
              .each_with_index
              .reduce(acc) do |acc, (value, col_idx)|
                  acc[Vector[col_idx, row_idx]] = value
                  acc
              end
          acc
      end
  end

  def find(value)
    @grid.find {|index, v| v == value}.first
  end

  def can_move?(cell)
    [".", "S", "E"].include?(@grid[cell])
  end
end

Node = Struct.new(:cell, :vector) do
  def forward() Node.new(self.cell + self.vector, self.vector) end
  def left() Node.new(self.cell, ANTI_CLOCKWISE[self.vector]) end
  def right() Node.new(self.cell, CLOCKWISE[self.vector]) end
end

STDIN.read.lines(chomp: true)
    .yield_self{Grid.new(_1)}
    .yield_self do |grid|
      dijkstra(Node.new(grid.find("S"), Vector[1, 0]), DIRECTIONS.map{|d| Node.new(grid.find("E"), d)}) do |node|
        result = []
        forward = node.forward
        result << [forward, 1] if grid.can_move?(forward[0])
        result << [node.left, 1000]
        result << [node.right, 1000]
        result
      end
      .values
      .min
    end
    .tap{p(_1)}
