#!/usr/bin/env ruby

require "matrix"

def resolve(a, b, total)
    100.times.each do |n|
        an = a * n
        next nil if an[0] > total[0] || an[1] > total[1]
        if (total[0] - an[0]) % b[0] == 0 && (total[1] - an[1]) % b[1] == 0
            if (total[0] - an[0]) / b[0] == (total[1] - an[1]) / b[1]
                # p("Found", (total[0] - an[0]) / b[0])
                print("Presses - A: #{n}; B: ", (total[0] - an[0]) / b[0], "\n")
                print("Returning ", (n * 3) + (total[0] - an[0]) / b[0], "\n")
                return (n * 3) + (total[0] - an[0]) / b[0]
            end
        end
    end
    0
end

STDIN.read.lines(chomp: true)
    .join("\n").split("\n\n")
    # ["Button A: X+94, Y+34", "Button B: X+22, Y+67", "Prize: X=8400, Y=5400"]
    # .map{_1.map{|line| line.match(/X\+(\d+)), Y\+(\d+)/)}}
    .map do |problem|
        problem.split("\n").map do |line|
            line
                .match(/X[+=](\d+), Y[+=](\d+)/)
                .to_a.drop(1).map(&:to_i)
                .yield_self{Vector.elements(_1)}
        end
    end
    .reduce(0) do |acc, (a, b, total)|
        acc += resolve(a, b, total)
        # 100.times.reduce(0) do |acc, n|
        # this could be better if we just removed it from total each timea nd kept track
        # acc += (100.times.lazy.map.with_index, find do |n, i|
        #     p(n)
        #     an = a * n
        #     next nil if an[0] > total[0] || an[1] > total[1]
        #     if (total[0] - an[0]) % b[0] == 0 && (total[1] - an[1]) % b[1] == 0
        #         if (total[0] - an[0]) / b[0] == (total[1] - an[1]) / b[1]
        #             # p("Found", (total[0] - an[0]) / b[0])
        #             print("Presses - A: #{n}; B: ", (total[0] - an[0]) / b[0], "\n")
        #             print("Returning ", (n * 3) + (total[0] - an[0]) / b[0], "\n")
        #             next (n * 3) + (total[0] - an[0]) / b[0]
        #         end
        #     end
        # end || 0)

        # p("Acc", acc)
        # exit
    end
    # .reduce(0) do |a, b, total|
    #     total - x
    # end
    .tap{p(_1)}



        # # 100.times do |n|
            
        #     # next if (a[0] * n) > total[0] || b[1] 
        #     # if (total[0] - (a[0] * n)) % b[0] == 0 && (total[1] - (a[1] * n)) % b[1] == 0
        #     #     bn = total[0] - (a[0] * n) / b[0] 
        #     #     next if (total[0] - (a[0] * n)) / b[0] != (total[1] - (a[1] * n)) / b[1]
        #     #     p("Yay! Match!")
        #     #     exit

        #     # end
        # end
        # a[0]
        # exit