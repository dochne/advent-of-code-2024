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
            grid.each_with_object(Hash.new{|h, k| h[k] = []}) do |(cell, row_idx), acc|
                cell.split("")
                    .each_with_index
                    .each_with_object(acc) {|(value, col_idx), acc| acc[value] << Vector[col_idx, row_idx] if value != "." }
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
