import os

struct Grid {
	grid   [][]string
	width  int
	height int
}

fn (g Grid) steps(right int, down int) int {
	mut tree_count := 0
	mut row := 0
	mut col := 0
	mut inside_grid := true
	for inside_grid {
		// println('current: row:$row col:$col item:${g.grid[row][col]}')
		if row + down < g.height {
			row += down
		} else {
			inside_grid = false
		}
		if col + right < g.width {
			col += right
		} else {
			// width repeats itself
			col = (col + right) % g.width
		}
		if inside_grid && g.grid[row][col] == '#' {
			tree_count++
		}
	}
	return tree_count
}

fn main() {
	input := read_input_map('./day3a/input.txt')
	grid := construct_grid(input)
	println(grid.steps(3, 1))
}

fn read_input_map(file_path string) []string {
	lines := os.read_lines(file_path) or {
		panic(err)
	}
	return lines
}

fn construct_grid(input []string) Grid {
	width := input[0].len
	height := input.len
	println('height:$height wdith:$width')
	mut grid := [][]string{len: height, init: []string{len: width}}
	for lidx, line in input {
		for cidx, char in line {
			grid[lidx][cidx] = char.str() // how-to dynamically append?
		}
	}
	return Grid{
		grid: grid
		width: width
		height: height
	}
}

fn solution(grid [][]string, step_right int, step_down int) {
	println(grid)
}
