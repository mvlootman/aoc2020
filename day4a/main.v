import os

fn main() {
	lines := read_file_as_string('input.txt')
	items := lines.split('\n\n')
	mut valid_passports := 0
	for item in items {
		mut fields := map[string]string{}
		flat_item := item.replace('\n', ' ')
		for key_value in flat_item.split(' ') {
			parts := key_value.split(':')
			fields[parts[0]] = parts[1]
		}
		if is_valid(fields) {
			valid_passports++
		}
	}
	println('valid passports:$valid_passports')
}

fn read_file_as_string(file_path string) string {
	raw := os.read_file(file_path) or {
		panic(err)
	}
	return raw
}

fn is_valid(fields map[string]string) bool {
	required_fields := ['byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid'] // optional : cid (Country ID)']
	for req_field in required_fields {
		if req_field !in fields {
			// println('$req_field not present')
			return false
		}
	}
	return true
}

// fn read_input_lines(file_path string) []string {
// lines := os.read_lines(file_path) or {
// panic(err)
// }
// return lines
// }

