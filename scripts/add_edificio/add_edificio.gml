function add_edificio(index, dir, a, b, _jugador = jugador){
	with control{
		if edificio_bool[# a, b]
			exit
		var temp_complex = abtoxy(a, b), chunk_x = clamp(floor(a / CHUNK_WIDTH), 0, chunk_xsize - 1), chunk_y = clamp(floor(b / CHUNK_HEIGHT), 0, chunk_ysize - 1), enemigo = (jugador != _jugador)
		x = temp_complex[0]
		y = temp_complex[1]
		var edificio = {
			index : floor(index),
			dir : floor(dir),
			a : floor(a),
			b : floor(b),
			x : x,
			y : y,
			center_x : x,
			center_y : y,
			coordenadas : get_size(a, b, dir, edificio_size[index]),
			bordes : get_arround(a, b, dir, edificio_size[index]),
			inputs : array_create(0, null_edificio),
			input_index : 0,
			outputs : array_create(0, null_edificio),
			output_index : 0,
			proceso : 0,
			start : false,
			carga : array_create(rss_max, 0),
			carga_max : array_create(rss_max, 0),
			carga_input : array_create(rss_max, true),
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
			energia_link : array_create(0, null_edificio),
			flujo : null_flujo,
			flujo_link : array_create(0, null_edificio),
			flujo_2 : null_flujo,
			flujo_2_link : array_create(0, null_edificio),
			vida : edificio_vida[index],
			target : null_dron,
			target_edificio : null_edificio,
			torres : array_create(0, null_edificio),
			flujo_consumo : 0,
			flujo_2_consumo : 0,
			flujo_consumo_max : edificio_flujo_consumo[index],
			energia_consumo : 0,
			energia_consumo_max : edificio_energia_consumo[index],
			edificio_index : real(edificio_count++),
			coordenadas_dis : ds_grid_create(0, 0),
			vivo : true,
			emisor : edificio_emisor[index],
			receptor : edificio_receptor[index],
			luz : false,
			instruccion : array_create(0, array_create(1, 0)),
			variables : [],
			procesador_link : array_create(0, null_edificio),
			eliminar : false,
			agregar : false,
			chunk_x : chunk_x,
			chunk_y : chunk_y,
			target_chunks : array_create(0, [0, 0]),
			//caminos: 0 = [cos(), 1 = sin()], silo_de_misiles: [0 = petroleo, 1 = tiempo_max], farbicas_de_drones: [0 = salida_x, 1 = salida_y]
			array_real : array_create(0, 0),
			xscale : 1,
			yscale : 1,
			//caminos: rotación de carga, bombas: rotor
			draw_rot : 0,
			edificios_cercanos : array_create(0, null_edificio),
			edificios_cercanos_heridos : array_create(0, null_edificio),
			reparadores_cercanos : array_create(0, null_edificio),
			imagen : spr_hexagono,
			sound : null_sound,
			modulo : false,
			// 0 = edificios, 1 = chunk_edificios, 2 = edificios_jugador, 3 = luz, 4 = edificios_activos
			// 5 = red, 6 = flujo, 7 = torres, 8 = edificios_index, 9 = edificio_dinamico/estatico, 10 = edificio_draw, 11 = edificios_totales, 12 = data.edificios, 13 = data.edificios_id, 14 = data.chunk_edificios
			punteros : array_create(12, 0),
			enemigo : (jugador != _jugador),
			prioridad : edificio_prioridad[index],
			inputs_carga : array_create(0, null_edificio),
			outputs_carga : array_create(0, null_edificio),
			outputs_carga_index : 0,
			waiting_dron : false,
			chunk_mina : 0,
			chunk_minb : 0,
			chunk_maxa : 0,
			chunk_maxb : 0,
			jugador : _jugador,
			calor : 0,
			calor_generado : 0
		}
		if edificio_size[index] = 2.5{
			if in(dir, 0, 1)
				edificio.center_x += 12
			else if in(dir, 3, 4)
				edificio.center_x -= 12
			if in(dir, 0, 4)
				edificio.center_y += 7
			else if in(dir, 1, 3)
				edificio.center_y -= 7
			else if dir = 2
				edificio.center_y -= 14
			else if dir = 5
				edificio.center_y += 14
		}
		else if edificio_size[index] mod 2 = 0{
			if edificio_rotable[index]{
				if dir mod 2 = 0
					edificio.center_x += 8
				else
					edificio.center_x -= 8
				edificio.center_y += 14
			}
			else{
				if edificio.dir = 0
					edificio.center_x += 8
				else
					edificio.center_x -= 8
				edificio.center_y += 14
				edificio.xscale = -1 + 2 * (dir = 0)
			}
		}
		array_disorder_push(edificios_totales, edificio, 12)
		var center_x = edificio.center_x, center_y = edificio.center_y, dron
		ds_grid_clear(edificio.coordenadas_dis, infinity)
		if not enemigo
			edificios_construidos++
		array_disorder_push(edificios_index[index], edificio, 8)
		if mision_actual >= 0 and mision.objetivo = 2 and mision.target_id = index and ++mision_counter >= mision.target_num
			pasar_mision()
		temp_complex = [0, 0]
		if in(index, id_planta_quimica, id_fabrica_de_drones, id_fabrica_de_drones_grande){
			edificio.carga_max = array_create(rss_max, 0)
			edificio.carga_output = array_create(rss_max, 0)
			if index = id_planta_quimica
				edificio.proceso = -1
		}
		calcular_inputs_outputs(edificio)
		if not edificio_inerte[edificio.index]
			array_disorder_push(edificios_activos, edificio, 4)
		if index = id_procesador{
			array_push(edificio.procesador_link, edificio)
			edificio.variables = array_create(16)
		}
		else if index = id_mensaje
			edificio.variables = array_create(1, "")
		else if index = id_memoria
			edificio.variables = array_create(128)
		array_push(efectos, add_efecto(size_fx[edificio_size[index] - 1], 0, x, y, 3))
		if index = id_nucleo{
			ds_grid_resize(edificio.coordenadas_dis, xsize, ysize)
			nucleos[_jugador] = edificio
		}
		else
			clic_sound = true
		set_camino_dir(edificio)
		//Añadir coordenadas
		var temp_list_size = get_size(a, b, dir, edificio_size[index]), chunk_mina = chunk_x, chunk_minb = chunk_y, chunk_maxa = chunk_x, chunk_maxb = chunk_y
		var c, aa, bb, d, i, j, _chunk_x, _chunk_y, temp_array, temp_edificio, temp_list
		if edificio_size[index] != 1
			for(c = array_length(temp_list_size) - 1; c >= 0; c--){
				temp_complex = temp_list_size[c]
				aa = clamp(floor(temp_complex[0] / CHUNK_WIDTH), 0, chunk_xsize - 1)
				bb = clamp(floor(temp_complex[1] / CHUNK_HEIGHT), 0, chunk_ysize - 1)
				chunk_mina = min(chunk_mina, aa)
				chunk_minb = min(chunk_minb, bb)
				chunk_maxa = max(chunk_maxa, aa)
				chunk_maxb = max(chunk_maxb, bb)
			}
		edificio.chunk_mina = chunk_mina
		edificio.chunk_minb = chunk_minb
		edificio.chunk_maxa = chunk_maxa
		edificio.chunk_maxb = chunk_maxb
		for(c = chunk_mina; c <= chunk_maxa; c++)
			for(d = chunk_minb; d <= chunk_maxb; d++){
				if edificio_draw_estatico[index]{
					array_push(chunk_edificios_estatico[# c, d], edificio)
					chunk_edificios_dirty[# c, d] = true
				}
				else
					array_push(chunk_edificios_dinamico[# c, d], edificio)
				array_push(chunk_edificios_draw[# c, d], edificio)
			}
		if in(index, id_taladro, id_taladro_electrico){
			edificio.select = 0.8
			for(c = array_length(temp_list_size) - 1; c >= 0; c--){
				temp_complex = temp_list_size[c]
				aa = temp_complex[0]
				bb = temp_complex[1]
				if ore[# aa, bb] >= 0
					edificio.select += 0.05
				if index = id_taladro_electrico and terreno_recurso_bool[terreno[# aa, bb]]
					edificio.select += 0.05
			}
		}
		var temp_list_arround = get_arround(a, b, dir, edificio_size[index])
		ds_grid_set(edificio_draw, a, b, true)
		array_disorder_push(edificios_jugador[_jugador], edificio, 0)
		array_disorder_push(chunk_edificios[# chunk_x, chunk_y], edificio, 1)
		edificios_counter[index]++
		if edificio_armas[index]{
			var dis = edificio_alcance_sqr[index], chunk_size_x = CHUNK_WIDTH * 48, chunk_size_y = CHUNK_HEIGHT * 14
			var mini = max(chunk_x - edificio_alcance_chunk_x[index], 0), minj = max(chunk_y - edificio_alcance_chunk_y[index], 0)
			var maxi = min(chunk_x + edificio_alcance_chunk_x[index], chunk_xsize - 1), maxj = min(chunk_y + edificio_alcance_chunk_y[index], chunk_ysize - 1)
			for(i = mini; i <= maxi; i++)
				for(j = minj; j <= maxj; j++){
					_chunk_x = i * chunk_size_x
					_chunk_y = j * chunk_size_y
					if distance_sqr(center_x, center_y, _chunk_x, _chunk_y) < dis or
						distance_sqr(center_x, center_y, _chunk_x + chunk_size_x, _chunk_y) < dis or
						distance_sqr(center_x, center_y, _chunk_x, _chunk_y + chunk_size_y) < dis or
						distance_sqr(center_x, center_y, _chunk_x + chunk_size_x, _chunk_y + chunk_size_y) < dis
						array_push(edificio.target_chunks, [i, j])
				}
			if index = id_lanzallamas{
				edificio.array_real[4] = 0
				edificio.array_real[5] = 0
			}
		}
		if tag_camino_o_tunel[index]{
			if in(index, id_cinta_transportadora, id_enrutador, id_cinta_magnetica){
				if (dir mod 3) = 1
					edificio.yscale = power(-1, dir > 1)
				else{
					edificio.xscale = power(-1, ((dir + 1) mod 6) > 1)
					edificio.yscale = power(-1, dir > 2)
				}
			}
			else
				edificio.draw_rot = (dir - 1) * 60
		}
		#region Torres reparadoras
			var alc = edificio_alcance_sqr[id_torre_reparadora]
			if index = id_torre_reparadora{
				for(c = array_length(edificios_jugador[_jugador]) - 2; c >= 0; c--){
					temp_edificio = edificios_jugador[_jugador][c]
					if distance_sqr(temp_edificio.center_x, temp_edificio.center_y, x, y) < alc{
						array_push(edificio.edificios_cercanos, temp_edificio)
						array_push(temp_edificio.reparadores_cercanos, edificio)
						if temp_edificio.vida < edificio_vida[temp_edificio.index]
							array_push(edificio.edificios_cercanos_heridos, temp_edificio)
					}
				}
			}
			for(c = array_length(edificios_index[id_torre_reparadora]) - 1; c >= 0; c--){
				temp_edificio = edificios_index[id_torre_reparadora][c]
				if temp_edificio.jugador = _jugador and distance_sqr(temp_edificio.center_x, temp_edificio.center_y, x, y) < alc{
					array_push(temp_edificio.edificios_cercanos, edificio)
					array_push(edificio.reparadores_cercanos, temp_edificio)
				}
			}
		#endregion
		if index = id_nucleo and menu = 1{
			edificio_pathfind(edificio)
			array_push(edificios_targeteables, edificio)
			for(c = array_length(drones) - 1; c >= 0; c--){
				dron = drones[c]
				if dron.jugador != _jugador
					dron.target = edificio_cercano[# dron.a, dron.b]
			}
		}
		else if index = id_ensambladora{
			edificio.mode = false
			if (edificio_tecnologia[_jugador, id_modulo] or not tecnologia){
				for(c = array_length(temp_list_arround) - 1; c >= 0; c--){
					temp_complex = temp_list_arround[c]
					aa = temp_complex[0]
					bb = temp_complex[1]
					if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
						continue
					if edificio_bool[# aa, bb]{
						temp_edificio = edificio_id[# aa, bb]
						if temp_edificio.index = id_ensambladora and not temp_edificio.mode{
							for(c = 0; c < rss_max; c++)
								if c != idr_electronicos
									temp_edificio.carga[c] = 0
							edificio.mode = true
							temp_edificio.mode = true
							edificio.link = temp_edificio
							temp_edificio.link = edificio
							edificio.carga_max[idr_cobre] = 0
							edificio.carga_input[idr_cobre] = false
							edificio.carga_max[idr_silicio] = 0
							edificio.carga_input[idr_silicio] = false
							edificio.carga_max[idr_electronicos] = 10
							edificio.carga_input[idr_electronicos] = true
							edificio.carga_max[idr_plastico] = 10
							edificio.carga_input[idr_plastico] = true
							edificio.carga_max[idr_bateria] = 10
							edificio.carga_input[idr_bateria] = true
							edificio.carga_output[idr_modulos] = true
							edificio.carga_output[idr_electronicos] = false
							temp_edificio.carga_max[idr_cobre] = 0
							temp_edificio.carga_input[idr_cobre] = false
							temp_edificio.carga_max[idr_silicio] = 0
							temp_edificio.carga_input[idr_silicio] = false
							temp_edificio.carga_max[idr_electronicos] = 10
							temp_edificio.carga_input[idr_electronicos] = true
							temp_edificio.carga_max[idr_plastico] = 10
							temp_edificio.carga_input[idr_plastico] = true
							temp_edificio.carga_max[idr_bateria] = 10
							temp_edificio.carga_input[idr_bateria] = true
							temp_edificio.carga_output[idr_modulos] = true
							temp_edificio.carga_output[idr_electronicos] = false
							temp_edificio.proceso = 0
							temp_edificio.start = false
							calcular_edificios_adyascentes(temp_edificio)
							break
						}
					}
				}
			}
		}
		for(c = array_length(temp_list_size) - 1; c >= 0; c--){
			temp_complex = temp_list_size[c]
			aa = temp_complex[0]
			bb = temp_complex[1]
			ds_grid_set(edificio_bool, aa, bb, true)
			ds_grid_set(edificio_id, aa, bb, edificio)
			ds_grid_set(repair_id, aa, bb, -1)
			if index = id_nucleo{
				ds_grid_set(edificio.coordenadas_dis, aa, bb, 0)
				ds_grid_set(edificio_cercano_dis, aa, bb, 0)
				ds_grid_set(edificio_cercano, aa, bb, edificio)
			}
		}
		calcular_edificios_adyascentes(edificio)
		//Añadir a la red electrica
		if edificio_energia[index]{
			if index = id_energia_infinita
				edificio.energia_consumo = edificio_energia_consumo[index]
			//Buscar edificios electricos colindantes
			var temp_list_redes = array_create(0, null_red)
			for(c = array_length(temp_list_arround) - 1; c >= 0; c--){
				temp_complex = temp_list_arround[c]
				aa = temp_complex[0]
				bb = temp_complex[1]
				if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
					continue
				if edificio_bool[# aa, bb]{
					temp_edificio = edificio_id[# aa, bb]
					if ((edificio_energia[temp_edificio.index] and tag_edificio_generador[index]) or (edificio_energia[index] and tag_edificio_generador[temp_edificio.index])) and temp_edificio.jugador = _jugador{
						array_push(edificio.energia_link, temp_edificio)
						array_push(temp_edificio.energia_link, edificio)
						if not array_contains(temp_list_redes, temp_edificio.red)
							array_push(temp_list_redes, temp_edificio.red)
					}
				}
			}
			//Buscar cables cerca
			temp_list = get_size(a, b, dir, 7)
			for(c = array_length(temp_list) - 1; c >= 0; c--){
				temp_complex = temp_list[c]
				aa = temp_complex[0]
				bb = temp_complex[1]
				if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
					continue
				if (aa != a or bb != b) and edificio_bool[# aa, bb]{
					temp_edificio = edificio_id[# aa, bb]
					if ((index = id_cable and edificio_energia[temp_edificio.index]) or temp_edificio.index = id_cable) and distance_sqr(center_x, center_y, temp_edificio.center_x, temp_edificio.center_y) <= CABLE_RANGE_SQR and not array_contains(edificio.energia_link, temp_edificio) and temp_edificio.jugador = _jugador{
						array_push(edificio.energia_link, temp_edificio)
						array_push(temp_edificio.energia_link, edificio)
						if not array_contains(temp_list_redes, temp_edificio.red)
							array_push(temp_list_redes, temp_edificio.red)
					}
				}
			}
			//Buscar otras torres de alta tensión
			if index = id_torre_de_alta_tension{
				for(c = array_length(edificios_index[id_torre_de_alta_tension]) - 1; c >= 0; c--){
					temp_edificio = edificios_index[id_torre_de_alta_tension][c]
					if temp_edificio.jugador = _jugador and distance_sqr(temp_edificio.center_x, temp_edificio.center_y, center_x, center_y) < TORRE_TENSION_RANGE_SQR{
						array_push(edificio.energia_link, temp_edificio)
						array_push(temp_edificio.energia_link, edificio)
						if not array_contains(temp_list_redes, temp_edificio.red)
							array_push(temp_list_redes, temp_edificio.red)
					}
				}
			}
			//Añadir red
			var temp_red = def_red()
			array_disorder_push(redes, temp_red, 0)
			//Combinar otras redes si las hay cerca
			if array_length(temp_list_redes) > 0{
				for(c = array_length(temp_list_redes) - 1; c >= 0; c--){
					var temp_red_2 = temp_list_redes[c]
					for(d = array_length(temp_red_2.edificios) - 1; d >= 0; d--){
						temp_edificio = temp_red_2.edificios[d]
						temp_edificio.red = temp_red
						array_disorder_push(temp_red.edificios, temp_edificio, 5)
					}
					temp_red.consumo += temp_red_2.consumo
					temp_red.generacion += temp_red_2.generacion
					temp_red.bateria += temp_red_2.bateria
					temp_red.bateria_max += temp_red_2.bateria_max
					delete(temp_red_2.edificios)
					array_disorder_remove(redes, temp_red_2, 0)
					delete(temp_red_2)
				}
			}
			//Modificar valores de la red resultante
			edificio.red = temp_red
			if edificio_energia_consumo[index] > 0{
				if in(index, id_cable, id_bateria, id_taladro_electrico)
					change_energia(abs(edificio_energia_consumo[index]), edificio)
			}
			else
				temp_red.generacion += abs(edificio.energia_consumo)
			if index = id_bateria{
				temp_red.bateria_max += 2500
				if _jugador = 1
					temp_red.bateria += 2500
			}
			else if in(index, id_panel_solar, id_procesador, id_planta_de_reciclaje)
				change_energia(edificio_energia_consumo[index], edificio)
			array_disorder_push(temp_red.edificios, edificio, 5)
		}
		//Detectar cañerías cercanas
		if edificio_flujo[index]{
			add_edificio_flujo(edificio, "flujo", _jugador)
			if array_length(edificio_flujo_liquido[index]) = 2
				add_edificio_flujo(edificio, "flujo_2", _jugador, 1)
		}
		//Datos específicos
		if index = id_laser
			edificio.mode = true
		if in(index, id_rifle, id_mortero, id_onda_de_choque)
			edificio.select = 0
		if index = id_silo_de_misiles{
			edificio.select = -1
			edificio.mode = false
			edificio.array_real[0] = 1
			edificio.array_real[1] = 1
			edificio.array_real[2] = -1
			edificio.array_real[3] = -1
		}
		if in(index, id_planta_quimica, id_fabrica_de_drones, id_fabrica_de_drones_grande, id_cinta_grande, id_planta_de_reciclaje)
			edificio.select = -1
		if in(index, id_planta_de_enriquecimiento, id_fabrica_de_drones, id_planta_de_reciclaje, id_planta_desalinizadora)
			edificio.proceso = -1
		if index = id_laser
			edificio.fuel = 1
		if index = id_refineria_de_petroleo
			edificio.select = 60
		if in(index, id_fabrica_de_drones, id_cinta_grande, id_fabrica_de_drones_grande){
			edificio.array_real[0] = -1
			edificio.array_real[1] = -1
		}
		return edificio
	}
}