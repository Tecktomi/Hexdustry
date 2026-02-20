function add_edificio(index, dir, a, b, enemigo = false){
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
			center_x : x,
			center_y : y,
			coordenadas : ds_list_create(),
			bordes : ds_list_create(),
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
			vida : edificio_vida[index],
			target : null_dron,
			target_edificio : null_edificio,
			torres : array_create(0, null_edificio),
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
			procesador_link : array_create(0, null_edificio),
			eliminar : false,
			agregar : false,
			chunk_x : clamp(floor(a / chunk_width), 0, chunk_xsize - 1),
			chunk_y : clamp(floor(b / chunk_height), 0, chunk_ysize - 1),
			target_chunks : array_create(0, {a : 0, b : 0}),
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
			sound : undefined,
			modulo : false,
			// 0 = edificios, 1 = chunk_edificios, 2 = [torres_tension, plantas_reciclaje, torres_reparadoras, puertos_carga, target.torres], 3 = luz, 4 = edificios_activos
			// 5 = red, 6 = flujo, 7 = torres, 8 = edificios_index, 9 = edificio_dinamico/estatico, 10 = edificio_draw
			punteros : array_create(5, 0),
			enemigo : enemigo,
			prioridad : 0,
			inputs_carga : array_create(0, null_edificio),
			outputs_carga : array_create(0, null_edificio),
			outputs_carga_index : 0,
			waiting_dron : false,
			chunk_mina : 0,
			chunk_minb : 0,
			chunk_maxa : 0,
			chunk_maxb : 0
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
			}
		}
		var center_x = edificio.center_x, center_y = edificio.center_y
		ds_grid_clear(edificio.coordenadas_dis, infinity)
		ds_list_add(edificio.coordenadas_close, {a : 0, b : 0})
		ds_list_clear(edificio.coordenadas_close)
		if not enemigo{
			edificios_construidos++
			array_disorder_push(edificios_index[index], edificio, 8)
		}
		if mision_actual >= 0 and mision_objetivo[mision_actual] = 2 and mision_target_id[mision_actual] = index and ++mision_counter >= mision_target_num[mision_actual]
			pasar_mision()
		temp_complex = {a : 0, b : 0}
		if in(index, id_planta_quimica, id_fabrica_de_drones){
			edificio.carga_max = array_create(rss_max, 0)
			edificio.carga_output = array_create(rss_max, 0)
			if index = id_planta_quimica
				edificio.proceso = -1
		}
		calculate_in_out(edificio)
		if not edificio_inerte[edificio.index]
			array_disorder_push(edificios_activos, edificio, 4)
		if index = id_procesador{
			array_push(edificio.procesador_link, edificio)
			edificio.variables = array_create(16)
			edificio.variables_nombre = array_create(16, "")
		}
		else if index = id_mensaje
			edificio.variables = array_create(1, "")
		else if index = id_memoria
			edificio.variables = array_create(128)
		else if index = id_planta_de_reciclaje
			array_disorder_push(plantas_de_reciclaje, edificio, 2)
		array_push(efectos, add_efecto(size_fx[edificio_size[index] - 1], 0, x, y, 3))
		if index = id_nucleo
			array_push(nucleos, edificio)
		else
			clic_sound = true
		set_camino_dir(edificio)
		//Añadir coordenadas
		var temp_list_size = get_size(a, b, dir, edificio_size[index]), chunk_mina = edificio.chunk_x, chunk_minb = edificio.chunk_y, chunk_maxa = edificio.chunk_x, chunk_maxb = edificio.chunk_y
		for(var c = ds_list_size(temp_list_size) - 1; c >= 0; c--){
			temp_complex = temp_list_size[|c]
			var aa = clamp(floor(temp_complex.a / chunk_width), 0, chunk_xsize - 1)
			var bb = clamp(floor(temp_complex.b / chunk_height), 0, chunk_ysize - 1)
			chunk_mina = min(chunk_mina, aa)
			chunk_minb = min(chunk_minb, bb)
			chunk_maxa = max(chunk_maxa, aa)
			chunk_maxb = max(chunk_maxb, bb)
			edificio.chunk_mina = chunk_mina
			edificio.chunk_minb = chunk_minb
			edificio.chunk_maxa = chunk_maxa
			edificio.chunk_maxb = chunk_maxb
		}
		for(var c = chunk_mina; c <= chunk_maxa; c++)
			for(var d = chunk_minb; d <= chunk_maxb; d++){
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
			for(var c = ds_list_size(temp_list_size) - 1; c >= 0; c--){
				temp_complex = temp_list_size[|c]
				var aa = temp_complex.a, bb = temp_complex.b
				if ore[# aa, bb] >= 0
					edificio.select += 0.05
				if index = id_taladro_electrico and terreno_recurso_bool[terreno[# aa, bb]]
					edificio.select += 0.05
			}
		}
		var temp_list_arround = get_arround(a, b, dir, edificio_size[index])
		ds_grid_set(edificio_draw, a, b, true)
		if enemigo{
			array_disorder_push(edificios_enemigos, edificio, 0)
			array_disorder_push(chunk_edificios_enemigo[# edificio.chunk_x, edificio.chunk_y], edificio, 1)
		}
		else{
			array_disorder_push(edificios, edificio, 0)
			array_disorder_push(chunk_edificios[# edificio.chunk_x, edificio.chunk_y], edificio, 1)
		}
		edificios_counter[index]++
		for(var c = ds_list_size(temp_list_arround) - 1; c >= 0; c--)
			ds_list_add(edificio.bordes, temp_list_arround[|c])
		if edificio_armas[index]{
			var dis = edificio_alcance_sqr[index], chunk_size_x = chunk_width * 48, chunk_size_y = chunk_height * 14
			var mini = max(edificio.chunk_x - edificio_alcance_chunk_x[index], 0), minj = max(edificio.chunk_y - edificio_alcance_chunk_y[index], 0)
			var maxi = min(edificio.chunk_x + edificio_alcance_chunk_x[index], chunk_xsize - 1), maxj = min(edificio.chunk_y + edificio_alcance_chunk_y[index], chunk_ysize - 1)
			for(var i = mini; i <= maxi; i++)
				for(var j = minj; j <= maxj; j++){
					var chunk_x = i * chunk_size_x, chunk_y = j * chunk_size_y
					if distance_sqr(center_x, center_y, chunk_x, chunk_y) < dis or
						distance_sqr(center_x, center_y, chunk_x + chunk_size_x, chunk_y) < dis or
						distance_sqr(center_x, center_y, chunk_x, chunk_y + chunk_size_y) < dis or
						distance_sqr(center_x, center_y, chunk_x + chunk_size_x, chunk_y + chunk_size_y) < dis
						array_push(edificio.target_chunks, {a : i, b : j})
				}
			if index = id_lanzallamas{
				edificio.array_real[4] = 0
				edificio.array_real[5] = 0
			}
		}
		if grafic_array_camino_o_tunel[index]{
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
				array_disorder_push(torres_reparadoras, edificio, 2)
				for(var c = array_length(edificios) - 2; c >= 0; c--){
					var temp_edificio = edificios[c]
					if temp_edificio.enemigo = enemigo and distance_sqr(temp_edificio.center_x, temp_edificio.center_y, x, y) < alc{
						array_push(edificio.edificios_cercanos, temp_edificio)
						array_push(temp_edificio.reparadores_cercanos, edificio)
						if temp_edificio.vida < edificio_vida[temp_edificio.index]
							array_push(edificio.edificios_cercanos_heridos, temp_edificio)
					}
				}
			}
			for(var c = array_length(torres_reparadoras) - 1; c >= 0; c--){
				var temp_edificio = torres_reparadoras[c]
				if temp_edificio.enemigo = enemigo and distance_sqr(temp_edificio.center_x, temp_edificio.center_y, x, y) < alc{
					array_push(temp_edificio.edificios_cercanos, edificio)
					array_push(edificio.reparadores_cercanos, temp_edificio)
				}
			}
		#endregion
		if index = id_nucleo and menu = 1{
			edificio_pathfind(edificio)
			array_push(edificios_targeteables, edificio)
			for(var c = array_length(enemigos) - 1; c >= 0; c--){
				var temp_enemigo = enemigos[c]
				temp_complex = xytoab(temp_enemigo.x, temp_enemigo.y)
				if temp_complex.a >= 0
					temp_enemigo.target = edificio_cercano[# temp_complex.a, temp_complex.b]
			}
		}
		else if index = id_ensambladora and (edificio_tecnologia[id_modulo] or not tecnologia){
			for(var c = ds_list_size(temp_list_arround) - 1; c >= 0; c--){
				temp_complex = temp_list_arround[|c]
				var aa = temp_complex.a, bb = temp_complex.b
				if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
					continue
				if edificio_bool[# aa, bb]{
					var temp_edificio = edificio_id[# aa, bb]
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
						calculate_in_out_2(temp_edificio)
						break
					}
				}
			}
		}
		for(var c = ds_list_size(temp_list_size) - 1; c >= 0; c--){
			temp_complex = temp_list_size[|c]
			var aa = temp_complex.a, bb = temp_complex.b
			ds_grid_set(edificio_bool, aa, bb, true)
			ds_grid_set(edificio_id, aa, bb, edificio)
			ds_grid_set(repair_id, aa, bb, -1)
			ds_list_add(edificio.coordenadas, temp_complex)
			if index = id_nucleo{
				ds_grid_set(edificio.coordenadas_dis, aa, bb, 0)
				ds_grid_set(edificio_cercano_dis, aa, bb, 0)
				ds_grid_set(edificio_cercano, aa, bb, edificio)
				ds_list_add(edificio.coordenadas_close, {a : aa, b : bb})
			}
		}
		calculate_in_out_2(edificio)
		//Añadir a la red electrica
		if edificio_energia[index]{
			if index = id_energia_infinita
				edificio.energia_consumo = edificio_energia_consumo[index]
			//Buscar edificios electricos colindantes
			var temp_list_redes = ds_list_create()
			for(var c = ds_list_size(temp_list_arround) - 1; c >= 0; c--){
				temp_complex = temp_list_arround[|c]
				var aa = temp_complex.a, bb = temp_complex.b
				if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
					continue
				if edificio_bool[# aa, bb]{
					var temp_edificio = edificio_id[# aa, bb]
					if ((edificio_energia[temp_edificio.index] and in(index, id_generador, id_bateria, id_panel_solar, id_energia_infinita, id_turbina, id_generador_geotermico, id_planta_nuclear, id_torre_de_alta_tension)) or
							(edificio_energia[index] and in(temp_edificio.index, id_generador, id_bateria, id_panel_solar, id_energia_infinita, id_turbina, id_generador_geotermico, id_planta_nuclear, id_torre_de_alta_tension))) and
							temp_edificio.enemigo = enemigo{
						array_push(edificio.energia_link, temp_edificio)
						array_push(temp_edificio.energia_link, edificio)
						if not ds_list_in(temp_list_redes, temp_edificio.red)
							ds_list_add(temp_list_redes, temp_edificio.red)
					}
				}
			}
			//Buscar cables cerca
			var temp_list = get_size(a, b, dir, 7)
			for(var c = ds_list_size(temp_list) - 1; c >= 0; c--){
				temp_complex = temp_list[|c]
				var aa = temp_complex.a, bb = temp_complex.b
				if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
					continue
				if (aa != a or bb != b) and edificio_bool[# aa, bb]{
					var temp_edificio = edificio_id[# aa, bb]
					if ((index = id_cable and edificio_energia[temp_edificio.index]) or temp_edificio.index = id_cable) and
							distance_sqr(center_x, center_y, temp_edificio.center_x, temp_edificio.center_y) <= 8100 and
							not array_contains(edificio.energia_link, temp_edificio) and
							temp_edificio.enemigo = enemigo{//90^2
						array_push(edificio.energia_link, temp_edificio)
						array_push(temp_edificio.energia_link, edificio)
						if not ds_list_in(temp_list_redes, temp_edificio.red)
							ds_list_add(temp_list_redes, temp_edificio.red)
					}
				}
			}
			ds_list_destroy(temp_list)
			//Buscar otras torres de alta tensión
			if index = id_torre_de_alta_tension{
				for(var c = array_length(torres_de_tension) - 1; c >= 0; c--){
					var temp_edificio = torres_de_tension[c]
					if distance_sqr(temp_edificio.center_x, temp_edificio.center_y, center_x, center_y) < 1_000_000 and temp_edificio.enemigo = enemigo{//1000^2
						array_push(edificio.energia_link, temp_edificio)
						array_push(temp_edificio.energia_link, edificio)
						if not ds_list_in(temp_list_redes, temp_edificio.red)
							ds_list_add(temp_list_redes, temp_edificio.red)
					}
				}
				array_disorder_push(torres_de_tension, edificio, 2)
			}
			//Añadir red
			var temp_red = def_red()
			array_disorder_push(redes, temp_red, 0)
			//Combinar otras redes si las hay cerca
			if not ds_list_empty(temp_list_redes){
				for(var c = ds_list_size(temp_list_redes) - 1; c >= 0; c--){
					var temp_red_2 = temp_list_redes[|c]
					for(var d = array_length(temp_red_2.edificios) - 1; d >= 0; d--){
						var temp_edificio = temp_red_2.edificios[d]
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
			ds_list_destroy(temp_list_redes)
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
				if enemigo
					temp_red.bateria += 2500
			}
			else if in(index, id_panel_solar, id_procesador, id_planta_de_reciclaje)
				change_energia(edificio_energia_consumo[index], edificio)
			array_disorder_push(temp_red.edificios, edificio, 5)
		}
		//Detectar cañerías cercanas
		if edificio_flujo[index]{
			if index = id_bomba_hidraulica{
				edificio.select = 0
				for(var c = ds_list_size(temp_list_size) - 1; c >= 0; c--){
					temp_complex = temp_list_size[|c]
					var aa = temp_complex.a, bb = temp_complex.b
					if in(terreno[# aa, bb], idt_agua, idt_agua_profunda){
						edificio.select++
						if terreno[# aa, bb] = idt_agua_profunda
							edificio.select += 0.2
						edificio.fuel = 0
					}
					else if terreno[# aa, bb] = idt_petroleo{
						edificio.select++
						edificio.fuel = 2
					}
					else if terreno[# aa, bb] = idt_lava{
						edificio.select++
						edificio.fuel = 3
					}
					else if grafic_array_agua_salada[terreno[# aa, bb]]{
						edificio.select++
						if terreno[# aa, bb] = idt_agua_salada_profunda
							edificio.select += 0.2
						edificio.fuel = 4
					}
					ds_list_add(edificio.coordenadas, temp_complex)
				}
			}
			var temp_list_flujos = ds_list_create()
			for(var c = ds_list_size(temp_list_arround) - 1; c >= 0; c--){
				temp_complex = temp_list_arround[|c]
				var aa = temp_complex.a, bb = temp_complex.b
				if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
					continue
				if edificio_bool[# aa, bb]{
					var temp_edificio = edificio_id[# aa, bb]
					if edificio_flujo[temp_edificio.index] and (in(index, id_tuberia, id_deposito, id_liquido_infinito, id_tuberia_subterranea) or
					in(temp_edificio.index, id_tuberia, id_deposito, id_liquido_infinito, id_tuberia_subterranea)) and temp_edificio.enemigo = enemigo{
						array_push(edificio.flujo_link, temp_edificio)
						array_push(temp_edificio.flujo_link, edificio)
						if not ds_list_in(temp_list_flujos, temp_edificio.flujo)
							ds_list_add(temp_list_flujos, temp_edificio.flujo)
						if temp_edificio.index = id_tuberia
							tuberia_arround(temp_edificio)
					}
				}
			}
			if index = id_tuberia_subterranea{
				var temp_list = get_size(a, b, 0, 7), flag = false, temp_edificio = null_edificio
				for(var c = ds_list_size(temp_list) - 1; c >= 0; c--){
					temp_complex = temp_list[|c]
					var aa = temp_complex.a, bb = temp_complex.b
					if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
						continue
					if edificio_bool[# temp_complex.a, temp_complex.b] and not (temp_complex.a = a and temp_complex.b = b){
						temp_edificio = edificio_id[# temp_complex.a, temp_complex.b]
						if temp_edificio.index = index and temp_edificio.link = null_edificio and temp_edificio.enemigo = enemigo{
							flag = true
							break
						}
					}
				}
				if flag{
					edificio.link = temp_edificio
					temp_edificio.link = edificio
					array_push(edificio.flujo_link, temp_edificio)
					array_push(temp_edificio.flujo_link, edificio)
					if not ds_list_in(temp_list_flujos, temp_edificio.flujo)
						ds_list_add(temp_list_flujos, temp_edificio.flujo)
				}
				
			}
			if ds_list_empty(temp_list_flujos){
				var new_flujo = def_flujo()
				array_disorder_push(flujos, new_flujo, 0)
				edificio.flujo = new_flujo
				array_disorder_push(new_flujo.edificios, edificio, 6)
			}
			else if in(index, id_tuberia, id_deposito, id_liquido_infinito, id_tuberia_subterranea){
				var new_flujo = def_flujo()
				for(var c = ds_list_size(temp_list_flujos) - 1; c >= 0; c--){
					var temp_flujo = temp_list_flujos[|c]
					if new_flujo.liquido = -1 or temp_flujo.liquido = -1 or new_flujo.liquido = temp_flujo.liquido{
						for(var d = array_length(temp_flujo.edificios) - 1; d >= 0; d--){
							var temp_edificio = temp_flujo.edificios[d]
							temp_edificio.flujo = new_flujo
							array_disorder_push(new_flujo.edificios, temp_edificio, 6)
						}
						if new_flujo.liquido = -1
							new_flujo.liquido = temp_flujo.liquido
						new_flujo.consumo += temp_flujo.consumo
						new_flujo.generacion += temp_flujo.generacion
						new_flujo.almacen += temp_flujo.almacen
						new_flujo.almacen_max += temp_flujo.almacen_max
						delete(temp_flujo.edificios)
						array_disorder_remove(flujos, temp_flujo, 0)
					}
				}
				array_disorder_push(flujos, new_flujo, 0)
				edificio.flujo = new_flujo
				array_disorder_push(new_flujo.edificios, edificio, 6)
			}
			else{
				var temp_flujo = temp_list_flujos[|0]
				edificio.flujo = temp_flujo
				array_disorder_push(temp_flujo.edificios, edificio, 6)
			}
			ds_list_destroy(temp_list_flujos)
			edificio.flujo.almacen_max += edificio_flujo_almacen[index]
			if index = id_bomba_hidraulica and in(edificio.flujo.liquido, -1, edificio.fuel){
				edificio.flujo.liquido = edificio.fuel
				change_flujo(edificio_flujo_consumo[index], edificio)
			}
			else if in(index, id_bomba_de_evaporacion, id_generador_geotermico, id_extractor_atmosferico) and in(edificio.flujo.liquido, -1, idl_agua){
				edificio.flujo.liquido = idl_agua
				change_flujo(edificio_flujo_consumo[index], edificio)
				if index = id_generador_geotermico{
					edificio.select = 0
					for(var c = ds_list_size(temp_list_size) - 1; c >= 0; c--){
						var temp_complex_2 = temp_list_size[|c], aa = temp_complex_2.a, bb = temp_complex_2.b
						edificio.select += (terreno[# aa, bb] = idt_lava)
					}
				}
				else if index = id_extractor_atmosferico{
					edificio.select = 0
					for(var c = ds_list_size(temp_list_size) - 1; c >= 0; c--){
						var temp_complex_2 = temp_list_size[|c], aa = temp_complex_2.a, bb = temp_complex_2.b, d = terreno[# aa, bb]
						if d = idt_hielo
							edificio.select += 1.5
						else if d = idt_nieve
							edificio.select += 1.3
						else if d != idt_salar
							edificio.select++
					}
				}
			}
			else if index = id_planta_de_reciclaje{
				edificio.flujo.liquido = 1
				change_flujo(edificio_flujo_consumo[index], edificio)
			}
			if grafic_luz and edificio.flujo.liquido = idl_lava
				encender_luz(, edificio)
			if index = id_tuberia
				tuberia_arround(edificio)
		}
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
		ds_list_destroy(temp_list_size)
		ds_list_destroy(temp_list_arround)
		return edificio
	}
}