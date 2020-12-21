import os
import regex

const (
	file_input = './input.txt'
)

fn main() {
	// println(calc_expression('((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2')) // 1 + (1 + 2 + 3 + (2 + 4 + 6))'))
	lines := get_input()
	mut res := u64(0)
	for l in lines {
		res += calc_expression(l)
	}
	println(res)
}

fn get_input() []string {
	lines := os.read_lines(file_input) or { panic(err) }
	return lines
}

fn calc_expression(expression string) u64 {
	// order of operations:
	// 1. parenthesis (unnest)
	// 2. addition
	// 3. multiplication
	mut res := u64(0)
	mut expr := expression
	mut sub_expr := ''
	mut start := 0
	mut end := 0
	for {
		sub_expr, start, end = unnest(expr)
		sub_expr = simplify_additions(sub_expr)
		sub_expr = simplify_multiplication(sub_expr)
		if start == -1 {
			return sub_expr.u64()
		} else {
			expr = expr[0..start] + sub_expr + expr[end..]
		}
	}
	return res
}

// removes all `a + b` in expression and replaces it with the value of a+b
// eg. 1 + 2 * 5 + 3  => 3 * 8
fn simplify_additions(expression string) string {
	// find pattern: (a) + (b) 
	// convert group a and b to ints() and add them together
	// replace the sum in expression match_a_start..match_b_end
	mut expr := expression
	pattern := r'(?P<a>\d+) \+ (?P<b>\d+)'
	mut re := regex.regex_opt(pattern) or { panic(err) }
	// text := '1 + 2 + 3' // => num_a:1 num_:2
	for {
		// println('expr=$expr')
		start, end := re.find(expr)
		// println('$start,$end')
		if start == -1 {
			break
		}
		groups := re.get_group_list()
		a := expr[groups[0].start..groups[0].end].u64()
		b := expr[groups[1].start..groups[1].end].u64()
		sum := a + b
		expr = expr[0..start] + sum.str() + expr[end..]
	}
	return expr
}

// removes all `a * b` in expression and replaces it with the value of a*b
// eg. 1 + 2 * 5 + 3  => 1 + 10 + 3
fn simplify_multiplication(expression string) string {
	// find pattern: (a) * (b) 
	// convert group a and b to ints() and multiply them together
	// replace the product in expression match_a_start..match_b_end
	mut expr := expression
	pattern := r'(?P<a>\d+) \* (?P<b>\d+)'
	mut re := regex.regex_opt(pattern) or { panic(err) }
	// text := '1 * 2 * 3' // => num_a:1 num_:2
	for {
		// println('expr=$expr')
		start, end := re.find(expr)
		// println('$start,$end')
		if start == -1 {
			break
		}
		groups := re.get_group_list()
		a := expr[groups[0].start..groups[0].end].u64()
		b := expr[groups[1].start..groups[1].end].u64()
		product := a * b
		expr = expr[0..start] + product.str() + expr[end..]
	}
	return expr
}

fn unnest(text string) (string, int, int) {
	match_inside_parens_query := r'\([^()]+\)' // starts with (escaped) parenthesis open, anything but '(' or ')' multiple times, and ends on ')'. Capture group around []+ part
	mut re := regex.regex_opt(match_inside_parens_query) or { panic(err) }
	idxs := re.find_all(text)
	if idxs.len == 0 {
		return text, -1, -1
	}
	start := idxs[0] + 1
	end := idxs[1] - 1
	return text[start..end], idxs[0], idxs[1] // remove out parens
}
