#!/usr/bin/env ruby

def can_solve?(pattern, stripes)
    return true if pattern.length == 0
    stripes.any? do |stripe|
        if pattern.index(stripe) == 0
            can_solve?(pattern[(stripe.length)..], stripes) 
        else
            false
        end
    end
end

STDIN.read
    .split("\n\n")
    .yield_self {|stripes, patterns| [stripes.split(", "), patterns.split("\n")]}
    .yield_self do |stripes, patterns|
        patterns.filter do |pattern|
            can_solve?(pattern, stripes)
        end
        .length
    end
    .tap{p(_1)}
