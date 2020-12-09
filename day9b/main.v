import os

const (
	answer_number = 23278925 // answer from part 1
)

fn main() {
	input := os.read_lines('input.txt') ?
	numbers := input.map(it.int())
	for i := 0; i < numbers.len; i++ {
		mut values := [numbers[i]]
		for j := i + 1; j < numbers.len; j++ {
			values << numbers[j]
			values_sum := values.reduce(sum, 0)
			if values_sum > answer_number {
				break
			}
			if values_sum == answer_number {
				values.sort()
				min := values.first()
				max := values.last()
				println('found solution: $min $max answer:${min + max}')
			}
		}
	}
}

fn sum(a int, b int) int {
	return a + b
}
