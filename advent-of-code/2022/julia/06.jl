function solution(length_of_marker)
    root = dirname(Base.source_dir())
    file = open(joinpath(root, "inputs/06-input.txt"))
    line = readline(file)

    for n in length_of_marker:(length(line))
        substring = line[n-(length_of_marker-1):n]
        if length(Set(substring)) == length_of_marker
            result = n
            println(join([substring, n], ' '))
            break
        end
    end
    
end

print("Part 1: ")
solution(4)
print("Part 2: ")
solution(14)
