function add_edificio(index, dir, a, b){
	var new_edificio = {
		index : floor(index),
		dir : dir,
		a : floor(a),
		b : floor(b),
		coordenadas : ds_list_create(),
		inputs : ds_list_create(),
		outputs : ds_list_create(),
		output_index : 0,
		proceso : 0,
		carga : [0],
		carga_max : [0],
		carga_output : [true],
		carga_id : 0,
		carga_total : 0,
		fuel : 0,
		select : -1,
		mode : false,
		waiting : false,
		idle : false,
		link : control.null_edificio
	}
	var temp_terreno, temp_complex, temp_list
	//Carga máxima y output general
	for(var c = 0; c < control.rss_max; c++){
		new_edificio.carga[c] = 0
		if control.edificio_input_all[index]
			new_edificio.carga_max[c] = control.edificio_carga_max[index]
		if control.edificio_output_all[index]
			new_edificio.carga_output[c] = true
	}
	//Inputs y carga máxima particular
	if not control.edificio_input_all[index]{
		var d = 0
		for(var c = 0; c < control.rss_max; c++)
			if d < array_length(control.edificio_input_index[index]) and c = control.edificio_input_index[index, d]{
				new_edificio.carga_max[c] = control.edificio_input_num[index, d]
				d++
			}
			else
				new_edificio.carga_max[c] = 0
	}
	//output particular
	if not control.edificio_output_all[index]{
		var d = 0
		for(var c = 0; c < control.rss_max; c++){
			if d < array_length(control.edificio_output_index[index]) and control.edificio_output_index[index, d] = c{
				new_edificio.carga_output[c] = true
				d++
			}
			else
				new_edificio.carga_output[c] = false
		}
	}
	//Añadir coordenadas
	temp_terreno = control.terreno[a, b]
	temp_terreno.edificio_draw = true
	ds_list_add(control.edificios, new_edificio)
	temp_list = get_size(a, b, dir, control.edificio_size[index])
	for(var c = 0; c < ds_list_size(temp_list); c++){
		temp_complex = ds_list_find_value(temp_list, c)
		temp_terreno = control.terreno[temp_complex.a, temp_complex.b]
		temp_terreno.edificio_bool = true
		temp_terreno.edificio = new_edificio
		ds_list_add(new_edificio.coordenadas, temp_complex)
	}
	ds_list_destroy(temp_list)
	//Añadir inputs y outputs
	temp_list = get_arround(a, b, dir, control.edificio_size[index])
	for(var c = 0; c < ds_list_size(temp_list); c++){
		temp_complex = ds_list_find_value(temp_list, c)
		if temp_complex.a >= 0 and temp_complex.b >= 0 and temp_complex.a < control.xsize and temp_complex.b < control.ysize{
			temp_terreno = control.terreno[temp_complex.a, temp_complex.b]
			if temp_terreno.edificio_bool{
				var temp_edificio = temp_terreno.edificio
				//OUTPUTS del nuevo edificio
				if control.edificio_receptor[temp_edificio.index] and control.edificio_emisor[index] and (ds_list_find_index(new_edificio.outputs, temp_edificio) = -1){
					var flag = true
					if in(control.edificio_nombre[index], "Cinta transportadora") and not
						complex_equal(temp_complex, next_to(a, b, dir))
						flag = false
					if flag and in(control.edificio_nombre[temp_edificio.index], "Cinta transportadora") and
						next_to_build(next_to(temp_edificio.a, temp_edificio.b, temp_edificio.dir), new_edificio)
						flag = false
					if flag and in(control.edificio_nombre[index], "Enrutador", "Selector", "Overflow") and not(
						complex_equal(temp_complex, next_to(a, b, (dir + 5) mod 6)) or
						complex_equal(temp_complex, next_to(a, b, dir)) or
						complex_equal(temp_complex, next_to(a, b, (dir + 1) mod 6)))
						flag = false
					if flag and in(control.edificio_nombre[temp_edificio.index], "Enrutador", "Selector", "Overflow", "Tunel") and(
						complex_equal(next_to(temp_edificio.a, temp_edificio.b, (temp_edificio.dir + 5) mod 6), {a : a, b : b}) or
						complex_equal(next_to(temp_edificio.a, temp_edificio.b, temp_edificio.dir), {a : a, b : b}) or
						complex_equal(next_to(temp_edificio.a, temp_edificio.b, (temp_edificio.dir + 1) mod 6), {a : a, b : b}))
						flag = false
					if flag and in(control.edificio_nombre[index], "Tunel") and(
						complex_equal(temp_complex, next_to(a, b, (dir + 5) mod 6)) or
						complex_equal(temp_complex, next_to(a, b, dir)) or
						complex_equal(temp_complex, next_to(a, b, (dir + 1) mod 6)))
						flag = false
					if flag{
						ds_list_add(temp_edificio.inputs, new_edificio)
						ds_list_add(new_edificio.outputs, temp_edificio)
					}
				}
				//INPUTS del nuevo edificio
				if control.edificio_emisor[temp_edificio.index] and control.edificio_receptor[index] and (ds_list_find_index(new_edificio.inputs, temp_edificio) = -1){
					var flag = true
					if in(control.edificio_nombre[index], "Cinta transportadora") and
						complex_equal(temp_complex, next_to(a, b, dir))
						flag = false
					if flag and in(control.edificio_nombre[temp_edificio.index], "Cinta transportadora") and not
						next_to_build(next_to(temp_edificio.a, temp_edificio.b, temp_edificio.dir), new_edificio)
						flag = false
					if flag and in(control.edificio_nombre[index], "Enrutador", "Selector", "Overflow", "Tunel") and(
						complex_equal(temp_complex, next_to(a, b, (dir + 5) mod 6)) or
						complex_equal(temp_complex, next_to(a, b, dir)) or
						complex_equal(temp_complex, next_to(a, b, (dir + 1) mod 6)))
						flag = false
					if flag and in(control.edificio_nombre[temp_edificio.index], "Enrutador", "Selector", "Overflow") and not(
						complex_equal(next_to(temp_edificio.a, temp_edificio.b, (temp_edificio.dir + 5) mod 6), {a : a, b : b}) or
						complex_equal(next_to(temp_edificio.a, temp_edificio.b, temp_edificio.dir), {a : a, b : b}) or
						complex_equal(next_to(temp_edificio.a, temp_edificio.b, (temp_edificio.dir + 1) mod 6), {a : a, b : b}))
						flag = false
					if flag and in(control.edificio_nombre[temp_edificio.index], "Tunel") and(
						complex_equal(next_to(temp_edificio.a, temp_edificio.b, (temp_edificio.dir + 5) mod 6), {a : a, b : b}) or
						complex_equal(next_to(temp_edificio.a, temp_edificio.b, temp_edificio.dir), {a : a, b : b}) or
						complex_equal(next_to(temp_edificio.a, temp_edificio.b, (temp_edificio.dir + 1) mod 6), {a : a, b : b}))
						flag = false
					if flag{
						ds_list_add(temp_edificio.outputs, new_edificio)
						ds_list_add(new_edificio.inputs, temp_edificio)
						if temp_edificio.waiting
							mover(temp_edificio)
					}
				}
			}
		}
	}
	ds_list_destroy(temp_list)
	return new_edificio
}