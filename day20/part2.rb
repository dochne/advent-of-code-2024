#!/usr/bin/env ruby

require "matrix"
require_relative "../helpers/priority_queue"

DIRECTIONS = [Vector[-1, 0], Vector[0, -1], Vector[1, 0], Vector[0, 1]]
PICOSECONDS = 20
ALL_POTENTIAL_VECTORS = (-PICOSECONDS..PICOSECONDS).reduce([]) do |acc, x|
    (-PICOSECONDS..PICOSECONDS).reduce(acc) do |acc, y|
        acc << Vector[x, y] if x.abs + y.abs <= PICOSECONDS
        acc
    end
end

Grid = Struct.new(:grid) do 
    def find(value) self.grid.find {|index, v| v == value}.first end
    def can_move?(cell, vector) [".", "S", "E"].include?(self.grid[cell + vector]) end
end

def distance_to_node(to_node, &neighbours)
    queue = PriorityQueue.new
    distance_from_start = Hash.new(Float::INFINITY)
    distance_from_start[to_node] = 0
    queue.push(to_node, 0)
  
    while current = queue.pop
        neighbours.call(current).each do |(neighbour, weight)|
          new_distance = distance_from_start[current] + weight
          if new_distance < distance_from_start[neighbour]
            distance_from_start[neighbour] = new_distance
            queue.move(neighbour, new_distance)
          end
        end
    end
    distance_from_start
  end

STDIN.read.lines(chomp: true)
    .each_with_index.reduce({}) do |acc, (cell, row_idx)|
        cell.split("")
            .each_with_index
            .reduce(acc) do |acc, (value, col_idx)|
                acc[Vector[col_idx, row_idx]] = value
                acc
            end
        acc
    end
    .yield_self{Grid.new(_1)}
    .yield_self do |grid|
        distance_to_node(grid.find("E")) do |cell|
            DIRECTIONS.each_with_object([]) do |dir, moves|
                moves << [cell + dir, 1] if grid.can_move?(cell, dir)
            end
        end
    end
    .yield_self do |distances|
        distances.reduce(0) do |total, (cell, distance)|
            ALL_POTENTIAL_VECTORS.reduce(total) do |total, vector|
                next total if distances[cell + vector].nil?

                difference = distances[cell + vector] - distances[cell] + (vector[0].abs + vector[1].abs)
                if difference <= -100
                    total += 1
                end
                total
            end
        end
    end
    .tap {p(_1)}
