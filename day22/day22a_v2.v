import os

// Decks holds the cards for a player
struct Deck {
mut:
	cards []int
	won bool
}

fn (mut d Deck) next() int {
	res := d.cards.first()
	d.cards.delete(0)
	return res
}

fn (mut d Deck) add_winning(card1 int, card2 int) {
	if card1 > card2 {
		d.cards << [card1, card2]
	} else {
		d.cards << [card2, card1]
	}
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
	play(p1,p2,1)
	// play
	// mut player1_won := false
	// mut seen := map[string]bool{}
	// for {
	// 	play(p1,p2)
	// 	key := '$p1_card-$p2_card'
	// 	if key in seen {
	// 		println('found same position. Player 1 wins.')
	// 		player1_won = true
	// 		break
	// 	}
	// 	seen[key] = true
	// }
	if p1.won {
		println('score:${calc_score(p1)}')
	} else if p2.won {
		println('score:${calc_score(p2)}')
	}
}

fn play(mut p1_deck Deck, mut p2_deck Deck, game_num int) {
	println('\nPLAY:$game_num \np1:$p1_deck\np2:$p2_deck')
	if p1_deck.is_empty() {
		p2_deck.won=true
		println('player 1 deck is empty, player 2 wins')
		return
	}
	if p2_deck.is_empty() {
		p1_deck.won=true
		println('player 2 deck is empty, player 1 wins')
		return
	}
	p1_card := p1_deck.next()
	p2_card := p2_deck.next()
	if p1_card > p2_card {
		p1_deck.add_winning(p1_card, p2_card)
	} else {
		p2_deck.add_winning(p2_card, p1_card)
	}
	play(mut p1_deck, mut p2_deck, game_num+1)

}

fn calc_score(player Deck) int {
	mut res := 0
	for i, c in player.cards {
		res += (player.cards.len - i) * c
	}
	return res
}
