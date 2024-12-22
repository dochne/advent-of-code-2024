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

VALID_KEYPAD_VECTORS = Set.new(KEYPAD_MAP.values)

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

VALID_ARROW_VECTORS = Set.new(ARROW_MAP.values)

# This is horseshit - let's make a method that takes a code, a position AND the current string
$cache = {}

def memoize(key, &block)
    $cache[key] ||= block.call
end

def numberpad_shift(code, pos)
    memoize("ns:#{code}:#{pos}") do
        return [] unless VALID_KEYPAD_VECTORS.include? pos # dead square
        return [""] if code.length == 0 # valid endpoint
        next_pos = KEYPAD_MAP[code[0]]
        diff = next_pos - pos
        options = []
        if diff == Vector[0, 0]
            options << ["A", numberpad_shift(code.last(code.length - 1), pos) ]
        else
            options << ["<", numberpad_shift(code, pos + Vector[-1, 0] )] if diff[0] < 0
            options << [">", numberpad_shift(code, pos + Vector[1, 0] )] if diff[0] > 0
            options << ["^", numberpad_shift(code, pos + Vector[0, -1] )] if diff[1] < 0
            options << ["v", numberpad_shift(code, pos + Vector[0, 1])] if diff[1] > 0
        end

        options.map do |(char, codes)|
            codes.map{char + _1}
        end.flatten
    end
end


def directional_shift(code, pos)
    memoize("ds:#{code}:#{pos}") do
        # return [] if pos == Vector[0, 0]
        return [] unless VALID_ARROW_VECTORS.include? pos
        return [""] if code.length == 0
        next_pos = ARROW_MAP[code[0]]
        diff = next_pos - pos
        options = []
        if diff == Vector[0, 0]
            options << ["A", directional_shift(code.last(code.length - 1), pos) ]
        else
            options << ["<", directional_shift(code, pos + Vector[-1, 0] )] if diff[0] < 0
            options << [">", directional_shift(code, pos + Vector[1, 0] )] if diff[0] > 0
            options << ["^", directional_shift(code, pos + Vector[0, -1] )] if diff[1] < 0
            options << ["v", directional_shift(code, pos + Vector[0, 1])] if diff[1] > 0
            
        end

        options.map do |(char, codes)|
            codes.map{char + _1}
        end.flatten
    end
end

STDIN.read.lines(chomp: true)
    .map do |code|
        # next nil if code != "456A"
        code
            .yield_self do |code|
                options = numberpad_shift(code.split(""), KEYPAD_MAP["A"])
                # p(options)
                # exit
            end
            .yield_self do |options|
                options = options.map do |option|
                    directional_shift(option.split(""), ARROW_MAP["A"])
                end.flatten

                option = options.sort_by(&:length).first
                p(option)
                options
            end
            .yield_self do |options|
                options = options.map do |option|
                    directional_shift(option.split(""), ARROW_MAP["A"])
                end.flatten

                option = options.sort_by(&:length).first
                p(option)
                options
            end
            .yield_self do |options|
                # options.map do |options| 
                
                option = options.sort_by(&:length).first
            

                # if code == "456A"
                #     p(option)
                #     # p(option.length)
                # end
                    # p(v1.first)
                    # p(v1.last)

                length = option.length

                    # exit
                    p("#{length} x #{code.sub("A", "")}")
                    length * code.sub("A", "").to_i
                    # p(v2)
                    # exit
                    # p(v2.first)
                    # exit
                # end
            end

        # code
        #     .yield_self {numeric_keypad(_1)}
        #     # .tap{p("Dir", _1)}
        #     .yield_self {directional_keypad(_1)}
        #     # .tap{p("Dir2", _1)}
        #     .yield_self {directional_keypad(_1)}
        #     # .tap{p("Dir3", _1)}
        #     .tap{p("#{_1.length} x " + code.sub("A", ""), '')}
        #     .length * code.sub("A", "").to_i
    end
    .tap{p(_1)}
    .sum()
    .tap{p(_1)}