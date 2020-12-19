import os

const (
	input_file = './input.txt'
)

struct Interval {
	from int
	to   int
}

struct Validator {
mut:
	rules map[string][]Interval
}

fn (mut v Validator) new(ruleset map[string][]Interval) {
	v.rules = ruleset
}

fn (v Validator) valid_ticket(ticket_num []int) bool {
	for n in ticket_num {
		mut valid_in_any := false
		for k in v.rules.keys() {
			if v.rules[k].is_valid(n) {
				valid_in_any = true
				break
			}
		}
		if !valid_in_any {
			return false
		}
	}
	return true
}

fn (rules []Interval) is_valid(val int) bool {
	mut res := false
	for r in rules {
		if r.from <= val && r.to >= val {
			res = true
		}
	}
	// println('is_valid val:[$val] res:[$res]')
	return res
}

fn parse_interval(interval string) Interval {
	parts := interval.split('-')
	return Interval{
		from: parts[0].int()
		to: parts[1].int()
	}
}

fn main() {
	mut field_map := map[string]bool{} // field -> match
	mut rules := map[string][]Interval{}
	mut validator := Validator{}
	raw := read_file_as_string(input_file)
	parts := raw.split('\n\n')
	for rule in parts[0].split('\n') {
		key := rule.all_before(':')
		intervals := rule.all_after(': ').split(' or ').map(parse_interval(it))
		rules[key] = intervals
		field_map[key] = true // unknown index
	}
	validator.new(rules)
	// nearby tickets
	nearby_tickets := parts[2]
	ticket_number_str := nearby_tickets.all_after('\n').split('\n') // .map( it.split(','))
	mut tickets := [][]int{}
	for line in ticket_number_str {
		tickets << line.split(',').map(it.int())
	}
	// remove invalid tickets
	tickets = tickets.filter(validator.valid_ticket(it))
	println('valid tickets:$tickets.len')
	assert tickets.len > 0
	mut matches_map := map[string][]int{} // key -> col.indices
	for col in 0..tickets[0].len {
		for field, _ in rules {
			mut match_all := true
			// println('field:$field rules:${rules[field]}')
			for i, _ in tickets {
				num_col_index := tickets[i][col]
				is_valid := rules[field].is_valid(num_col_index)
				match_all = match_all && is_valid
				// println('Col:$col num_col_index:$num_col_index is_valid:${is_valid}')
			}
			if match_all {
				matches_map[field] << col
				println('matched all column values for [$field] result:[$match_all] col:[$col]')
			}
		}
	}
	// println('matches:$matches_map')
	for k,v in matches_map{
		println('key:$k v:$v')
	}

}

fn read_file_as_string(file_path string) string {
	raw := os.read_file(file_path) or { panic(err) }
	return raw
}
