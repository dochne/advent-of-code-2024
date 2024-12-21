
require 'test/unit'
require 'matrix'

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

class MyTest < Test::Unit::TestCase
  # def setup
  # end

  # def teardown
  # end

  def data_provider_numeric
    [
      ['593A', '<^^A^>AvvAvA'],
       #        <^^A>^AvvAvA
      ['459A', '^^<<A>A^>AvvvA'],
      ['283A', '<^A^^Avv>AvA'],
      ['670A', '^^A<<^A>vvvA>A'],
      # ['279A', '']
    ]
  end

#   593A
# 283A
# 670A
# 459A
# 279A


  def test_example
    data_provider_numeric.each do |value, expected|
        keypad = numeric_keypad(value)
        assert(keypad == expected, "#{value}: #{keypad} != expected #{expected}")
    end
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
  p("Direction #{movement}")
  # exit
  movement
end
end