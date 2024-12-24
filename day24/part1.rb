#!/usr/bin/env ruby

Instruction = Struct.new(:input1, :op, :input2, :output) do
    def can_run? (memory)
        !memory[self.input1].nil? && !memory[self.input2].nil?
    end
end
# we're really after a dependency graph here aren't we
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
            .map{Instruction.new(*_1)}
        ]
    end
    .yield_self do |memory, instructions|
        while instructions.length > 0
            p(instructions.length)
            to_run = instructions.filter{_1.can_run?(memory)}
            instructions = instructions.filter{!_1.can_run?(memory)}
            p(to_run)
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
        memory
    end
    .filter{|k, v| k[0] == "z"}
    .sort_by{|k, v| k}
    .reverse
    .map{_1[1]}
    .join("")
    .to_i(2)
    .tap{p(_1)}
