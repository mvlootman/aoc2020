import os

const (
	preamble_len = 25
	numbers      = read_input()
)

fn main() {
	mut preamble := []int{}
	mut curr := 0
	for curr < numbers.len - 1 {
		preamble = numbers[curr..curr + preamble_len]
		next_num := numbers[curr + preamble_len]
		if !valid_number(next_num, preamble) {
			println('invalid number: $next_num')
			return
		}
		curr++
	}
	println('all numbers valid')
}

fn read_input() []int {
	input := os.read_lines('input.txt') or { panic(err) }
	numbers := input.map(it.int())
	return numbers
}

fn valid_number(num int, preamble []int) bool {
	for idx, p1 in preamble {
		for p2 in preamble[idx + 1..] {
			if p1 + p2 == num {
				return true
			}
		}
	}
	return false
}
