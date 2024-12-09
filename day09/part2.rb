#!/usr/bin/env ruby

Pointer = Struct.new(:start, :length, :value)

STDIN.read.lines(chomp: true)
    .first.split("").map(&:to_i)
    .each_with_object([]) do |n, acc|
        next acc << Pointer.new(0, n, 0) if acc.length == 0
        acc << Pointer.new(acc.last.start + acc.last.length, n, acc.length % 2 == 0 ? acc.length / 2 : ".")
    end
    .yield_self do |pointers|
        shifted = []
        while true do
          break if pointers.length == 0
          next_gap_idx = pointers.find_index{|v| v.value == "." && v.length >= pointers.last.length}
          if next_gap_idx.nil?
            shifted.unshift pointers.pop
            pointers.pop if pointers.last&.value == "." 
            next
          end

          gap = pointers[next_gap_idx]
          data = pointers.pop
          if data.length == gap.length
              pointers[next_gap_idx] = Pointer.new(gap.start, gap.length, data.value)
          elsif data.length < gap.length
              pointers[next_gap_idx] = Pointer.new(gap.start, data.length, data.value)
              pointers.insert(next_gap_idx + 1, Pointer.new(gap.start + data.length, gap.length - data.length, gap.value))
          end
          pointers.pop if pointers.last.value == "." 
        end
        pointers + shifted
    end
    .reduce(0) do |acc, pointer|
        (pointer.start...(pointer.start + pointer.length)).each do |i|
            acc += (i * pointer.value)
        end
        acc
    end
    .tap{p(_1)}
