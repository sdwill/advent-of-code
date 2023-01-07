root = dirname(Base.source_dir())

file = open(joinpath(root, "inputs/04-input.txt"))
lines = readlines(file)

function part_1(lines)
    num_full_subsets = 0

    for line in lines
        elves = split(line, ',')
        bounds = [[parse(Int, bound) for bound in split(elf, '-')] for elf in elves]
        ranges = [lower:upper for (lower, upper) in bounds]
        if issubset(ranges[1], ranges[2]) | issubset(ranges[2], ranges[1])
            num_full_subsets += 1
        end
    end

    println("Part 1: $(num_full_subsets)")
end

function part_2(lines)
    num_overlaps = 0

    for line in lines
        elves = split(line, ',')
        bounds = [[parse(Int, bound) for bound in split(elf, '-')] for elf in elves]
        ranges = [lower:upper for (lower, upper) in bounds]
        if intersect(Set(ranges[1]), Set(ranges[2])) != Set()
            num_overlaps += 1
        end
    end

    println("Part 2: $(num_overlaps)")
end

part_1(lines)
part_2(lines)
