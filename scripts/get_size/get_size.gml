function get_size(a, b, dir, size){
	var i = 0
	if size = 2.5
		var output = array_create(4, [0, 0])
	else
		output = array_create(control.size_size[max(0, size - 1)], [0, 0])
	output[0] = [real(a), real(b)]
	if size = 2{
		dir = 6 - (dir mod 2)
		for(var c = 4; c < 6; c++)
			output[++i] = next_to(a, b, (dir + c) mod 6)
	}
	if size = 2.5
		for(var c = 4; c <= 6; c++)
			output[++i] = next_to(a, b, (dir + c) mod 6)
	if size = 3
		for(var c = 0; c < 6; c++)
			output[++i] = next_to(a, b, (dir + c) mod 6)
	if size = 4
		for(var c = 0; c < 6; c++){
			var temp_complex = next_to(a, b, (dir + c) mod 6)
			output[++i] = temp_complex
			if c = 4
				for(var d = 3; d < 6; d++)
					output[++i] = next_to(temp_complex[0], temp_complex[1], (dir + d) mod 6)
			if c = 5
				for(var d = 5; d < 7 ; d++)
					output[++i] = next_to(temp_complex[0], temp_complex[1], (dir + d) mod 6)
		}
	if size = 5
		for(var c = 0; c < 6; c++){
			var temp_complex = next_to(a, b, (dir + c) mod 6)
			output[++i] = temp_complex
			output[++i] = next_to(temp_complex[0], temp_complex[1], (dir + c) mod 6)
			output[++i] = next_to(temp_complex[0], temp_complex[1], (dir + c + 1) mod 6)
		}
	if size = 7
		for(var c = 0; c < 6; c++){
			var temp_complex = next_to(a, b, (dir + c) mod 6)
			output[++i] = temp_complex
			var temp_complex_2 = next_to(temp_complex[0], temp_complex[1], (dir + c) mod 6)
			output[++i] = temp_complex_2
			output[++i] = next_to(temp_complex_2[0], temp_complex_2[1], (dir + c + 5) mod 6)
			output[++i] = next_to(temp_complex_2[0], temp_complex_2[1], (dir + c) mod 6)
			output[++i] = next_to(temp_complex_2[0], temp_complex_2[1], (dir + c + 1) mod 6)
			output[++i] = next_to(temp_complex[0], temp_complex[1], (dir + c + 1) mod 6)
		}
	return output
}