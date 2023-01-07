root = dirname(Base.source_dir())

file = open(joinpath(root, "inputs/03-input.txt"))
lines = readlines(file)

letters = vcat(collect('a':'z'), collect('A':'Z'))
priorities = Dict(letter => n for (n, letter) in enumerate(letters))

function part_1(lines)
    solution = 0
    for line in lines
        bitmaps = zeros(Bool, 2, 52)
        num_items = length(line)
        splitind = Int(num_items/2)
        compartments = (line[1:splitind], line[splitind+1:end])
        for (n, compartment) in enumerate(compartments)
            for (k, char) in enumerate(compartment)
                bitmaps[n, priorities[char]] = true
            end
        end
        common_priority = [priorities[letters[index]] for (index, item) in enumerate(bitmaps[1, :] .& bitmaps[2, :]) 
                           if item][1]
        solution += common_priority
    end
    println("Part 1: $(solution)")
end

function part_2(lines)
    solution = 0
    for m = 0:(Int(length(lines) / 3) - 1)
        bitmaps = zeros(Bool, 3, 52)
        for n = 0:2
            line = lines[3 * m + n + 1]
            for (k, char) = enumerate(line)
                bitmaps[n+1, priorities[char]] = true
            end
        end
        try
            common_priority = [priorities[letters[index]] for (index, item) 
                            in enumerate(bitmaps[1, :] .& bitmaps[2, :] .& bitmaps[3, :]) if item][1]
            solution += common_priority
        catch e
            println(lines[3*m+1:3*m+3])  # Print out the lines for debugging purposes
        end
    end
    println("Part 2: $(solution)")
end

part_1(lines)
part_2(lines)
