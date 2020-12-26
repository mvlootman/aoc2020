import os

struct Policy {
	pos_1 int
	pos_2 int
	char  string
}

fn main() {
	input := read_input_file('./day2b/input.txt')
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
		policy, password := parse_input_line(input)
		is_valid := is_valid_password(policy, password)
		if is_valid {
			valid_password_count++
		}
	}
	return valid_password_count
}

fn parse_input_line(line string) (Policy, string) {
	// format: <min>-<max> <char>: <pwd>
	// eg. 1-3 a: abcde
	parts := line.split(' ')
	positions := parts[0].split('-')
	password := parts[2]
	policy := Policy{
		pos_1: positions[0].int()
		pos_2: positions[1].int()
		char: parts[1].split(':')[0]
	}
	return policy, password
}

fn is_valid_password(policy Policy, password string) bool {
	char_at_pos_1 := password[policy.pos_1 - 1]
	char_at_pos_2 := password[policy.pos_2 - 1]
	// logical exclusive OR
	is_valid := (char_at_pos_1.str() == policy.char) != (char_at_pos_2.str() == policy.char)
	return is_valid
}
