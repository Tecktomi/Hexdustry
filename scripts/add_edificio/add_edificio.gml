function add_edificio(index, dir, a, b){
	with control{
		var temp_complex = abtoxy(a, b)
		x = temp_complex.a
		y = temp_complex.b
		var edificio = {
			index : floor(index),
			dir : floor(dir),
			a : floor(a),
			b : floor(b),
			x : x,
			y : y,
			coordenadas : ds_list_create(),
			bordes : ds_list_create(),
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
			red : null_red,
			energy_output : 0,
			energy_storage : 0,
			energia_link : ds_list_create(),
			flujo : null_flujo,
			flujo_link : ds_list_create(),
			vida : edificio_vida[index],
			target : null_enemigo,
			flujo_consumo : 0,
			energia_consumo : 0,
			edificio_index : edificio_max++
		}
		ds_list_add(edificio.energia_link, null_edificio)
		ds_list_clear(edificio.energia_link)
		ds_list_add(edificio.flujo_link, null_edificio)
		ds_list_clear(edificio.flujo_link)
		var var_edificio_nombre = edificio_nombre[index]
		var temp_terreno = null_terreno
		temp_complex = {a : 0, b : 0}
		for(var c = 0; c < rss_max; c++)
			edificio.carga[c] = 0
		if edificio_input_all[index]{
			for(var c = 0; c < rss_max; c++)
				edificio.carga_max[c] = edificio_carga_max[index]
		}
		else{
			var d = 0
			for(var c = 0; c < rss_max; c++)
				if d < array_length(edificio_input_id[index]) and c = edificio_input_id[index, d]{
					edificio.carga_max[c] = edificio_input_num[index, d]
					d++
				}
				else
					edificio.carga_max[c] = 0
		}
		if edificio_output_all[index]{
			for(var c = 0; c < rss_max; c++)
				edificio.carga_output[c] = true
		}
		else{
			var d = 0
			for(var c = 0; c < rss_max; c++){
				if d < array_length(edificio_output_id[index]) and edificio_output_id[index, d] = c{
					edificio.carga_output[c] = true
					d++
				}
				else
					edificio.carga_output[c] = false
			}
		}
		//Añadir coordenadas
		temp_terreno = terreno[a, b]
		temp_terreno.edificio_draw = true
		ds_list_add(edificios, edificio)
		if not edificio_camino[index] and not in(var_edificio_nombre, "Tubería")
			ds_list_add(edificios_targeteables, edificio)
		var temp_list = get_arround(a, b, dir, edificio_size[index])
		for(var c = 0; c < ds_list_size(temp_list); c++)
			ds_list_add(edificio.bordes, temp_list[|c])
		temp_list = get_size(a, b, dir, edificio_size[index])
		for(var c = 0; c < ds_list_size(temp_list); c++){
			temp_complex = temp_list[|c]
			temp_terreno = terreno[temp_complex.a, temp_complex.b]
			temp_terreno.edificio_bool = true
			temp_terreno.edificio = edificio
			ds_list_add(edificio.coordenadas, temp_complex)
		}
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
					if edificio_receptor[temp_edificio.index] and edificio_emisor[index] and (ds_list_find_index(edificio.outputs, temp_edificio) = -1) and flag{
						flag = true
						if in(var_edificio_nombre, "Cinta Transportadora", "Cinta Magnética") and not
							complex_equal(temp_complex, next_to(a, b, dir))
							flag = false
						if flag and in(edificio_nombre[temp_edificio.index], "Cinta Transportadora", "Cinta Magnética") and
							next_to_build(next_to(temp_edificio.a, temp_edificio.b, temp_edificio.dir), edificio)
							flag = false
						if flag and in(var_edificio_nombre, "Enrutador", "Selector", "Overflow") and not(
							complex_equal(temp_complex, next_to(a, b, (dir + 5) mod 6)) or
							complex_equal(temp_complex, next_to(a, b, dir)) or
							complex_equal(temp_complex, next_to(a, b, (dir + 1) mod 6)))
							flag = false
						if flag and in(edificio_nombre[temp_edificio.index], "Enrutador", "Selector", "Overflow", "Túnel")
							for(var d = 0; d < ds_list_size(edificio.coordenadas); d++)
								if complex_equal(next_to(temp_edificio.a, temp_edificio.b, (temp_edificio.dir + 5) mod 6), edificio.coordenadas[|d]) or
								complex_equal(next_to(temp_edificio.a, temp_edificio.b, temp_edificio.dir), edificio.coordenadas[|d]) or
								complex_equal(next_to(temp_edificio.a, temp_edificio.b, (temp_edificio.dir + 1) mod 6), edificio.coordenadas[|d]){
									flag = false
									break
								}
						if flag and in(var_edificio_nombre, "Túnel") and(
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
					if edificio_output_all[temp_edificio.index] or edificio_input_all[index]
						flag = true
					else for(var d = 0; d < array_length(edificio_output_id[temp_edificio.index]); d++)
						for(var e = 0; e < array_length(edificio_input_id[index]); e++)
							if edificio_output_id[temp_edificio.index, d] = edificio_input_id[index, e]{
								flag = true
								break
							}
					if edificio_emisor[temp_edificio.index] and edificio_receptor[index] and (ds_list_find_index(edificio.inputs, temp_edificio) = -1) and flag{
						flag = true
						if in(var_edificio_nombre, "Cinta Transportadora", "Cinta Magnética") and
							complex_equal(temp_complex, next_to(a, b, dir))
							flag = false
						if flag and in(edificio_nombre[temp_edificio.index], "Cinta Transportadora", "Cinta Magnética") and not
							next_to_build(next_to(temp_edificio.a, temp_edificio.b, temp_edificio.dir), edificio)
							flag = false
						if flag and in(var_edificio_nombre, "Enrutador", "Selector", "Overflow", "Túnel") and(
							complex_equal(temp_complex, next_to(a, b, (dir + 5) mod 6)) or
							complex_equal(temp_complex, next_to(a, b, dir)) or
							complex_equal(temp_complex, next_to(a, b, (dir + 1) mod 6)))
							flag = false
						if flag and in(edificio_nombre[temp_edificio.index], "Enrutador", "Selector", "Overflow"){
							flag = false
							for(var d = 0; d < ds_list_size(edificio.coordenadas); d++)
								if (complex_equal(next_to(temp_edificio.a, temp_edificio.b, (temp_edificio.dir + 5) mod 6), edificio.coordenadas[|d]) or
									complex_equal(next_to(temp_edificio.a, temp_edificio.b, temp_edificio.dir), edificio.coordenadas[|d]) or
									complex_equal(next_to(temp_edificio.a, temp_edificio.b, (temp_edificio.dir + 1) mod 6), edificio.coordenadas[|d])){
									flag = true
									break
								}
						}
						if flag and in(edificio_nombre[temp_edificio.index], "Túnel")
							for(var d = 0; d < ds_list_size(edificio.coordenadas); d++)
								if complex_equal(next_to(temp_edificio.a, temp_edificio.b, (temp_edificio.dir + 5) mod 6), edificio.coordenadas[|d]) or
								complex_equal(next_to(temp_edificio.a, temp_edificio.b, temp_edificio.dir), edificio.coordenadas[|d]) or
								complex_equal(next_to(temp_edificio.a, temp_edificio.b, (temp_edificio.dir + 1) mod 6), edificio.coordenadas[|d]){
									flag = false
									break
								}
						if flag{
							ds_list_add(temp_edificio.outputs, edificio)
							ds_list_add(edificio.inputs, temp_edificio)
							if temp_edificio.waiting
								mover(temp_edificio.a, temp_edificio.b)
						}
					}
				}
			}
		}
		ds_list_destroy(temp_list_2)
		//Añadir a la red electrica
		if edificio_energia[index]{
			if in(var_edificio_nombre, "Energía Infinita")
				edificio.energy_output = -edificio_energia_consumo[index]
			//Detectar otras redes cerca
			var temp_list_redes = ds_list_create()
			temp_list_2 = get_arround(a, b, dir, edificio_size[index])
			for(var c = 0; c < ds_list_size(temp_list_2); c++){
				temp_complex = temp_list_2[|c]
				var aa = temp_complex.a, bb = temp_complex.b
				if aa >= 0 and bb >= 0 and aa < xsize and bb < ysize{
					temp_terreno = terreno[aa, bb]
					if temp_terreno.edificio_bool{
						var temp_edificio = temp_terreno.edificio
						if (edificio_energia[temp_edificio.index] and in(var_edificio_nombre, "Generador", "Batería", "Panel Solar", "Energía Infinita", "Turbina")) or (edificio_energia[index] and in(edificio_nombre[temp_edificio.index], "Generador", "Batería", "Panel Solar", "Energía Infinita", "Turbina")){
							ds_list_add(edificio.energia_link, temp_edificio)
							ds_list_add(temp_edificio.energia_link, edificio)
							if not ds_list_in(temp_list_redes, temp_edificio.red)
								ds_list_add(temp_list_redes, temp_edificio.red)
						}
					}
				}
			}
			var temp_list_3 = get_size(a, b, dir, 7)
			for(var c = 0; c < ds_list_size(temp_list_3); c++){
				temp_complex = temp_list_3[|c]
				if (temp_complex.a != a or temp_complex.b != b) and temp_complex.a >= 0 and temp_complex.b >= 0 and temp_complex.a < xsize and temp_complex.b < ysize{
					temp_terreno = terreno[temp_complex.a, temp_complex.b]
					if temp_terreno.edificio_draw{
						var temp_edificio = temp_terreno.edificio
						if (var_edificio_nombre = "Cable" and edificio_energia[temp_edificio.index]) or edificio_nombre[temp_edificio.index] = "Cable"{
							ds_list_add(edificio.energia_link, temp_edificio)
							ds_list_add(temp_edificio.energia_link, edificio)
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
				bateria_max : 0,
				eficiencia : 0
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
			edificio.red = temp_red
			if edificio_energia_consumo[index] > 0{
				if in(var_edificio_nombre, "Cable", "Batería", "Taladro Eléctrico")
					change_energia(abs(edificio_energia_consumo[index]), edificio)
			}
			else
				temp_red.generacion += edificio.energy_output
			if in(var_edificio_nombre, "Batería")
				temp_red.bateria_max += 2500
			if var_edificio_nombre = "Panel Solar"{
				change_energia(edificio_energia_consumo[index], edificio)
			}
			ds_list_add(temp_red.edificios, edificio)
		}
		//Detectar cañerías cercanas
		if edificio_flujo[index]{
			if var_edificio_nombre = "Bomba Hidráulica"{
				for(var c = 0; c < ds_list_size(temp_list); c++){
					temp_complex = temp_list[|c]
					temp_terreno = terreno[temp_complex.a, temp_complex.b]
					if in(terreno_nombre[temp_terreno.terreno], "Agua", "Agua Profunda")
						edificio.select = 0
					else if in(terreno_nombre[temp_terreno.terreno], "Petróleo")
						edificio.select = 2
					ds_list_add(edificio.coordenadas, temp_complex)
				}
			}
			var temp_list_4 = get_arround(a, b, dir, edificio_size[index])
			var temp_list_flujos = ds_list_create()
			for(var c = 0; c < ds_list_size(temp_list_4); c++){
				temp_complex = temp_list_4[|c]
				if temp_complex.a >= 0 and temp_complex.b >= 0 and temp_complex.a < xsize and temp_complex.b < ysize{
					temp_terreno = terreno[temp_complex.a, temp_complex.b]
					if temp_terreno.edificio_bool{
						var temp_edificio = temp_terreno.edificio
						if edificio_flujo[temp_edificio.index] and (in(var_edificio_nombre, "Tubería", "Depósito", "Líquido Infinito") or in(edificio_nombre[temp_edificio.index], "Tubería", "Depósito", "Líquido Infinito")){
							ds_list_add(edificio.flujo_link, temp_edificio)
							ds_list_add(temp_edificio.flujo_link, edificio)
							if not ds_list_in(temp_list_flujos, temp_edificio.flujo)
								ds_list_add(temp_list_flujos, temp_edificio.flujo)
						}
					}
				}
			}
			ds_list_destroy(temp_list_4)
			if ds_list_empty(temp_list_flujos){
				var new_flujo ={
					edificios : ds_list_create(),
					liquido : -1,
					generacion: 0,
					consumo: 0,
					almacen : 0,
					almacen_max : 0
				}
				ds_list_add(flujos, new_flujo)
				edificio.flujo = new_flujo
				ds_list_add(new_flujo.edificios, edificio)
			}
			else if in(var_edificio_nombre, "Tubería", "Depósito", "Líquido Infinito"){
				var new_flujo ={
					edificios : ds_list_create(),
					liquido : -1,
					generacion: 0,
					consumo: 0,
					almacen : 0,
					almacen_max : 0
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
						new_flujo.almacen += temp_flujo.almacen
						new_flujo.almacen_max += temp_flujo.almacen_max
						ds_list_destroy(temp_flujo.edificios)
						ds_list_remove(flujos, temp_flujo)
					}
				}
				ds_list_add(flujos, new_flujo)
				edificio.flujo = new_flujo
				ds_list_add(new_flujo.edificios, edificio)
			}
			else{
				var temp_flujo = temp_list_flujos[|0]
				edificio.flujo = temp_flujo
				ds_list_add(temp_flujo.edificios, edificio)
			}
			ds_list_destroy(temp_list_flujos)
			edificio.flujo.almacen_max += edificio_flujo_almacen[index]
			if var_edificio_nombre = "Bomba de Evaporación"{
				edificio.flujo.liquido = 0
				change_flujo(edificio_flujo_consumo[index], edificio)
			}
		}
		if var_edificio_nombre = "Láser"
			edificio.mode = true
		else if var_edificio_nombre = "Rifle"
			edificio.select = 0
		if not edificio_camino[index]{
			for(var c = 0; c < ds_list_size(enemigos); c++){
				var enemigo = enemigos[|c], temp_complex_2 = abtoxy(enemigo.target.a, enemigo.target.b), aa = enemigo.a, bb = enemigo.b
				if sqr(aa - x) + sqr(bb - y) < sqr(aa - temp_complex_2.a) + sqr(bb - temp_complex_2.b)
					enemigo.target = edificio
			}
		}
		ds_list_destroy(temp_list)
		return edificio
	}
}