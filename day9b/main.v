import os

// array (queue) of 25 numbers
// next_num to validate if sum exists in combining 2 of the 25 numbers (preamble)
// oldest item in queue gets dequeued and next_num is added to the queue
const (
	answer_number = 23278925
)

fn main() {
	

	input := os.read_lines('input.txt') ?
	numbers := input.map(it.int())
	for i :=0 ; i < numbers.len; i++ {
		mut values :=[numbers[i]]
		for j :=i+1 ; j < numbers.len; j++{
			values << numbers[j]
			values_sum := values.reduce(sum,0)
			if  values_sum> answer_number{
				break
			}

			if values_sum == answer_number{
				values.sort()
				min :=values.first() 
				max := values.last()
				println('found solution: ${min} ${max} answer:${min+max}')
			}
		}
	}
}
fn sum(a int, b int) int {
	return a+b
}
fn valid_number(num int, values []int) bool {
	for i :=0 ; i < values.len; i++{
		for j:=0; j< values.len; j++{
			// skip same 
			if i==j { continue}
			if values[i] + values[j] == num{
				return true
			}
		}
	}
	return false
}
