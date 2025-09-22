function calculate_in_out_2(edificio = null_edificio){
	var index = edificio.index, a = edificio.a, b = edificio.b, dir = edificio.dir, var_edificio_nombre = edificio_nombre[index]
	with control{
		//Añadir inputs y outputs
		var temp_list = get_arround(a, b, dir, edificio_size[index])
		for(var c = 0; c < ds_list_size(temp_list); c++){
			var temp_complex = temp_list[|c], aa = temp_complex.a, bb = temp_complex.b
			if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
				continue
			if edificio_bool[# aa, bb]{
				var temp_edificio = edificio_id[# aa, bb], temp_a = temp_edificio.a, temp_b = temp_edificio.b, temp_index = temp_edificio.index, temp_dir = temp_edificio.dir
				//OUTPUTS del nuevo edificio
				var flag = false
				if edificio_input_all[temp_index] or edificio_output_all[index]
					flag = true
				else for(var d = 0; d < array_length(edificio_input_id[temp_index]); d++)
					for(var e = 0; e < array_length(edificio_output_id[index]); e++)
						if edificio_input_id[temp_index, d] = edificio_output_id[index, e]{
							flag = true
							break
						}
				if flag and edificio_receptor[temp_index] and edificio_emisor[index] and ds_list_find_index(edificio.outputs, temp_edificio) = -1{
					flag = true
					if in(var_edificio_nombre, "Cinta Transportadora", "Cinta Magnética") and not complex_equal(temp_complex, next_to(a, b, dir))
						flag = false
					if flag and in(edificio_nombre[temp_index], "Cinta Transportadora", "Cinta Magnética") and
						next_to_build(next_to(temp_a, temp_b, temp_edificio.dir), edificio)
						flag = false
					if flag and in(var_edificio_nombre, "Enrutador", "Selector", "Overflow") and not(
						complex_equal(temp_complex, next_to(a, b, (dir + 5) mod 6)) or
						complex_equal(temp_complex, next_to(a, b, dir)) or
						complex_equal(temp_complex, next_to(a, b, (dir + 1) mod 6)))
						flag = false
					if flag and in(edificio_nombre[temp_index], "Enrutador", "Selector", "Overflow", "Túnel", "Túnel salida")
						for(var d = 0; d < ds_list_size(edificio.coordenadas); d++)
							if complex_equal(next_to(temp_a, temp_b, (temp_dir + 5) mod 6), edificio.coordenadas[|d]) or
							complex_equal(next_to(temp_a, temp_b, temp_edificio.dir), edificio.coordenadas[|d]) or
							complex_equal(next_to(temp_a, temp_b, (temp_edificio.dir + 1) mod 6), edificio.coordenadas[|d]){
								flag = false
								break
							}
					if flag and in(var_edificio_nombre, "Túnel", "Túnel salida") and(
						complex_equal(temp_complex, next_to(a, b, (dir + 5) mod 6)) or
						complex_equal(temp_complex, next_to(a, b, dir)) or
						complex_equal(temp_complex, next_to(a, b, (dir + 1) mod 6)))
						flag = false
					if flag{
						ds_list_add(temp_edificio.inputs, edificio)
						ds_list_add(edificio.outputs, temp_edificio)
					}
				}
				//INPUTS del nuevo edificio
				flag = false
				if edificio_output_all[temp_index] or edificio_input_all[index]
					flag = true
				else for(var d = 0; d < array_length(edificio_output_id[temp_index]); d++)
					for(var e = 0; e < array_length(edificio_input_id[index]); e++)
						if edificio_output_id[temp_index, d] = edificio_input_id[index, e]{
							flag = true
							break
						}
				if flag and edificio_emisor[temp_index] and edificio_receptor[index] and ds_list_find_index(edificio.inputs, temp_edificio) = -1{
					flag = true
					if in(var_edificio_nombre, "Cinta Transportadora", "Cinta Magnética") and
						complex_equal(temp_complex, next_to(a, b, dir))
						flag = false
					if flag and in(edificio_nombre[temp_index], "Cinta Transportadora", "Cinta Magnética") and not
						next_to_build(next_to(temp_a, temp_b, temp_edificio.dir), edificio)
						flag = false
					if flag and in(var_edificio_nombre, "Enrutador", "Selector", "Overflow", "Túnel", "Túnel salida") and(
						complex_equal(temp_complex, next_to(a, b, (dir + 5) mod 6)) or
						complex_equal(temp_complex, next_to(a, b, dir)) or
						complex_equal(temp_complex, next_to(a, b, (dir + 1) mod 6)))
						flag = false
					if flag and in(edificio_nombre[temp_index], "Enrutador", "Selector", "Overflow"){
						flag = false
						for(var d = 0; d < ds_list_size(edificio.coordenadas); d++)
							if (complex_equal(next_to(temp_a, temp_b, (temp_edificio.dir + 5) mod 6), edificio.coordenadas[|d]) or
								complex_equal(next_to(temp_a, temp_b, temp_edificio.dir), edificio.coordenadas[|d]) or
								complex_equal(next_to(temp_a, temp_b, (temp_edificio.dir + 1) mod 6), edificio.coordenadas[|d])){
								flag = true
								break
							}
					}
					if flag and in(edificio_nombre[temp_index], "Túnel", "Túnel salida")
						for(var d = 0; d < ds_list_size(edificio.coordenadas); d++)
							if complex_equal(next_to(temp_a, temp_b, (temp_edificio.dir + 5) mod 6), edificio.coordenadas[|d]) or
							complex_equal(next_to(temp_a, temp_b, temp_edificio.dir), edificio.coordenadas[|d]) or
							complex_equal(next_to(temp_a, temp_b, (temp_edificio.dir + 1) mod 6), edificio.coordenadas[|d]){
								flag = false
								break
							}
					if flag{
						ds_list_add(temp_edificio.outputs, edificio)
						ds_list_add(edificio.inputs, temp_edificio)
						if temp_edificio.waiting
							mover(temp_a, temp_b)
					}
				}
			}
		}
		ds_list_destroy(temp_list)
	}
}