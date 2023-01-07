root = dirname(Base.source_dir())

# Function that maps (player, opponent) => outcome
outcomes = Dict(
    ("rock", "rock") => "draw",
    ("rock", "paper") => "loss",
    ("rock", "scissors") => "win",
    ("paper", "rock") => "win",
    ("paper", "paper") => "draw",
    ("paper", "scissors") => "loss",
    ("scissors", "rock") => "loss",
    ("scissors", "paper") => "win",
    ("scissors", "scissors") => "draw",
)

outcome_points = Dict( 
    "loss" => 0,
    "draw" => 3,
    "win" => 6
 )

move_points = Dict( 
    "rock" => 1,
    "paper" => 2,
    "scissors" => 3
 )


# Part 1
opponent_key = Dict( 
    "A" => "rock",
    "B" => "paper",
    "C" => "scissors"
 )

my_key = Dict( 
    "X" => "rock",
    "Y" => "paper",
    "Z" => "scissors"
 )

file = open(joinpath(root, "inputs/02-input.txt"))
lines = readlines(file)

function part_1(lines, opponent_key, my_key, outcome_points, move_points)
    result = 0
    for line in lines
        tokens = split(line)
        opponent_move = opponent_key[tokens[1]]
        my_move = my_key[tokens[2]]
        result += outcome_points[outcomes[(my_move, opponent_move)]] + move_points[my_move]
    end
    result
end

println("Part 1: $(part_1(lines, opponent_key, my_key, outcome_points, move_points))")

# Part 2
# Reverse the dictionary of outcomes
my_key = Dict((opponent_move, outcome) => my_move for ((my_move, opponent_move), outcome) in outcomes)

outcomes = Dict( 
    "X" => "loss",
    "Y" => "draw",
    "Z" => "win"
 )

function part_2()
    result = 0
    for line in lines
        tokens = split(line)
        opponent_move = opponent_key[tokens[1]]
        desired_outcome = outcomes[tokens[2]]
        my_move = my_key[(opponent_move, desired_outcome)]
        result += outcome_points[desired_outcome] + move_points[my_move]
    end
    result
end

println("Part 2: $(part_2())")
