#!/usr/bin/env ruby

require "matrix"

DIRECTIONS = [Vector[-1, 0], Vector[0, -1], Vector[1, 0], Vector[0, 1]]
CLOCKWISE = DIRECTIONS.each_with_index.each_with_object(Hash.new) {|(dir, i), acc| acc[dir] = DIRECTIONS[(i + 1) % 4]}
ANTI_CLOCKWISE = DIRECTIONS.each_with_index.each_with_object(Hash.new) {|(dir, i), acc| acc[dir] = DIRECTIONS[(i + 3) % 4]}

class Node
  attr_accessor :cell, :vector, :parent, :cost, :h_cost
  def initialize(cell, vector, parent = nil)
    @cell = cell
    @vector = vector
    @parent = parent
    @cost = 0
    @h_cost = 0
  end

  # self.cache = {}

  def f() @cost + @h_cost end

  def ==(node2)
    # maybe, this isn't the check we want to do for complete
    

    @cell == node2.cell && @vector == node2.vector
    # print(@cell, " ", node2.cell, " Vectors", @vector, " ", node2.vector, " Equal? ", v ? "Yes!" : "No")
    # end
  end
end

Grid = Struct.new(:grid) do
  def initialize(lines)
      @grid = lines.each_with_index.reduce({}) do |acc, (cell, row_idx)|
          cell.split("")
              .each_with_index
              .reduce(acc) do |acc, (value, col_idx)|
                  next acc if value == "."
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

  def can_move?(cell)
    # p(cell)
    @grid[cell].nil? || @grid[cell] == "E" || @grid[cell] == "S"
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

  def distance(node1, node2)
    # p("Node1", node1.cell)
    # p("Node2", node2.cell)
    node1.cell[0].abs - node2.cell[0].abs + node1.cell[1].abs - node2.cell[1].abs
    # (node1.cell - node2.cell).to_a.sum
  end

  def reconstruct_path(node)
    path = []
    while node
      path << [node.cell, node.vector]
      node = node.parent
    end
    path.reverse
  end

  def traverse(start, finish)
    start = Node.new(start, Vector[1, 0])
    finish = Node.new(finish, Vector[1, 0])
    open_set = []
    open_set << start
    closed_set = Set.new

    while !open_set.empty?
      p(closed_set.length) if (closed_set.length % 100) == 0
      current = open_set.min_by(&:f)

      open_set.delete(current)
      closed_set << [current.cell, current.vector]

      # 111488 = too high
      # 111480 = actual
      neighbours(current) do |neighbour, cost|
        next if closed_set.include?([neighbour.cell, neighbour.vector])
        next_cost = current.cost + cost

        if !open_set.include? neighbour
          open_set << neighbour
        elsif next_cost >= neighbour.cost
          next
        end

        neighbour.parent = current
        neighbour.cost = next_cost
        neighbour.h_cost = distance(neighbour, finish)
      end
    end

    if current.cell == finish.cell
        # p(current.cost)
        closed_set.each do |cell, vector|
          set_color(cell, "blue")
        end

        path = reconstruct_path(current) 
        path.each do |cell, vector|
          if @grid[cell].nil?
            @grid[cell] = 1
          elsif @grid[cell] != "E" && @grid[cell] != "S"
            @grid[cell] += 1
          end
          set_color(cell)
        end
        display

        p(current.cost)
        exit
      end
  end
end

STDIN.read.lines(chomp: true)
    .yield_self{Grid.new(_1)}
    .yield_self do |grid|
      grid.traverse(grid.find("S"), grid.find("E"))
    end
    .tap{p(_1)}
