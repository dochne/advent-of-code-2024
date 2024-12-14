#!/usr/bin/env ruby

require "matrix"
require "chunky_png"

STDIN.read.lines(chomp: true)
    .map{_1.match(/=(-?\d+,-?\d+).*=(-?\d+,-?\d+)/).to_a.drop(1).map{|v| Vector.elements(v.split(",").map(&:to_i))}}
    .yield_self do |grid|
        width = 101
        height = 103

        black = ChunkyPNG::Color('black @ 0.5')

        1000000000000.times do |times|

            # This was hacked here after we'd found the sus images
            next unless (times - 50) % 103 == 0
            next unless (times - 97) % 101 == 0

            filename = "#{Dir.pwd}/day14/.artifacts/#{times.to_s.rjust(5, "0")}.png"
            next if File.exist? filename

            grid.map do |cell, velocity|
                (cell + (velocity * times)).yield_self{|c| Vector[c[0] % width, c[1] % height]}
            end
            .tap do |grid|
                png = ChunkyPNG::Image.new(width, height, ChunkyPNG::Color::WHITE)

                # h: 103 each time
                # horizontal: 50, 153, 256
                # v: 101 each time
                # vertical: 97, 198, 299

                hash = grid.each_with_object(Hash.new(0)){|cell, acc| acc[cell] += 1}
                (0...height).each do |row_idx|
                    (0...width).each do |col_idx|
                        if hash[Vector[col_idx, row_idx]] != 0
                            png[col_idx, row_idx] = black
                        end
                    end
                end

                png.save(filename, :interlace => true)
                return
                ""
            end
        end
    end
    .tap{p(_1)}

