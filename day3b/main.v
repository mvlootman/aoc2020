import os

struct Grid {
	grid   [][]string
	width  int
	height int
}

fn (g Grid) run_slope(right int, down int) int {
	mut tree_count := 0
	mut row := 0
	mut col := 0
	mut inside_grid := true
	for inside_grid {
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
	mut result := []int64{}
	/*
	Right 1, down 1.
	Right 3, down 1. (This is the slope you already checked.)
	Right 5, down 1.
	Right 7, down 1.
	Right 1, down 2.
	*/
	result << grid.run_slope(1, 1)
	result << grid.run_slope(3, 1)
	result << grid.run_slope(5, 1)
	result << grid.run_slope(7, 1)
	result << grid.run_slope(1, 2)
	println(result.reduce(multipy, 1))
}

fn multipy(a int64, b int64) int64 {
	return a * b
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
	mut grid := [][]string{len: height} //}, init: []string{len: width}}
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
