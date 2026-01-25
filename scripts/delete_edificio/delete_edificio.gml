function delete_edificio(edificio = control.null_edificio, destruccion = false){
	with control{
		if not edificio_bool[# edificio.a, edificio.b]{
			show_debug_message($"###ADVERTENCIA###\n\nIntentando eliminar {edificio_nombre[edificio.index]} en {edificio.a}, {edificio.b}")
			exit
		}
		var index = edificio.index, pre_vida = edificio.vida, aa = edificio.a, bb = edificio.b, enemigo = edificio.enemigo
		edificio.vida = 0
		if index = id_nucleo and not enemigo{
			array_remove(nucleos, edificio)
			if menu = 1{
				array_remove(edificios_targeteables, edificio)
				if array_length(nucleos) = 0{
					win = 2
					selected_dron = null_dron
				}
			}
		}
		if enemigo{
			array_disorder_remove(edificios_enemigos, edificio, 0)
			array_disorder_remove(chunk_edificios_enemigo[# edificio.chunk_x, edificio.chunk_y], edificio, 1)
			if mision_actual >= 0 and mision_objetivo[mision_actual] = 8 and mision_target_id[mision_actual] = index and ++mision_counter >= mision_target_num[mision_actual]
				pasar_mision()
		}
		else{
			array_disorder_remove(edificios, edificio, 0)
			array_disorder_remove(chunk_edificios[# edificio.chunk_x, edificio.chunk_y], edificio, 1)
		}
		edificios_counter[index]--
		ds_grid_destroy(edificio.coordenadas_dis)
		if destruccion
			if enemigo
				edificios_destruidos++
			else
				edificios_perdidos++
		if index = id_puerto_de_carga and edificio.link != null_edificio{
			if edificio.receptor
				array_disorder_remove(puerto_carga_array, edificio, 2)
			else
				array_disorder_remove(puerto_carga_array, edificio.link, 2)
			if puerto_carga_atended >= array_length(puerto_carga_array)
				puerto_carga_atended = 0
			edificio.link.receptor = false
			edificio.link.emisor = false
			calculate_in_out_2(edificio.link)
			edificio.link.link = null_edificio
		}
		desactivar_edificio(edificio)
		for(var i = real(index = id_procesador); i < array_length(edificio.procesador_link); i++)
			array_remove(edificio.procesador_link[i].procesador_link, edificio)
		#region Torres reparadoras
			if index = id_torre_reparadora{
				array_disorder_remove(torres_reparadoras, edificio, 2)
				for(var c = array_length(edificio.edificios_cercanos) - 1; c >= 0; c--){
					var temp_edificio = edificio.edificios_cercanos[c]
					array_remove(temp_edificio.reparadores_cercanos, edificio)
				}
			}
			var flag = pre_vida < edificio_vida[index]
			for(var c = array_length(edificio.reparadores_cercanos) - 1; c >= 0; c--){
				var temp_edificio = edificio.reparadores_cercanos[c]
				array_remove(temp_edificio.edificios_cercanos, edificio)
				if flag
					array_remove(temp_edificio.edificios_cercanos_heridos, edificio)
				if temp_edificio.link = edificio
					temp_edificio.link = null_edificio
			}
		#endregion
		if index = id_planta_de_reciclaje
			array_disorder_remove(plantas_de_reciclaje, edificio, 2)
		else if index = id_ensambladora and edificio.mode{
			var temp_edificio = edificio.link
			for(var a = 0; a < rss_max; a++)
				if a != idr_electronico
					temp_edificio.carga[a] = 0
			temp_edificio.carga_total = 0
			temp_edificio.mode = false
			temp_edificio.carga_max[idr_cobre] = 10
			temp_edificio.carga_input[idr_cobre] = true
			temp_edificio.carga_max[idr_silicio] = 10
			temp_edificio.carga_input[idr_silicio] = true
			temp_edificio.carga_max[idr_electronico] = 0
			temp_edificio.carga_input[idr_electronico] = false
			temp_edificio.carga_max[idr_plastico] = 0
			temp_edificio.carga_input[idr_plastico] = false
			temp_edificio.carga_max[idr_bateria] = 0
			temp_edificio.carga_input[idr_bateria] = false
			temp_edificio.carga_output[idr_modulo] = false
			temp_edificio.carga_output[idr_electronico] = true
			calculate_in_out_2(temp_edificio)
			temp_edificio.link = null_edificio
		}
		//Cancelar coordenadas
		for(var i = ds_list_size(edificio.coordenadas) - 1; i >= 0; i--){
			var temp_coordenada_2 = edificio.coordenadas[|i], a = temp_coordenada_2.a, b = temp_coordenada_2.b
			if index = 0{
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
		}
		ds_list_destroy(edificio.coordenadas)
		if menu = 1 and index = id_nucleo and array_length(edificios_targeteables) > 0
			for(var a = 0; a < xsize; a++)
				for(var b = 0; b < ysize; b++)
					if terreno_caminable[terreno[# a, b]]{
						var temp_priority = ds_grid_get(edificio_cercano_priority, a, b)
						if not ds_priority_empty(temp_priority){
							var temp_edificio = ds_priority_find_min(temp_priority)
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
		ds_grid_clear(edificio_cercano_dir, -1)
		if edificio_armas[index]{
			if edificio.target != null_dron and edificio.target.vida > 0
				array_disorder_remove(edificio.target.torres, edificio, 2)
		}
		//Eliminar tuneles
		if in(index, id_tunel, id_tunel_salida) and not edificio.idle
			edificio.link.idle = true
		//Cancelar outputs
		for(var a = array_length(edificio.outputs) - 1; a >= 0; a--){
			var temp_edificio = edificio.outputs[a]
			array_remove(temp_edificio.inputs, edificio)
			if temp_edificio.index = id_cinta_transportadora
				camino_calcular_in(temp_edificio)
		}
		delete(edificio.outputs)
		//Cancelar inputs
		for(var a = array_length(edificio.inputs) - 1; a >= 0; a--){
			var temp_edificio = edificio.inputs[a]
			array_remove(temp_edificio.outputs, edificio)
			if temp_edificio.output_index >= array_length(temp_edificio.outputs)
				temp_edificio.output_index = 0
		}
		delete(edificio.inputs)
		//Cancelar red
		if edificio_energia[index]{
			var temp_red = edificio.red
			array_remove(temp_red.edificios, edificio)
			if index = id_torre_de_alta_tension
				array_disorder_remove(torres_de_tension, edificio, 2)
			//Eliminar la red si no hay más edificios
			if array_length(temp_red.edificios) = 0{
				delete(temp_red.edificios)
				array_disorder_remove(redes, temp_red, 0)
			}
			else{
				change_energia(0, edificio)
				//Eliminar conecciones directas
				for(var a = array_length(edificio.energia_link) - 1; a >= 0; a--){
					var temp_edificio = edificio.energia_link[a]
					array_remove(temp_edificio.energia_link, edificio)
				}
				//Revisar nuevo estado de red
				var red_bateria = 0
				for(var a = array_length(temp_red.edificios) - 1; a >= 0; a--){
					var temp_edificio = temp_red.edificios[a]
					if temp_edificio.index = id_bateria
						red_bateria++
				}
				var agregado = ds_list_create(), visited = array_create(edificio_count, false)
				while array_length(temp_red.edificios) > 0{
					var nodo = temp_red.edificios[array_length(temp_red.edificios) - 1]
					if not visited[nodo.edificio_index]{
						var isla = array_create(0), isla_bateria = 0, pila = ds_stack_create()
						ds_stack_push(pila, nodo)
						ds_list_add(agregado, nodo)
						while not ds_stack_empty(pila){
							nodo = ds_stack_pop(pila)
							if nodo.index = id_bateria
								isla_bateria++
							array_push(isla, nodo)
							array_remove(temp_red.edificios, nodo)
							if not visited[nodo.edificio_index]{
								visited[nodo.edificio_index] = true
								for(var a = array_length(nodo.energia_link) - 1; a >= 0; a--){
									var temp_edificio = nodo.energia_link[a]
									if not visited[temp_edificio.edificio_index] and not ds_list_in(agregado, temp_edificio){
										ds_stack_push(pila, temp_edificio)
										ds_list_add(agregado, temp_edificio)
									}
								}
							}
						}
						ds_stack_destroy(pila)
						var temp_red_2 = {
							edificios : isla,
							generacion: 0,
							consumo: 0,
							bateria: 0,
							bateria_max : 0,
							eficiencia : 0,
							punteros : array_create(0, 0)
						}
						if red_bateria > 0
							temp_red_2.bateria = floor(temp_red.bateria * isla_bateria / red_bateria)
						for(var a = array_length(isla) - 1; a >= 0; a--){
							var temp_edificio = isla[a]
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
			var temp_flujo = edificio.flujo
			change_flujo(0, edificio)
			array_remove(temp_flujo.edificios, edificio)
			if array_length(temp_flujo.edificios) = 0{
				array_disorder_remove(flujos, temp_flujo, 0)
				delete(temp_flujo.edificios)
			}
			else{
				temp_flujo.almacen_max -= edificio_flujo_almacen[index]
				temp_flujo.almacen = min(temp_flujo.almacen, temp_flujo.almacen_max)
				//Reordenamiento de redes de cañerías
				if array_length(edificio.flujo_link) > 1{
					//Eliminar conecciones directas
					for(var a = array_length(edificio.flujo_link) - 1; a >= 0; a--){
						var temp_edificio = edificio.flujo_link[a]
						array_remove(temp_edificio.flujo_link, edificio)
					}
					edificio.flujo_link = []
					//Revisar nuevo estado de red
					var flujo_almacen = 0
					for(var a = array_length(temp_flujo.edificios) - 1; a >= 0; a--)
						flujo_almacen += edificio_flujo_almacen[temp_flujo.edificios[a].index]
					var agregado = ds_list_create(), visited = array_create(edificio_count, false)
					while array_length(temp_flujo.edificios) > 0{
						var nodo = temp_flujo.edificios[array_length(temp_flujo.edificios) - 1]
						if not visited[nodo.edificio_index]{
							var isla = array_create(0), isla_almacen = 0, pila = ds_stack_create()
							ds_stack_push(pila, nodo)
							ds_list_add(agregado, nodo)
							while not ds_stack_empty(pila){
								nodo = ds_stack_pop(pila)
								isla_almacen += edificio_flujo_almacen[nodo.index]
								array_push(isla, nodo)
								array_remove(temp_flujo.edificios, nodo)
								if not visited[nodo.edificio_index]{
									visited[nodo.edificio_index] = true
									for(var a = array_length(nodo.flujo_link) - 1; a >= 0; a--){
										var temp_edificio = nodo.flujo_link[a]
										if not visited[temp_edificio.edificio_index] and not ds_list_in(agregado, temp_edificio){
											ds_stack_push(pila, temp_edificio)
											ds_list_add(agregado, temp_edificio)
										}
									}
								}
							}
							ds_stack_destroy(pila)
							var temp_flujo_2 = {
								edificios : isla,
								liquido : temp_flujo.liquido,
								generacion: 0,
								consumo: 0,
								almacen: 0,
								almacen_max : 0,
								eficiencia : 0,
								punteros : array_create(0, 0)
							}
							if flujo_almacen > 0
								temp_flujo_2.almacen = floor(temp_flujo.almacen * isla_almacen / flujo_almacen)
							for(var a = array_length(isla) - 1; a >= 0; a--){
								var temp_edificio = isla[a]
								temp_edificio.flujo = temp_flujo_2
								temp_flujo_2.almacen_max += edificio_flujo_almacen[temp_edificio.index]
								if edificio_flujo_consumo[temp_edificio.index] > 0
									temp_flujo_2.consumo += temp_edificio.flujo_consumo
								else
									temp_flujo_2.generacion -= temp_edificio.flujo_consumo
							}
							array_disorder_push(flujos, temp_flujo_2, 0)
						}
					}
				delete(temp_flujo.edificios)
				array_disorder_remove(flujos, temp_flujo, 0)
				}
			}
			//Eliminar links
			for(var a = array_length(edificio.flujo_link) - 1; a >= 0; a--){
				var temp_edificio = edificio.flujo_link[a]
				array_remove(temp_edificio.flujo_link, edificio)
			}
			delete(edificio.flujo_link)
			if index = id_tuberia_subterranea
				edificio.link.link = null_edificio
			var temp_list = get_arround(aa, bb, edificio.dir, edificio_size[index])
			for(var a = ds_list_size(temp_list) - 1; a >= 0; a--){
				var temp_complex = temp_list[|a], aaa = temp_complex.a, bbb = temp_complex.b
				if aaa < 0 or bbb < 0 or aaa >= xsize or bbb >= ysize or not edificio_bool[# aaa, bbb]
					continue
				var temp_edificio = edificio_id[# aaa, bbb]
				if temp_edificio.index = id_tuberia
					tuberia_arround(temp_edificio)
			}
		}
		//Retorno de recursos
		if not cheat and not destruccion{
			var b = pre_vida / edificio_vida[index]
			for(var a = array_length(edificio_precio_id[index]) - 1; a >= 0; a--){
				var c = floor(b * edificio_precio_num[index, a] / 2)
				nucleo.carga[edificio_precio_id[index, a]] += c
				nucleo.carga_total += c
			}
		}
		//Camiar target de enemigos
		size = array_length(enemigos)
		if index != id_nucleo
			for(var a = 0; a < size; a++){
				var temp_enemigo = enemigos[a]
				if temp_enemigo.target = edificio{
					var temp_complex = xytoab(temp_enemigo.x, temp_enemigo.y)
					if temp_complex.a >= 0
						destruccion.target = edificio_cercano[# temp_complex.a, temp_complex.b]
				}
			}
		//Explosión Nuclear
		if destruccion and index = id_planta_nuclear and edificio.fuel > 0{
			var xpos = edificio.center_x, ypos = edificio.center_y
			//Daño edificios
			for(var i = array_length(edificios) - 1; i >= 0; i--){
				var temp_edificio = edificios[i], dis = distance_sqr(xpos, ypos, temp_edificio.center_x, temp_edificio.center_y)
				if dis < 160_000 //400^2
					herir_edificio(9_000_000 / max(1, dis) * random_range(0.7, 1.3), temp_edificio)
			}
			//Daño enemigos
			for(var i = array_length(enemigos) - 1; i >= 0; i--){
				var dron = enemigos[i], dis = distance_sqr(xpos, ypos, dron.x, dron.y)
				if dis < 160_000//400^2
					herir_dron(1_000_000 / max(1, dis) * random_range(0.7, 1.3), dron)
			}
			//Daño drones aliados
			for(var i = array_length(drones_aliados) - 1; i >= 0; i--){
				var dron = drones_aliados[i], dis = distance_sqr(xpos, ypos, dron.x, dron.y)
				if dis < 160_000//400^2
					herir_dron(1_000_000 / max(1, dis) * random_range(0.7, 1.3), dron)
			}
			nuclear_x = xpos
			nuclear_y = ypos
			nuclear_step = 300
		}
		//Cruce de caminos
		if index = id_cruce
			for(var a = 0; a < 3; a++){
				var temp_complex = next_to(aa, bb, a), aaa = temp_complex.a, bbb = temp_complex.b
				if aaa < 0 or bbb < 0 or aaa >= xsize or bbb >= ysize
					continue
				if edificio_bool[# aaa, bbb]{
					var temp_edificio = edificio_id[# aaa, bbb]
					calculate_in_out_2(temp_edificio)
				}
			}
		//Cambiar target de torres
		var array_edificios = enemigo ? edificios_enemigos : edificios
		if array_length(array_edificios) > 0{
			for(var i = array_length(edificio.torres) - 1; i >= 0; i--){
				var temp_edificio = edificio.torres[i]
				if temp_edificio.target_edificio = edificio{
					temp_edificio.target_edificio = null_edificio
					if temp_edificio.index = id_mortero
						turret_target(temp_edificio, 10_000)//100^2
					else
						turret_target(temp_edificio)
				}
			}
		}
		else for(var i = array_length(edificio.torres) - 1; i >= 0; i--){
			var temp_edificio = edificio.torres[i]
			if temp_edificio.target = edificio
				temp_edificio.target_edificio = null_edificio
		}
		delete(edificio)
	}
}