root = dirname(Base.source_dir())
file = open(joinpath(root, "inputs/01-input.txt"))
lines = readlines(file)

elves = [0]

for (n, line) in enumerate(lines)
    try
        elves[end] += parse(Int, line)
    catch e
        append!(elves, 0)
    end
end

part_1 = maximum(elves)
part_2 = sum(sort(elves, rev=true)[1:3])

println("Part 1: $(part_1)")
println("Part 2: $(part_2)")
