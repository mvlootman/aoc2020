import os

fn main() {
	mut numbers := get_input()
	mut diff_types := map[string]int{}
	mut jolts := 0
	for numbers.len > 0 {
		diff, new_jolts := find_next_adapter(mut numbers, jolts)
		if diff == -1 {
			panic('no matching adapter found')
		}
		jolts = new_jolts
		diff_types[diff.str()]++
	}
	// add device itself
	diff_types['3']++
	answer := diff_types['1'] * diff_types['3']
	println('diff_types:$diff_types answer:$answer')
}

fn get_input() []int {
	input := os.read_lines('./input.txt') or { panic(err) }
	return input.map(it.int())
}

// returns diff and current adapter
fn find_next_adapter(mut numbers []int, curr_jolts int) (int, int) {
	mut diff := 0
	for i in [0, 1, 2, 3] {
		idx := numbers.index(curr_jolts + i)
		if idx != -1 {
			adapter := numbers[idx]
			diff += numbers[idx] - curr_jolts
			numbers.delete(idx)
			return diff, adapter
		}
	}
	return -1, -1
}
