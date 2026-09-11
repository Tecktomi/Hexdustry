function get_size(a = 0, b = 0, dir = 0, size = 0){
	with control{
		var bmod = b & 1, c, temp_complex, d, temp_complex_2, temp_complex_3, dir2
		var output = array_create(0, 0)
		array_push(output, real(a), real(b))
		if size = 2{
			dir = 6 - (dir mod 2)
			for(c = 4; c < 6; c++){
				dir2 = (c + dir) mod 6
				array_push(output, a + DESFACE_A[bmod, dir2], b + DESFACE_B[bmod, dir2])
			}
		}
		else if size = 2.5{
			for(c = 4; c <= 6; c++){
				dir2 = (c + dir) mod 6
				array_push(output, a + DESFACE_A[bmod, dir2], b + DESFACE_B[bmod, dir2])
			}
		}
		else if size = 3{
			for(c = 0; c < 6; c++)
				array_push(output, a + DESFACE_A[bmod, c], b + DESFACE_B[bmod, c])
		}
		else if size = 4{
			for(c = 0; c < 6; c++){
				temp_complex = next_to(a, b, (dir + c) mod 6)
				array_push(output, temp_complex[0], temp_complex[1])
				if c = 4
					for(d = 3; d < 6; d++){
						temp_complex_2 = next_to(temp_complex[0], temp_complex[1], (dir + d) mod 6)
						array_push(output, temp_complex_2[0], temp_complex_2[1])
					}
				if c = 5
					for(d = 5; d < 7 ; d++){
						temp_complex_2 = next_to(temp_complex[0], temp_complex[1], (dir + d) mod 6)
						array_push(output, temp_complex_2[0], temp_complex_2[1])
					}
			}
		}
		else if size = 5{
			for(c = 0; c < 6; c++){
				temp_complex = next_to(a, b, (dir + c) mod 6)
				array_push(output, temp_complex[0], temp_complex[1])
				temp_complex_2 = next_to(temp_complex[0], temp_complex[1], (dir + c) mod 6)
				array_push(output, temp_complex_2[0], temp_complex_2[1])
				temp_complex_2 = next_to(temp_complex[0], temp_complex[1], (dir + c + 1) mod 6)
				array_push(output, temp_complex_2[0], temp_complex_2[1])
			}
		}
		else if size = 7{
			for(c = 0; c < 6; c++){
				temp_complex = next_to(a, b, (dir + c) mod 6)
				array_push(output, temp_complex[0], temp_complex[1])
				temp_complex_2 = next_to(temp_complex[0], temp_complex[1], (dir + c) mod 6)
				array_push(output, temp_complex_2[0], temp_complex_2[1])
				temp_complex_3 = next_to(temp_complex_2[0], temp_complex_2[1], (dir + c + 5) mod 6)
				array_push(output, temp_complex_3[0], temp_complex_3[1])
				temp_complex_3 = next_to(temp_complex_2[0], temp_complex_2[1], (dir + c) mod 6)
				array_push(output, temp_complex_3[0], temp_complex_3[1])
				temp_complex_3 = next_to(temp_complex_2[0], temp_complex_2[1], (dir + c + 1) mod 6)
				array_push(output, temp_complex_3[0], temp_complex_3[1])
				temp_complex_2 = next_to(temp_complex[0], temp_complex[1], (dir + c + 1) mod 6)
				array_push(output, temp_complex_2[0], temp_complex_2[1])
			}
		}
		return output
	}
}