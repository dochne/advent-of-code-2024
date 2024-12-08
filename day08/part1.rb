#!/usr/bin/env ruby

require "matrix"

State = Struct.new(:node_map, :width, :height)

STDIN.read.lines(chomp: true)
    .each_with_index
    .yield_self do |grid|
        nodes = grid.reduce(Hash.new{|h, k| h[k] = []}) do |acc, (cell, row_idx)|
            cell.split("")
                .each_with_index
                .reduce(acc) do |acc, (value, col_idx)|
                    acc[value] << Vector[col_idx, row_idx] if value != "."
                    acc
                end
            acc
        end
        State.new(nodes, grid.first[0].length, grid.to_a.length)
    end
    .yield_self do |state|
        anti_nodes = state.node_map.reduce([]) do |acc, (cell, nodes)|
            nodes.combination(2) do |a, b|
                acc << a - ((a - b) * 2)
                acc << b + ((a - b) * 2)

                # print(a, " ", b, " ", a - ((a - b) * 2), " ", a + ((a - b) * 2)," ")
                # # p(a)
                # # p(b)
                # # p(a - ((a - b) * 2))
                # if nodes.include? a - ((a - b) * 2)
                #     p("Yay")
                # elsif nodes.include? a + ((a - b) * 2)
                #     p("Other yay")
                # else
                #     p("Nay")
                # end
            end

            acc
        end

        def get_cell(state, vector, anti_nodes)
            return "X" if anti_nodes.include? vector
            state.node_map.each do |(cell, nodes)|
                return cell if nodes.include? vector
            end
            return "."
        end

        (0...state.height).each do |row_idx|
            (0...state.width).each do |col_idx|
                print get_cell(state, Vector[col_idx, row_idx], anti_nodes)
            end
            print("\n")
        end

        # anti_nodes.uniq.length
        # grid.each_index do |idx|
        #     p(idx)
        # end

        v = anti_nodes.filter do |cell|
            0 <= cell[0] && cell[0] < state.width && 0 <= cell[1] && cell[1] < state.height
        end

        v.uniq.length
        # p(nodes.length)
        # p(nodes.length)
        
    end
    .tap{ p(_1) }


