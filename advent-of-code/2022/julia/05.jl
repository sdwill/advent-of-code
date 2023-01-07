using DataStructures

root = dirname(Base.source_dir())

file = open(joinpath(root, "inputs/05-input.txt"))
lines = readlines(file)

# Print out the initial conditions
for line in lines[1:9]
    println(line)
end


function part_1(lines)
    # Lines 1-9 contain the initial conditions
    # Parse the initial conditions here into a list of stacks
    stacks = [Stack{Char}() for i = 1:9]
    [push!(stacks[n], char) for line in lines[8:-1:1] for (n, char) in enumerate(line[2:4:end]) if char != ' ']

    # Lines 11+ contain the instructions
    # For each line, parse the instruction into (number of moves, source stack, destination stack) and then perform
    # them by popping elements from the source stack and pushing them onto the destination stack
    for line in lines[11:end]
        tokens = split(line, ' ')
        (number, source, dest) = [parse(Int, token) for token in tokens[2:2:end]]
        for n in 1:number
            push!(stacks[dest], pop!(stacks[source]))
        end
    end

    # Print out the solution string (the top element of each stack)
    solution = join([first(stack) for stack in stacks])
    println("Part 1: $(solution)")
end

function part_2(lines)
    # Lines 1-9 contain the initial conditions
    # Parse the initial conditions here into a list of stacks
    stacks = [Stack{Char}() for i = 1:9]
    crane = Stack{Char}()
    [push!(stacks[n], char) for line in lines[8:-1:1] for (n, char) in enumerate(line[2:4:end]) if char != ' ']

    # Lines 11+ contain the instructions
    # For each line, parse the instruction into (number of moves, source stack, destination stack) and then perform
    # them by popping elements from the source stack and pushing them onto the destination stack
    for line in lines[11:end]
        tokens = split(line, ' ')
        (number, source, dest) = [parse(Int, token) for token in tokens[2:2:end]]
        for n in 1:number
            push!(crane, pop!(stacks[source]))
        end
        for n in 1:number
            push!(stacks[dest], pop!(crane))
        end
    end

    # Print out the solution string (the top element of each stack)
    solution = join([first(stack) for stack in stacks])
    println("Part 2: $(solution)")
end

part_1(lines)
part_2(lines)
