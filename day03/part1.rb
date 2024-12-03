#!/usr/bin/env ruby

STDIN.read.lines(chomp: true)
    .join("")
    .scan(/mul\((\d{1,3}),(\d{1,3})\)/)
    .reduce(0) {|acc, row| acc + row.map(&:to_i).reduce(:*)}
    .tap{p(_1)}
    