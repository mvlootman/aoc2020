import os

struct Rule {
mut:
	from string
	to   []string
}

fn main() {
	lines := read_file_lines('input.txt')
	rules := parse_rules(lines)
	// direct linked gold bags
	direct, nested_bags := find_in_nested_bags('shiny gold', mut []string{}, 0, rules)
	println('shiny gold direct:$direct')
	println('bags: $nested_bags')
	// // println(find_in_nested_bags('pale magenta', rules))
	// mut total := direct
	// // find in which bag those found bags can be nested
	// for nest_bag in nested_bags{
	// println('nest_bag:${nest_bag}')
	// indirect, nested_sub_bags := find_in_nested_bags(nest_bag.trim(' '), rules)
	// println('$nest_bag indirect:$indirect')
	// println('nested bags: $nested_sub_bags')
	// total += indirect
	// }
	// println('total:$total')
}

// return count and further bags to search
fn find_in_nested_bags(bag string, mut found_uniq_bags []string, current_count int, rules []Rule) (int, string) {
	println('find_in_nested_bags: bag:$bag current_count:$current_count')
	mut count := current_count
	// base case
	if bag == '' {
		println('no more bags')
		return count, ''
	}
	// println('bag:$bag to search. current count:$current_count')
	// mut found_in_bag := []string{}0
	for r in rules {
	
		for to in r.to {
			// println('looking for bag:$bag currently see:$to')
			if to == bag {
				if r.from !in found_uniq_bags {
					found_uniq_bags << r.from
					count++
					println('\tMATCH bag:[$bag] in:[$r.from]')
					next_parent_bag := r.from.trim(' ')
					count, _ = find_in_nested_bags(next_parent_bag, mut found_uniq_bags,
						count, rules)
				}
			}
		}
	}
	return count, ''
}

fn parse_rules(lines []string) []Rule {
	// format
	// char1 char2 <bags> contain num char1 char2<,> repeat
	// muted lavender bags contain 5 dull brown bags, 4 pale maroon bags, 2 drab orange bags.
	mut rules := []Rule{}
	for line in lines {
		mut rule := Rule{}
		rule.from = line.all_before('bags').trim(' ')
		contained_bags := line.all_after('contain').split(',').map(it.trim(' ').split(' '))
		for bag in contained_bags {
			rule.to << bag[1].trim(' ') + ' ' + bag[2].trim(' ') // find cleaner way
		}
		rules << rule
	}
	return rules
}

fn read_file_lines(file_path string) []string {
	lines := os.read_lines(file_path) or { panic(err) }
	return lines
}
