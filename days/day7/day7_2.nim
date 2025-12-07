import sequtils, sets, strutils, tables

proc readFile(filename: string): seq[string] =
  var f = open(filename, fmRead)
  defer: close(f)
  result = @[]
  for line in f.lines:
    result.add(line.strip)

proc countPaths(row, col: int, fileLines: seq[string], memo: var Table[(int, int), int]): int =
  if row < 0 or row >= fileLines.len or col < 0 or col >= fileLines[row].len:
    return 0

  if row == fileLines.len - 1:
    return 1

  if (row, col) in memo:
    return memo[(row, col)]

  var paths = 0

  if fileLines[row][col] == '^':
    if col > 0:
      paths += countPaths(row + 1, col - 1, fileLines, memo)
    if col < fileLines[row].len - 1:
      paths += countPaths(row + 1, col + 1, fileLines, memo)
  else:
    paths += countPaths(row + 1, col, fileLines, memo)

  memo[(row, col)] = paths

  return paths

proc processFile(fileLines: seq[string]) =
  var memo = initTable[(int, int), int]()
  var startCol = -1

  for i, ch in fileLines[0]:
    if ch == 'S':
      startCol = i
      break

  if startCol == -1:
    return

  let totalPaths = countPaths(0, startCol, fileLines, memo)

  echo "part2: ", totalPaths

proc main() =
  let filename = "input.txt"
  let lines = readFile(filename)
  processFile(lines)

main()
