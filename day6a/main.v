import os

fn main() {
	input := read_file_as_string('input.txt')
	groups := input.split('\n\n')
				.map(it.replace('\n', ''))
				.map(parse_answers(it))
				.map(it.keys().len)
				.reduce(sum, 0)
	println(groups)
}

fn sum(first int, total int) int {
	return first + total
}

fn parse_answers(input string) map[string]int {
	mut res := map[string]int{}
	for char in input {
		res[char.str()]++
	}
	return res
}

fn read_file_as_string(file_path string) string {
	raw := os.read_file(file_path) or { panic(err) }
	return raw
}
