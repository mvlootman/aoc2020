import os

const (
	input_file = 'input.txt'
)

// struct Input {
// 	mask  string
// 	steps []Step
// }

// struct Step {
// 	location int
// 	val      int
// }

struct Program {
mut:
	memory map[string]u64
}

fn main() {
	inputs := get_inputs()
	mut program := Program{}
	output := program.execute(inputs)
	println(output)
}

fn (mut p Program) execute(inputs []string) u64 {
	mut mask := ''
	for line in inputs {
		if line.starts_with('mask') {
			mask = line.all_after('= ').trim('').reverse()
		} else {
			mem_loc := line.find_between('[', ']').u64()
			val := line.all_after('= ').trim('').u64()
			mut new_val := val
			for i, ch in mask {
				new_val = match ch {
					`0`, `1` { modify_bit_at(new_val, u64(i), u64(ch)) }
					else { new_val }
				}
			}
			p.memory[mem_loc.str()] = new_val
			// println('new_val:$new_val')
		}
	}
	// return sum
	mut res := u64(0)
	for k, v in p.memory {
		println('$k:$v')
		res += u64(v)
	}
	return res
}

fn modify_bit_at(number u64, pos u64, bit_val u64) u64 {
	mask := u64(1) << pos
	res := (number & ~mask) | ((bit_val << pos) & mask)
	// println('modify_bit_at n:$number pos:$pos val:$bit_val =>res:$res')
	return res
}

fn get_inputs() []string {
	lines := os.read_lines(input_file) or { panic(err) }
	return lines
}

// fn get_inputs() Input {
// lines := os.read_lines(input_file) or { panic(err) }
// lines.split()
// input := Input{
// mask: lines[0].all_after('= ').trim('')
// steps: lines[1..].map(extract_step(it))
// }
// }
// return input
// }
// fn extract_step(line string) Step {
// 	index := line.find_between('[', ']').int()
// 	val := line.all_after('= ').trim('').int()
// 	step := Step{index, val}
// 	return step
// }

// mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
// mem[8] = 11
// mem[7] = 101
// mem[8] = 0
