#!/usr/bin/env ruby

STDIN.read.split("\n\n")
    .reduce([[],[]]) do |acc, segment|
        line = segment.lines(chomp: true)
            .map{_1.split("")}
            .transpose
        acc[segment[0] == "#" ? 0 : 1] << line.map{|pin| pin.filter{_1 == "#"}.length}
        acc
    end
    .yield_self do |box|
        box[0].reduce(0) do |acc, lock|
            acc += box[1].filter{|key| lock.zip(key).filter{_1 + _2 <= 7}.length == 5}.length
        end
    end
    .tap{p(_1)}
