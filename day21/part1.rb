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

def directional_keypad(code)
    # p("Code incoming #{code}")
    code = code.split("")
    movement = ""
    last_char = "A"
    # pos = ARROW_MAP["A"]
    while char = code.shift
        pos = ARROW_MAP[last_char]
        next_pos = ARROW_MAP[char]
        diff = next_pos - pos
        
        # so, we know where we currently are, it's a bit of a head fuck as we
        # want to prioritise for future uses of this method

        
        # if 
        # if horizontal = positive, move horizontal first
        # if horitontal = negative, move vertical first

        # always prioritise going left as soon as possible
        can_go_left_first = pos + Vector[diff[0], 0] != Vector[0, 0]

        ma = ""
        ma += "".rjust(diff[0].abs, diff[0] < 0 ? "<" : ">") if can_go_left_first
        ma += "".rjust(diff[1].abs, diff[1] < 0 ? "^" : "v") if diff[1] != 0
        ma += "".rjust(diff[0].abs, diff[0] < 0 ? "<" : ">") unless can_go_left_first
        ma += "A"

        # p("Last Char #{last_char} - Pos #{pos} - NextChar: #{char} - NextPos #{next_pos} - Diff #{diff} - #{ma}")
        movement += ma
        # last_pos = pos
        last_char = char
    end
    # p("Keypad: #{movement}")
    
    movement
end

def numeric_keypad(code)
    code = code.split("")
    movement = ""
    last_char = "A"
    
    while char = code.shift
        pos = KEYPAD_MAP[last_char]
        next_pos = KEYPAD_MAP[char]
        diff = next_pos - pos
        
        
        ma = ""
        # if horizontal = positive, move horizontal first
        # if horitontal = negative, move vertical first
        
  
  
    # prioritise going left MAX DISTANCE (if you can)
    # then going up
    # then going down
    # then going right
        must_go_left_first = pos + Vector[diff[0], 0] != Vector[0, 3] && diff[0] < 0
        must_go_right_first = pos + Vector[0, diff[1]] == Vector[0, 3]
  
        ma = ""
        # if can_go_left_first && diff[0] < 0
        #     ma += "".rjust(diff[0].abs, "<")
        # end
  
            # then we can go left!
  
        
        horizontal_done = false
        ma += "".rjust(diff[0].abs, diff[0] < 0 ? "<" : ">") if must_go_left_first || must_go_right_first
        # ma += "".rjust(diff[0].abs, ">") if !can_go_down_first && diff[0] > 0
        # ma += "".rjust(diff[1].abs, "v") if can_go_down_first && diff[1] < 0
        ma += "".rjust(diff[1].abs, diff[1] < 0 ? "^" : "v") #if !can_go_down_first || diff[1] > 0
  
        ma += "".rjust(diff[0].abs, diff[0] < 0 ? "<" : ">") if !must_go_left_first && !must_go_right_first
        
        ma += "A"
  
        # 379A
        # Bad: ^A^^<<A>>AvvvA
        # Gud: ^A<<^^A>>AvvvA
  
        # Bad: <A>A<AA<vAA>>^AvAA^A<vAAA>^A
        # Gud: <A>Av<<AA>^AA>AvAA^A<vAAA>^A
  
        # p("Last Char #{last_char} - Pos #{pos} - NextChar: #{char} - NextPos #{next_pos} - Diff #{diff} - #{ma}")
        movement += ma
        #[46254, 21508, 45560, 33966, 21204]
        # 168492 = too high
        # 168492 = too high, i guess let's write some kind of recursive bullshit?
  
        # pos = next_pos
        last_char = char
    end
    # p("Direction #{movement}")
    # exit
    movement
  end

# Data: day21/data.txt

# "<AAv<A>^>A<Av>A^Av<AA^>Av<A^>A"
# "<vA<AA>>^AvA<^A>AAvA^A<vA>^A<v<A>^A>AvA^A<v<A>A>^AAvA<^A>Av<<A>A>^AvA^<A>A"
# "74 x 593"
# "<Av<A>^>A<AA>Av<AA>A^Av<A^>A"
# "<vA<AA>>^AvA<^A>AvA^A<v<A>>^AAvA^A<vA<A>>^AAvA^A<A>A<v<A>A>^AvA<^A>A"
# "68 x 283"
# "<AA>A<Av<AA>>^AvA<AAA>^AvA^A"
# "v<<A>^>AAvA^Av<A<AA>^>AAvA^<A>AvA^Av<A^>Av<<A>^>AAA<Av>A^Av<A^>A<A>A"
# "68 x 670"
# "<AAv<AA>^>AvA^A<Av>A^Av<AAA^>A"
# "v<<A>^>AAv<A<A>^>AAvAA^<A>Av<A^>A<A>Av<<A>^>Av<A>A^A<A>Av<A<A>^>AAA<A>vA^A"
# "74 x 459"
# "<Av<A>^>A<AAv<A>^>AvAA^Av<AAA^>A"
# "<vA<AA>>^AvA<^A>AvA^A<vA<AA>>^AvA<^A>AAvA^A<vA>^AA<A>A<v<A>A^>AAAvA<^A>A"
# "72 x 279"
# [43882, 19244, 45560, 33966, 20088]
# 162740

# could it be something like "Prioritise right and up"? Why would that help?

# if X presses will take us out of bounds, prioritise the other option
# otherwise, prioritise the closer option


# if last button was (say) < and we need to do another <, prioritise that first
# maybe? we're always having to press A when we're on a robot right?

# should we do an optimisation pass?

# if the last direction was up, then we optimise down first rather than L/R


# value = "379A"
#     .tap{p(_1)}
#     .yield_self {numeric_keypad(_1)}
#     # .yield_self {"^A<<^^A>>AvvvA"}
#     .tap{p(_1)}
#     .yield_self {directional_keypad(_1)}
#     .tap{p(_1)}
#     .yield_self {directional_keypad(_1)}
#     .tap{p(_1)}
#     .tap{p(_1.length)}

# # # p(value)

# exit

# 379A
#     +---+---+
#     | ^ | A |
#     +---+---+
# | < | v | > |
# +---+---+---+
# <A{3}>A{PRESS}<AA{9}v<AA{7}>>^A{PRESS}vAA{9}^A{PRESS}v<AAA{A}>^A{PRESS}
# <A>A<AAv <AA>>^ AvAA ^Av<AAA>^A

#< v<<A
#A >>^A
#> vA
#A ^A
#< v<<A
#A >>^A
#A A
#v v<A

#< <A
#A >>^A
#A A
#> vA
#> A
#^ ^<A
#A >A
#v <vA
#A ^>A
#A A

#^ <A
#A >A
#v <vA
#< <A
#A >>^A
#A A
#A A
#> vA
#^ <^A
#A >A


# -----
# v<<A>>^AvA^Av<<A>>^AAv<A<A>>^AAvAA^<A>A<vA^>AA<A>A<vA<A>>^AAAvA<^A>A #68
# v<<A>>^AvA^Av<<A>>^AAv<A<A>>^AAvAA^<A>Av<A>^AA<A>Av<A<A>>^AAAvA^<A>A

# v<<A>>^A = <
# vA = >
# <A = ^
# v<A = v
# A = A

#     +---+---+
#     | ^ | A |
#     +---+---+
# | < | v | > |
# +---+---+---+

# If we're travelling to <, we want to do it first as that way we can optimise for pressing < twice, not once

# <A{3}>A{PRESS}v<<AA{1}>^AA{7}>A{PRESS}vAA{7}^A{PRESS}v<AAA{A}>^A{PRESS}
# <A{3}>A{PRESS}<AA{9}<vAA{7}^>>A{PRESS}vAA{7}^A{PRESS}<vAAA{A}^>A{PRESS}

# <A{3}>A{PRESS}<AA{9}<vAA^>>AvAA^A<vAAA^>A
# <A{3}>A{PRESS}<AA{9}<vAA^>>AvAA^A<vAAA^>A
# <A{3}>A{PRESS}<AA{9}<vAA{7}^>>A{PRESS}vAA{7}^A{PRESS}<vAAA{A}^>A{PRESS}
# +---+---+---+
# | 7 | 8 | 9 |
# +---+---+---+
# | 4 | 5 | 6 |
# +---+---+---+
# | 1 | 2 | 3 |
# +---+---+---+
#     | 0 | A |
#     +---+---+
#^A^^<<A>>AvvvA

# length is equal to vector distance from A

# <<vA^>>AvA^A<<vA^>>AA<<vA>A^>AA<Av>AA^A<vA^>AA<A>A<<vA>A^>AAA<Av>A^A
# <v<A>>^AvA^A<vA<AA>>^AAvA<^A>AAvA^A<vA>^AA<A>A<v<A>A>^AAAvA<^A>A

# exit

STDIN.read.lines(chomp: true)
    .map do |code|
        # p(code)
        code
            .yield_self {numeric_keypad(_1)}
            # .tap{p("Dir", _1)}
            .yield_self do |v|
                2.times do |n|
                    p(n)
                    v = directional_keypad(v)
                end
                v
            end
            # .yield_self {directional_keypad(_1)}
            # # .tap{p("Dir2", _1)}
            # .yield_self {directional_keypad(_1)}
            # .tap{p("Dir3", _1)}
            .tap{p("#{_1.length} x " + code.sub("A", ""), '')}
            .length * code.sub("A", "").to_i
    end
    .tap{p(_1)}
    .reduce(&:+)
    .tap{p(_1)}


    # Good: v<<A>^A>A<AA>A<vAA>A^A<vA>^A
    # Bad : v<<A>^A>A<AA>AvA<AA>^A<vA>^A

    # prioritise going left MAX DISTANCE (if you can)
    # then going up
    # then going down
    # then going right

    # Good: <^A^^Avv>AvA
    # Bad:  <^A^^A>vvAvA