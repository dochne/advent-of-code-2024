
require "matrix"
require_relative "./priority_queue.rb"

# so, the things we might want to know are:
# i want to know the distance from nodeA to nodeB (shortest route)
# i want to know the actual path between nodeA and nodeB
# i want to know *all* the possible optimal paths between nodeA and nodeB
# i want to know *all* the possible optimal paths between nodeA and nodeB, nodeC and nodeD

# start_node and finish_nodes should be represented by a Vector (probs)
# def dijkstra(start_node, finish_nodes, &neighbours)
#   queue = PriorityQueue.new
#   distance_from_start = Hash.new(Float::INFINITY)
#   parent_node = {}
#   distance_from_start[start_node] = 0
#   queue.push(start_node, 0)

#   while current = queue.pop
#       neighbours.call(current).each do |(neighbour, weight)|
#         new_distance = distance_from_start[current] + weight
#         if new_distance < distance_from_start[neighbour]
#           distance_from_start[neighbour] = new_distance
#           parent_node[neighbour] = current
#           queue.move(neighbour, new_distance)
#         end
#       end
#   end

#   finish_nodes.reduce({}) do |acc, node|
#     acc[node] = distance_from_start[node]
#     acc
#   end
# end

DijkstraResult = Struct.new(:distance, :path)

def dijkstra_dist_to_node(to_node, &neighbours)
  queue = PriorityQueue.new
  distance_from_start = Hash.new(Float::INFINITY)
  parent_nodes = {}
  distance_from_start[to_node] = 0
  queue.push(to_node, 0)

  while current = queue.pop
      neighbours.call(current).each do |(neighbour, weight)|
        new_distance = distance_from_start[current] + weight
        if new_distance < distance_from_start[neighbour]
          distance_from_start[neighbour] = new_distance
          queue.move(neighbour, new_distance)
        end
      end
  end
  distance_from_start
end

# just saying paths from here
def dijkstra(start_node, finish_nodes, &neighbours)
  queue = PriorityQueue.new
  distance_from_start = Hash.new(Float::INFINITY)
  parent_nodes = {}
  distance_from_start[start_node] = 0
  queue.push(start_node, 0)

  while current = queue.pop
      neighbours.call(current).each do |(neighbour, weight)|
        new_distance = distance_from_start[current] + weight
        if new_distance < distance_from_start[neighbour]
          distance_from_start[neighbour] = new_distance
          parent_nodes[neighbour] = current
          queue.move(neighbour, new_distance)
        end
      end
  end

  finish_nodes.each_with_object({}) do |node, acc|
    acc[node] = DijkstraResult.new(distance_from_start[node], get_path(node, parent_nodes))
  end
end

def get_path(node, parent_nodes)
  result = [node]

  while parent_node = parent_nodes[node]
    result << parent_node
    node = parent_node
  end
  
    
  # result += get_path(parent_nodes[node], parent_nodes) unless parent_nodes[node].nil?
  # parent_nodes[node].each do |parent_node|
  #   result += get_path(parent_node, parent_nodes)
  # end
  result
end

# this is for all paths below
def get_path_all(node, parent_nodes)
  result = [node]
  parent_nodes[node].each do |parent_node|
    result += get_path(parent_node, parent_nodes)
  end
  result
end

# This is niche enough that it should probably just be in day16
def dijkstra_all_paths(start_node, finish_nodes, &neighbours)
  queue = PriorityQueue.new
  distance_from_start = Hash.new(Float::INFINITY)
  parent_nodes = Hash.new{|h, k| h[k] = []}
  distance_from_start[start_node] = 0
  queue.push(start_node, 0)

  while current = queue.pop
      neighbours.call(current).each do |(neighbour, weight)|
        new_distance = distance_from_start[current] + weight
        if new_distance < distance_from_start[neighbour]
          distance_from_start[neighbour] = new_distance
          parent_nodes[neighbour] = [current]
          queue.move(neighbour, new_distance)
        elsif new_distance == distance_from_start[neighbour]
          parent_nodes[neighbour] << current
        end
      end
  end

  finish_nodes.each_with_object({}) do |node, acc|
    # path here is actually "any node that we could have potentially travelled through in the optimal route"
    acc[node] = DijkstraResult.new(distance_from_start[node], get_path_all(node, parent_nodes))
    # while parent_nodes[current]
    
  end
end




#   p(distance_from_start)
#   current = Vector[5, 5]
#   path = []
#   while parent_node[current]
#     path << parent_node[current]
#     current = parent_node[current]
#   end
#   p(path)
#   # p(parent_node[Vector[5, 5]])
#   # distances[end_node]
  
#   # p(value)
# end

# dijkstra(Vector[0, 0]) do |cell|
#   response = []
#   response << [cell + Vector[0, 1], 1] if cell[1] < 5
#   response << [cell + Vector[1, 0], 1] if cell[0] < 5
#   response
# end