import os
import math

const (
	input_file      = './input.txt'
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
	ship_x       int // west <--> east
	ship_y       int // north <--> south
	wp_x         int = 10
	wp_y         int = 1
	heading      string = start_direction
}

fn main() {
	mut p := Program{}
	p.run()
}

fn (mut p Program) run() {
	p.get_input()
	p.execute()
	p.calc_manhattan_distance()
}

fn (mut p Program) execute() {
	for instr in p.instructions {
		match instr.action {
			'N', 'S', 'E', 'W' { p.move_waypoint(instr.action, instr.arg) }
			'F' { p.move_ship(instr.arg) }
			'L', 'R' { p.turn(instr.action, instr.arg) }
			else { eprintln('UNKNOWN: $instr') }
		}
	}
}

fn (mut p Program) turn(action string, degrees int) {
	mut num_90_degrees_rotations := degrees / 90
	for _ in 0 .. num_90_degrees_rotations {
		x, y := p.wp_x, p.wp_y
		if action == 'R' {
			p.wp_x, p.wp_y = y, -x
		} else {
			p.wp_x, p.wp_y = -y, x
		}
	}
}

fn (mut p Program) move_waypoint(direction string, distance int) {
	match direction { // can combine direction with +/-x +/-y
		'N' { p.wp_y += distance }
		'E' { p.wp_x += distance }
		'S' { p.wp_y -= distance }
		'W' { p.wp_x -= distance }
		else { eprintln('unknown direction: $direction') }
	}
}

fn (mut p Program) move_ship(times int) {
	p.ship_x += p.wp_x * times
	p.ship_y += p.wp_y * times
}

fn (p Program) print_positions() {
	ship_formatted := puzzle_format(p.ship_x, p.ship_y)
	wp_formatted := puzzle_format(p.wp_x, p.wp_y)
	println('ship: $p.ship_x,$p.ship_y) $ship_formatted  wp: ($p.wp_x,$p.wp_y) $wp_formatted heading:$p.heading')
}

fn puzzle_format(x int, y int) string {
	x_str := if x >= 0 { 'east' } else { 'west' }
	y_str := if y >= 0 { 'north' } else { 'south' }
	return '$x units $x_str $y units $y_str'
}

fn (p Program) calc_manhattan_distance() int {
	println('final x:$p.ship_x y:$p.ship_y')
	return int(math.abs(p.ship_x) + math.abs(p.ship_y))
}

fn (mut p Program) get_input() {
	input := os.read_lines(input_file) or { panic(err) }
	p.instructions = input.map(Instruction{
		action: it[0].str()
		arg: it[1..].int()
	})
}
