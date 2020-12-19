import os

const (
	input_file = './input_sample.txt'
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
	println('is_valid val:[$val] res:[$res]')
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
	// tickets = tickets.filter(!validator.valid_ticket(it))
	mut mapping_index := map[string]int{}
	// key => index 
	for n in 0 .. tickets[0].len {
		println('[N=$n]')
		for row in 0 .. tickets.len {
			println('val:${tickets[row][n]}')
			for k, v in field_map {
				// if field_map[k] == false {		// CLEAR MAP!!!!!!
				// 	continue
				// }
				num_valid := rules[k].is_valid(tickets[row][n])
				println('num:${tickets[row][n]} num_valid:$num_valid field_map[$k]=${field_map[k]}')
				field_map[k] = field_map[k] && num_valid
				println('after ${field_map[k]} k=$k')
			}
		}
		println('AFTER COL FIELD_MAP:$field_map')
		// inspect map
		mut key := ''
		mut count := 0
		for k, _ in field_map {
			if field_map[k] {
				key = k
				count++
			}
		}
		if count == 1 {
			mapping_index[key] = n
			println('COL:$n KEY:$key $mapping_index')	
		} 
			
		
		// reset field_map
		for k, _ in field_map {
			field_map[k] = true
		}
	}
	println('\n\n')
	println(mapping_index)
}

fn read_file_as_string(file_path string) string {
	raw := os.read_file(file_path) or { panic(err) }
	return raw
}
