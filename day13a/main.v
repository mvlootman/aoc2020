import os

const (
	input_file = './input.txt'
)

fn main() {
	ts, busses := get_input()
	find_earliest_bus(ts, busses)
}

fn get_input() (int, []int) {
	input := os.read_lines(input_file) or { panic(err) }
	ts := input[0].int()
	busses := input[1].replace(',x', '').split(',').map(it.int())
	return ts, busses
	// return 939,[7, 13, 59, 31, 19]
}

fn find_earliest_bus(timestamp int, busses []int) {
	mut min_ts := 0
	mut bus_id := 0
	for bus in busses {
		bus_arrival_ts := first_after_timestamp(timestamp, bus)
		if bus_arrival_ts < min_ts || min_ts == 0 {
			min_ts = bus_arrival_ts
			bus_id = bus
		}
	}
	wait_duration := min_ts - timestamp
	answer := wait_duration * bus_id
	println('take bus:$bus_id arriving at:$min_ts waiting time:$wait_duration')
	println('answer: $answer')
}

fn first_after_timestamp(ts int, bus int) int {
	mut arrival_ts := 0
	for {
		if arrival_ts >= ts {
			break
		}
		arrival_ts += bus
	}
	return arrival_ts
}
