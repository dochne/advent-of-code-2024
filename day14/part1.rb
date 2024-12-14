#!/usr/bin/env ruby

require "matrix"
#p=0,4 v=3,-3
STDIN.read.lines(chomp: true)
    .map{_1.match(/=(-?\d+,-?\d+).*=(-?\d+,-?\d+)/).to_a.drop(1).map{|v| Vector.elements(v.split(",").map(&:to_i))}}
    .yield_self do |grid|
        # width = 11
        # height = 7

        width = 101
        height = 103
        times = 100
        
        grid.map do |cell, velocity|
            (cell + (velocity * times)).yield_self{|c| Vector[c[0] % width, c[1] % height]}
        end
        .tap do |grid|
            hash = grid.each_with_object(Hash.new(0)){|cell, acc| acc[cell] += 1}
            (0...height).each do |row_idx|
                (0...width).each do |col_idx|
                    print hash[Vector[col_idx, row_idx]].yield_self{_1 == 0 ? "." : _1}
                end
                print "\n"
            end
        end
        .reduce(Hash.new{|h, k| h[k] = 0}) do |acc, cell|
            next acc if cell[0] == (width / 2).ceil || cell[1] == (height / 2).ceil
            acc[Vector[(cell[0].to_f / width).round, (cell[1].to_f / height).round]] += 1
            acc
        end
        .values
        .reduce(:*)
    end
    .tap{p(_1)}

