[inline]
fn main() {
	base := u64(19 )
	mut i := base * u64( 10_000_000_000_000) // start value
	for {
		// reorder biggest number first
			if (i + 9) % 41 == 0 && 
			(i + 50) % 853 == 0 && 
			(i + 19) % 523 == 0 && 
			(i + 36) % 17 == 0 && 
			(i + 37) % 13 == 0 && 
			(i + 48) % 29 == 0 && 
			(i + 56) % 37 == 0 && 
			(i + 73) % 23 == 0 {
			println('found match for i:$i')
			return
		} 
		i += base
	}
}