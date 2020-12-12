import os
import math

const (
	input_file      = './input.txt' //'./input_example1.txt'
	start_direction = 'E'
	directions      = ['N', 'E', 'S', 'W']
)

struct Instruction {
	action string
	arg    int
}

struct Program {
mut:
	instructions []Instruction
	x            int // west <--> east
	y            int // north <--> south
	heading      string = start_direction
}

fn main() {
	mut p := Program{}
	p.run()
	println(p.calc_manhattan_distance())
}

fn (mut p Program) run() {
	p.get_input()
	p.execute()
}

fn (mut p Program) execute() {
	for instr in p.instructions {
		println('instr: i$instr')
		match instr.action {
			'N', 'S', 'E', 'W' { p.move(instr.action, instr.arg) }
			'F' { p.move(p.heading, instr.arg) }
			'L', 'R' { p.turn(instr.action, instr.arg) }
			else { println('other $instr') }
		}
		println('pos: x:[$p.x] y:[$p.y] heading:[$p.heading]')
	}
}

fn (mut p Program) turn(action string, degrees int) {
	current_heading_index := directions.index(p.heading)
	mut index_advance := degrees / 90
	if action == 'L' {
		index_advance = 4 - index_advance	//anti-clockwise (4-L=R)
	}
	dest_index := int(math.abs((current_heading_index + index_advance))) % directions.len
	p.heading = directions[dest_index]
}

fn (mut p Program) move(direction string, distance int) {
	match direction { // can combine direction with +/-x +/-y
		'N' { p.y += distance }
		'E' { p.x += distance }
		'S' { p.y -= distance }
		'W' { p.x -= distance }
		else { eprintln('uknown direction: $direction') }
	}
}

fn (p Program) calc_manhattan_distance() int {
	println('final x:$p.x y:$p.y')
	return int(math.abs(p.x) + math.abs(p.y))
}

fn (mut p Program) get_input() {
	input := os.read_lines(input_file) or { panic(err) }
	p.instructions = input.map(Instruction{
		action: it[0].str()
		arg: it[1..].int()
	})
}
