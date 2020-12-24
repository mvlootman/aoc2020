import os

struct Hand {
mut:
	cards []int
}

fn (mut h Hand) next() int {
	res := h.cards.first()
	h.cards.delete(0)
	return res
}

fn (mut h Hand) add_winning(card1 int, card2 int) {
	if card1 > card2 {
		h.cards << [card1, card2]
	} else {
		h.cards << [card2, card1]
	}
}

fn (h Hand) is_empty() bool {
	return h.cards.len == 0
}

fn main() {
	println(os.args[1])
	raw := os.read_file(os.args[1]) ?
	players_input := raw.split('\n\n')
	player1_numbers := players_input[0].split('\n')[1..].map(it.int())
	player2_numbers := players_input[1].split('\n')[1..].map(it.int())
	mut p1 := Hand{
		cards: player1_numbers
	}
	mut p2 := Hand{
		cards: player2_numbers
	}
	// play
	mut player1_won := false
	for {

		if p1.is_empty() {
			break
		}
		if p2.is_empty() {
			player1_won = true
			break
		}
		p1_card := p1.next()
		p2_card := p2.next()
		if p1_card > p2_card {
			p1.add_winning(p1_card, p2_card)
		} else {
			p2.add_winning(p2_card, p1_card)
		}
	}

	if player1_won {
		println('player 1 won')
		println('score:${calc_score(p1)}')
	} else {
		println('player 2 won')
		println('score:${calc_score(p2)}')
	}
}

fn calc_score(player Hand) int {
	mut res := 0
	for i, c in player.cards {
		res += (player.cards.len - i) * c
	}
	return res
}
