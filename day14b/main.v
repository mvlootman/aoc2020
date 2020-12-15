import os
import strconv

const (
	input_file = 'input.txt'
)

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
			addresses := apply_mask(mem_loc, mask)
			for addr in addresses {
				p.memory[addr.str()] = val
			}
		}
	}
	// return sum
	mut res := u64(0)
	for _, v in p.memory {
		res += u64(v)
	}
	return res
}

fn get_inputs() []string {
	lines := os.read_lines(input_file) or { panic(err) }
	return lines
}

fn apply_mask(val u64, mask string) []u64 {
	mut vals := []string{}
	mut xs_ids := []int{}
	mut upd_mask := ''
	for i, ch in mask {
		match ch {
			`0` {
				upd_mask += bit_at_pos(val, i).str()
			}
			`1` {
				upd_mask += '1'
			}
			`X` {
				upd_mask += '0' // we create the zero version and add the one version after
				xs_ids << i
			}
			else {}
		}
	}
	vals << upd_mask
	combinations := bool_combinations(xs_ids.len)
	for combo in combinations {
		// e.g. [0, 0, 0]
		// [0, 0, 1]
		// [0, 1, 0] etc
		mut tmp := upd_mask
		for i, v in combo {
			pos := xs_ids[i]
			tmp = tmp[0..pos] + v.str() + tmp[pos + 1..] // replace character with value of combination
		}
		vals << tmp
	}
	vals = vals.map(it.reverse())
	res := vals.map(strconv.parse_uint(it, 2, it.len))
	return res
}

fn bit_at_pos(number u64, pos int) u64 {
	res := (number >> pos) & 1
	return res
}

fn bool_combinations(num int) [][]int {
	max := 1 << num
	mut res := [][]int{len: max, init: []int{}}
	for i in 0 .. max {
		bin_str := decbin(u32(i), u64(num))
		cut_str := bin_str[bin_str.len - num..]
		res[i] = cut_str.split('').map(it.int())
	}
	return res
}

// returns binary number out of decimal number
// https://www.php.net/manual/de/function.decbin.php
// https://www.javatpoint.com/c-program-to-convert-decimal-to-binary
fn decbin(value u64, length u64) string {
	mut n := value
	mut v := ''
	mut i := 0
	for n > 0 {
		v += (n % 2).str()
		n = n / 2
		i++
	}
	if length > 0 {
		for v.len < length {
			v += '0'
		}
	}
	return v.reverse()
}

// 3608464522781
