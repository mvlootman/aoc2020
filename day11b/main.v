import os

const (
	occupy_treshold = 5
)

enum CellState {
	unknown
	floor
	occupied
	empty
}

enum Direction {
	north
	northeast
	east
	southeast
	south
	southwest
	west
	northwest
}

struct Program {
mut:
	grid    [][]CellState
	rows    int
	cols    int
	changes int
}

fn main() {
	mut p := Program{}
	p.run()
}

fn (mut p Program) run() {
	p.get_input()
	for {
		p.advance()
		// p.print_grid()
		if p.changes == 0 {
			break
		}
	}
	println('occupied count:$p.get_occupied_count()')
}

fn (mut p Program) advance() {
	// create new grid to update
	p.changes = 0
	mut new_grid := p.grid.clone()
	for rid in 0 .. p.rows {
		for cid in 0 .. p.cols {
			val := p.grid[rid][cid]
			neighbour_count := p.occupied_neighbors(rid, cid)
			new_state := match val {
				.occupied {
					if neighbour_count >= occupy_treshold { CellState.empty } else { CellState.occupied }
				}
				.empty {
					if neighbour_count == 0 { CellState.occupied } else { CellState.empty }
				}
				else {
					val
				}
			}
			if val != new_state {
				p.changes++
			}
			new_grid[rid][cid] = new_state
		}
	}
	p.grid = new_grid
}

fn (p Program) get_occupied_count() int {
	mut count := 0
	for r in 0 .. p.rows {
		for c in 0 .. p.cols {
			if p.grid[r][c] == .occupied {
				count++
			}
		}
	}
	return count
}

fn (p Program) occupied_neighbors(row int, col int) int {
	mut occupy_count := 0
	for dir in [Direction.north, Direction.northeast, Direction.east, Direction.southeast, Direction.south,
		Direction.southwest, Direction.west, Direction.northwest] {
		occupy_count += p.find_directional_occupied(row, col, dir)
	}
	return occupy_count
}

// find_directional_occupied will navigate from given position into given direction until a occupied seat is found and return 1 .
// Or when empty seat if found or navigated out-of-board, it will return 0
fn (p Program) find_directional_occupied(row int, col int, direction Direction) int {
	mut new_row := row
	mut new_col := col
	for {
		match direction {
			.north {
				new_row--
			}
			.northeast {
				new_row--
				new_col++
			}
			.east {
				new_col++
			}
			.southeast {
				new_row++
				new_col++
			}
			.south {
				new_row++
			}
			.southwest {
				new_row++
				new_col--
			}
			.west {
				new_col--
			}
			.northwest {
				new_row--
				new_col--
			}
		}
		// check if within bounds of grid
		if new_row < 0 || new_row > p.rows - 1 || new_col < 0 || new_col > p.cols - 1 {
			return 0
		}
		match p.cell_state(new_row, new_col) {
			.occupied { return 1 }
			.empty { return 0 }
			else {} // keep on going in same direction
		}
	}
	return 0 // should not get here
}

fn (p Program) cell_state(row int, col int) CellState {
	return p.grid[row][col]
}

fn (mut p Program) get_input() {
	input := os.read_lines('./input.txt') or { panic(err) }
	p.cols = input[0].len
	p.rows = input.len
	p.grid = [][]CellState{len: p.rows, init: []CellState{len: p.cols}}
	for line_idx, line in input {
		for ch_idx, ch in line {
			cell_state := match ch {
				`L` { CellState.empty}
				`#` { CellState.occupied}
				`.` { CellState.floor}
				else { CellState.floor}
			}
			p.grid[line_idx][ch_idx] = cell_state
		}
	}
}

// print_grid dumps the current grid into same format as puzzle
fn (p Program) print_grid() {
	for r in 0 .. p.rows {
		for c in 0 .. p.cols {
			match p.grid[r][c] {
				.occupied { print('#') }
				.empty { print('L') }
				.floor { print('.') }
				.unknown { print('?') }
			}
		}
		println('')
	}
}

// 2144
