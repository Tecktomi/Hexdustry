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
		link : control.null_edificio,
		red : control.red_null,
		energy_output : 0,
		energy_storage : 0,
		energy_link : ds_list_create(),
		flujo : ds_list_create(),
		flujo_link : ds_list_create()
	}
	ds_list_add(new_edificio.energy_link, control.null_edificio)
	ds_list_clear(new_edificio.energy_link)
	ds_list_add(new_edificio.flujo, control.flujo_null)
	ds_list_clear(new_edificio.flujo)
	ds_list_add(new_edificio.flujo_link, control.null_edificio)
	ds_list_clear(new_edificio.flujo_link)
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
				var flag = false
				if edificio_input_all[temp_edificio.index] or edificio_output_all[index]
					flag = true
				else for(var d = 0; d < array_length(edificio_input_index[temp_edificio.index]); d++)
					for(var e = 0; e < array_length(edificio_output_index[index]); e++)
						if edificio_input_index[temp_edificio.index, d] = edificio_output_index[index, e]{
							flag = true
							break
						}
				if control.edificio_receptor[temp_edificio.index] and control.edificio_emisor[index] and (ds_list_find_index(new_edificio.outputs, temp_edificio) = -1) and flag{
					flag = true
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
				flag = false
				if edificio_output_all[temp_edificio.index] or edificio_input_all[index]
					flag = true
				else for(var d = 0; d < array_length(edificio_output_index[temp_edificio.index]); d++)
					for(var e = 0; e < array_length(edificio_input_index[index]); e++)
						if edificio_output_index[temp_edificio.index, d] = edificio_input_index[index, e]{
							flag = true
							break
						}
				if control.edificio_emisor[temp_edificio.index] and control.edificio_receptor[index] and (ds_list_find_index(new_edificio.inputs, temp_edificio) = -1) and flag{
					flag = true
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
							mover(temp_edificio.a, temp_edificio.b)
					}
				}
			}
		}
	}
	//Añadir a la red electrica
	if control.edificio_electricidad[index]{
		if in(control.edificio_nombre[index], "Panel solar")
			new_edificio.energy_output = -control.edificio_elec_consumo[index]
		temp_complex = abtoxy(a, b)
		//Detectar otras redes cerca
		temp_list = get_size(a, b, dir, 7)
		var temp_list_redes = ds_list_create()
		for(var c = 0; c < ds_list_size(temp_list); c++){
			temp_complex = ds_list_find_value(temp_list, c)
			if temp_complex.a != a or temp_complex.b != b{
				temp_terreno = control.terreno[temp_complex.a, temp_complex.b]
				if temp_terreno.edificio_bool{
					var temp_edificio = temp_terreno.edificio
					if (control.edificio_nombre[index] = "Cable" and control.edificio_electricidad[temp_edificio.index]) or (control.edificio_nombre[temp_edificio.index] = "Cable" and control.edificio_electricidad[index]){
						ds_list_add(new_edificio.energy_link, temp_edificio)
						ds_list_add(temp_edificio.energy_link, new_edificio)
						if not ds_list_in(temp_list_redes, temp_edificio.red)
							ds_list_add(temp_list_redes, temp_edificio.red)
					}
				}
			}
		}
		//Añadir red
		var temp_red = {
			edificios: ds_list_create(),
			generacion: 0,
			consumo: 0,
			bateria: 0,
			bateria_max : 0
		}
		ds_list_add(control.redes, temp_red)
		//Combinar otras redes si las hay cerca
		if not ds_list_empty(temp_list_redes){
			for(var c = 0; c < ds_list_size(temp_list_redes); c++){
				var temp_red_2 = ds_list_find_value(temp_list_redes, c)
				for(var d = 0; d < ds_list_size(temp_red_2.edificios); d++){
					var temp_edificio = ds_list_find_value(temp_red_2.edificios, d)
					temp_edificio.red = temp_red
					ds_list_add(temp_red.edificios, temp_edificio)
				}
				temp_red.consumo += temp_red_2.consumo
				temp_red.generacion += temp_red_2.generacion
				temp_red.bateria += temp_red_2.bateria
				temp_red.bateria_max += temp_red_2.bateria_max
				ds_list_destroy(temp_red_2.edificios)
				ds_list_remove(control.redes, temp_red_2)
				delete(temp_red_2)
			}
		}
		ds_list_destroy(temp_list_redes)
		//Modificar valores de la red resultante
		if control.edificio_elec_consumo[index] > 0
			temp_red.consumo += control.edificio_elec_consumo[index]
		else
			temp_red.generacion += new_edificio.energy_output
		if in(control.edificio_nombre[index], "Bateria")
			temp_red.bateria_max += 1000
		new_edificio.red = temp_red
		ds_list_add(temp_red.edificios, new_edificio)
	}
	//Redes de cañerias
	if control.edificio_flujo[index]{
		temp_list = get_arround(a, b, dir, control.edificio_size[index])
		for(var c = 0; c < ds_list_size(temp_list); c++){
			temp_terreno = ds_list_find_value(temp_list, c)
			if temp_terreno.edificio_bool{
				var temp_edificio = temp_terreno.edificio
				if control.edificio_flujo[temp_edificio.index]{
					
				}
			}
		}
	}
	ds_list_destroy(temp_list)
	return new_edificio
}