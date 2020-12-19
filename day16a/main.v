
import os

const (
	input_file = './input.txt'
)

struct Interval {
	from int
	to   int
}

fn (rules []Interval) is_valid(val int) bool {
	mut res := false
	for r in rules {
		if r.from <= val && r.to >= val {
			// a match makes it valid
			return true
		}
	}
	return res
}

fn get_interval(interval string) Interval {
	parts := interval.split('-')
	return Interval{
		from: parts[0].int()
		to: parts[1].int()
	}
}

fn main() {
	mut rules := map[string][]Interval{}
	raw := read_file_as_string(input_file)
	parts := raw.split('\n\n')
	for rule in parts[0].split('\n') {
		key := rule.all_before(':')
		intervals := rule.all_after(': ').split(' or ').map(get_interval(it))
		rules[key] = intervals
	}
	// nearby tickets
	nearby_tickets := parts[2]
	numbers := nearby_tickets.all_after('\n').replace('\n', ',').split(',').map(it.int())
	mut res := 0
	for n in numbers {
		mut valid_in_any := false
		for k in rules.keys() {
			if rules[k].is_valid(n) {
				valid_in_any = true
				break
			}
		}
		if !valid_in_any {
			res += n
		}
	}
	println(res)
}

fn read_file_as_string(file_path string) string {
	raw := os.read_file(file_path) or { panic(err) }
	return raw
}
