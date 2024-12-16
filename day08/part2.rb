#!/usr/bin/env ruby

require "matrix"
require "set"

State = Struct.new(:node_map, :width, :height) do
    def is_valid?(vector) vector[0].between?(0, width - 1) && vector[1].between?(0, height - 1) end
end

STDIN.read.lines(chomp: true)
    .each_with_index
    .yield_self do |grid|
        State.new(
            grid.each_with_object(Hash.new{|h, k| h[k] = []}) do |(cell, row_idx), acc|
                cell.split("")
                    .each_with_index
                    .each_with_object(acc) do |(value, col_idx), acc|
                        acc[value] << Vector[col_idx, row_idx] if value != "."
                    end
            end,
            grid.first[0].length,
            grid.to_a.length
        )
    end
    .yield_self do |state|
        state.node_map.reduce(Set.new) do |acc, (cell, nodes)|
            nodes.combination(2).each_with_object(acc) do |(a, b), acc|
                freq = a - b
                acc << a while state.is_valid?(a += freq)
                acc << b while state.is_valid?(b -= freq)
            end + nodes
        end
    end
    .yield_self { _1.length }
    .tap{ p(_1) }
