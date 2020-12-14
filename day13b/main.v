import os

const (
	input_file = './input.txt'
)

fn main() {
	busses := get_input()
	println(find_alignment(busses, 3417))
}

fn get_input() []u64 {
	input := os.read_lines(input_file) or { panic(err) }
	busses := input[1].replace(',x', ',0').split(',').map(it.u64())
	return busses
}

fn find_alignment(busses []u64, timestamp u64) u64 {
	bus_zero := busses[0]
	// answer expected to be larger than 100_000_000_000_000 
	// start at n * bus_zero
	mut curr_ts := u64(0)
	mut found_match := false
	for {
		// cycle through the bus_zero times and check if on that departure_ts the other have the correct distance_ts
		for idx, other_bus in busses[1..] {
			found_match = false
			// skip X busses
			if other_bus == 0 {
				continue
			}
			offset_to_bus_zero := u64(idx+1) // index but we skipped bus_zero
			// check if other_bus leaves at curr_ts+distance val
			if (curr_ts + offset_to_bus_zero) % other_bus == 0 {
				found_match = true
			} else {
				// move to next bus_zero value
				curr_ts += bus_zero
				break
			}
		}
		if found_match {
			// all busses are aligned at this ts
			println('Alignment found at ts=$curr_ts')
			return curr_ts
		}
	}
	return -1
}
