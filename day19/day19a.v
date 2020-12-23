// 0: 1 2
// 1: "a"
// 2: 1 3 | 3 1
// 3: "b"
// Therefore, rule 0 matches aab or aba.
// iterate input list
// find "<char>" match (-> rule #x)
// replace all references to rule#x with <char>
// until all <char> have been found / replaced
// work from highest rule# to lower rule, replace reference rule to actual rule value
// replace every ref to ruleID:1 to "a"
// 0: "a" 2
// 1: "a"
// 2: "a" 3 | 3 "a"
// 3: "b"
// same but now ruleID:3 -> "b"
// 0: "a" 2
// 1: "a"
// 2: "a" "b" | "b" "a"
// 3: "b"
// replace all any reference to its value (note the groups [])
// 0: "a" ["a" "b" | "b" "a"]
// 1: "a"
// 2: "a" "b" | "b" "a"
// 3: "b"
// rule ID:0 now contains the pattern that has to match
// regex: a(ab|ba)
import os
import pcre

const (
	file_input = './day19.in'
)

fn main() {
	raw := os.read_file(file_input) or { panic(err) }
	parts := raw.split('\n\n')
	assert parts.len == 2
	pattern := '^${get_regex_rule_zero(parts[0])}$' // r'a(ab|ba)' // 
	// println('regex: $pattern')
	candidates := parts[1].split('\n')
	println('canidates:$candidates.len')
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
	for i := max_rule_id; i >= 0; i-- {
		mut tmp := rules[i.str()]
		has_or := tmp.contains('|')
		if has_or {
			tmp = ' ( ' + tmp + ' ) ' // need extra spacing for split to get individual numbers
		}
		// iterate other rules to check if i was referenced and replace it
		for j := max_rule_id; j >= 0; j-- {
			if i == j {
				continue
			}
			mut refs := rules[j.str()].split(' ')
			for k, _ in refs {
				if refs[k] == i.str() {
					// println('refs[k]=${refs[k]} i:$i j:$j')
					refs[k] = refs[k].replace(i.str(), tmp)
				}
			}
			rules[j.str()] = refs.join(' ')
		}
	}
	return rules['0'].replace(' ', '')
}
