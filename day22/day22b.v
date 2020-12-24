import os

// Decks holds the cards for a player
struct Deck {
mut:
	cards []int
}

fn (mut d Deck) next() int {
	res := d.cards.first()
	d.cards.delete(0)
	return res
}

fn (mut d Deck) add_winning(card1 int, card2 int) {
	d.cards << [card1, card2]
}

fn (d Deck) is_empty() bool {
	return d.cards.len == 0
}

fn main() {
	println(os.args[1])
	raw := os.read_file(os.args[1]) ?
	players_input := raw.split('\n\n')
	player1_numbers := players_input[0].split('\n')[1..].map(it.int())
	player2_numbers := players_input[1].split('\n')[1..].map(it.int())
	mut p1 := Deck{
		cards: player1_numbers
	}
	mut p2 := Deck{
		cards: player2_numbers
	}
	_, winners_deck := play(mut p1, mut p2)
	println('final deck:$winners_deck')
	score := calc_score(winners_deck)
	println('score :$score')
}

fn play(mut p1_deck Deck, mut p2_deck Deck) (bool, &Deck) {
	mut seen := map[string]bool{}
	mut player_one_won := false
	for {
		if p1_deck.is_empty() {
			return false, p2_deck
		}
		if p2_deck.is_empty() {
			return true, p1_deck
		}
		key := p1_deck.cards.map(it.str()).join('-') + p2_deck.cards.map(it.str()).join('-')
		if key in seen {
			return true, p1_deck
		}
		seen[key] = true
		p1_card := p1_deck.next()
		p2_card := p2_deck.next()
		// if both players drew cards with numbers which are less or equal to
		// their deck size we play sub game
		if p1_card <= p1_deck.cards.len && p2_card <= p2_deck.cards.len {
			// create copy of n-cards from deck
			mut p1_copy_deck := Deck{
				cards: p1_deck.cards[0..p1_card].clone()
			}
			mut p2_copy_deck := Deck{
				cards: p2_deck.cards[0..p2_card].clone()
			}
			play(mut p1_copy_deck, mut p2_copy_deck)
			player_one_won, _ = play(mut p1_copy_deck, mut p2_copy_deck)
		} else {
			player_one_won = p1_card > p2_card
		}
		if player_one_won {
			p1_deck.add_winning(p1_card, p2_card)
		} else {
			p2_deck.add_winning(p2_card, p1_card)
		}
	}
	if player_one_won {
		return true, p1_deck
	} else {
		return false, p2_deck
	}
}

fn calc_score(player Deck) int {
	// println('calc_score:$player')
	mut res := 0
	for i, c in player.cards {
		res += (player.cards.len - i) * c
	}
	return res
}
