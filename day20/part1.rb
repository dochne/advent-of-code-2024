#!/usr/bin/env ruby

require "matrix"
require_relative "../helpers/dijkstra"

DIRECTIONS = [Vector[-1, 0], Vector[0, -1], Vector[1, 0], Vector[0, 1]]

Node = Struct.new(:cell, :cheated)
Grid = Struct.new(:grid) do 
    def find(value)
        self.grid.find {|index, v| v == value}.first
    end

    def can_move?(cell, vector)
        [".", "S", "E"].include?(self.grid[cell + vector])
    end
    # def dijkstra(start_node, finish_nodes, &neighbours)
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
        # def dijkstra(start_node, finish_nodes, &neighbours)
        start_node = Node.new(grid.find("S"), false) # 0 is just while we're testing the routing
        finish_nodes = [Node.new(grid.find("E"), false)]

        distances = dijkstra_dist_to_node(grid.find("E")) do |cell|
            DIRECTIONS.each_with_object([]) do |dir, moves|
                moves << [cell + dir, 1] if grid.can_move?(cell, dir)
            end
        end
        distance_without_cheating = distances[grid.find("S")]

        total_cheats = distances.reduce(0) do |total, (cell, distance)|
            DIRECTIONS.reduce(total) do |total, dir|
                jump_two = cell + (dir * 2)
                next total if distances[jump_two].nil?
                difference = distances[jump_two] - distances[cell] + 2
                if difference <= -100
                    # p("Cheat is #{difference}")
                    total += 1
                end
                total
            end
        end
        # distances
        
        p(total_cheats)
        exit
        # distance = dijkstra(start_node, finish_nodes) do |node|
        #     DIRECTIONS.each_with_object([]) do |dir, moves|
        #         moves << [Node.new(node.cell + dir, node.cheated), 1] if grid.can_move?(node.cell, dir)
        #     end
        # end

        [grid, distance[finish_nodes.first].distance]
    end
    .yield_self do |grid, distance|

        p(distance)
        
    end
    

        # p(distance[0].distance)

        # exit


        # neighbours = Proc.new do |node|
        #     moves = []
        #     DIRECTIONS.each do |dir|
        #         moves << [Node.new(node.cell + dir, node.cheated), 1] if grid.can_move?(node.cell, dir)
        #     end

        #     unless node.cheated
        #         DIRECTIONS.each do |dir|
        #             if grid.can_move?(node.cell, dir * 2)
        #                 if node.cell[1] == 1
        #                     p("#{node.cell} -> #{node.cell + (dir * 2)}")
        #                 end
        #                 moves << [Node.new(node.cell + (dir * 2), true), 2] 
        #             end
        #         end
        #     end
        #     moves
        # end

        # # we actually want a list of lengths from every single node
        # result = dijkstra(start_node, finish_nodes) do |node|
        #     moves = []
        #     DIRECTIONS.each do |dir|
        #         moves << [Node.new(node.cell + dir, node.cheated), 1] if grid.can_move?(node.cell, dir)
        #     end

        #     unless node.cheated
        #         DIRECTIONS.each do |dir|
        #             if grid.can_move?(node.cell, dir * 2)
        #                 if node.cell[1] == 1
        #                     p("#{node.cell} -> #{node.cell + (dir * 2)}")
        #                 end
        #                 moves << [Node.new(node.cell + (dir * 2), true), 2] 
        #             end
        #         end
        #     end

        #     moves
        # end


        # p("\n\n\n")
        # p(result[finish_nodes[0]].distance)
        # result[finish_nodes[0]].each do |cell|
        #     p(cell)
        # end
        # p(start_node)
    # end
    # .tap{p(_1)}
