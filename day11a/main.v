import os

enum CellState {
	unknown
	floor
	occupied
	empty
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
		if p.changes == 0 {
			break
		}
	}
	println('occupied count:${p.get_occupied_count()}')
}

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

fn (mut p Program) advance() {
	p.changes = 0
	mut new_grid := p.grid.clone()
	for rid in 0 .. p.rows {
		for cid in 0 .. p.cols {
			val := p.grid[rid][cid]
			neighbour_count := p.occupied_neighbors(rid, cid)
			new_state := match val {
				.occupied {
					if neighbour_count >= 4 { CellState.empty } else { CellState.occupied }
				}
				.empty {
					if neighbour_count == 0 { CellState.occupied } else { CellState.empty }
				}
				else {
					val
				}
			}
			if p.grid[rid][cid] != new_state {
				p.changes++
			}
			new_grid[rid][cid] = new_state
		}
	}
	p.grid = new_grid
}

fn (p Program) occupied_neighbors(row int, col int) int {
	n := if row == 0 {
		0
	} else if p.grid[row - 1][col] == .occupied {
		1
	} else {
		0
	}
	ne := if row == 0 || col == p.cols - 1 {
		0
	} else if p.grid[row - 1][col + 1] == .occupied {
		1
	} else {
		0
	}
	e := if col == p.cols - 1 {
		0
	} else if p.grid[row][col + 1] == .occupied {
		1
	} else {
		0
	}
	se := if row == p.rows - 1 || col == p.cols - 1 {
		0
	} else if p.grid[row + 1][col + 1] == .occupied {
		1
	} else {
		0
	}
	s := if row == p.rows - 1 {
		0
	} else if p.grid[row + 1][col] == .occupied {
		1
	} else {
		0
	}
	sw := if row == p.rows - 1 || col == 0 {
		0
	} else if p.grid[row + 1][col - 1] == .occupied {
		1
	} else {
		0
	}
	w := if col == 0 {
		0
	} else if p.grid[row][col - 1] == .occupied {
		1
	} else {
		0
	}
	nw := if row == 0 || col == 0 {
		0
	} else if p.grid[row - 1][col - 1] == .occupied {
		1
	} else {
		0
	}
	occupy_count := n + ne + e + se + s + sw + w + nw
	return occupy_count
}

fn (mut p Program) get_input() {
	input := os.read_lines('./input.txt') or { panic(err) }
	p.cols = input[0].len
	p.rows = input.len
	p.grid = [][]CellState{len: p.rows, init: []CellState{len: p.cols}}
	for line_idx, line in input {
		for ch_idx, ch in line {
			mut cell_state := CellState.floor
			if ch == `L` {
				cell_state = CellState.empty
			} else if ch == `#` {
				cell_state = CellState.occupied
			} else if ch == `.` {
				cell_state = CellState.floor
			} else {
				panic('invalid input cell: $ch')
			}
			p.grid[line_idx][ch_idx] = cell_state
		}
	}
}
