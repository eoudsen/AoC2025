import re
from collections import deque
import pulp as pl


class Machine1:
    def __init__(self, match: re.Match | None):
        if match is None:
            raise ValueError("Invlaid line format")
        groups = match.groups()
        light = groups[0].replace('.', '0').replace('#', '1')
        self.lights = int(light, base=2)
        self.buttons = []
        for button in groups[1].strip().split(' '):
            bits = len(light) * ['0']
            for i in [int(x) for x in button[1:-1].split(',')]:
                bits[i] = '1'
            self.buttons.append(int(''.join(bits), base=2))

        self.jolts = list(map(int, groups[2].split(',')))

class Machine2:
    def __init__(self, match: re.Match | None):
        if match is None:
            raise ValueError("Invalid line format")
        groups = match.groups()
        self.lights = [c == '#' for c in groups[0]]
        self.buttons = [tuple(int(x) for x in button[1:-1].split(',') if x) for button in groups[1].strip().split(' ')]
        self.jolts = [int(x) for x in groups[2].split(',')]


with open('input.txt', 'r') as input_file:
    lines = input_file.readlines()
    line_regex = re.compile(r'^\[([\.#]+)\] ((?:\([0-9,]+\) )+){([0-9,]+)}$')
    machines1 = [Machine1(line_regex.match(line)) for line in lines]
    machines2 = [Machine2(line_regex.match(line)) for line in lines]


# Part 1
count = 0
for machine in machines1:
    init = 0
    visited = {init}
    queue = deque([(init, 0)])
    while queue:
        prev, n = queue.popleft()
        if prev == machine.lights:
            count += n
            break
        for switches in machine.buttons:
            xor = prev ^ switches
            if xor not in visited:
                visited.add(xor)
                queue.append((xor, n + 1))

print("part1: count\n")


total_presses = []

for i, problem in enumerate(machines2):
    optimize_variables = [pl.LpVariable(f'x{i}', lowBound=0, cat='Integer') for i in range(1, len(problem.buttons) + 1)]

    optimize_prop = pl.LpProblem(f"Machine_{i}", pl.LpMinimize)

    for light_index, light_on in enumerate(problem.lights):
        buttons_toggling_lights = [opt_var for opt_var, button in zip(optimize_variables, problem.buttons) if light_index in button]
        optimize_prop += pl.lpSum(buttons_toggling_lights) == problem.jolts[light_index]

    optimize_prop += pl.lpSum(optimize_variables)

    optimize_prop.solve()

    total_presses += [pl.value(optimize_prop.objective)]

print("part2:", int(sum(total_presses)))