function load_grid(filename)
    lines = readlines(filename)
    grid = hcat([ [c == '@' ? 1 : 0 for c in line] for line in lines]...)
    return grid
end

function count_neighbors(grid, x, y)
    count = 0
    rows, cols = size(grid)
    for i in max(1, x - 1):min(rows, x + 1)
        for j in max(1, y - 1):min(cols, y + 1)
            if (i != x || j != y) && grid[i, j] == 1
                count += 1
            end
        end
    end
    return count
end

function remove_low_neighboring_ones!(grid, threshold)
    count_removed = 0
    rows, cols = size(grid)
    to_remove = Set()

    for i in 1:rows
        for j in 1:cols
            if grid[i, j] == 1 && count_neighbors(grid, i, j) < threshold
                push!(to_remove, (i, j))
            end
        end
    end

    for (i, j) in to_remove
        grid[i, j] = 0
        count_removed += 1
    end

    return count_removed
end

function iterative_removal(grid)
    total_removed = 0
    threshold = 4

    original_count = remove_low_neighboring_ones!(grid, threshold)
    total_removed += original_count

    while true
        removed_count = remove_low_neighboring_ones!(grid, threshold)
        if removed_count == 0
            break
        end
        total_removed += removed_count
    end

    return original_count, total_removed
end

filename = "input.txt"
grid = load_grid(filename)
original_result, total_removals = iterative_removal(grid)

println("part1: ", original_result)
println("part2 ", total_removals)
