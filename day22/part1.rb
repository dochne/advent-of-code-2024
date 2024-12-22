#!/usr/bin/env ruby

def mix(secret, value)
    secret ^ value
end

def prune(secret)
    secret % 16777216
end

def solve(v, n)
    while n > 0
        r = v * 64
        v = v ^ r # mix 
        v = v % 16777216 # prune

        r = v / 32
        v = v ^ r # mix
        v = v % 16777216 # prune

        r = v * 2048
        v = v ^ r # mix
        v = v % 16777216 # prune
        n -= 1
    end
    v
end

STDIN.read.lines(chomp: true)
    .map do |value|
        solve(value.to_i, 2000)
    end
    .sum
    .tap{p(_1)}

#     .yield_self do |v| 
#         v = v.to_i


#         # p(mix(42, 15))
#         # p(prune(100000000))
#         # exit
#         v = 123

        
#         p(solve(v, 10))
#         exit
#         10.times do
#             # p(v)

# # Calculate the result of multiplying the secret number by 64.
# #     Then, mix this result into the secret number.
# #     Finally, prune the secret number.

# # Calculate the result of dividing the secret number by 32. Round the result down to the nearest integer.
# #     Then, mix this result into the secret number.
# #     Finally, prune the secret number.

# # Calculate the result of multiplying the secret number by 2048. Then, mix this result into the secret number. Finally, prune the secret number.

#             # v = prune(mix(v, v * 64))
#             # v = prune(mix(v, v / 32))
#             # v = prune(mix(v, v * 2048))

#             r = v * 64
#             # p("r", r)
#             v = v ^ r # mix 
#             v = v % 16777216 # prune
        
#             # p(v)
            
#             r = v / 32
#             # p("r", r)
#             v = v ^ r # mix
#             v = v % 16777216 # prune

#             # p(v)
#             r = v * 2048
#             # p("r", r)
#             v = v ^ r # mix
#             v = v % 16777216 # prune


#             p(v)
#         end

#         # p(v)
#     end
#     .tap{p(_1)}
