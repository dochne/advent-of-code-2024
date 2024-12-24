#!/usr/bin/env ruby

Graph = Struct.new(:nodes, :edges)

def subgraphs(graph, accepted_nodes, potential_nodes) 
    graphs = []
    potential_nodes.each_with_index do |potential_node, index|
        if (accepted_nodes - graph.edges[potential_node]).empty?
            graphs += subgraphs(graph, accepted_nodes + [potential_node], potential_nodes.drop(index + 1)) 
        end
    end
    return [accepted_nodes] if graphs.length == 0
    graphs
end

STDIN.read.lines(chomp: true)
    .map{_1.split("-").sort}
    .reduce(Graph.new(Set.new, Hash.new{|h, k| h[k] = []})) do |graph, nodes|
        graph.nodes += nodes
        graph.edges[nodes[0]] << nodes[1]
        graph.edges[nodes[1]] << nodes[0]
        graph
    end
    .yield_self do |graph|
        graph.nodes.reduce([]) do |acc, node|
            acc += subgraphs(graph, [node], graph.edges[node])
        end.sort_by(&:length).last.sort!
    end
    .tap{p(_1.join(","))}
