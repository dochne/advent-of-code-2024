#!/usr/bin/env ruby

require "matrix"
require "concurrent"

# Note, this didn't actually fail - I just replaced it with a much cleaner feeling implementation

DIRECTIONS = [Vector[-1, 0], Vector[0, -1], Vector[1, 0], Vector[0, 1]]
CLOCKWISE = DIRECTIONS.each_with_index.each_with_object(Hash.new) {|(dir, i), acc| acc[dir] = DIRECTIONS[(i + 1) % 4]}
ANTI_CLOCKWISE = DIRECTIONS.each_with_index.each_with_object(Hash.new) {|(dir, i), acc| acc[dir] = DIRECTIONS[(i + 3) % 4]}

class PriorityQueue
  def initialize()
    @queue = Concurrent::Collection::NonConcurrentPriorityQueue.new({order: :min})
    @score = {}
  end
  def push(item, score)
    @queue.push([score, item])
    @score[item] = score
  end
  def empty?() @queue.length == 0 end
  def length() @queue.length end
  def pop() 
    value = @queue.pop
    value.nil? ? nil : value[1]
  end

  def move(item, prev_store, new_score)
    @queue.delete([@score[item], item])
    @queue.push([new_score, item])
  end
  # queue.move(neighbour, distances[heighbour], new_distance)
          # queue.change_priority(neighbour, new_distance)
end


# class Node
#   attr_accessor :cell, :vector, :parent, :cost, :h_cost
#   def initialize(cell, vector, parent = nil)
#     @cell = cell
#     @vector = vector
#     @parent = parent
#     @cost = 0
#     @h_cost = 0
#   end

#   # self.cache = {}

#   def f() @cost + @h_cost end

#   def ==(node2)
#     # maybe, this isn't the check we want to do for complete
    

#     @cell == node2.cell && @vector == node2.vector
#     # print(@cell, " ", node2.cell, " Vectors", @vector, " ", node2.vector, " Equal? ", v ? "Yes!" : "No")
#     # end
#   end
# end

Node = Struct.new(:cell, :vector)

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
      @grid_color = {}
  end

  def find(value)
      @grid.find {|index, v| v == value}.first
  end

  def empty_cells
    @grid.filter{|cell, value| can_move?(cell)}.keys
  end

  def can_move?(cell)
    # p(cell)
    @grid[cell] == "." || @grid[cell] == "E" || @grid[cell] == "S"
  end

  def complete?(cell) @grid[cell] == "E" end

  def value(cell) @grid[cell] end

  def set(cell, value)
      @grid[cell] = value
  end

  def set_color(cell, color = "red")
    # always red atmp!
    # p("is called")
    @grid_color[cell] = color
  end

  def display
    # p("display")
    p(@grid_color)
      width, height = [@grid.keys.map{_1[0]}.max, @grid.keys.map{_1[1]}.max]
      (0...height + 1).each do |row_idx|
          (0...width + 1).each do |col_idx|
              value = @grid[Vector[col_idx, row_idx]] || "."
              # p(@grid_color[Vector[col_idx, row_idx]])
              # 
              color = @grid_color[Vector[col_idx, row_idx]]
              if color == "red"
                print "\033[31m"
              elsif color == "blue"
                print "\e[0;33m"
              end
              print "#{value}\033[0m"
          end
          print "\n"
      end
  end

  def neighbours(node)
    yield [Node.new(node.cell + node.vector, node.vector), 1] if can_move?(node.cell + node.vector)
    yield [Node.new(node.cell, CLOCKWISE[node.vector]), 1000]
    yield [Node.new(node.cell, ANTI_CLOCKWISE[node.vector]), 1000]
  end

  def dijkstra(start_node)
    distances = Hash.new(Float::INFINITY) # Stores the shortest distances from start_node to all other nodes
    previous_nodes = Hash.new(nil) # Stores the previous node for the shortest path
    queue = PriorityQueue.new

    empty_cells.each do |cell|
      DIRECTIONS.each do |dir|
        queue.push(Node.new(cell, dir), Float::INFINITY)
      end
    end

    distances[start_node] = 0
  
    while current = queue.pop
      p(queue.length)
      neighbours(current) do |neighbour, weight|
        new_distance = distances[current] + weight
        if new_distance < distances[neighbour]
          distances[neighbour] = new_distance
          previous_nodes[neighbour] = current
          queue.move(neighbour, distances[neighbour], new_distance)
        end
      end
    end
  
    p("--")
    # p(find("E"))
    # p(distances)
    finish_node = find("E")
    v = DIRECTIONS
      .map{Node.new(finish_node, _1)}
      .map{distances[_1]}
      .min

    p(v)
    exit

    # distances[Node.new(find("E"), Vector[1, 0])])
    # previous_nodes.each do |node, prev|
    #   path = []
    #   current = node
    #   while current
    #     path.unshift(current)
    #     current = result[:previous_nodes][current]
    #   end
    #   puts "#{node}: #{path.join(' -> ')}"
    # end

    # { distances: distances, previous_nodes: previous_nodes }
  end
end

STDIN.read.lines(chomp: true)
    .yield_self{Grid.new(_1)}
    .yield_self do |grid|
      grid.dijkstra(Node.new(grid.find("S"), Vector[1, 0]))
    end
    .tap{p(_1)}
