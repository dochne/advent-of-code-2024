#!/usr/bin/env ruby

require "matrix"
# +---+---+---+
# | 7 | 8 | 9 |
# +---+---+---+
# | 4 | 5 | 6 |
# +---+---+---+
# | 1 | 2 | 3 |
# +---+---+---+
#     | 0 | A |
#     +---+---+

KEYPAD_MAP = {
    "A" => Vector[2, 3],
    "0" => Vector[1, 3],
    "1" => Vector[0, 2],
    "2" => Vector[1, 2],
    "3" => Vector[2, 2],
    "4" => Vector[0, 1],
    "5" => Vector[1, 1],
    "6" => Vector[2, 1],
    "7" => Vector[0, 0],
    "8" => Vector[1, 0],
    "9" => Vector[2, 0],
}

#     +---+---+
#     | ^ | A |
#     +---+---+
# | < | v | > |
# +---+---+---+
ARROW_MAP = {
    "^" => Vector[1, 0],
    "A" => Vector[2, 0],
    "<" => Vector[0, 1],
    "v" => Vector[1, 1],
    ">" => Vector[2, 1]
}

$cache = {}
def memoize(key, &block)
    $cache[key] ||= block.call
end

def directional_keypad(code)
    memoize(code) do
        code = code.split("")
        movement = []
        last_char = "A"
        while char = code.shift
            pos = ARROW_MAP[last_char]
            next_pos = ARROW_MAP[char]
            diff = next_pos - pos

            must_go_left_first = pos + Vector[diff[0], 0] != Vector[0, 0] && diff[0] < 0
            must_go_right_first = pos + Vector[0, diff[1]] == Vector[0, 0]
    
            ma = ""
            ma += "".rjust(diff[0].abs, diff[0] < 0 ? "<" : ">") if must_go_left_first || must_go_right_first || diff[0] > 1
            ma += "".rjust(diff[1].abs, diff[1] < 0 ? "^" : "v") if diff[1] != 0
            ma += "".rjust(diff[0].abs, diff[0] < 0 ? "<" : ">") if !must_go_left_first && !must_go_right_first && diff[0] <= 1
            ma += "A"

            movement << ma
            last_char = char
        end

        movement
    end
end

def numeric_keypad(code)
    code = code.split("")
    movement = []
    last_char = "A"

    while char = code.shift
        pos = KEYPAD_MAP[last_char]
        next_pos = KEYPAD_MAP[char]
        diff = next_pos - pos

        must_go_left_first = pos + Vector[diff[0], 0] != Vector[0, 3] && diff[0] < 0
        must_go_right_first = pos + Vector[0, diff[1]] == Vector[0, 3]
        
        ma = ""
        ma += "".rjust(diff[0].abs, diff[0] < 0 ? "<" : ">") if must_go_left_first || must_go_right_first || diff[0] > 1
        ma += "".rjust(diff[1].abs, diff[1] < 0 ? "^" : "v")
        ma += "".rjust(diff[0].abs, diff[0] < 0 ? "<" : ">") if !must_go_left_first && !must_go_right_first && diff[0] <= 1
        ma += "A"

        movement << ma
        last_char = char
    end
    movement
end

STDIN.read.lines(chomp: true)
    .map do |code|
        code
        .yield_self {numeric_keypad(_1)}
        .yield_self do |path|
            tally = path.tally
            25.times do |n|
                tally = tally.reduce(Hash.new(0)) do |tally, (key, value)|
                    directional_keypad(key).each {|new_key| tally[new_key] += value}
                    tally
                end
            end
            tally.reduce(0) {|acc, (k, v)| acc += k.length * v} * code.sub("A", "").to_i
        end
    end
    .tap{p(_1)}
    .sum
    .tap{p(_1)}
