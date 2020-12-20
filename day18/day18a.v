import os

fn main() {
	// expressions := [
	// 	'2 * 3 + (4 * 5)' /* becomes 26 */,
	// 	'5 + (8 * 3 + 9 + 3 * 4 * 3)' /* becomes 437. */,
	// 	'5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))' /* becomes 12240. */,
	// 	'((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2' /* becomes 13632. */,
	// ]

	lines := os.read_lines('./input.txt')?
	mut answer := u64(0)
	for expr in lines{
		res := calc(expr)
		println('$expr => result: $res')
		answer += u64(res)
	}
	println('answer: $answer')
}

enum Ops {
	plus
	multiply
}

fn calc(expression string) u64 {
	// for each subexpr in expr
	mut expr := expression
	mut res := u64(0)
	for {
		mut sub_expr := expr.find_between('(', ')')
		for {
			if sub_expr.contains_any('()') {
				sub_expr = sub_expr.find_between('(', ')')
			} else {
				break
			}
		}
		if sub_expr.len > 0 {
			sub_val := sub_calc(sub_expr)
			// println('sub_epxr:$sub_expr sub_val:$sub_val')
			expr = expr.replace('($sub_expr)', sub_val.str())
			// println('remaining expr:$expr')
			continue
		}
		res += sub_calc(expr)
		break
	}
	//
	return res
}

fn sub_calc(expr string) u64 {
	mut res := u64(0)
	tokens := expr.split(' ')
	mut left_op := u64(0)
	mut right_op := u64(0)
	mut op := Ops.plus
	for token in tokens {
		match token {
			'+' {
				op = Ops.plus
			}
			'*' {
				op = Ops.multiply
			}
			else {
				right_op = token.u64()
				match op {
					.plus { res = left_op + right_op }
					.multiply { res = left_op * right_op }
				}
			}
		}
		left_op = res
		// println('token:$token res:$res')
	}
	return res
}
