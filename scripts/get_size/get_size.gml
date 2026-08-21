function get_size(a = 0, b = 0, dir = 0, size = 0){
	with control{
		var i = 0, bmod = b & 1, c, temp_complex, d, temp_complex_2
		if size = 2.5
			var output = array_create(4, [0, 0])
		else
			output = array_create(SIZE_SIZE[max(0, size - 1)], [0, 0])
		output[0] = [real(a), real(b)]
		if size = 2{
			dir = 6 - (dir mod 2)
			for(c = 4; c < 6; c++){
				temp_complex = DESFACE[bmod, (c + dir) mod 6]
				output[++i] = [a + temp_complex[0], b + temp_complex[1]]
			}
		}
		if size = 2.5
			for(c = 4; c <= 6; c++){
				temp_complex = DESFACE[bmod, (c + dir) mod 6]
				output[++i] = [a + temp_complex[0], b + temp_complex[1]]
			}
		if size = 3
			for(c = 0; c < 6; c++){
				temp_complex = DESFACE[bmod, c]
				output[++i] = [a + temp_complex[0], b + temp_complex[1]]
			}
		if size = 4
			for(c = 0; c < 6; c++){
				temp_complex = next_to(a, b, (dir + c) mod 6)
				output[++i] = temp_complex
				if c = 4
					for(d = 3; d < 6; d++)
						output[++i] = next_to(temp_complex[0], temp_complex[1], (dir + d) mod 6)
				if c = 5
					for(d = 5; d < 7 ; d++)
						output[++i] = next_to(temp_complex[0], temp_complex[1], (dir + d) mod 6)
			}
		if size = 5
			for(c = 0; c < 6; c++){
				temp_complex = next_to(a, b, (dir + c) mod 6)
				output[++i] = temp_complex
				output[++i] = next_to(temp_complex[0], temp_complex[1], (dir + c) mod 6)
				output[++i] = next_to(temp_complex[0], temp_complex[1], (dir + c + 1) mod 6)
			}
		if size = 7
			for(c = 0; c < 6; c++){
				temp_complex = next_to(a, b, (dir + c) mod 6)
				output[++i] = temp_complex
				temp_complex_2 = next_to(temp_complex[0], temp_complex[1], (dir + c) mod 6)
				output[++i] = temp_complex_2
				output[++i] = next_to(temp_complex_2[0], temp_complex_2[1], (dir + c + 5) mod 6)
				output[++i] = next_to(temp_complex_2[0], temp_complex_2[1], (dir + c) mod 6)
				output[++i] = next_to(temp_complex_2[0], temp_complex_2[1], (dir + c + 1) mod 6)
				output[++i] = next_to(temp_complex[0], temp_complex[1], (dir + c + 1) mod 6)
			}
		return output
	}
}