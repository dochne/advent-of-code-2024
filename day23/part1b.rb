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
        connected = graph.nodes.reduce({}) do |acc, node|
            values = graph.edges.filter{_1.include?(node)}.flatten.uniq

            # key = node
            # key = values
            key = values.find{|value| acc.keys.include?(value)} || node
            

            # p("Key #{key}")
            # Hash.new{|h, k| h[k] = Set.new
            acc[key] = Set.new if acc[key].nil?
            # p(values)
            # p(key)
            # p(acc)
            acc[key].merge(values)
            # p(acc)
            # exit
            # p(value)
            # values.each do |value|
            #     if acc[value].length > 0
            # end

            # p(acc)
            # acc
            # p(values)
            # exit
            acc
        end
    end
    .yield_self do |graphs|
        # p(graphs.first)
        p(graphs.values.sort_by{_1.length}.last)
        exit
        p(graphs)
        exit
        graphs.reduce([]) do |acc, graph|
            # graph[1].to_a.combination(3) do |value|
            #     acc << value
            # end
            acc
        end
    end
    .tap{p(_1)}