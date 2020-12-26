import os

fn main() {
	input := read_file_as_string('input.txt')
	group_sizes := input.split('\n\n').map(it.split('\n')).map(it.len)
	answers := input.split('\n\n').map(it.replace('\n', '')).map(parse_answers(it))
	mut unanimous_group_count := 0
	for idx, group_size in group_sizes {
		unanimous_group_count += find_unanimous_answers_for_group(answers[idx], group_size)
	}
	println(unanimous_group_count)
}

fn find_unanimous_answers_for_group(answers map[string]int, group_size int) int {
	mut unanimous_count := 0
	for _, val in answers {
		if val == group_size {
			unanimous_count++
		}
	}
	return unanimous_count
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
