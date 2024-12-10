#!/usr/bin/env ruby

require "matrix"

State = Struct.new(:by_vector, :by_value)

VECTORS = [Vector[0, 1], Vector[0, -1], Vector[-1, 0], Vector[1, 0]]

STDIN.read.lines(chomp: true)
    .each_with_index
    .yield_self do |grid|
        grid.reduce(State.new({}, Hash.new{|h, k| h[k]=[]})) do |acc, (cell, row_idx)|
            cell.split("")
                .each_with_index
                .reduce(acc) do |acc, (value, col_idx)|
                    acc.by_vector[Vector[col_idx, row_idx]] = value.to_i
                    acc.by_value[value.to_i] << Vector[col_idx, row_idx]
                    acc
                end
            acc
        end
    end
    .yield_self do |state|
        (0..9).reverse_each.reduce({}) do |acc, n|
            state.by_value[n].each_with_object({}) do |cell, next_acc|
                next next_acc[cell] = 1 if n == 9
                next_acc[cell] = VECTORS.reduce(0) {|sum, vector| sum + acc[cell + vector].to_i}
            end
        end
    end
    .values
    .sum
    .tap{p(_1)}

