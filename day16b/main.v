import os

const (
	input_file = './input.txt'
)

fn valid_ticket(ticket_num []int, limits [][]int) bool {
	for n in ticket_num {
		mut valid_in_any := false
		for l in limits {
			min1, max1, min2, max2 := l[0], l[1], l[2], l[3]
			valid_in_any = valid_in_any || (min1 <= n && n <= max1) || (min2 <= n && n <= max2)
		}
		if !valid_in_any {
			return false
		}
	}
	return true
}


fn parse_interval_limits(interval string) (int, int) {
	parts := interval.split('-')
	return parts[0].int(), parts[1].int()
}

fn main() {
	raw := read_file_as_string(input_file)
	parts := raw.split('\n\n')
	mut limits := [][]int{} // holds per fieldindex the min/max pairs
	for rule in parts[0].split('\n') {
		key := rule.all_before(':')
		limit_vals := rule.all_after(': ').replace(' or ', '-').split('-').map(it.int()) // replace by (\d+) 
		limits << limit_vals
	}

	// own ticket
	own_ticket := parts[1].replace('own ticket:your ticket:\n','').split(',').map(it.int())
	println('own ticket:$own_ticket')
	// nearby tickets
	nearby_tickets := parts[2]
	ticket_number_str := nearby_tickets.all_after('\n').split('\n') 
	mut tickets := [][]int{}
	for line in ticket_number_str {
		tickets << line.split(',').map(it.int())
	}

	// remove invalid tickets
	tickets = tickets.filter(valid_ticket(it, limits))
	println('valid tickets:$tickets.len')
	mut arr_valid := [][]bool{len: tickets[0].len, init: []bool{len: limits.len, init: true}} // 20x20 
	assert arr_valid.len == 20
	assert arr_valid[0].len == 20
	for i, _ in tickets {
		for ticket_num in 0 .. tickets[i].len {
			for field in 0 .. limits.len {
				num := tickets[i][ticket_num]
				l := limits[field]
				min1, max1, min2, max2 := l[0], l[1], l[2], l[3]
				is_valid := (min1 <= num && num <= max1) || (min2 <= num && num <= max2)
				if !is_valid {
					arr_valid[ticket_num][field] = false
				}
			}
		}
	}

	// we have an array(i,j) with ticket position (i) and field index (j), this (i,j) return whether for ticket position all values matched field limits
	// Now we find the fields for the ticket positions by checking to see if one position matches a single field
	// then mark that field as false for all other ticket positions
	mut matched_cols := []int{}
	mut field_to_pos := map[string]int{} // field X => ticket pos. N
	for {
		// finished when we matched all columns
		if matched_cols.len == arr_valid.len {
			break
		}
		for tpos in 0 .. arr_valid.len {
			if tpos !in matched_cols {
				candidates := arr_valid[tpos].filter(it == true)
				if candidates.len == 1 {
					// lookup the index it occured as filter loses that
					mut index := -1
					for i, fld in arr_valid[tpos] {
						if fld {
							index = i
							matched_cols << tpos
							field_to_pos[i.str()] = tpos
							// remove this fld from other positions
							for ipos in 0 .. arr_valid.len {
								arr_valid[ipos][i] = false
							}
							break
						}
					}
				}
			}
		}
	}
	// println(field_to_pos)

	// for all duration* fields  we need the first 6 fields
	// we then find the matching ticket pos and find the value of our own ticket
	// which we multiply together for the answer
	mut answer:= u64(1)
	for i in 0..6{
		// lookup index we need 
		idx := field_to_pos[i.str()]
		answer *= u64(own_ticket[idx])
		println('i:$i idx:$idx my-ticket-value:${u64(own_ticket[idx])} answer:$answer')
	}
	println('answer day 16 part 2: $answer')
}

fn read_file_as_string(file_path string) string {
	raw := os.read_file(file_path) or { panic(err) }
	return raw
}
