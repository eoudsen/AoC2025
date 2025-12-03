function getContent(filename)
    local lines = {}
    local file = io.open(filename, "r")
    if not file then
        error("I/O error: Unable to open the file.")
    end
    for line in file:lines() do
        table.insert(lines, line)
    end
    file:close()
    return lines
end

function findNumber(integers, num)
    local indexList = {}
    for i = num, 1, -1 do
        local high = 0
        local index = 0
        local startIndex = #indexList > 0 and indexList[#indexList] + 1 or 1
        for j = startIndex, #integers - (i - 1) do
            if integers[j] > high then
                high = integers[j]
                index = j
            end
        end
        table.insert(indexList, index)
    end

    local result = ""
    for _, idx in ipairs(indexList) do
        result = result .. integers[idx]
    end
    return tonumber(result)
end

function part1()
    local lines = getContent("input.txt")
    local total = 0

    for _, line in ipairs(lines) do
        local integers = {}
        for c in line:gmatch(".") do
            table.insert(integers, tonumber(c))
        end
        local number = findNumber(integers, 2)
        total = total + number
    end

    return total
end

function part2()
    local lines = getContent("input.txt")
    local total = 0

    for _, line in ipairs(lines) do
        local integers = {}
        for c in line:gmatch(".") do
            table.insert(integers, tonumber(c))
        end
        local number = findNumber(integers, 12)
        total = total + number
    end

    return total
end

function main()
    print(part1())
    print(part2())
end

main()
