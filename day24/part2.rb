#!/usr/bin/env ruby

Instruction = Struct.new(:input1, :op, :input2, :output) do
    def can_run? (memory)
        !memory[self.input1].nil? && !memory[self.input2].nil?
    end
end

def input(name)
    case name[0]
        when "x" then "#{name} [style=filled, fillcolor=yellow]"
        when "y" then "#{name} [style=filled, fillcolor=orange]"
        when "z" then "#{name} [style=filled, fillcolor=red]"
        else "#{name}"
        end
end

STDIN.read.split("\n\n")
    .yield_self do |memory, instructions|
        [
            memory.lines.each_with_object([]) do |line, acc|
            acc << line
                .match(/([^ ]+): ([^ ]+)/)
                .to_a
                .drop(1)
                .yield_self {[_1[0], _1[1].to_i]}
            end.to_h,
            instructions.lines(chomp: true).map do |line|
                line.match(/([^ ]+) (AND|OR|XOR) ([^ ]+) -> ([^ ]+)/)
                    .to_a
                    .drop(1)
            end
            .map{
                i1, i2 = [_1, _3].sort
                Instruction.new(i1, _2, i2, _4)
            }
        ]
    end
    .yield_self do |memory, instructions|
        swap_pairs = [
            ["z07", "vmv"],
            ["z20", "kfm"],
            ["z28", "hnv"],
            ["hth", "tqr"], # 35ish
        ]

        swap_pairs.each do |(i1, i2)|
            index_1 = instructions.find_index{|i| i.output == i1}
            index_2 = instructions.find_index{|i| i.output == i2}
            instructions[index_1].output = i2
            instructions[index_2].output = i1
        end

        # hnv,hth,kfm,pkm,tqr,z07,z20,z28 - not right
        print(swap_pairs.flatten.sort.join(","), "\n")
        [memory, instructions]
    end
    .yield_self do |memory, instructions|
        initial_memory = memory
        initial_instructions = instructions
        while instructions.length > 0
            changed = false
            to_run = instructions.filter{_1.can_run?(memory)}
            instructions = instructions.filter{!_1.can_run?(memory)}
            to_run.each do |l|
                value1 = memory[l.input1]
                value2 = memory[l.input2]
                memory[l.output] = case l.op
                when "AND"; value1 & value2
                when "OR"; value1 | value2
                when "XOR"; value1 ^ value2
                else raise "oh no"
                end
            end
        end
        [
            initial_memory,
            initial_instructions,
            memory.filter{_1[0] == "z"}.sort_by{_1[0]}.map{_1[1]}.join("").reverse
        ]
    end
    .yield_self do |memory, instructions, result|        
        schema = ["digraph {"]
        schema += instructions
            .reduce(Set.new) {|acc, i| acc += [i.input1, i.input2, i.output]}
            .map do |name|
                case name[0]
                    when "x" then "#{name} [style=filled, fillcolor=yellow, shape=circle]"
                    when "y" then "#{name} [style=filled, fillcolor=orange, shape=circle]"
                    when "z" then "#{name} [style=filled, fillcolor=red, shape=circle]"
                    else "#{name} [style=filled, fillcolor=darkseagreen4, shape=circle]"
                end
            end
            .filter {!_1.nil?}

        instructions.each_with_index do |l, i|
            op_node = "#{l.input1}_#{l.input2}_#{i}"

            schema << "  #{op_node}[label=\"#{l.op}\",style=filled,fillcolor=deepskyblue,shape=circle]"
            schema << "  " + l.input1 + " -> #{op_node}"
            schema << "  " + l.input2 + " -> #{op_node}"
            schema << "  #{op_node} -> #{l.output}";
        end
        schema << "}"
        Dir::mkdir(".artifacts") unless Dir.exist?(".artifacts")
        File::write(".artifacts/schema.dot", schema.join("\n"))
        value = `dot -Tsvg .artifacts/schema.dot -o .artifacts/schema.svg`
        # p(value)
        `open "file://#{Dir.pwd}/.artifacts/schema.svg"`

        x = memory.filter{_1[0] == "x"}.values.join("").reverse
        y = memory.filter{_1[0] == "y"}.values.join("").reverse
        v = (x.to_i(2) + y.to_i(2)).to_s(2)
        print(x.rjust(v.length, "0"), ": #{x.to_i(2)}\n")
        print(y.rjust(v.length, "0"), ": #{y.to_i(2)}\n")
        print("\n")
        print("Expected\n")
        print(v,  ": #{v.to_i(2)}\n")
        print("Actual\n")
        print(result.rjust(v.length, "0"), ": #{result.to_i(2)}\n")
        print("Diff\n")
        print(v.to_i(2) - result.to_i(2), "\n")
        exit
    end
