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
			return false
		}
		val := fields[req_field]
		valid := match req_field {
			'byr' { validate_num(val, 1920, 2002) }
			'iyr' { validate_num(val, 2010, 2020) }
			'eyr' { validate_num(val, 2020, 2030) }
			'hgt' { validate_height(val) }
			'hcl' { validate_hair_color(val) }
			'ecl' { validate_eye_color(val) }
			'pid' { validate_passport_id(val) }
			else { true }
		}
		if !valid {
			return false
		}
	}
	return true
}

fn validate_num(val string, min int, max int) bool {
	num := val.int()
	return num >= min && num <= max
}

fn validate_height(val string) bool {
	unit := val[val.len - 2..]
	if unit !in ['cm', 'in'] {
		return false
	}
	length := val[..val.len - 2]
	valid := match unit {
		'cm' { validate_num(length, 150, 193) }
		'in' { validate_num(length, 59, 76) }
		else { false }
	}
	return valid
}

fn validate_hair_color(val string) bool {
	if val[0] != `#` || val.len != 7 {
		return false
	}
	for ch in val[1..] {
		if !ch.is_hex_digit() {
			return false
		}
	}
	return true
}

fn validate_eye_color(val string) bool {
	return val in ['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth']
}

fn validate_passport_id(val string) bool {
	if val.len != 9 {
		return false
	}
	for ch in val {
		if !ch.is_digit() {
			return false
		}
	}
	return true
}
