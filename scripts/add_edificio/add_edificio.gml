function add_edificio(index, dir, a, b){
	with control{
		var new_edificio = {
			index : floor(index),
			dir : floor(dir),
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
			link : null_edificio,
			red : red_null,
			energy_output : 0,
			energy_storage : 0,
			energy_link : ds_list_create(),
			flujo : flujo_null,
			flujo_link : ds_list_create(),
			vida : edificio_vida[index],
			target : null_enemigo
		}
		ds_list_add(new_edificio.energy_link, null_edificio)
		ds_list_clear(new_edificio.energy_link)
		ds_list_add(new_edificio.flujo_link, null_edificio)
		ds_list_clear(new_edificio.flujo_link)
		var var_edificio_nombre = edificio_nombre[index]
		var temp_terreno = null_terreno, temp_complex = {a : 0, b : 0}
		for(var c = 0; c < rss_max; c++)
			new_edificio.carga[c] = 0
		if edificio_input_all[index]{
			for(var c = 0; c < rss_max; c++)
				new_edificio.carga_max[c] = edificio_carga_max[index]
		}
		else{
			var d = 0
			for(var c = 0; c < rss_max; c++)
				if d < array_length(edificio_input_id[index]) and c = edificio_input_id[index, d]{
					new_edificio.carga_max[c] = edificio_input_num[index, d]
					d++
				}
				else
					new_edificio.carga_max[c] = 0
		}
		if edificio_output_all[index]{
			for(var c = 0; c < rss_max; c++)
				new_edificio.carga_output[c] = true
		}
		else{
			var d = 0
			for(var c = 0; c < rss_max; c++){
				if d < array_length(edificio_output_id[index]) and edificio_output_id[index, d] = c{
					new_edificio.carga_output[c] = true
					d++
				}
				else
					new_edificio.carga_output[c] = false
			}
		}
		//Añadir coordenadas
		temp_terreno = terreno[a, b]
		temp_terreno.edificio_draw = true
		ds_list_add(edificios, new_edificio)
		var temp_list = get_size(a, b, dir, edificio_size[index])
		for(var c = 0; c < ds_list_size(temp_list); c++){
			temp_complex = temp_list[|c]
			temp_terreno = terreno[temp_complex.a, temp_complex.b]
			temp_terreno.edificio_bool = true
			temp_terreno.edificio = new_edificio
			ds_list_add(new_edificio.coordenadas, temp_complex)
		}
		ds_list_destroy(temp_list)
		//Añadir inputs y outputs
		var temp_list_2 = get_arround(a, b, dir, edificio_size[index])
		for(var c = 0; c < ds_list_size(temp_list_2); c++){
			temp_complex = temp_list_2[|c]
			if temp_complex.a >= 0 and temp_complex.b >= 0 and temp_complex.a < xsize and temp_complex.b < ysize{
				temp_terreno = terreno[temp_complex.a, temp_complex.b]
				if temp_terreno.edificio_bool{
					var temp_edificio = temp_terreno.edificio
					//OUTPUTS del nuevo edificio
					var flag = false
					if edificio_input_all[temp_edificio.index] or edificio_output_all[index]
						flag = true
					else for(var d = 0; d < array_length(edificio_input_id[temp_edificio.index]); d++)
						for(var e = 0; e < array_length(edificio_output_id[index]); e++)
							if edificio_input_id[temp_edificio.index, d] = edificio_output_id[index, e]{
								flag = true
								break
							}
					if edificio_receptor[temp_edificio.index] and edificio_emisor[index] and (ds_list_find_index(new_edificio.outputs, temp_edificio) = -1) and flag{
						flag = true
						if in(var_edificio_nombre, "Cinta Transportadora", "Cinta Magnética") and not
							complex_equal(temp_complex, next_to(a, b, dir))
							flag = false
						if flag and in(edificio_nombre[temp_edificio.index], "Cinta Transportadora", "Cinta Magnética") and
							next_to_build(next_to(temp_edificio.a, temp_edificio.b, temp_edificio.dir), new_edificio)
							flag = false
						if flag and in(var_edificio_nombre, "Enrutador", "Selector", "Overflow") and not(
							complex_equal(temp_complex, next_to(a, b, (dir + 5) mod 6)) or
							complex_equal(temp_complex, next_to(a, b, dir)) or
							complex_equal(temp_complex, next_to(a, b, (dir + 1) mod 6)))
							flag = false
						if flag and in(edificio_nombre[temp_edificio.index], "Enrutador", "Selector", "Overflow", "Túnel")
							for(var d = 0; d < ds_list_size(new_edificio.coordenadas); d++)
								if complex_equal(next_to(temp_edificio.a, temp_edificio.b, (temp_edificio.dir + 5) mod 6), new_edificio.coordenadas[|d]) or
								complex_equal(next_to(temp_edificio.a, temp_edificio.b, temp_edificio.dir), new_edificio.coordenadas[|d]) or
								complex_equal(next_to(temp_edificio.a, temp_edificio.b, (temp_edificio.dir + 1) mod 6), new_edificio.coordenadas[|d]){
									flag = false
									break
								}
						if flag and in(var_edificio_nombre, "Túnel") and(
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
					else for(var d = 0; d < array_length(edificio_output_id[temp_edificio.index]); d++)
						for(var e = 0; e < array_length(edificio_input_id[index]); e++)
							if edificio_output_id[temp_edificio.index, d] = edificio_input_id[index, e]{
								flag = true
								break
							}
					if edificio_emisor[temp_edificio.index] and edificio_receptor[index] and (ds_list_find_index(new_edificio.inputs, temp_edificio) = -1) and flag{
						flag = true
						if in(var_edificio_nombre, "Cinta Transportadora", "Cinta Magnética") and
							complex_equal(temp_complex, next_to(a, b, dir))
							flag = false
						if flag and in(edificio_nombre[temp_edificio.index], "Cinta Transportadora", "Cinta Magnética") and not
							next_to_build(next_to(temp_edificio.a, temp_edificio.b, temp_edificio.dir), new_edificio)
							flag = false
						if flag and in(var_edificio_nombre, "Enrutador", "Selector", "Overflow", "Túnel") and(
							complex_equal(temp_complex, next_to(a, b, (dir + 5) mod 6)) or
							complex_equal(temp_complex, next_to(a, b, dir)) or
							complex_equal(temp_complex, next_to(a, b, (dir + 1) mod 6)))
							flag = false
						if flag and in(edificio_nombre[temp_edificio.index], "Enrutador", "Selector", "Overflow"){
							flag = false
							for(var d = 0; d < ds_list_size(new_edificio.coordenadas); d++)
								if (complex_equal(next_to(temp_edificio.a, temp_edificio.b, (temp_edificio.dir + 5) mod 6), new_edificio.coordenadas[|d]) or
									complex_equal(next_to(temp_edificio.a, temp_edificio.b, temp_edificio.dir), new_edificio.coordenadas[|d]) or
									complex_equal(next_to(temp_edificio.a, temp_edificio.b, (temp_edificio.dir + 1) mod 6), new_edificio.coordenadas[|d])){
									flag = true
									break
								}
						}
						if flag and in(edificio_nombre[temp_edificio.index], "Túnel")
							for(var d = 0; d < ds_list_size(new_edificio.coordenadas); d++)
								if complex_equal(next_to(temp_edificio.a, temp_edificio.b, (temp_edificio.dir + 5) mod 6), new_edificio.coordenadas[|d]) or
								complex_equal(next_to(temp_edificio.a, temp_edificio.b, temp_edificio.dir), new_edificio.coordenadas[|d]) or
								complex_equal(next_to(temp_edificio.a, temp_edificio.b, (temp_edificio.dir + 1) mod 6), new_edificio.coordenadas[|d]){
									flag = false
									break
								}
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
		ds_list_destroy(temp_list_2)
		//Añadir a la red electrica
		if edificio_electricidad[index]{
			if in(var_edificio_nombre, "Panel Solar", "Energía Infinita")
				new_edificio.energy_output = -edificio_elec_consumo[index]
			temp_complex = abtoxy(a, b)
			//Detectar otras redes cerca
			var temp_list_3 = get_size(a, b, dir, 7)
			var temp_list_redes = ds_list_create()
			for(var c = 0; c < ds_list_size(temp_list_3); c++){
				temp_complex = temp_list_3[|c]
				if (temp_complex.a != a or temp_complex.b != b) and temp_complex.a >= 0 and temp_complex.b >= 0 and temp_complex.a < xsize and temp_complex.b < ysize{
					temp_terreno = terreno[temp_complex.a, temp_complex.b]
					if temp_terreno.edificio_bool{
						var temp_edificio = temp_terreno.edificio
						if (var_edificio_nombre = "Cable" and edificio_electricidad[temp_edificio.index]) or (edificio_nombre[temp_edificio.index] = "Cable" and edificio_electricidad[index]){
							ds_list_add(new_edificio.energy_link, temp_edificio)
							ds_list_add(temp_edificio.energy_link, new_edificio)
							if not ds_list_in(temp_list_redes, temp_edificio.red)
								ds_list_add(temp_list_redes, temp_edificio.red)
						}
					}
				}
			}
			ds_list_destroy(temp_list_3)
			//Añadir red
			var temp_red = {
				edificios: ds_list_create(),
				generacion: 0,
				consumo: 0,
				bateria: 0,
				bateria_max : 0
			}
			ds_list_add(redes, temp_red)
			//Combinar otras redes si las hay cerca
			if not ds_list_empty(temp_list_redes){
				for(var c = 0; c < ds_list_size(temp_list_redes); c++){
					var temp_red_2 = temp_list_redes[|c]
					for(var d = 0; d < ds_list_size(temp_red_2.edificios); d++){
						var temp_edificio = temp_red_2.edificios[|d]
						temp_edificio.red = temp_red
						ds_list_add(temp_red.edificios, temp_edificio)
					}
					temp_red.consumo += temp_red_2.consumo
					temp_red.generacion += temp_red_2.generacion
					temp_red.bateria += temp_red_2.bateria
					temp_red.bateria_max += temp_red_2.bateria_max
					ds_list_destroy(temp_red_2.edificios)
					ds_list_remove(redes, temp_red_2)
					delete(temp_red_2)
				}
			}
			ds_list_destroy(temp_list_redes)
			//Modificar valores de la red resultante
			if edificio_elec_consumo[index] > 0
				temp_red.consumo += edificio_elec_consumo[index]
			else
				temp_red.generacion += new_edificio.energy_output
			if in(var_edificio_nombre, "Batería")
				temp_red.bateria_max += 2500
			new_edificio.red = temp_red
			ds_list_add(temp_red.edificios, new_edificio)
		}
		//Detectar cañerías cercanas
		if edificio_flujo[index]{
			var temp_list_4 = get_arround(a, b, dir, edificio_size[index])
			var temp_list_flujos = ds_list_create()
			for(var c = 0; c < ds_list_size(temp_list_4); c++){
				temp_complex = temp_list_4[|c]
				temp_terreno = terreno[temp_complex.a, temp_complex.b]
				if temp_terreno.edificio_bool{
					var temp_edificio = temp_terreno.edificio
					if edificio_flujo[temp_edificio.index] and var_edificio_nombre = "Tubería" or edificio_nombre[temp_edificio.index] = "Tubería"{
						ds_list_add(new_edificio.flujo_link, temp_edificio)
						ds_list_add(temp_edificio.flujo_link, new_edificio)
						if not ds_list_in(temp_list_flujos, temp_edificio.flujo)
							ds_list_add(temp_list_flujos, temp_edificio.flujo)
					}
				}
			}
			ds_list_destroy(temp_list_4)
			if ds_list_empty(temp_list_flujos){
				var new_flujo ={
					edificios : ds_list_create(),
					liquido : -1,
					cantidad : 0,
					generacion: 0,
					consumo: 0,
					cantidad_max : 0
				}
				ds_list_add(flujos, new_flujo)
				new_edificio.flujo = new_flujo
				ds_list_add(new_flujo.edificios, new_edificio)
			}
			else if var_edificio_nombre = "Tubería"{
				var new_flujo ={
					edificios : ds_list_create(),
					liquido : -1,
					cantidad : 0,
					generacion: 0,
					consumo: 0,
					cantidad_max : 0
				}
				for(var c = 0; c < ds_list_size(temp_list_flujos); c++){
					var temp_flujo = temp_list_flujos[|c]
					if new_flujo.liquido = -1 or temp_flujo.liquido = -1 or new_flujo.liquido = temp_flujo.liquido{
						for(var d = 0; d < ds_list_size(temp_flujo.edificios); d++){
							var temp_edificio = temp_flujo.edificios[|d]
							temp_edificio.flujo = new_flujo
							ds_list_add(new_flujo.edificios, temp_edificio)
						}
						if new_flujo.liquido = -1
							new_flujo.liquido = temp_flujo.liquido
						new_flujo.consumo += temp_flujo.consumo
						new_flujo.generacion += temp_flujo.generacion
						new_flujo.cantidad += temp_flujo.cantidad
						new_flujo.cantidad_max += temp_flujo.cantidad_max
						ds_list_destroy(temp_flujo.edificios)
						ds_list_remove(flujos, temp_flujo)
					}
				}
				ds_list_add(flujos, new_flujo)
				new_edificio.flujo = new_flujo
				ds_list_add(new_flujo.edificios, new_edificio)
			}
			else{
				var temp_flujo = temp_list_flujos[|0]
				new_edificio.flujo = temp_flujo
				ds_list_add(temp_flujo.edificios, new_edificio)
			}
			ds_list_destroy(temp_list_flujos)
			new_edificio.flujo.cantidad_max += edificio_flujo_almacen[index]
		}
		if var_edificio_nombre = "Láser"
			new_edificio.mode = true
		if not edificio_camino[index]{
			temp_complex = abtoxy(a, b)
			for(var c = 0; c < ds_list_size(enemigos); c++){
				var enemigo = enemigos[|c], temp_complex_2 = abtoxy(enemigo.target.a, enemigo.target.b)
				if sqr(enemigo.a - temp_complex.a) + sqr(enemigo.b - temp_complex.b) < sqr(enemigo.a - temp_complex_2.a) + sqr(enemigo.b - temp_complex_2.b)
					enemigo.target = new_edificio
			}
		}
		return new_edificio
	}
}