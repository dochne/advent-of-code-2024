#!/usr/bin/env ruby

$cache = {}
def memoize(key, &block)
    $cache[key] ||= block.call
end

def can_solve?(pattern, stripes)
    memoize(pattern) do
        return 1 if pattern.length == 0
        stripes.reduce(0) do |acc, stripe|
            acc += can_solve?(pattern[(stripe.length)..], stripes)  if pattern.index(stripe) == 0
            acc
        end
    end
end

STDIN.read
    .split("\n\n")
    .yield_self {|stripes, patterns| [stripes.split(", "), patterns.split("\n")]}
    .yield_self do |stripes, patterns|
        patterns.reduce(0) do |acc, pattern|
            acc += can_solve?(pattern, stripes)
        end
    end
    .tap{p(_1)}
