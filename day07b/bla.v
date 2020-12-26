import os
import regex

const(
	reg = regex.regex_opt(r'(\d+) ([a-z]+ [a-z]+)')
)

fn main() {	
	// mut re := regex.new()
	//println(lines.map(parse(it,mut re)))
	parse('bla')
}

fn parse(line string) []string {
	mut res:=[]string{}
	 mut re := reg
   start, end := re.match_string(line)
println('$start $end')
	// groups := reg.find_all(line)

 	// println(groups)
	// group_list := re.get_group_list() 
	// 		println('group[0] ${group_list}')


	// for i := 0; i < groups.len; i += 2 {
	// 	res << line[groups[i]..groups[i + 1]]
	// }
	return res
}

fn read_file_lines(file_path string) []string {
	lines := os.read_lines(file_path) or { panic(err) }
	return lines
}
