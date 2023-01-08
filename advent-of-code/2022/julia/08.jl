root = dirname(Base.source_dir())

file = open(joinpath(root, "inputs/08-input.txt"))
lines = readlines(file)


function parse_input(lines::Vector{String})
    """
    Parse the input file into an array of integers
    """
    M = length(lines)
    N = length(lines[1])
    res = zeros(Int, M, N)
    for m in 1:M
        for n in 1:N
            res[m, n] = parse(Int, lines[m][n])
        end
    end
    res
end

function map_visible(trees::AbstractArray{Int})
    """
    Iterate through each row of arr from left to right. Any element larger than every element to its left is marked as
    visible. Then repeat from right to left, with any element larger than every element to its right being marked.
    """
    M, N = size(trees)
    visible = zeros(Bool, M, N)
    visible[1, :] .= true
    visible[:, 1] .= true
    visible[:, end] .= true
    visible[end, :] .= true

    for m in 2:M-1
        largest = 0
        for n in 1:N
            if trees[m, n] > largest
                largest = trees[m, n]
                visible[m, n] = true
            end
        end
    end

    for m in 2:M-1
        largest = 0
        for n in reverse(1:N)
            if trees[m, n] > largest
                largest = trees[m, n]
                visible[m, n] = true
            end
        end
    end
    visible
end

function part_1(trees::AbstractArray{Int})
    """
    Find the visible trees by searching left/right, followed by up/down (passing the transposed input into map_visible
    and then transposing the output). Return the total number of visible trees.
    """
    visible = map_visible(trees) .| map_visible(trees')'
    solution = sum(visible)
    println("Part 1: $(solution)")
    return visible
end

function calculate_scenic_score_1d(vec::Vector{Int}, n::Int)
    """
    Calculate the scenic score for element n in a vector
    """
    val = vec[n]
    scenic_score = 1
    N = length(vec)

    # Look right
    for i in (n+1):N
        if (vec[i] >= val) | (i == N)
            scenic_score *= i - n
            break
        end
    end
    
    # Look left
    for i in reverse(1:(n-1))
        if (vec[i] >= val) | (i == 1)
            scenic_score *= n - i
            break
        end
        
    end
    scenic_score
end

function calculate_scenic_score(trees::AbstractArray{Int}, m::Int, n::Int)
    """ 
    Compute the scenic score for an element in the two-dimensional array of trees, by computing the product of the 
    scenic scores for row and column vectors.
    """
    lr = calculate_scenic_score_1d(trees[m, :], n) 
    ud = calculate_scenic_score_1d(trees[:, n], m)
    lr*ud
end

function part_2(trees, visible)
    """
    Compute the best scenic score of all visible trees.
    """
    M, N = size(visible)

    best_scenic_score = 1
    for m in 2:(M-1)
        for n in 2:(N-1)
            if visible[m, n]
                best_scenic_score = max(best_scenic_score, calculate_scenic_score(trees, m, n))
            end
        end
    end
    println("Part 2: $(best_scenic_score)")
end

trees = parse_input(lines)
visible = part_1(trees)
part_2(trees, visible)


