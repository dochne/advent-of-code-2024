#!/usr/bin/env ruby

# def memoize
#     @memo ||= {}
#     @memo[args] ||= yield
# end
$cache = {}

def memoize(key, &block)
    $cache[key] ||= block.call
end

STDIN.read.lines(chomp: true)
    .first.split(" ").map(&:to_i)
    .yield_self do |stones|
        25.times.reduce(stones) do |stones|
            # p(stones)
            result = []
            stones.each do |stone|
                result += memoize(stone) do 
                    if stone == 0
                        # print("Stone ", stone, " 1\n")
                        [1]
                    elsif stone.to_s.length % 2 == 0
                        # print("Stone ", stone, " %2\n")
                        stone = stone.to_s
                        [stone.to_s[0, stone.length / 2], stone.to_s[stone.length / 2, stone.length]].map(&:to_i) 
                    else
                        # print("Stone ", stone, " *2024\n")
                        [stone * 2024]
                    end
                end
            end
            result
            
        end
    end
    .tap{p(_1.length)}
