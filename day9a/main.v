import os

// array (queue) of 25 numbers
// next_num to validate if sum exists in combining 2 of the 25 numbers (preamble)
// oldest item in queue gets dequeued and next_num is added to the queue
const (
	preamble_len = 25
)

fn main() {
	mut preamble := []int{}
	input := os.read_lines('input.txt') ?
	numbers := input.map(it.int())
	mut curr := preamble_len
	preamble = numbers[..preamble_len]
	println('preamble: $preamble')
	for curr < numbers.len - 1 {
		next_num := numbers[curr]
		if !valid_number(next_num, preamble) {
			println('invalid number: $next_num')
			return
		}
		// optimize later
		preamble = preamble[1..].clone()		// clone needed to avoid bug
		preamble << next_num
		curr++
	}
	println('all numbers valid')
}

fn valid_number(num int, preamble []int) bool {
	for i :=0 ; i < preamble.len; i++{
		for j:=0; j< preamble_len; j++{
			// skip same 
			if i==j { continue}
			if preamble[i] + preamble[j] == num{
				return true
			}
		}
	}
	println('num:$num preamble:$preamble')
	return false
}
