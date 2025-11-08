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
			input_index : 0,
			outputs : ds_list_create(),
			output_index : 0,
			proceso : 0,
			carga : array_create(rss_max, 0),
			carga_max : array_create(rss_max, 0),
			carga_output : array_create(rss_max, true),
			carga_id : 0,
			carga_total : 0,
			fuel : 0,
			select : -1,
			mode : false,
			waiting : false,
			idle : false,
			link : null_edificio,
			red : null_red,
			energia_link : ds_list_create(),
			flujo : null_flujo,
			flujo_link : ds_list_create(),
			vida : edificio_vida[index],
			target : null_enemigo,
			flujo_consumo : 0,
			flujo_consumo_max : edificio_flujo_consumo[index],
			energia_consumo : 0,
			energia_consumo_max : edificio_energia_consumo[index],
			edificio_index : real(edificio_count++),
			coordenadas_dis : ds_grid_create(xsize, ysize),
			coordenadas_close : ds_list_create(),
			vivo : true,
			emisor : edificio_emisor[index],
			receptor : edificio_receptor[index],
			luz : false,
			instruccion : array_create(0, array_create(1, 0)),
			variables : [],
			pointer : -1,
			procesador_link : array_create(0, null_edificio),
			eliminar : false,
			agregar : false,
			chunk_x : clamp(round(a / chunk_width), 0, ds_grid_width(chunk_edificios) - 1),
			chunk_y : clamp(round(b / chunk_height), 0, ds_grid_height(chunk_edificios) - 1),
			chunk_pointer : 0,
			target_chunks : array_create(0, {a : 0, b : 0})
		}
		ds_list_add(edificio.energia_link, null_edificio)
		ds_list_clear(edificio.energia_link)
		ds_list_add(edificio.flujo_link, null_edificio)
		ds_list_clear(edificio.flujo_link)
		ds_grid_clear(edificio.coordenadas_dis, infinity)
		ds_list_add(edificio.coordenadas_close, {a : 0, b : 0})
		ds_list_clear(edificio.coordenadas_close)
		var var_edificio_nombre = edificio_nombre[index]
		edificios_construidos++
		if mision_actual >= 0 and mision_objetivo[mision_actual] = 2 and mision_target_id[mision_actual] = index and ++mision_counter >= mision_target_num[mision_actual]
			pasar_mision()
		temp_complex = {a : 0, b : 0}
		if in(var_edificio_nombre, "Planta Química", "Fábrica de Drones"){
			edificio.carga_max = array_create(rss_max, 0)
			edificio.carga_output = array_create(rss_max, 0)
		}
		calculate_in_out(edificio)
		activar_edificio(edificio)
		if var_edificio_nombre = "Procesador"{
			array_push(edificio.procesador_link, edificio)
			edificio.variables = array_create(16)
			edificio.variables_nombre = array_create(16, "")
		}
		else if var_edificio_nombre = "Mensaje"
			edificio.variables = array_create(1, "")
		else if var_edificio_nombre = "Memoria"
			edificio.variables = array_create(128)
		array_push(efectos, add_efecto(size_fx[edificio_size[index] - 1], 0, x, y, 3))
		edificio.chunk_pointer = array_length(chunk_edificios[# edificio.chunk_x, edificio.chunk_y])
		array_push(chunk_edificios[# edificio.chunk_x, edificio.chunk_y], edificio)
		if index = 0
			array_push(nucleos, edificio)
		//Añadir coordenadas
		var temp_list_size = get_size(a, b, dir, edificio_size[index])
		var temp_list_arround = get_arround(a, b, dir, edificio_size[index])
		ds_grid_set(edificio_draw, a, b, true)
		ds_list_add(edificios, edificio)
		edificios_counter[index]++
		var size = ds_list_size(temp_list_arround)
		for(var c = 0; c < size; c++)
			ds_list_add(edificio.bordes, temp_list_arround[|c])
		if edificio_armas[index]{
			var dis = edificio_alcance_sqr[index]
			for(var i = floor(xsize / chunk_width) - 1; i >= 0; i--)
				for(var j = floor(ysize / chunk_height) - 1; j >= 0; j--){
					temp_complex = abtoxy(chunk_width * i, chunk_height * j)
					var temp_complex_2 = abtoxy(chunk_width * i, chunk_height * (j + 1) - 1), temp_complex_3 = abtoxy(chunk_width * (i + 1) - 1, chunk_height * j), temp_complex_4 = abtoxy(chunk_width * (i + 1) - 1, chunk_height * (j + 1) - 1)
					if distance_sqr(x, y, temp_complex.a, temp_complex.b) < dis or
						distance_sqr(x, y, temp_complex_2.a, temp_complex_2.b) < dis or
						distance_sqr(x, y, temp_complex_3.a, temp_complex_3.b) < dis or
						distance_sqr(x, y, temp_complex_4.a, temp_complex_4.b) < dis
						array_push(edificio.target_chunks, {a : i, b : j})
				}
		}
		//Edificios targeteables
		if index = 0{
			edificio_pathfind(edificio)
			ds_list_add(edificios_targeteables, edificio)
			size = array_length(enemigos)
			for(var c = 0; c < size; c++){
				var enemigo = enemigos[c]
				temp_complex = xytoab(enemigo.a, enemigo.b)
				enemigo.target = edificio_cercano[# temp_complex.a, temp_complex.b]
			}
		}
		size = ds_list_size(temp_list_size)
		for(var c = 0; c < size; c++){
			temp_complex = temp_list_size[|c]
			var aa = temp_complex.a, bb = temp_complex.b
			ds_grid_set(edificio_bool, aa, bb, true)
			ds_grid_set(edificio_id, aa, bb, edificio)
			ds_list_add(edificio.coordenadas, temp_complex)
			if index = 0{
				ds_grid_set(edificio.coordenadas_dis, aa, bb, 0)
				ds_grid_set(edificio_cercano_dis, aa, bb, 0)
				ds_grid_set(edificio_cercano, aa, bb, edificio)
				ds_list_add(edificio.coordenadas_close, {a : aa, b : bb})
			}
		}
		calculate_in_out_2(edificio)
		//Añadir a la red electrica
		if edificio_energia[index]{
			if var_edificio_nombre = "Energía Infinita"
				edificio.energia_consumo = edificio_energia_consumo[index]
			//Buscar edificios electricos colindantes
			var temp_list_redes = ds_list_create()
			size = ds_list_size(temp_list_arround)
			for(var c = 0; c < size; c++){
				temp_complex = temp_list_arround[|c]
				var aa = temp_complex.a, bb = temp_complex.b
				if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
					continue
				if edificio_bool[# aa, bb]{
					var temp_edificio = edificio_id[# aa, bb]
					if (edificio_energia[temp_edificio.index] and in(var_edificio_nombre, "Generador", "Batería", "Panel Solar", "Energía Infinita", "Turbina", "Generador Geotérmico", "Planta Nuclear", "Torre de Alta Tensión")) or (edificio_energia[index] and in(edificio_nombre[temp_edificio.index], "Generador", "Batería", "Panel Solar", "Energía Infinita", "Turbina", "Generador Geotérmico", "Planta Nuclear", "Torre de Alta Tensión")){
						ds_list_add(edificio.energia_link, temp_edificio)
						ds_list_add(temp_edificio.energia_link, edificio)
						if not ds_list_in(temp_list_redes, temp_edificio.red)
							ds_list_add(temp_list_redes, temp_edificio.red)
					}
				}
			}
			//Buscar cables cerca
			var temp_list = get_size(a, b, dir, 7)
			size = ds_list_size(temp_list)
			for(var c = 0; c < size; c++){
				temp_complex = temp_list[|c]
				var aa = temp_complex.a, bb = temp_complex.b
				if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
					continue
				if (aa != a or bb != b) and edificio_draw[# aa, bb]{
					var temp_edificio = edificio_id[# aa, bb]
					if (var_edificio_nombre = "Cable" and edificio_energia[temp_edificio.index]) or edificio_nombre[temp_edificio.index] = "Cable"{
						ds_list_add(edificio.energia_link, temp_edificio)
						ds_list_add(temp_edificio.energia_link, edificio)
						if not ds_list_in(temp_list_redes, temp_edificio.red)
							ds_list_add(temp_list_redes, temp_edificio.red)
					}
				}
			}
			ds_list_destroy(temp_list)
			//Buscar otras torres de alta tensión
			if var_edificio_nombre = "Torre de Alta Tensión"{
				size = array_length(torres_de_tension)
				for(var c = 0; c < size; c++){
					var temp_edificio = torres_de_tension[c]
					if sqr(temp_edificio.x - edificio.x) + sqr(temp_edificio.y - edificio.y) < 1_000_000{//1000^2
						ds_list_add(edificio.energia_link, temp_edificio)
						ds_list_add(temp_edificio.energia_link, edificio)
						if not ds_list_in(temp_list_redes, temp_edificio.red)
							ds_list_add(temp_list_redes, temp_edificio.red)
					}
				}
				array_push(torres_de_tension, edificio)
			}
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
				size = ds_list_size(temp_list_redes)
				for(var c = 0; c < size; c++){
					var temp_red_2 = temp_list_redes[|c], size_2 = ds_list_size(temp_red_2.edificios)
					for(var d = 0; d < size_2; d++){
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
				temp_red.generacion += abs(edificio.energia_consumo)
			if in(var_edificio_nombre, "Batería")
				temp_red.bateria_max += 2500
			else if in(var_edificio_nombre, "Panel Solar", "Procesador")
				change_energia(edificio_energia_consumo[index], edificio)
			ds_list_add(temp_red.edificios, edificio)
		}
		//Detectar cañerías cercanas
		if edificio_flujo[index]{
			if var_edificio_nombre = "Bomba Hidráulica"{
				size = ds_list_size(temp_list_size)
				for(var c = 0; c < size; c++){
					temp_complex = temp_list_size[|c]
					var aa = temp_complex.a, bb = temp_complex.b
					if in(terreno_nombre[terreno[# aa, bb]], "Agua", "Agua Profunda")
						edificio.select = 0
					else if in(terreno_nombre[terreno[# aa, bb]], "Petróleo")
						edificio.select = 2
					else if in(terreno_nombre[terreno[# aa, bb]], "Lava")
						edificio.select = 3
					ds_list_add(edificio.coordenadas, temp_complex)
				}
			}
			var temp_list_flujos = ds_list_create()
			size = ds_list_size(temp_list_arround)
			for(var c = 0; c < size; c++){
				temp_complex = temp_list_arround[|c]
				var aa = temp_complex.a, bb = temp_complex.b
				if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
					continue
				if edificio_bool[# aa, bb]{
					var temp_edificio = edificio_id[# aa, bb]
					if edificio_flujo[temp_edificio.index] and (in(var_edificio_nombre, "Tubería", "Depósito", "Líquido Infinito") or in(edificio_nombre[temp_edificio.index], "Tubería", "Depósito", "Líquido Infinito")){
						ds_list_add(edificio.flujo_link, temp_edificio)
						ds_list_add(temp_edificio.flujo_link, edificio)
						if not ds_list_in(temp_list_flujos, temp_edificio.flujo)
							ds_list_add(temp_list_flujos, temp_edificio.flujo)
					}
				}
			}
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
				size = ds_list_size(temp_list_flujos)
				for(var c = 0; c < size; c++){
					var temp_flujo = temp_list_flujos[|c]
					if new_flujo.liquido = -1 or temp_flujo.liquido = -1 or new_flujo.liquido = temp_flujo.liquido{
						var size_2 = ds_list_size(temp_flujo.edificios)
						for(var d = 0; d < size_2; d++){
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
			else if var_edificio_nombre = "Generador Geotérmico"{
				edificio.flujo.liquido = 3
				change_flujo(edificio_flujo_consumo[index], edificio)
			}
			if grafic_luz and edificio.flujo.liquido = 3{
				edificio.luz = true
				add_luz(a, b, 1)
			}
		}
		if var_edificio_nombre = "Láser"
			edificio.mode = true
		else if in(var_edificio_nombre = "Rifle", "Mortero")
			edificio.select = 0
		else if in(var_edificio_nombre, "Planta Química", "Fábrica de Drones")
			edificio.select = -1
		ds_list_destroy(temp_list_size)
		ds_list_destroy(temp_list_arround)
		return edificio
	}
}