import os

fn main() {
	input := read_input_file('./day1b/input.txt')
	println(solution(input))
}

fn read_input_file(file_path string) []int {
	mut arr := []int{}
	lines := os.read_lines(file_path) or {
		panic(err)
	}
	for line in lines {
		arr << line.int()
	}
	return arr
}

fn solution(numbers []int) int {
	for i := 0; i < numbers.len; i++ {
		for j := i + 1; j < numbers.len; j++ {
			for k := j + 1; k < numbers.len; k++ {
				sum := numbers[i] + numbers[j] + numbers[k]
				if sum == 2020 {
					res := numbers[i] * numbers[j] * numbers[k]
					return res
				}
			}
		}
	}
	return -1
}
