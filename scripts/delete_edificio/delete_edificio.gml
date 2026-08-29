function delete_edificio(edificio = control.null_edificio, destruccion = false, _server = false, _cheat = control.cheat){
	with control{
		if not edificio_bool[# edificio.a, edificio.b]{
			show_debug_message($"###ADVERTENCIA###\n  Intentando eliminar {edificio.index = -1 ? "??" : edificio_nombre[edificio.index]} en {edificio.a}, {edificio.b}")
			exit
		}
		var index = edificio.index, pre_vida = edificio.vida, aa = edificio.a, bb = edificio.b, enemigo = edificio.enemigo
		if online and not _server and not destruccion{
			server_delete_edificio(aa, bb)
			if not servidor
				exit
		}
		var chunk_x = edificio.chunk_x, chunk_y = edificio.chunk_y, _jugador = real(edificio.jugador)
		var a, b, flag, temp_edificio, temp_coordenada_2, temp_priority, i, dis, temp_complex, dron, aaa, bbb
		edificio.vida = 0
		array_disorder_remove(edificios_index[index], edificio, ptre_index)
		if index = id_nucleo and menu = 1 and not enemigo{
			if nucleos[_jugador] = edificio
				nucleos[_jugador] = null_edificio
			array_remove(edificios_targeteables, edificio)
			flag = true
			for(a = array_length(edificios_index[id_nucleo]) - 1; a >= 0; a--){
				temp_edificio = edificios_index[id_nucleo, a]
				if temp_edificio.jugador = _jugador{
					flag = false
					break
				}
			}
			if flag{
				win = 2
				selected_dron = null_dron
				pausa = 0
			}
			ds_grid_clear(edificio_cercano_dir, -1)
		}
		if enemigo and mision_actual >= 0 and mision.objetivo = idm_destruir_edificio and mision.target_id = index and ++mision_counter >= mision.target_num
			pasar_mision()
		array_disorder_remove(edificios_jugador[_jugador], edificio, ptre_jugador)
		array_disorder_remove(chunk_edificios[# chunk_x, chunk_y], edificio, ptre_chunk)
		for(a = edificio.chunk_mina; a <= edificio.chunk_maxa; a++)
			for(b = edificio.chunk_minb; b <= edificio.chunk_maxb; b++){
				if edificio_draw_estatico[index]{
					array_remove(chunk_edificios_estatico[# a, b], edificio)
					chunk_edificios_dirty[# a, b] = true
				}
				else
					array_remove(chunk_edificios_dinamico[# a, b], edificio)
				array_remove(chunk_edificios_draw[# a, b], edificio)
			}
		edificios_counter[index]--
		array_disorder_remove(edificios_totales, edificio, ptre_total)
		ds_grid_destroy(edificio.coordenadas_dis)
		if destruccion{
			if enemigo
				edificios_destruidos++
			else
				edificios_perdidos++
		}
		if index = id_puerto_de_carga and edificio.link != null_edificio{
			if edificio.receptor
				array_disorder_remove(puerto_carga_array[_jugador], edificio, ptre_puerto)
			else
				array_disorder_remove(puerto_carga_array[_jugador], edificio.link, ptre_puerto)
			if puerto_carga_atended[_jugador] >= array_length(puerto_carga_array[_jugador])
				puerto_carga_atended[_jugador] = 0
			edificio.link.receptor = false
			edificio.link.emisor = false
			calcular_edificios_adyascentes(edificio.link)
			edificio.link.link = null_edificio
		}
		desactivar_edificio(edificio)
		for(a = real(index = id_procesador); a < array_length(edificio.procesador_link); a++)
			array_remove(edificio.procesador_link[a].procesador_link, edificio)
		#region Torres reparadoras
			if index = id_torre_reparadora{
				for(a = array_length(edificio.edificios_cercanos) - 1; a >= 0; a--){
					temp_edificio = edificio.edificios_cercanos[a]
					array_remove(temp_edificio.reparadores_cercanos, edificio)
				}
			}
			flag = pre_vida < edificio_vida[index]
			for(a = array_length(edificio.reparadores_cercanos) - 1; a >= 0; a--){
				temp_edificio = edificio.reparadores_cercanos[a]
				array_remove(temp_edificio.edificios_cercanos, edificio)
				if flag
					array_remove(temp_edificio.edificios_cercanos_heridos, edificio)
				if temp_edificio.link = edificio
					temp_edificio.link = null_edificio
			}
		#endregion
		if index = id_ensambladora and edificio.mode{
			temp_edificio = edificio.link
			for(a = 0; a < rss_max; a++)
				if a != idr_electronicos
					temp_edificio.carga[a] = 0
			temp_edificio.carga_total = 0
			temp_edificio.mode = false
			temp_edificio.carga_max[idr_cobre] = 10
			temp_edificio.carga_input[idr_cobre] = true
			temp_edificio.carga_max[idr_silicio] = 10
			temp_edificio.carga_input[idr_silicio] = true
			temp_edificio.carga_max[idr_electronicos] = 0
			temp_edificio.carga_input[idr_electronicos] = false
			temp_edificio.carga_max[idr_plastico] = 0
			temp_edificio.carga_input[idr_plastico] = false
			temp_edificio.carga_max[idr_bateria] = 0
			temp_edificio.carga_input[idr_bateria] = false
			temp_edificio.carga_output[idr_modulos] = false
			temp_edificio.carga_output[idr_electronicos] = true
			calcular_edificios_adyascentes(temp_edificio)
			temp_edificio.link = null_edificio
		}
		//Ser reciclado
		if edificio_size[index] <= 3 and tag_edificio_construible[index]{
			for(a = array_length(edificios_index[id_planta_de_reciclaje]) - 1; a >= 0; a--){
				temp_edificio = edificios_index[id_planta_de_reciclaje][a]
				if temp_edificio.select = -1 and temp_edificio.jugador = _jugador and distance_sqr(edificio.center_x, edificio.center_y, temp_edificio.center_x, temp_edificio.center_y) < PLANTA_RECICLAJE_RANGE_SQR{
					temp_edificio.mode = true
					temp_edificio.select = index
					break
				}
			}
		}
		//Cancelar coordenadas
		for(i = array_length(edificio.coordenadas) - 1; i >= 0; i--){
			temp_coordenada_2 = edificio.coordenadas[i]
			a = temp_coordenada_2[0]
			b = temp_coordenada_2[1]
			if index = id_nucleo{
				ds_grid_set(edificio_cercano, a, b, null_edificio)
				ds_grid_set(edificio_cercano_dis, a, b, infinity)
			}
			ds_grid_set(edificio_bool, a, b, false)
			ds_grid_set(edificio_id, a, b, null_edificio)
			ds_grid_set(edificio_draw, a, b, false)
		}
		if grafic_luz
			encender_luz(false, edificio)
		if destruccion and not enemigo{
			ds_grid_set(repair_id, aa, bb, index)
			ds_grid_set(repair_dir, aa, bb, edificio.dir)
			if tag_edificio_seteable[index]{
				ds_grid_set(repair_mode, aa, bb, edificio.mode)
				ds_grid_set(repair_select, aa, bb, edificio.select)
			}
		}
		if menu = 1 and index = id_nucleo and array_length(edificios_targeteables) > 0
			for(a = 0; a < xsize; a++)
				for(b = 0; b < ysize; b++)
					if terreno_caminable[terreno[# a, b]]{
						temp_priority = ds_grid_get(edificio_cercano_priority, a, b)
						if not ds_priority_empty(temp_priority){
							temp_edificio = ds_priority_find_min(temp_priority)
							while not temp_edificio.vivo{
								ds_priority_delete_min(temp_priority)
								temp_edificio = ds_priority_find_min(temp_priority)
							}
							if temp_edificio = edificio{
								ds_priority_delete_min(temp_priority)
								temp_edificio = ds_priority_find_min(temp_priority)
								while not ds_priority_empty(temp_priority) and not temp_edificio.vivo{
									ds_priority_delete_min(temp_priority)
									temp_edificio = ds_priority_find_min(temp_priority)
								}
								if not ds_priority_empty(temp_priority){
									ds_grid_set(edificio_cercano, a, b, temp_edificio)
									ds_grid_set(edificio_cercano_dis, a, b, temp_edificio.coordenadas_dis[# a, b])
								}
								else
									show_debug_message("!!")
							}
						}
					}
		edificio.vivo = false
		if edificio_armas[index]{
			if edificio.target != null_dron and edificio.target.vida > 0
				array_disorder_remove(edificio.target.torres, edificio, ptre_torre_dron)
		}
		//Eliminar tuneles
		if in(index, id_tunel, id_tunel_salida) and not edificio.idle
			edificio.link.idle = true
		//Cancelar outputs
		for(a = array_length(edificio.outputs) - 1; a >= 0; a--){
			temp_edificio = edificio.outputs[a]
			array_remove(temp_edificio.inputs, edificio)
			if temp_edificio.index = id_cinta_transportadora
				camino_calcular_in(temp_edificio)
		}
		delete(edificio.outputs)
		//Cancelar inputs
		for(a = array_length(edificio.inputs) - 1; a >= 0; a--){
			temp_edificio = edificio.inputs[a]
			array_remove(temp_edificio.outputs, edificio)
			if temp_edificio.output_index >= array_length(temp_edificio.outputs)
				temp_edificio.output_index = 0
		}
		delete(edificio.inputs)
		change_calor(0, edificio)
		//Cancelar red
		if edificio_energia[index]{
			var temp_red = edificio.red, red_bateria, agregado, nodo, isla, temp_red_2, isla_bateria, pila, visitado
			array_disorder_remove(temp_red.edificios, edificio, ptre_red)
			//Eliminar la red si no hay más edificios
			if array_length(temp_red.edificios) = 0{
				delete(temp_red.edificios)
				array_disorder_remove(redes, temp_red, 0)
			}
			else{
				change_energia(0, edificio)
				//Eliminar conecciones directas
				for(a = array_length(edificio.energia_link) - 1; a >= 0; a--){
					temp_edificio = edificio.energia_link[a]
					array_remove(temp_edificio.energia_link, edificio)
				}
				//Revisar nuevo estado de red
				red_bateria = 0
				for(a = array_length(temp_red.edificios) - 1; a >= 0; a--){
					temp_edificio = temp_red.edificios[a]
					if temp_edificio.index = id_bateria
						red_bateria++
				}
				agregado = array_create(edificio_count, false)
				visitado = array_create(edificio_count, false)
				while array_length(temp_red.edificios) > 0{
					nodo = temp_red.edificios[array_length(temp_red.edificios) - 1]
					if not visitado[nodo.edificio_index]{
						isla = array_create(0)
						isla_bateria = 0
						pila = ds_stack_create()
						ds_stack_push(pila, nodo)
						agregado[nodo.edificio_index] = true
						while not ds_stack_empty(pila){
							nodo = ds_stack_pop(pila)
							if nodo.index = id_bateria
								isla_bateria++
							array_push(isla, nodo)
							array_disorder_remove(temp_red.edificios, nodo, ptre_red)
							if not visitado[nodo.edificio_index]{
								visitado[nodo.edificio_index] = true
								for(a = array_length(nodo.energia_link) - 1; a >= 0; a--){
									temp_edificio = nodo.energia_link[a]
									if not visitado[temp_edificio.edificio_index] and not agregado[temp_edificio.edificio_index]{
										ds_stack_push(pila, temp_edificio)
										agregado[temp_edificio.edificio_index] = true
									}
								}
							}
						}
						ds_stack_destroy(pila)
						temp_red_2 = def_red()
						temp_red_2.edificios = isla
						if red_bateria > 0
							temp_red_2.bateria = floor(temp_red.bateria * isla_bateria / red_bateria)
						for(a = array_length(isla) - 1; a >= 0; a--){
							temp_edificio = isla[a]
							temp_edificio.red = temp_red_2
							if edificio_energia_consumo[temp_edificio.index] > 0
								temp_red_2.consumo += abs(temp_edificio.energia_consumo)
							else
								temp_red_2.generacion += abs(temp_edificio.energia_consumo)
							if temp_edificio.index = id_bateria
								temp_red_2.bateria_max += 2500
						}
						array_disorder_push(redes, temp_red_2, 0)
					}
				}
				delete(temp_red.edificios)
				array_disorder_remove(redes, temp_red, 0)
			}
			delete(edificio.energia_link)
		}
		//Flujos de cañerias
		if edificio_flujo[index]{
			delete_edificio_flujo(edificio, edificio.flujo)
			if array_length(edificio_flujo_liquido[index]) = 2
				delete_edificio_flujo(edificio, edificio.flujo_2)
		}
		//Retorno de recursos
		if not _cheat and not destruccion and ((_jugador = jugador) or (online and servidor)){
			b = pre_vida / edificio_vida[index]
			for(a = array_length(edificio_precio_id[index]) - 1; a >= 0; a--)
				jugador_recursos[_jugador, edificio_precio_id[index, a]] += floor(b * edificio_precio_num[index, a] / 2)
		}
		//Camiar target de enemigos
		if index != id_nucleo
			for(a = array_length(drones) - 1; a >= 0; a--){
				var temp_enemigo = drones[a]
				if temp_enemigo.jugador != _jugador and temp_enemigo.target = edificio{
					temp_complex = xytoab(temp_enemigo.x, temp_enemigo.y)
					if temp_complex[0] >= 0{
						temp_edificio = edificio_cercano[# temp_complex[0], temp_complex[1]]
						if temp_edificio = null_edificio and array_length(edificios_index[id_nucleo]) > 0
							temp_enemigo.target = edificios_index[id_nucleo][0]
						else
							temp_enemigo.target = temp_edificio
					}
				}
			}
		//Explosión Nuclear
		if destruccion and index = id_planta_nuclear and edificio.fuel > 0{
			var xpos = edificio.center_x, ypos = edificio.center_y
			//Daño edificios
			for(i = array_length(edificios) - 1; i >= 0; i--){
				temp_edificio = edificios[i]
				dis = distance_sqr(xpos, ypos, temp_edificio.center_x, temp_edificio.center_y)
				if dis < PLANTA_NUCLEAR_RANGE_SQR
					herir_edificio(9_000_000 / max(1, dis) * random_range(0.7, 1.3), temp_edificio)
			}
			//Daño drones
			for(i = array_length(drones) - 1; i >= 0; i--){
				dron = drones[i]
				dis = distance_sqr(xpos, ypos, dron.x, dron.y)
				if dis < PLANTA_NUCLEAR_RANGE_SQR
					herir_dron(1_000_000 / max(1, dis) * random_range(0.7, 1.3), dron)
			}
			nuclear_x = xpos
			nuclear_y = ypos
			nuclear_step = 300
		}
		//Destrucción en cadena
		if destruccion and (edificio.carga[idr_explosivo] > 0 or (edificio_flujo[index] and edificio.flujo.liquido = idl_petroleo and edificio.flujo.almacen > 0))
			array_push(explosion_queue, {
				x : edificio.x,
				y : edificio.y,
				edificio : null_edificio,
				enemigo : not enemigo,
				radio : 4900,
				dmg : 200 + 30 * edificio.carga[idr_explosivo],
				incendiario : false,
				jugador : -1})
		//Cruce de caminos
		if index = id_cruce
			for(a = 0; a < 3; a++){
				temp_complex = next_to(aa, bb, a)
				aaa = temp_complex[0]
				bbb = temp_complex[1]
				if aaa < 0 or bbb < 0 or aaa >= xsize or bbb >= ysize
					continue
				if edificio_bool[# aaa, bbb]{
					temp_edificio = edificio_id[# aaa, bbb]
					calcular_edificios_adyascentes(temp_edificio)
				}
			}
		//Cambiar target de torres
		for(i = array_length(edificio.torres) - 1; i >= 0; i--){
			temp_edificio = edificio.torres[i]
			if temp_edificio.target_edificio = edificio{
				temp_edificio.target_edificio = null_edificio
				if temp_edificio.index = id_mortero
					turret_target(temp_edificio, 10_000)//100^2
				else
					turret_target(temp_edificio)
			}
		}
		//Carga de drones
		if tag_dron_encima[index]{
			for(a = array_length(edificio.inputs_carga) - 1; a >= 0; a--)
				array_remove(edificio.inputs_carga[a].outputs_carga, edificio)
			for(a = array_length(edificio.outputs_carga) - 1; a >= 0; a--)
				array_remove(edificio.outputs_carga[a].inputs_carga, edificio)
			if array_contains(edificios_salida_drones, edificio)
				array_disorder_remove(edificios_salida_drones, edificio, ptre_salida_drones)
		}
		if show_menu and edificio = show_menu_build{
			show_menu = false
			show_menu_build = null_edificio
		}
		delete(edificio)
	}
}