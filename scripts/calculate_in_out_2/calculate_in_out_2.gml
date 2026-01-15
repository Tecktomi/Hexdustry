function calculate_in_out_2(edificio = control.null_edificio, set_receptor = true){
	var index = edificio.index, a = edificio.a, b = edificio.b, dir = edificio.dir
	with control{
		for(var i = array_length(edificio.inputs) - 1; i >= 0; i--){
			var temp_edificio = edificio.inputs[i]
			array_remove(temp_edificio.outputs, edificio)
		}
		edificio.inputs = []
		if set_receptor
			edificio.receptor = edificio_receptor[index]
		for(var i = array_length(edificio.outputs) - 1; i >= 0; i--){
			var temp_edificio = edificio.outputs[i]
			array_remove(temp_edificio.inputs, edificio)
			if temp_edificio.index = id_cinta_transportadora
				camino_calcular_in(temp_edificio)
		}
		edificio.outputs = []
		if set_receptor
			edificio.emisor = edificio_emisor[index]
		//Cruce de caminos
		if index = id_cruce{
			for(var c = 0; c < 3; c++){
				var temp_complex = next_to(a, b, c), aa = temp_complex.a, bb = temp_complex.b
				if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
					continue
				if edificio_bool[# aa, bb]{
					var temp_edificio = edificio_id[# aa, bb], flag = false
					while temp_edificio.index = id_cruce and aa >= 0 and bb >= 0 and aa < xsize and bb < ysize{
						temp_complex = next_to(aa, bb, c)
						aa = temp_complex.a
						bb = temp_complex.b
						if edificio_bool[# aa, bb]
							temp_edificio = edificio_id[# aa, bb]
						else{
							flag = true
							break
						}
					}
					if flag
						continue
					temp_complex = next_to(a, b, (c + 3) mod 6)
					aa = temp_complex.a
					bb = temp_complex.b
					if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
						continue
					if edificio_bool[# aa, bb]{
						var temp_edificio_2 = edificio_id[# aa, bb]
						flag = false
						while temp_edificio_2.index = id_cruce and aa >= 0 and bb >= 0 and aa < xsize and bb < ysize{
							temp_complex = next_to(aa, bb, (c + 3) mod 6)
							aa = temp_complex.a
							bb = temp_complex.b
							if edificio_bool[# aa, bb]
								temp_edificio_2 = edificio_id[# aa, bb]
							else{
								flag = true
								break
							}
						}
						if flag
							continue
						if temp_edificio.receptor and temp_edificio_2.emisor and temp_edificio.index != id_tunel_salida{
							flag = false
							if edificio_input_all[temp_edificio.index] or edificio_output_all[temp_edificio_2.index]
								flag = true
							else for(var i = 0; i < rss_max; i++)
								if temp_edificio.carga_input[i] > 0 and temp_edificio_2.carga_output[i]{
									flag = true
									break
								}
							if flag{
								if in(temp_edificio_2.index, id_cinta_transportadora, id_cinta_magnetica) and temp_edificio_2.dir != c
									flag = false
								if flag and in(temp_edificio_2.index, id_enrutador, id_selector, id_overflow, id_tunel_salida, id_tunel) and in(temp_edificio_2.dir, c + 2, c + 3, (c + 4) mod 6)
									flag = false
								if flag and in(temp_edificio.index, id_cinta_transportadora, id_cinta_magnetica) and temp_edificio.dir = c + 3
									flag = false
								if flag and in(temp_edificio.index, id_enrutador, id_selector, id_overflow, id_tunel_salida) and in(temp_edificio.dir, c + 2, c + 3, (c + 4) mod 6)
									flag = false
								if flag{
									array_push(temp_edificio.inputs, temp_edificio_2)
									array_push(temp_edificio_2.outputs, temp_edificio)
									if temp_edificio.index = id_cinta_transportadora
										camino_calcular_in(temp_edificio)
									if temp_edificio_2.waiting
										mover(temp_edificio_2)
								}
							}
						}
						if temp_edificio_2.receptor and temp_edificio.emisor and temp_edificio_2.index != id_tunel_salida{
							flag = false
							if edificio_input_all[temp_edificio_2.index] or edificio_output_all[temp_edificio.index]
								flag = true
							else for(var i = 0; i < rss_max; i++)
								if temp_edificio_2.carga_input[i] > 0 and temp_edificio.carga_output[i]{
									flag = true
									break
								}
							if flag{
								if in(temp_edificio.index, id_cinta_transportadora, id_cinta_magnetica) and temp_edificio.dir != c + 3
									flag = false
								if flag and in(temp_edificio.index, id_enrutador, id_selector, id_overflow, id_tunel_salida, id_tunel) and in(temp_edificio.dir, c, c + 1, (c + 5) mod 6)
									flag = false
								if flag and in(temp_edificio_2.index, id_cinta_transportadora, id_cinta_magnetica) and temp_edificio_2.dir = c
									flag = false
								if flag and in(temp_edificio_2.index, id_enrutador, id_selector, id_overflow, id_tunel_salida) and in(temp_edificio_2.dir, c, c + 1, (c + 5) mod 6)
									flag = false
								if flag{
									array_push(temp_edificio_2.inputs, temp_edificio)
									array_push(temp_edificio.outputs, temp_edificio_2)
									if temp_edificio_2.index = id_cinta_transportadora
										camino_calcular_in(temp_edificio_2)
									if temp_edificio.waiting
										mover(temp_edificio)
								}
							}
						}
					}
				}
			}
		}
		//Inputs e Outputs
		else{
			var temp_list = get_arround(a, b, dir, edificio_size[index])
			for(var c = ds_list_size(temp_list) - 1; c >= 0; c--){
				var temp_complex = temp_list[|c], aa = temp_complex.a, bb = temp_complex.b
				if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
					continue
				if not edificio_bool[# aa, bb]
					continue
				var temp_edificio = edificio_id[# aa, bb], temp_a = temp_edificio.a, temp_b = temp_edificio.b, temp_index = temp_edificio.index
				if temp_index = id_cruce{
					calculate_in_out_2(temp_edificio)
					continue
				}
				var temp_dir = temp_edificio.dir
				var par_dir = next_to(a, b, dir), par_dir_1 = next_to(a, b, (dir + 1) mod 6), par_dir_5 = next_to(a, b, (dir + 5) mod 6), par_dir_2 = next_to(a, b, (dir + 2) mod 6), par_dir_3 = next_to(a, b, (dir + 3) mod 6), par_dir_4 = next_to(a, b, (dir + 4) mod 6)
				var par_dir_a = next_to(temp_a, temp_b, temp_dir), par_dir_a_1 = next_to(temp_a, temp_b, (temp_dir + 1) mod 6), par_dir_a_5 = next_to(temp_a, temp_b, (temp_dir + 5) mod 6), par_dir_a_2 = next_to(temp_a, temp_b, (temp_dir + 2) mod 6), par_dir_a_3 = next_to(temp_a, temp_b, (temp_dir + 3) mod 6), par_dir_a_4 = next_to(temp_a, temp_b, (temp_dir + 4) mod 6)
				//OUTPUTS del nuevo edificio
				if temp_edificio.receptor and edificio.emisor{
					var flag = false
					if edificio_input_all[temp_index] or edificio_output_all[index]
						flag = true
					else for(var i = 0; i < rss_max; i++)
						if edificio.carga_output[i] and temp_edificio.carga_input[i]{
							flag = true
							break
						}
					if flag and index != id_tunel and not array_contains(edificio.outputs, temp_edificio){
						if in(index, id_cinta_transportadora, id_cinta_magnetica) and not complex_equal(temp_complex, par_dir)
							flag = false
						if flag and in(temp_index, id_cinta_transportadora, id_cinta_magnetica) and next_to_build(par_dir_a, edificio)
							flag = false
						if flag and in(index, id_enrutador, id_selector, id_overflow) and not(complex_equal(temp_complex, par_dir_5) or complex_equal(temp_complex, par_dir) or complex_equal(temp_complex, par_dir_1))
							flag = false
						if flag and in(index, id_tunel_salida) and not(complex_equal(temp_complex, par_dir_2) or complex_equal(temp_complex, par_dir_3) or complex_equal(temp_complex, par_dir_4))
							flag = false
						if flag and in(temp_index, id_enrutador, id_selector, id_overflow, id_tunel)
							for(var d = ds_list_size(edificio.coordenadas) - 1; d >= 0; d--){
								var temp_complex_2 = edificio.coordenadas[|d]
								if complex_equal(par_dir_a_5, temp_complex_2) or complex_equal(par_dir_a, temp_complex_2) or complex_equal(par_dir_a_1, temp_complex_2){
									flag = false
									break
								}
							}
						if flag{
							array_push(temp_edificio.inputs, edificio)
							array_push(edificio.outputs, temp_edificio)
						}
					}
				}
				//INPUTS del nuevo edificio
				if temp_edificio.emisor and edificio.receptor{
					var flag = false
					if edificio_output_all[temp_index] or edificio_input_all[index]
						flag = true
					else for(var i = 0; i < rss_max; i++)
						if edificio.carga_input[i] and temp_edificio.carga_output[i]{
							flag = true
							break
						}
					if flag and temp_index != id_tunel and not array_contains(edificio.inputs, temp_edificio){
						if in(index, id_cinta_transportadora, id_cinta_magnetica) and complex_equal(temp_complex, par_dir)
							flag = false
						if flag and in(temp_index, id_cinta_transportadora, id_cinta_magnetica) and not next_to_build(par_dir_a, edificio)
							flag = false
						if flag and in(index, id_enrutador, id_selector, id_overflow, id_tunel) and (complex_equal(temp_complex, par_dir_5) or complex_equal(temp_complex, par_dir) or complex_equal(temp_complex, par_dir_1))
							flag = false
						if flag and in(temp_index, id_enrutador, id_selector, id_overflow){
							flag = false
							for(var d = ds_list_size(edificio.coordenadas) - 1; d >= 0; d--){
								var temp_complex_2 = edificio.coordenadas[|d]
								if complex_equal(par_dir_a_5, temp_complex_2) or complex_equal(par_dir_a, temp_complex_2) or complex_equal(par_dir_a_1, temp_complex_2){
									flag = true
									break
								}
							}
						}
						if flag and temp_index = id_tunel_salida{
							flag = false
							for(var d = ds_list_size(edificio.coordenadas) - 1; d >= 0; d--){
								var temp_complex_2 = edificio.coordenadas[|d]
								if complex_equal(par_dir_a_2, temp_complex_2) or complex_equal(par_dir_a_3, temp_complex_2) or complex_equal(par_dir_a_4, temp_complex_2){
									flag = true
									break
								}
							}
						}
						if flag{
							array_push(temp_edificio.outputs, edificio)
							array_push(edificio.inputs, temp_edificio)
							if temp_edificio.waiting
								mover(temp_edificio)
						}
					}
				}
			}
			ds_list_destroy(temp_list)
			if index = id_cinta_transportadora
				camino_calcular_in(edificio)
			for(var c = array_length(edificio.outputs) - 1; c >= 0; c--){
				var temp_edificio = edificio.outputs[c]
				if temp_edificio.index = id_cinta_transportadora
					camino_calcular_in(temp_edificio)
			}
		}
	}
}