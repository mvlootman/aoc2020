


x := [1,3,5]
mask := '_x_x_x_'
for i:=0; i < 1<<(x.len); i++{	
mut mask_copy := mask

				for z, x_pos in x {
					// println('\ni:$i z:$z x_pos:$x_pos')
					mask_copy = mask_copy[0..x_pos] + '0' + mask_copy[x_pos+1..]
					// println('i>>z[ $i>>$z => ${i>>z}] (i>>z)&1[${(i>>z)&1}]')
					
					if (i>>z)&1 == 1 {
						// println('q')
						mask_copy = mask_copy[0..x_pos] + '1' + mask_copy[x_pos+1..]
					}
				}
	println(mask_copy)
}