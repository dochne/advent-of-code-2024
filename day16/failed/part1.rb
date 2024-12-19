#!/usr/bin/env ruby

require "matrix"

DIRECTIONS = [Vector[-1, 0], Vector[0, -1], Vector[1, 0], Vector[0, 1]]
CLOCKWISE = DIRECTIONS.each_with_index.each_with_object(Hash.new) {|(dir, i), acc| acc[dir] = DIRECTIONS[(i + 1) % 4]}
ANTI_CLOCKWISE = DIRECTIONS.each_with_index.each_with_object(Hash.new) {|(dir, i), acc| acc[dir] = DIRECTIONS[(i + 3) % 4]}

Grid = Struct.new(:grid) do
    def initialize(lines)
        self.grid = lines.each_with_index.reduce({}) do |acc, (cell, row_idx)|
            cell.split("")
                .each_with_index
                .reduce(acc) do |acc, (value, col_idx)|
                    next acc if value == "."
                    acc[Vector[col_idx, row_idx]] = value
                    acc
                end
            acc
        end
    end

    def find(value)
        self.grid.find {|index, v| v == value}.first
    end

    def empty?(cell) self.grid[cell].nil? || self.grid[cell] == "E" || self.grid[cell] == "S" end

    def complete?(cell) self.grid[cell] == "E" end

    def value(cell) self.grid[cell] end

    def set(cell, value)
        self.grid[cell] = value
    end

    def display
        width, height = [self.grid.keys.map{_1[0]}.max, self.grid.keys.map{_1[1]}.max]
        (0...height + 1).each do |row_idx|
            (0...width + 1).each do |col_idx|
                value = self.grid[Vector[col_idx, row_idx]] || "."
                print value == "@" ? "\033[31m@\033[0m" : value
            end
            print "\n"
        end
    end
end

$cache = {}

def memoize(key, &block)
    $cache[key] ||= block.call
end

def calculate_shortest(parents, cell, start_cell, stack = [])
    return Float::INFINITY if stack.include? cell
    memoize(cell) do
        parents[cell].map do |parent_cell|
            return 0 if parent_cell == start_cell
            calculate_shortest(parents, parent_cell, start_cell, stack + [cell]) + (cell[0] != parent_cell[0] ? 1 : 1000)
        end.min
    end
end

Pos = Struct.new(:cell, :dir)
STDIN.read.lines(chomp: true)
    .yield_self{Grid.new(_1)}
    .yield_self do |grid|
        start, finish = [grid.find("S"), grid.find("E")]
        start_pos = Pos.new(start, Vector[0, 1])
        
        bfs = [start_pos]
        visited = Set.new
        parents = Hash.new{|h, k| h[k] = []}
        # costs = {pos => 0}

        # open_set = Set.new
        # closed_set = Set.new

        # while closed_set
        
        # p(grid.empty?(Vector[0, 13]))
        # exit
        while pos = bfs.pop
            # p(pos)

            

            visited << pos

            options = {
                Pos.new(pos.cell + pos.dir, pos.dir) => 1,
                Pos.new(pos.cell, CLOCKWISE[pos.dir]) => 1000,
                Pos.new(pos.cell, ANTI_CLOCKWISE[pos.dir]) => 1000
            }

            options.each do |next_pos, cost|
                next unless grid.empty?(next_pos.cell)
                

                # if next_pos[0][0] < 0
                #     p(pos)
                #     p("Pos", grid.value(pos))
                #     exit
                # end
                parents[next_pos] << pos
                bfs << next_pos unless visited.include?(next_pos)
            end

            # p(visited.length)
            # p(bfs.length)


            # next_pos = Pos.new(cell + dir, dir)
            # if visited[next_pos] < 
            
            # bfs << 
            
            # [, Pos.new(cell, CLOCKWISE[dir]), Pos.new(cell)
            # if grid.empty?(cell + dir)
                
            #     next_pos = Pos.new(cell + dir, dir)
            #     if visited[next_pos].nil?
            #         visited[next_pos] = visited[pos] + 1    
            #     else
            #         visited[next_pos] = visited[pos] + 1
            #     end
                
            #     next unless visited[next_pos].nil?
            #     bfs << next_pos
                
        end


        # if grid.complete?(pos.cell)
            # p()
        
        shortest = DIRECTIONS.map{calculate_shortest(parents, Pos.new(finish, _1), start_pos)}
        # shortest = calculate_shortest(parents, Pos.new(finish, Vector[0, 1]), start_pos)
        p(shortest)
        exit
        # end
        # p(visited)
        # exit


        
        visited.each do |cell|
            # p(cell.cell)
            grid.set(cell.cell, "@")
            # p cell
        end
        
        

        # two moves - move forward (if possible) or rotate right or left

        # p(visited)

        # score 
        # if visited[[pos, direction]]
        

        grid

    end
    .tap{_1.display}

    # .tap{p(_1)}
