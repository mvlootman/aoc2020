import os
const (
	preamble_len = 25
)

fn main() {
	mut preamble := []int{}
	input := os.read_lines('input.txt') ?
	numbers := input.map(it.int())
	mut curr := preamble_len
	preamble = numbers[..preamble_len]
	for curr < numbers.len - 1 {
		next_num := numbers[curr]
		if !valid_number(next_num, preamble) {
			println('invalid number: $next_num')
			return
		}
		// optimize later
		preamble = preamble[1..].clone() // clone needed to avoid bug
		preamble << next_num
		curr++
	}
	println('all numbers valid')
}

fn valid_number(num int, preamble []int) bool {
	for i := 0; i < preamble.len; i++ {
		for j := 0; j < preamble_len; j++ {
			// skip same
			if i == j {
				continue
			}
			if preamble[i] + preamble[j] == num {
				return true
			}
		}
	}
	return false
}
