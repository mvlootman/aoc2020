import os

struct Op {
	op  string
	arg int
}

fn main() {
	lines := read_file_lines('input.txt')
	code := get_instructions(lines)
	run_code_detect_loop(code)
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
fn run_code_detect_loop(code []Op) {
	mut acc := 0
	mut current_line := 0
	mut visited_lines := []int{}
	for {
		if current_line in visited_lines {
			println('instruction already encounted line:$current_line value of acc:$acc')
			break
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
		// println('acc:$acc')
		current_line++
		if current_line > code.len - 1 || current_line < 0 {
			println('unable to get next instruction terminating next index:$current_line acc:$acc')
			break
		}
	}
	println('done')
}

fn read_file_lines(file_path string) []string {
	lines := os.read_lines(file_path) or { panic(err) }
	return lines
}
