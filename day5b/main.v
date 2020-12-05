import math
import os

fn main() {
	input_list := read_file_lines('input.txt')
	mut booked_seats := []int{}
	for input in input_list {
		_, _, seat_id := decode_ticket(input)
		booked_seats << seat_id
	}
	_, _, start_seat_id := decode_ticket('FFFFFFFRRR') // row: 0, col: 7, seat_id: 7
	_, _, end_seat_id := decode_ticket('BBBBBBBLLL') // row: 127, col: 0, seat_id 1016
	// candidate seat wil start after start_seat and before end_seat_id
	for candidate_seat_id in start_seat_id + 1 .. end_seat_id {
		if candidate_seat_id !in booked_seats {
			println('seat_id:$candidate_seat_id')
			break
		}
	}
}

fn read_file_lines(file_path string) []string {
	lines := os.read_lines(file_path) or {
		panic(err)
	}
	return lines
}

fn decode_ticket(input string) (int, int, int) {
	row := decode_row(input[..7])
	col := decode_col(input[7..])
	seat_id := calc_seat_id(row, col)
	return row, col, seat_id
}

fn decode_row(input string) int {
	val := input.reverse()
	mut binary := ''
	for c in val {
		digit := match c {
			`F` { '0' }
			`B` { '1' }
			else { '0' }
		}
		binary += digit
	}
	res := binary_string_to_int(binary)
	return res
}

fn decode_col(input string) int {
	val := input.reverse()
	mut binary := ''
	for c in val {
		digit := match c {
			`L` { '0' }
			`R` { '1' }
			else { '0' }
		}
		binary += digit
	}
	res := binary_string_to_int(binary)
	return res
}

fn calc_seat_id(row int, col int) int {
	return row * 8 + col
}

fn binary_string_to_int(binary string) int {
	mut res := 0
	for idx, c in binary {
		digit := c.str().int()
		res += digit * int(math.pow(f64(2), f64(idx)))
	}
	return res
}
