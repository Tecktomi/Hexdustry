function get_arround(a, b, dir, size){
	with control{
		var i = 0, bmod = b & 1, c, d, temp_complex, temp_complex_2, temp_array
		if size = 2.5
			var output = array_create(10, [0, 0])
		else
			output = array_create(SIZE_BORDE[max(0, size - 1)], [0, 0])
		if size = 1{
			for(c = 0; c < 6; c++)
				output[++i] = [a + DESFACE_A[bmod, c], b + DESFACE_B[bmod, c]]
		}
		else if size = 2{
			dir = 6 - (dir mod 2)
			for(c = 0; c < 6; c++){
				temp_complex = next_to(a, b, (dir + c) mod 6)
				if c = 4{
					for(d = 3; d < 6; d++)
						output[++i] = next_to(temp_complex[0], temp_complex[1], (dir + d) mod 6)
				}
				else if c = 5{
					for(d = 5; d < 7 ; d++)
						output[++i] = next_to(temp_complex[0], temp_complex[1], (dir + d) mod 6)
				}
				else
					output[++i] = temp_complex
			}
		}
		else if size = 2.5{
			temp_complex = next_to(a, b, (dir + 2) mod 6)
			output[++i] = temp_complex
			temp_array = [4, 4, 5, 0, 0, 1, 1, 2, 3]
			for(c = 0; c < array_length(temp_array); c++){
				temp_complex = next_to(temp_complex[0], temp_complex[1], (dir + temp_array[c]) mod 6)
				output[++i] = temp_complex
			}
		}
		else if size = 3{
			for(c = 0; c < 6; c++){
				temp_complex = next_to(a, b, (dir + c) mod 6)
				output[++i] = next_to(temp_complex[0], temp_complex[1], c)
				output[++i] = next_to(temp_complex[0], temp_complex[1], (c + 1) mod 6)
			}
		}
		else if size = 4{
			if dir = 0{
				c = 0
				temp_complex = [a, b + 6]
				repeat(3){
					repeat(3){
						temp_complex = next_to(temp_complex[0], temp_complex[1], c)
						output[++i] = temp_complex
					}
					repeat(2){
						temp_complex = next_to(temp_complex[0], temp_complex[1], c + 1)
						output[++i] = temp_complex
					}
					c += 2
				}
			}
			else{
				c = 0
				temp_complex = [a, b + 6]
				repeat(3){
					repeat(2){
						temp_complex = next_to(temp_complex[0], temp_complex[1], c)
						output[++i] = temp_complex
					}
					repeat(3){
						temp_complex = next_to(temp_complex[0], temp_complex[1], c + 1)
						output[++i] = temp_complex
					}
					c += 2
				}
			}
		}
		else if size = 5{
			for(c = 0; c < 6; c++){
				temp_complex = next_to(a, b, (dir + c) mod 6)
				temp_complex_2 = next_to(temp_complex[0], temp_complex[1], c)
				output[++i] = next_to(temp_complex_2[0], temp_complex_2[1], (c + 5) mod 6)
				output[++i] = next_to(temp_complex_2[0], temp_complex_2[1], c)
				output[++i] = next_to(temp_complex_2[0], temp_complex_2[1], (c + 1) mod 6)
			}
		}
		return output
	}
}