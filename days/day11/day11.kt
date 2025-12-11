package day11

import java.io.File

fun nPaths(source: String, destination: String, topologicalSort: MutableList<String>, edges: MutableMap<String, MutableList<String>>): Long {
    val count = mutableMapOf<String, Long>().withDefault { 0L }
    count[source] = 1

    for (node in topologicalSort) {
        for (edge in edges[node] ?: emptyList()) {
            count[edge] = count.getValue(edge) + count.getValue(node)
        }
    }
    return count.getValue(destination)
}

fun main() {
    val inputFile = "days/day11/input.txt"
    val data = File(inputFile).readLines().map { it.trim() }

    val nodes = mutableSetOf<String>()
    val edges = mutableMapOf<String, MutableList<String>>()

    for (line in data) {
        val (source, other) = line.split(": ")
        nodes.add(source)
        for (destination in other.split(" ")) {
            nodes.add(destination)
            edges.computeIfAbsent(source) { mutableListOf() }.add(destination)
        }
    }

    val inDegree = mutableMapOf<String, Int>().withDefault { 0 }
    for (edgeList in edges.values) {
        for (edge in edgeList) {
            inDegree[edge] = inDegree.getValue(edge) + 1
        }
    }

    val topologicalSort = mutableListOf<String>()
    val stack = nodes.filter { inDegree.getValue(it) == 0 }.toMutableList()

    while (stack.isNotEmpty()) {
        val node = stack.removeAt(stack.lastIndex)
        topologicalSort.add(node)
        for (edge in edges[node] ?: emptyList()) {
            inDegree[edge] = inDegree.getValue(edge) - 1
            if (inDegree[edge] == 0) {
                stack.add(edge)
            }
        }
    }

    val part1Result = nPaths("you", "out", topologicalSort, edges)
    println("part 1: $part1Result")

    var part2Result = 0L
    part2Result += nPaths("svr", "dac", topologicalSort, edges) * nPaths("dac", "fft", topologicalSort, edges) * nPaths("fft", "out", topologicalSort, edges)
    part2Result += nPaths("svr", "fft", topologicalSort, edges) * nPaths("fft", "dac", topologicalSort, edges) * nPaths("dac", "out", topologicalSort, edges)
    println("part 2: $part2Result")
}
