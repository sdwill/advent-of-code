"""
Solution for 2022 Advent of Code, Part 7. General approach:
    - Represent the directory tree as a set of nodes that form a simple tree: each node has a string identifier (name),
      size, a parent node, and (optionally) child nodes. 
    - The parse!() function constructs the tree from the input file
    - The size of a node is the sum of the sizes of its descendants. The size!() function traverses the tree and  
      computes the size of a given node and its descendants. Calling size!(base) computes the sizes for all nodes in the
      directory tree.
"""

mutable struct Node
    name::String  # String identifier
    dir::Bool  # Is directory?
    size::Union{Int, Nothing}  # Total size of all descendants
    parent::Union{Node, Nothing}  # Parent node
    children::Dict{String, Union{Node, Nothing}}  # Child nodes

    function Node(name, dir, size, parent)
        """ 
        Custom constructor that initializes children to an empty dictionary, since we don't know them at init time
        """
        node = new(name, dir, size, parent)
        node.children = Dict()
        return node
    end
end

# Pretty-print Nodes
import Base.show
show(io::IO, node::Node) = show(io, "Node($(node.name))")

# Base node, representing the root of the filesystem
base = Node("/", true, nothing, nothing)

function parse!(path)
    ## Load file
    file = open(path)
    lines = readlines(file)
    ## A cell
    current = base

    for line in lines
        global current
        if startswith(line, "\$ cd")  # Update current target node
            dest = split(line, ' ')[end]
            if dest == "/"
                current = base
            elseif dest == ".."
                current = current.parent
            else
                current = current.children[dest]
            end
        elseif startswith(line, "\$ ls")  # Move to next line(s), which specifu directory contents
            continue
        else  # List contents of directory
            if startswith(line, "dir")  # Directory node
                node_name = split(line, ' ')[end]
                node_dir = true
                node_size = nothing
                node_parent = current
            else  # File node
                (node_size, node_name) = split(line, ' ')
                node_dir = false
                node_size = parse(Int, node_size)
                node_parent = current
            end
            new = Node(node_name, node_dir, node_size, node_parent)
            current.children[node_name] = new
        end
    end
end

function size!(node::Node)
    if !isnothing(node.size)
        println("Node $(node.name) has size $(node.size)")
    elseif isnothing(node.children) | isempty(node.children)
        println("Node $(node.name) has no children (or children is empty)")
        return 0
    else
        println("Node $(node.name) has following child sizes:") #$(Dict(key => child.size for (key, child) in node.children))")
        for (key, child) in node.children
            println("\t$(key) => $(child.size)")
        end
        node.size = sum([size!(child) for (key, child) in node.children])
    end
    return node.size
end


function part_I()
    """
    Assuming that all node sizes have already been computed, add the sizes of all nodes x such that x.size <= 100,000.
    """
    result = 0
    visited = []
    
    function traverse(node::Node)
        if !(node in visited)
            append!(visited, [node])
            println("$(node.name) -> $(node.size)")
            if (node.size <= 100000) & node.dir
                println("Node $(node.name) is a directory; has size $(node.size) <= 100,000")
                result += node.size
            end
            
            for (key, child) in node.children
                traverse(child)
            end
        end
    end

    global base
    traverse(base)
    return result
end

function part_II()
    """
    Assuming that all node sizes have already been computed, find the least-size node that frees up the specified amount
    of disk space.
    """
    global base
    total_size = 70000000
    needed = 30000000
    available = total_size - base.size
    minimum_size = needed - available
    smallest_feasible = base.size

    visited = []
    
    function traverse(node::Node)
        if !(node in visited)
            append!(visited, [node])
            println("$(node.name) -> $(node.size)")
            if (node.size >= minimum_size) & node.dir & (node.size <= smallest_feasible)
                smallest_feasible = node.size
                println("Node $(node.name) is a directory; has size $(node.size) >= $(minimum_size) ",
                        "and <= $(smallest_feasible)")
            end
            
            for (key, child) in node.children
                traverse(child)
            end
        end
    end

    global base
    traverse(base)
    return smallest_feasible
end

# path = "2022/inputs/07-input-test.txt"  # Example input from problem description
path = "2022/inputs/07-input.txt"

parse!(path)
size!(base)
part_I()
part_II()
