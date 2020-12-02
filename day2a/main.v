import os

struct Policy {
	min  int
	max  int
	char string
}

fn main() {
	// input := ['1-3 a: abcde']
	input := read_input_file('./day2a/input.txt')
	println(solution(input))
}

fn read_input_file(file_path string) []string {
	lines := os.read_lines(file_path) or {
		panic(err)
	}
	return lines
}

fn solution(problem_input []string) int {
	mut valid_password_count := 0
	for input in problem_input {
		policy, password := parse_input_policy(input)
		is_valid := is_valid_password(policy, password)
		if is_valid {
			valid_password_count++
		}
	}
	return valid_password_count
}

fn parse_input_policy(line string) (Policy, string) {
	// format: <min>-<max> <char>: <pwd>
	// eg. 1-3 a: abcde
	parts := line.split(' ')
	min_max := parts[0].split('-')
	password := parts[2]
	policy := Policy{
		min: min_max[0].int()
		max: min_max[1].int()
		char: parts[1].split(':')[0]
	}
	return policy, password
}

fn is_valid_password(policy Policy, password string) bool {
	char_occurence := occurences(policy.char, password)
	is_invalid := char_occurence < policy.min || char_occurence > policy.max
	return !is_invalid
}

fn occurences(find_char string, input string) int {
	mut count := 0
	for char in input {
		if char.str() == find_char {
			count++
		}
	}
	return count
}
