#!/usr/bin/env ruby

require "matrix"
require "set"

State = Struct.new(:node_map, :width, :height, :anti_nodes) do
    def is_valid?(vector) (0 <= vector[0] && vector[0] < width && 0 <= vector[1] && vector[1] < height) end
end

STDIN.read.lines(chomp: true)
    .each_with_index
    .yield_self do |grid|
        State.new(
            grid.reduce(Hash.new{|h, k| h[k] = []}) do |acc, (cell, row_idx)|
                cell.split("")
                    .each_with_index
                    .reduce(acc) do |acc, (value, col_idx)|
                        acc[value] << Vector[col_idx, row_idx] if value != "."
                        acc
                    end
                acc
            end,
            grid.first[0].length,
            grid.to_a.length
        )
    end
    .tap do |state|
        state.anti_nodes = state.node_map.reduce(Set.new) do |acc, (cell, nodes)|
            nodes.combination(2).reduce(acc) do |acc, (a, b)|
                freq = (a - b)
                acc += [].tap {|nodes| nodes << a while state.is_valid?(a += freq)}
                acc += [].tap {|nodes| nodes << b while state.is_valid?(b -= freq)}
            end + nodes
        end
    end
    .yield_self { _1.anti_nodes.length }
    .tap{ p(_1) }
