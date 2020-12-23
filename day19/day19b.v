import os
import pcre

const (
	file_input = './day19b.sample3'
)

fn main() {
	raw := os.read_file(file_input) or { panic(err) }
	parts := raw.split('\n\n')
	assert parts.len == 2
	pattern := '^${get_regex_rule_zero(parts[0])}$' // r'a(ab|ba)' // 
	println('regex: $pattern')
	candidates := parts[1].split('\n')
	println('candidates:$candidates.len')
	mut re := pcre.new_regex(pattern, 0) or { panic(err) }
	mut matches := 0
	for c in candidates {
		re.match_str(c, 0, 0) or { continue }
		matches++
	}
	println('matches:$matches')
}

fn get_regex_rule_zero(raw_rules string) string {
	mut rules := map[string]string{}
	mut char_rules := []string{}
	mut max_rule_id := 0
	for r in raw_rules.split('\n') {
		rule_num := r.all_before(':')
		mut rule_contents := r.all_after(':')
		if rule_num.int() > max_rule_id {
			max_rule_id = rule_num.int()
		}
		if r.contains('"') {
			char_rules << rule_num
			// remove extra ""
			rule_contents = rule_contents.find_between('"', '"')
			// println('rule:$rule_num val:$rule_contents')
		}
		rules[rule_num] = rule_contents
	}
	// update for part 2
	rules['8'] = ' 42 | 42 8'
	rules['11'] = ' 42 31 | 42 11 31'
	// println('max_rule_id:$max_rule_id')
	// replace chars
	for char_num in char_rules {
		val := rules[char_num]
		for i := max_rule_id; i >= 0; i-- {
			// println('before: ${rules[i.str()]} val:$val')
			mut tmp := rules[i.str()].split(' ')
			for j, _ in tmp {
				if tmp[j] == char_num {
					tmp[j] = tmp[j].replace(char_num, val)
					// println('after:$tmp[j]')
				}
			}
			rules[i.str()] = tmp.join(' ')
		}
	}
	// expand self-ref rule
	for i := max_rule_id; i >= 0; i-- {
		if i == 8 {
			println('start [8] ${rules['8']}')
		}
		mut parts := rules[i.str()].split(' ')
		for p_idx, p in parts {
			if p == i.str() {
				parts[p_idx] = ' | ' +  rules[i.str()].replace('$i', '') 
			}
		}
		rules[i.str()] = parts.join(' ')
		if i == 8 {
			println('post [8] ${rules['8']}')
		}
	}
	for i := max_rule_id; i >= 0; i-- {
		mut tmp := rules[i.str()]
		has_or := tmp.contains('|')
		if has_or {
			tmp = ' ( ' + tmp + ' ) ' // need extra spacing for split to get individual numbers
		}
		// iterate other rules to check if i was referenced and replace it
		for j := max_rule_id; j >= 0; j-- {
			mut refs := rules[j.str()].split(' ')
			for k, _ in refs {
				// if i == j && refs[k].int() ==i  { refs[k]= rules[i.str()].replace(i.str(), '') }
				if refs[k] == i.str() {
					// println('refs[k]=${refs[k]} i:$i j:$j')
					refs[k] = refs[k].replace(i.str(), tmp)
				}
			}
			rules[j.str()] = refs.join(' ')
		}
	}
	for k, v in rules {
		println('k:$k val:$v')
	}
	return rules['0'].replace(' ', '')
}
