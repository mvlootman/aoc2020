// import os
import regex

enum Ops {
	plus
	multiply
}

fn main() {
	// lines := [
	// 	// '1 + (2 * 3) + (4 * (5 + 6))', //  still becomes 51.
	// 	// '2 * 3 + (4 * 5)'//  becomes 46.
	// 	// '5 + (8 * 3 + 9 + 3 * 4 * 3)', //  becomes 1445.
	// 	// '5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))',// becomes 669060.
	// 	// '((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2', //becomes 23340
	// ]
	// query := r'(?P<first>\d+) \+ (?P<second>\d+)'
	line := [
		'1 + (2 + 1)',
		/* 'er was eens', */ /* '(12 + 34 + (4 + 5))', *//* '(12 + 34 + (4 + 5) + (6 + 9))', *//* '(12 + 34 + (4 + 5) + 15)', *//* '1 * 2 * 3 + (4 - 1) + 12 - (3 + 1)', */
		'((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2' /* becomes 23340 */,
	]
	for l in line {
		println('\norg:$l')
		mut expr := l
		for {
			mut matches := unnest(expr)
			// no more nestings
			if matches.len == 0 {
				break
			}
			for m in matches {
				println('\t sub:$m')
				sub_res := sub_calc(m, false)
				println('calc => $sub_res')
				expr = expr.replace(m, sub_res.str())
				println('\t after: $expr')
			}
		}

		// now handle the additions first
		
		println('pre => expr:$expr')
		sub_res := sub_calc(expr, false)
		println('FINAL => $sub_res expr:$expr')
	}
	// println('unnest:${unnest('er was eens')}')
	// println('unnest:${unnest('')
}

fn sub_calc(expression string, recurse bool) u64 {
	mut expr := expression
	expr = expr.replace('(', '').replace(')', '')
	println('expr=$expr')
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
		// println('token:$token res:$res left_op:$left_op right_op:$right_op')
	}
	return res
}

fn unnest(text string) []string {
	match_inside_parens_query := r'(\([^()]+\))' // starts with (escaped) parenthesis open, anything but '(' or ')' multiple times, and ends on ')'. Capture group around []+ part
	// text := '(12 + 34 + 31)' // => (4+5)
	mut re := regex.regex_opt(match_inside_parens_query) or { panic(err) }
	re.group_csave_flag = true
	// println(re.get_query())
	// #0(c#1(pa)+z ?)+  // #0 and #1 are the ids of the groups, are shown if re.debug is 1 or 2
	idxs := re.find_all(text)
	// println(idxs)
	// println(re.get_group_list())
	mut res := []string{}
	for i := 0; i < idxs.len; i = i + 2 {
		res << text[idxs[i]..idxs[i + 1]]
	}
	return res
}
