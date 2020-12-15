fn main() {
	run([0, 3, 6], 2020) // 436
	run([3, 1, 2], 2020) //1836

	//puzzle input part 1
	run([1,0,15,2,10,13], 2020) //211
	//puzzle input part 2
	run([1,0,15,2,10,13], 3000000)

}
[direct_array_access]
[inline]
fn run(input []int, end_position int) {
	mut list := []int{len: end_position, init: -1}
	// setup starting range
	for i, v in input {
		list[i] = v
	}
	// mut num := 0
	for i in input.len .. end_position {
		mut prev := list[i - 1]
		last_idxs := last_spoken_indexes(prev, list)
		// println('last_idxs:$last_idxs')
		if last_idxs.len in [0, 1] {
			// not spoken before
			list[i] = 0
		} else {
			// spoken before
			distance := last_idxs[last_idxs.len - 1] - last_idxs[last_idxs.len - 2]
			list[i] = distance
		}
	}
	println('pos:$end_position => ${list[end_position - 1]}')
}
[direct_array_access]
[inline]
fn last_spoken_indexes(num int, list []int) []int {
	mut res := []int{}
	mut last_idx := -1
	for i, val in list {
		if val == num {
			last_idx = i
			res << i
		}
	}
	return res
}
