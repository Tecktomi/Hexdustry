function get_arround(a, b, dir, size){
	var output = ds_list_create()
	if size = 1
		for(var c = 0; c < 6; c++)
			ds_list_add(output, next_to(a, b, (dir + c) mod 6))
	else if size = 2
		for(var c = 0; c < 6; c++){
			var temp_complex = next_to(a, b, (dir + c) mod 6)
			if c = 4{
				for(var d = 3; d < 6; d++)
					ds_list_add(output, next_to(temp_complex.a, temp_complex.b, (dir + d) mod 6))
			}
			else if c = 5{
				for(var d = 5; d < 7 ; d++)
					ds_list_add(output, next_to(temp_complex.a, temp_complex.b, (dir + d) mod 6))
			}
			else
				ds_list_add(output, temp_complex)
		}
	else if size = 2.5{
		var temp_complex = next_to(a, b, (dir + 2) mod 6)
		ds_list_add(output, temp_complex)
		var temp_array = [4, 4, 5, 0, 0, 1, 1, 2, 3]
		for(var c = 0; c < array_length(temp_array); c++){
			temp_complex = next_to(temp_complex.a, temp_complex.b, (dir + temp_array[c]) mod 6)
			ds_list_add(output, temp_complex)
		}
	}
	else if size = 3
		for(var c = 0; c < 6; c++){
			var temp_complex = next_to(a, b, (dir + c) mod 6)
			ds_list_add(output, next_to(temp_complex.a, temp_complex.b, (dir + c) mod 6))
			ds_list_add(output, next_to(temp_complex.a, temp_complex.b, (dir + c + 1) mod 6))
		}
	else if size = 4{
		if dir = 0{
			var c = 0, temp_complex = {a : a, b : b + 6}
			repeat(3){
				repeat(3){
					temp_complex = next_to(temp_complex.a, temp_complex.b, c)
					ds_list_add(output, temp_complex)
				}
				repeat(2){
					temp_complex = next_to(temp_complex.a, temp_complex.b, c + 1)
					ds_list_add(output, temp_complex)
				}
				c += 2
			}
		}
		else{
			var c = 0, temp_complex = {a : a, b : b + 6}
			repeat(3){
				repeat(2){
					temp_complex = next_to(temp_complex.a, temp_complex.b, c)
					ds_list_add(output, temp_complex)
				}
				repeat(3){
					temp_complex = next_to(temp_complex.a, temp_complex.b, c + 1)
					ds_list_add(output, temp_complex)
				}
				c += 2
			}
		}
	}
	else if size = 5
		for(var c = 0; c < 6; c++){
			var temp_complex = next_to(a, b, (dir + c) mod 6)
			var temp_complex_2 = next_to(temp_complex.a, temp_complex.b, (dir + c) mod 6)
			ds_list_add(output, next_to(temp_complex_2.a, temp_complex_2.b, (dir + c + 5) mod 6))
			ds_list_add(output, next_to(temp_complex_2.a, temp_complex_2.b, (dir + c) mod 6))
			ds_list_add(output, next_to(temp_complex_2.a, temp_complex_2.b, (dir + c + 1) mod 6))
		}
	return output
}