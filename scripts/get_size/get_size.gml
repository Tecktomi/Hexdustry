function get_size(a, b, dir, size){
	var output = ds_list_create()
	ds_list_add(output, {a : real(a), b : real(b)})
	if size = 2
		for(var c = 4; c < 6; c++)
			ds_list_add(output, next_to(a, b, (dir + c) mod 6))
	if size = 2.5
		for(var c = 4; c <= 6; c++)
			ds_list_add(output, next_to(a, b, (dir + c) mod 6))
	if size = 3
		for(var c = 0; c < 6; c++)
			ds_list_add(output, next_to(a, b, (dir + c) mod 6))
	if size = 4
		for(var c = 0; c < 6; c++){
			var temp_complex = next_to(a, b, (dir + c) mod 6)
			ds_list_add(output, temp_complex)
			if c = 4
				for(var d = 3; d < 6; d++)
					ds_list_add(output, next_to(temp_complex.a, temp_complex.b, (dir + d) mod 6))
			if c = 5
				for(var d = 5; d < 7 ; d++)
					ds_list_add(output, next_to(temp_complex.a, temp_complex.b, (dir + d) mod 6))
		}
	if size = 5
		for(var c = 0; c < 6; c++){
			var temp_complex = next_to(a, b, (dir + c) mod 6)
			ds_list_add(output, temp_complex)
			ds_list_add(output, next_to(temp_complex.a, temp_complex.b, (dir + c) mod 6))
			ds_list_add(output, next_to(temp_complex.a, temp_complex.b, (dir + c + 1) mod 6))
		}
	if size = 7
		for(var c = 0; c < 6; c++){
			var temp_complex = next_to(a, b, (dir + c) mod 6)
			ds_list_add(output, temp_complex)
			var temp_complex_2 = next_to(temp_complex.a, temp_complex.b, (dir + c) mod 6)
			ds_list_add(output, temp_complex_2)
			ds_list_add(output, next_to(temp_complex_2.a, temp_complex_2.b, (dir + c + 5) mod 6))
			ds_list_add(output, next_to(temp_complex_2.a, temp_complex_2.b, (dir + c) mod 6))
			ds_list_add(output, next_to(temp_complex_2.a, temp_complex_2.b, (dir + c + 1) mod 6))
			ds_list_add(output, next_to(temp_complex.a, temp_complex.b, (dir + c + 1) mod 6))
		}
	return output
}