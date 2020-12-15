fn main() {
	run([0, 3, 6], 2020) // 436
	run([3, 1, 2], 2020) // 1836
	run([1, 0, 15, 2, 10, 13], 2020) // 211
	run([1, 0, 15, 2, 10, 13], 30000000) // 2159626
}

fn run(input []int, nth_num int) {
	mut num_map := map[string]int{} // num => turn idx
	mut last_spoken_num := ''
	for turn in 1 .. nth_num {
		// add inpu∏t
		if turn < input.len {
			num_map[input[turn - 1].str()] = turn
			last_spoken_num = input[turn].str()
		} else {
			if last_spoken_num in num_map {
				// already have prev_turn
				prev_turn := num_map[last_spoken_num]
				num_map[last_spoken_num] = turn
				last_spoken_num = (turn - prev_turn).str()
			} else {
				// not seen before
				num_map[last_spoken_num] = turn
				last_spoken_num = '0'
			}
		}
	}
	println(last_spoken_num)
}

// 436
// 1836
// 211
// 2159626
// ./mapped  11.73s user 1.26s system 98% cpu 13.208 total
