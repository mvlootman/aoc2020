import math
import os

fn main() {
	// exclude seatids front seat_id 1*8+[1..8] => <=16 skip 
	// exclude seatids back seat_id 128*8+[1...8] => >1025 skip

	input_list := read_file_lines('input.txt')
	mut booked_seats  := []int{}
	for input in input_list {
		_, _, seat_id := decode_ticket(input)
		booked_seats << seat_id
	}
	for candidate_seat_id in  17..1025{
		if candidate_seat_id !in booked_seats{
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
	// println('decode_row:$input res:$res')
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
	// println('decode_col:$input res:$res')
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
