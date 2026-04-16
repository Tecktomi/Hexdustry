function get_arround(a, b, dir, size){
	var i = 0
	if size = 2.5
		var output = array_create(10, [0, 0])
	else
		output = array_create(control.size_borde[max(0, size - 1)], [0, 0])
	if size = 1{
		for(var c = 0; c < 6; c++)
			output[++i] = next_to(a, b, c)
	}
	else if size = 2{
		dir = 6 - (dir mod 2)
		for(var c = 0; c < 6; c++){
			var temp_complex = next_to(a, b, (dir + c) mod 6)
			if c = 4{
				for(var d = 3; d < 6; d++)
					output[++i] = next_to(temp_complex[0], temp_complex[1], (dir + d) mod 6)
			}
			else if c = 5{
				for(var d = 5; d < 7 ; d++)
					output[++i] = next_to(temp_complex[0], temp_complex[1], (dir + d) mod 6)
			}
			else
				output[++i] = temp_complex
		}
	}
	else if size = 2.5{
		var temp_complex = next_to(a, b, (dir + 2) mod 6)
		output[++i] = temp_complex
		var temp_array = [4, 4, 5, 0, 0, 1, 1, 2, 3]
		for(var c = 0; c < array_length(temp_array); c++){
			temp_complex = next_to(temp_complex[0], temp_complex[1], (dir + temp_array[c]) mod 6)
			output[++i] = temp_complex
		}
	}
	else if size = 3{
		for(var c = 0; c < 6; c++){
			var temp_complex = next_to(a, b, (dir + c) mod 6)
			output[++i] = next_to(temp_complex[0], temp_complex[1], c)
			output[++i] = next_to(temp_complex[0], temp_complex[1], (c + 1) mod 6)
		}
	}
	else if size = 4{
		if dir = 0{
			var c = 0, temp_complex = [a, b + 6]
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
			var c = 0, temp_complex = [a, b + 6]
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
		for(var c = 0; c < 6; c++){
			var temp_complex = next_to(a, b, (dir + c) mod 6)
			var temp_complex_2 = next_to(temp_complex[0], temp_complex[1], c)
			output[++i] = next_to(temp_complex_2[0], temp_complex_2[1], (c + 5) mod 6)
			output[++i] = next_to(temp_complex_2[0], temp_complex_2[1], c)
			output[++i] = next_to(temp_complex_2[0], temp_complex_2[1], (c + 1) mod 6)
		}
	}
	return output
}