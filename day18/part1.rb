#!/usr/bin/env ruby

require "matrix"
require "concurrent"

DIRECTIONS = [Vector[0, 1], Vector[0, -1], Vector[1, 0], Vector[-1, 0]]

class PriorityQueue
    def initialize() @queue = Concurrent::Collection::NonConcurrentPriorityQueue.new({order: :min}) end
    def push(item, score) @queue.push([score, item]) end
    def empty?() @queue.length == 0 end
    def length() @queue.length end
    def pop() 
      value = @queue.pop
      value.nil? ? nil : value[1]
    end
  
    def move(item, prev_score, new_score)
      @queue.delete([prev_score, item])
      @queue.push([new_score, item])
    end
  end

class Grid
    def initialize(vectors, width, height)
        @grid = vectors.each_with_object({}) {|v, acc| acc[v] = "#"}
        @width = width
        @height = height
    end

    def neighbours(cell)
        DIRECTIONS.each_with_object([]) do |vector, acc|
            acc << cell + vector if empty?(cell + vector)
        end
    end

    def empty_cells
        cells = []
        (0...@width).each do |col_idx|
            (0...@height).each do |row_idx|
                cells << Vector[col_idx, row_idx] if empty?(Vector[col_idx, row_idx])
            end
        end
        cells
    end

    def empty?(cell)
        0 <= cell[0] && cell[0] < @height &&
        0 <= cell[1] && cell[1] < @width &&
        @grid[cell].nil?
    end

    def path(start_node, end_node)
        distances = Hash.new(Float::INFINITY) 
        previous_nodes = Hash.new(nil) 
        queue = PriorityQueue.new

        empty_cells.each do |cell|
            queue.push(cell, Float::INFINITY)
        end

        distances[start_node] = 0
    
        while current = queue.pop
            # p("Neighbours", neighbours(current))
            neighbours(current).each do |neighbour|
                # p("Neighbour", neighbour)
                new_distance = distances[current] + 1
                # p("New Distance", new_distance)
                if new_distance < distances[neighbour]
                    distances[neighbour] = new_distance
                    previous_nodes[neighbour] = current
                    queue.move(neighbour, distances[neighbour], new_distance)
                end
            end
        end

        distances[end_node]
        # p("Distances", distances)
    
        # exit
        # p("--")
        # # p(find("E"))
        # # p(distances)
        # finish_node = find("E")
        # v = DIRECTIONS
        # .map{Node.new(finish_node, _1)}
        # .map{distances[_1]}
        # .min

        # p(v)
        # exit
    end

    def display
        width, height = [@grid.keys.map{_1[0]}.max, @grid.keys.map{_1[1]}.max]
        (0...height + 1).each do |row_idx|
            (0...width + 1).each do |col_idx|
                value = @grid[Vector[col_idx, row_idx]] || "."
                print value
                # print value == "@" ? "\033[31m@\033[0m" : value
            end
            print "\n"
        end
    end
end

STDIN.read.lines(chomp: true)
    .map{|line| Vector.elements(line.split(",").map(&:to_i))}
    # .slice(1024)
    .take(1024)
    .yield_self{Grid.new(_1, 71, 71)}
    .tap{_1.display}
    .yield_self{_1.path(Vector[0, 0], Vector[70, 70])}
    .tap{p(_1)}
