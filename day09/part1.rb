#!/usr/bin/env ruby

Pointer = Struct.new(:start, :end_, :value)

STDIN.read.lines(chomp: true)
    .first.split("").map(&:to_i)
    .each_with_object([]) do |n, acc|
        next acc << Pointer.new(0, n, 0) if acc.length == 0
        acc << Pointer.new(acc.last.end_, acc.last.end_ + n, acc.length % 2 == 0 ? acc.length / 2 : ".")
    end
    .tap {_1.each{|v| p(v)} }




    # we're goign to need a heap of some sort
    # maybe what we need is a list of indexes, so 10:15