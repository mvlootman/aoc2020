fn main() {
	pub_key_a := u64(10441485)
	pub_key_b := u64(1004920)
	size := loop_size(7, pub_key_a)
	println(calc(pub_key_b, size))
}

fn loop_size(subj u64, value u64) u64 {
	mut lv := u64(1)
	mut i := u64(0)
	for lv != value {
		i++
		lv = (lv *subj)% 20201227
	}
	return i
}

fn calc(subject u64, loop_size u64) u64 {
	mut v := u64(1)
	for _ in 0 .. loop_size {
		v = (v * subject) % 20201227
	}
	return v
}
