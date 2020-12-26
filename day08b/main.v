import os

struct Op {
	arg int
mut:
	op  string
}

fn main() {
	lines := read_file_lines('input.txt')
	mut code := get_instructions(lines)
	run_replace_op('jmp', 'nop', code)
	run_replace_op('nop', 'jmp', code)
}

fn run_replace_op(from string, to string, org_code []Op) {
	mut code := org_code
	mut mut_idx := next_op_idx(code, from, -1)
	code[mut_idx].op = to
	for {
		finished := run_code_detect_loop(code)
		if finished {
			println('succesful finish')
			break
		}
		// reset
		code[mut_idx].op = from
		mut_idx = next_op_idx(code, from, mut_idx)
		code[mut_idx].op = to
	}
}

fn next_op_idx(code []Op, operation string, startIndex int) int {
	for idx, op in code {
		if idx <= startIndex {
			continue
		}
		if op.op == operation {
			return idx
		}
	}
	return startIndex
}

fn get_instructions(lines []string) []Op {
	mut res := []Op{}
	for line in lines {
		parts := line.split(' ')
		arg := match parts[1].starts_with('+') {
			true { parts[1][1..].int() }
			else { parts[1].int() }
		}
		op := Op{
			op: parts[0]
			arg: arg
		}
		res << op
	}
	return res
}

// run_code_detect_loop runs the code and prints accumulator when the a loop would start
fn run_code_detect_loop(code []Op) bool {
	mut acc := 0
	mut current_line := 0
	mut visited_lines := []int{}
	for {
		if current_line > code.len - 1 || current_line < 0 {
			// println('unable to get next instruction terminating next index:$current_line acc:$acc')
			break
		}
		if current_line in visited_lines {
			// println('loop instruction already encounted line:$current_line value of acc:$acc')
			return false
		} else {
			visited_lines << current_line
		}
		current_op := code[current_line]
		// println('op:$current_op.op arg:$current_op.arg')
		match current_op.op {
			'acc' {
				acc += current_op.arg
			}
			'jmp' {
				current_line += current_op.arg
				continue
			}
			'nop' {}
			else {
				println('unknown instruction:$current_op')
			}
		}
		current_line++
	}
	println('done acc:$acc')
	return true
}

fn read_file_lines(file_path string) []string {
	lines := os.read_lines(file_path) or { panic(err) }
	return lines
}
