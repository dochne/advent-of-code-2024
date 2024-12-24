#!/usr/bin/env ruby

Graph = Struct.new(:nodes, :edges)

STDIN.read.lines(chomp: true)
    .map{_1.split("-").sort}
    .reduce(Graph.new(Set.new, Set.new)) do |graph, nodes|
        nodes.each {|node| graph.nodes << node}
        graph.edges << nodes
        graph
    end
    .yield_self do |graph|
        graph.nodes.reduce(Set.new) do |acc, node|
            acc += graph.edges.filter{_1.include? node}
                .flatten
                .uniq
                .combination(3)
                .filter do |combo|
                    graph.edges.include?(combo.filter{_1 != node}.sort)
                end
                .map{_1.sort}
        end
    end
    .filter{|combo| combo.any?{_1[0] == "t"}}
    .tap{p(_1.length)}

    # .yield_self do |graph|
    #     exit
    #     connected = graph.nodes.reduce({}) do |acc, node|
            
    #         values = graph.edges.filter{_1.include?(node)}.flatten.uniq

    #         # key = node
    #         # key = values
    #         key = values.find{|value| acc.keys.include?(value)} || node
            

    #         # p("Key #{key}")
    #         # Hash.new{|h, k| h[k] = Set.new
    #         acc[key] = Set.new if acc[key].nil?
    #         # p(values)
    #         # p(key)
    #         # p(acc)
    #         acc[key].merge(values)
    #         acc
    #     end
    # end
    # .yield_self do |graphs|
    #     graphs.reduce([]) do |acc, graph|
    #         graph[1].to_a.combination(3) do |value|
    #             acc << value
    #         end
    #         acc
    #     end
    # end
    # .tap{p(_1)}