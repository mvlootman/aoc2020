import os

struct Food {
mut:
	ingredients []string
	allergies   []string
}

fn main() {
	lines := os.read_lines('./day21.in') ?
	mut foods := []Food{}
	mut all_allergies := []string{}
	mut all_ingredients := []string{}
	for l in lines {
		ingr := l.all_before('(').trim(' ').split(' ')
		allergies := l.find_between('(contains ', ')').split(',').map(it.trim(' '))
		foods << Food{
			ingredients: ingr
			allergies: allergies
		}
		for ing in ingr{
			if ing !in all_ingredients{
				all_ingredients << ing
			}
		}
		for allerg in allergies {
			if allerg !in all_allergies {
				all_allergies << allerg
			}
		}
	}
	mut mapped_ingredients := map[string]string{} // ingredient -> allergy
	for {
		for allerg in all_allergies {
			println('\n\ninspecting allergy:$allerg')
			// find all food having allergies
			foods_with_specific_allegy := foods.filter(allerg in it.allergies)
			num_foods_with_allergy := foods_with_specific_allegy.len
			// check if we have a single ingredient the same number in common in all foods
			mut seen := map[string]int{}
			for food in foods_with_specific_allegy {
				for ingr in food.ingredients {
					if ingr !in mapped_ingredients {
						// skip ingredients we already have mapped
						seen[ingr]++
					}
				}
			}
			mut candidate := ''
			for k, v in seen {
				if v == num_foods_with_allergy {
					if candidate.len > 0 {
						// no single key with the desired count
						candidate = ''
					}
					candidate = k
				}
			}
			if candidate.len > 0 {
				mapped_ingredients[candidate] = allerg
			}
		}
		if mapped_ingredients.len == all_allergies.len { break}
	}
	mut count := 0
	for f in foods{
		for ingr in f.ingredients{
			if ingr !in mapped_ingredients{
				count++
			}
		}
	}
	println('answer:$count')
}
