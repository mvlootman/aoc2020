import math
import strconv
fn main() {
	mask := apply_mask(42, '000000000000000000000000000000X1001X')
	vals := unroll_xs(mask)
	println(vals)
}

fn unroll_xs(mask string) []u64 {
	mut res := []string{}
	mut tmp_mask := mask
	for {

		idx := tmp_mask.index('X') or { break }
		println(idx)
		if idx != -1 {
			// println('pre: $tmp_mask')
			res << tmp_mask[0..idx] + '0' + tmp_mask[idx + 1..]
			res << tmp_mask[0..idx] + '1' + tmp_mask[idx + 1..]
			tmp_mask = mask[0..idx] + '0' + tmp_mask[idx + 1..] // zero out x
			// println('post: $tmp_mask')
		} else {
			break
		}
	}

	res = res.filter(!it.contains('X'))
	
	return res.map(strconv.parse_uint(it, 2, it.len))
}

fn apply_mask(val u64, mask string) string {
	mut upd_mask := ''
	mut floating := []string{}
	for i, ch in mask.reverse() {
		match ch {
			`0` { upd_mask += bit_at_pos(val, i).str() }
			`1` { upd_mask += '1' }
			`X` { upd_mask += 'X' }
			else {}
		}
	}

	return upd_mask.reverse()
}

fn bit_at_pos(number u64, pos int) u64 {
	res := (number >> pos) & 1
	return res
}

// fn modify_bit_at(number u64, pos u64, bit_val u64) u64 {
// 	mask := u64(1) << pos
// 	res := (number & ~mask) | ((bit_val << pos) & mask)
// 	// println('modify_bit_at n:$number pos:$pos val:$bit_val =>res:$res')
// 	return res
// }


// fn modify_bit_at(number u64, pos u64, bit_val u64) u64 {
// 	mask := u64(1) << pos
// 	res := (number & ~mask) | ((bit_val << pos) & mask)
// 	return res
// }