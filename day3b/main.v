import os

struct Grid {
	lines  []string
	width  int
	height int
}

fn (g Grid) run_slope(right int, down int) int {
	mut tree_count := 0
	mut row := 0
	mut col := 0
	for row < g.height {
		if g.lines[row][col] == `#` {
			tree_count++
		}
		row += down
		col = (col + right) % g.width
	}
	return tree_count
}

fn main() {
	input := read_input_map('./day3a/input.txt')
	grid := construct_grid(input)
	results := [
		grid.run_slope(1, 1),
		grid.run_slope(3, 1),
		grid.run_slope(5, 1),
		grid.run_slope(7, 1),
		grid.run_slope(1, 2),
	]
	mut result := i64(1)
	for num in results {
		result = result * num
	}
	println(result)
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
	return Grid{
		grid: input
		width: width
		height: height
	}
}
