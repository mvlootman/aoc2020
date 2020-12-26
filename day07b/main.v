import os

struct Bag {
mut:
	name        string
	num         int
	nested_bags []Bag
}

fn main() {
	lines := read_file_lines('input.txt')
	bags := parse_bags(lines)
	println(count_bags('shiny gold', bags))
}

// recurse into the results
fn count_bags(src_bag string, bags []Bag) int {
	mut count := 0
	// base case
	if src_bag == '' {
		return count
	}
	for b in bags {
		if b.name == src_bag {
			for to in b.nested_bags {
				count += to.num // own count
				count += to.num * count_bags(to.name, bags) // nested counts
			}
		}
	}
	return count
}

fn parse_bags(lines []string) []Bag {
	mut bags := []Bag{}
	for line in lines {
		mut bag := Bag{}
		bag.name = line.all_before('bags').trim(' ')
		contained_bags := line.all_after('contain').split(',').map(it.trim(' ').split(' '))
		for cbag in contained_bags {
			nested_bag := Bag{
				num: cbag[0].int()
				name: cbag[1].trim(' ') + ' ' + cbag[2].trim(' ')
			}
			bag.nested_bags << nested_bag
		}
		bags << bag
	}
	return bags
}

fn read_file_lines(file_path string) []string {
	lines := os.read_lines(file_path) or { panic(err) }
	return lines
}
