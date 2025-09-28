function calculate_in_out_2(edificio = null_edificio){
	var index = edificio.index, a = edificio.a, b = edificio.b, dir = edificio.dir, var_edificio_nombre = edificio_nombre[index]
	with control{
		while not ds_list_empty(edificio.inputs){
			var temp_edificio = edificio.inputs[|0]
			ds_list_remove(temp_edificio.outputs, edificio)
			ds_list_delete(edificio.inputs, 0)
		}
		while not ds_list_empty(edificio.outputs){
			var temp_edificio = edificio.outputs[|0]
			ds_list_remove(temp_edificio.inputs, edificio)
			ds_list_delete(edificio.outputs, 0)
		}
		//Añadir inputs y outputs
		var temp_list = get_arround(a, b, dir, edificio_size[index])
		for(var c = 0; c < ds_list_size(temp_list); c++){
			var temp_complex = temp_list[|c], aa = temp_complex.a, bb = temp_complex.b
			if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
				continue
			if edificio_bool[# aa, bb]{
				var temp_edificio = edificio_id[# aa, bb], temp_a = temp_edificio.a, temp_b = temp_edificio.b, temp_index = temp_edificio.index, temp_dir = temp_edificio.dir, temp_var_edificio_nombre = edificio_nombre[temp_index]
				var par_dir = next_to(a, b, dir), par_dir_1 = next_to(a, b, (dir + 1) mod 6), par_dir_5 = next_to(a, b, (dir + 5) mod 6), par_dir_2 = next_to(a, b, (dir + 2) mod 6), par_dir_3 = next_to(a, b, (dir + 3) mod 6), par_dir_4 = next_to(a, b, (dir + 4) mod 6)
				var par_dir_a = next_to(temp_a, temp_b, temp_dir), par_dir_a_1 = next_to(temp_a, temp_b, (temp_dir + 1) mod 6), par_dir_a_5 = next_to(temp_a, temp_b, (temp_dir + 5) mod 6), par_dir_a_2 = next_to(temp_a, temp_b, (temp_dir + 2) mod 6), par_dir_a_3 = next_to(temp_a, temp_b, (temp_dir + 3) mod 6), par_dir_a_4 = next_to(temp_a, temp_b, (temp_dir + 4) mod 6)
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
				if var_edificio_nombre = "Túnel"
					flag = false
				if flag and temp_edificio.receptor and edificio.emisor and ds_list_find_index(edificio.outputs, temp_edificio) = -1{
					flag = true
					if flag and in(var_edificio_nombre, "Cinta Transportadora", "Cinta Magnética") and not complex_equal(temp_complex, par_dir)
						flag = false
					if flag and in(temp_var_edificio_nombre, "Cinta Transportadora", "Cinta Magnética") and next_to_build(par_dir_a, edificio)
						flag = false
					if flag and in(var_edificio_nombre, "Enrutador", "Selector", "Overflow") and not(complex_equal(temp_complex, par_dir_5) or complex_equal(temp_complex, par_dir) or complex_equal(temp_complex, par_dir_1))
						flag = false
					if flag and in(var_edificio_nombre, "Túnel salida") and not(complex_equal(temp_complex, par_dir_2) or complex_equal(temp_complex, par_dir_2) or complex_equal(temp_complex, par_dir_4))
						flag = false
					if flag and in(temp_var_edificio_nombre, "Enrutador", "Selector", "Overflow", "Túnel")
						for(var d = 0; d < ds_list_size(edificio.coordenadas); d++){
							var temp_complex_2 = edificio.coordenadas[|d]
							if complex_equal(par_dir_a_5, temp_complex_2) or complex_equal(par_dir_a, temp_complex_2) or complex_equal(par_dir_a_1, temp_complex_2){
								flag = false
								break
							}
						}
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
				if flag and temp_edificio.emisor and edificio.receptor and ds_list_find_index(edificio.inputs, temp_edificio) = -1{
					flag = true
					if temp_var_edificio_nombre = "Túnel"
						flag = false
					if flag and in(var_edificio_nombre, "Cinta Transportadora", "Cinta Magnética") and complex_equal(temp_complex, par_dir)
						flag = false
					if flag and in(temp_var_edificio_nombre, "Cinta Transportadora", "Cinta Magnética") and not next_to_build(par_dir_a, edificio)
						flag = false
					if flag and in(var_edificio_nombre, "Enrutador", "Selector", "Overflow", "Túnel") and (complex_equal(temp_complex, par_dir_5) or complex_equal(temp_complex, par_dir) or complex_equal(temp_complex, par_dir_1))
						flag = false
					if flag and in(temp_var_edificio_nombre, "Enrutador", "Selector", "Overflow"){
						flag = false
						for(var d = 0; d < ds_list_size(edificio.coordenadas); d++){
							var temp_complex_2 = edificio.coordenadas[|d]
							if complex_equal(par_dir_a_5, temp_complex_2) or complex_equal(par_dir_a, temp_complex_2) or complex_equal(par_dir_a_1, temp_complex_2){
								flag = true
								break
							}
						}
					}
					if flag and in(temp_var_edificio_nombre, "Túnel salida"){
						flag = false
						for(var d = 0; d < ds_list_size(edificio.coordenadas); d++){
							var temp_complex_2 = edificio.coordenadas[|d]
							if complex_equal(par_dir_a_2, temp_complex_2) or complex_equal(par_dir_a_3, temp_complex_2) or complex_equal(par_dir_a_4, temp_complex_2){
								flag = true
								break
							}
						}
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