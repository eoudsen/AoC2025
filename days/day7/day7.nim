import sequtils, sets, strutils

proc readFile(filename: string): seq[string] =
  var f = open(filename, fmRead)
  defer: close(f)
  result = @[]
  for line in f.lines:
    result.add(line.strip)

proc processFile(fileLines: seq[string]) =
  var splitCount = 0
  var currentIndices = initSet[int]()

  for i, ch in fileLines[0]:
    if ch == 'S':
      currentIndices.incl(i)

  for i in 1..<fileLines.len:
    let row = fileLines[i]
    var newIndices = initSet[int]()

    for idx in currentIndices:
      if idx >= 0 and idx < row.len and row[idx] == '^':
        if idx > 0: newIndices.incl(idx - 1)
        if idx < row.len - 1: newIndices.incl(idx + 1)
        splitCount.inc()
      else:
        newIndices.incl(idx)

    currentIndices = newIndices

  echo "part1: ", splitCount

proc main() =
  let filename = "input.txt"
  let lines = readFile(filename)
  processFile(lines)

main()
