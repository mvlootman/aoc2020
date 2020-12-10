import os

struct Program {
mut:
	numbers []int
	cache   map[string]u64
}

fn main() {
	mut p := Program{}
	println(p.run())
}

fn (mut p Program) run() u64 {
	p.get_input()
	return p.find_combinations(0)
}

fn (mut p Program) get_input() {
	input := os.read_lines('./input.txt') or { panic(err) }
	p.numbers = [0]	// start = 0 jolts
	p.numbers << input.map(it.int())
	p.numbers.sort()
	p.numbers << p.numbers[p.numbers.len-1]+3 // device (max+3)
}

fn (mut p Program) find_combinations(i int) u64 {
	if i==p.numbers.len-1 { return 1}

	key :=i.str()
	if key in p.cache {
		return p.cache[key] 
	}

	mut result := u64(0)
	for j in i+1..p.numbers.len {
		if p.numbers[j] - p.numbers[i] <= 3 { // can skip current one
			result += p.find_combinations(j)
		}
		else {break}
	}
	p.cache[key] = result
	return result
}