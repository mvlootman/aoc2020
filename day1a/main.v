import os

fn main() {
	input := read_input_file('./day1a/input.txt')
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
			sum := numbers[i] + numbers[j]
			if sum == 2020 {
				res := numbers[i] * numbers[j]
				return res
			}
		}
	}
	return -1
}
