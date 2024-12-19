require "concurrent"


class PriorityQueue
    def initialize()
      @queue = Concurrent::Collection::NonConcurrentPriorityQueue.new({order: :min})
      @hash = {}
    end

    def push(item, score)
      @queue.push([score, item])
      @hash[item] = score
    end

    def empty?() @queue.length == 0 end
    def length() @queue.length end
    def pop() 
      value = @queue.pop
      value.nil? ? nil : value[1]
    end
  
    def move(item, score)
      @queue.delete([@hash[item], item])
      @queue.push([score, item])
    end
  end
