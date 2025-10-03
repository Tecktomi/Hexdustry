function delete_edificio(aa, bb, enemigo = false){
	with control{
		if not edificio_bool[# aa, bb]
			exit
		var edificio = edificio_id[# aa, bb], index = edificio.index, var_edificio_nombre = edificio_nombre[index]
		if index = 0 and menu = 1{
			if show_question("Has perdido, jugar de nuevo?")
				game_restart()
			else
				game_end()
		}
		ds_list_remove(edificios, edificio)
		edificios_counter[index]--
		ds_grid_destroy(edificio.coordenadas_dis)
		if not edificio_camino[index] and not in(var_edificio_nombre, "Tubería")
			ds_list_remove(edificios_targeteables, edificio)
		if var_edificio_nombre = "Puerto de Carga" and edificio.link != null_edificio{
			if edificio.receptor
				array_remove(puerto_carga_array, edificio)
			else
				array_remove(puerto_carga_array, edificio.link)
			if puerto_carga_atended >= array_length(puerto_carga_array)
				puerto_carga_atended = 0
			edificio.link.receptor = false
			edificio.link.emisor = false
			calculate_in_out_2(edificio.link)
			edificio.link.link = null_edificio
		}
		//Cancelar coordenadas
		for(var i = 0; i < ds_list_size(edificio.coordenadas); i++){
			var temp_coordenada_2 = edificio.coordenadas[|i], a = temp_coordenada_2.a, b = temp_coordenada_2.b
			ds_grid_set(edificio_cercano, a, b, null_edificio)
			ds_grid_set(edificio_cercano_dis, a, b, infinity)
			ds_grid_set(edificio_bool, a, b, false)
			ds_grid_set(edificio_id, a, b, null_edificio)
			ds_grid_set(edificio_draw, a, b, false)
		}
		if ver_luz and edificio.luz{
			var temp_list = edificio.coordenadas, size = ds_list_size(temp_list)
			for(var b = 0; b < size; b++){
				var temp_complex = temp_list[|b]
				add_luz(temp_complex.a, temp_complex.b, -1)
			}
		}
		ds_list_destroy(edificio.coordenadas)
		if not ds_list_empty(edificios_targeteables)
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
		//Eliminar tuneles
		if in(var_edificio_nombre = "Túnel", "Túnel salida") and not edificio.idle
			edificio.link.idle = true
		//Cancelar outputs
		for(var a = 0; a < ds_list_size(edificio.outputs); a++){
			var temp_edificio = edificio.outputs[|a]
			ds_list_remove(temp_edificio.inputs, edificio)
		}
		ds_list_destroy(edificio.outputs)
		//Cancelar inputs
		for(var a = 0; a < ds_list_size(edificio.inputs); a++){
			var temp_edificio = edificio.inputs[|a]
			ds_list_remove(temp_edificio.outputs, edificio)
			if temp_edificio.output_index >= ds_list_size(temp_edificio.outputs)
				temp_edificio.output_index = 0
		}
		ds_list_destroy(edificio.inputs)
		//Cancelar red
		if edificio_energia[index]{
			var temp_red = edificio.red
			ds_list_remove(temp_red.edificios, edificio)
			//Eliminar la red si no hay más edificios
			if ds_list_empty(temp_red.edificios){
				ds_list_destroy(temp_red.edificios)
				ds_list_remove(redes, temp_red)
			}
			else{
				change_energia(0, edificio)
				//Eliminar conecciones directas
				for(var a = 0; a < ds_list_size(edificio.energia_link); a++){
					var temp_edificio = edificio.energia_link[|a]
					ds_list_remove(temp_edificio.energia_link, edificio)
				}
				//Revisar nuevo estado de red
				var red_bateria = 0
				for(var a = 0; a < ds_list_size(temp_red.edificios); a++){
					var temp_edificio = temp_red.edificios[|a]
					if in(edificio_nombre[temp_edificio.index], "Batería")
						red_bateria++
				}
				var agregado = ds_list_create(), visited = array_create(edificio_count, false)
				while not ds_list_empty(temp_red.edificios){
					var nodo = temp_red.edificios[|0]
					if not visited[nodo.edificio_index]{
						var isla = ds_list_create(), isla_bateria = 0
						var pila = ds_stack_create()
						ds_stack_push(pila, nodo)
						ds_list_add(agregado, nodo)
						while not ds_stack_empty(pila){
							nodo = ds_stack_pop(pila)
							if in(edificio_nombre[nodo.index], "Batería")
								isla_bateria++
							ds_list_add(isla, nodo)
							ds_list_remove(temp_red.edificios, nodo)
							if not visited[nodo.edificio_index]{
								visited[nodo.edificio_index] = true
								for(var a = 0; a < ds_list_size(nodo.energia_link); a++){
									var temp_edificio = nodo.energia_link[|a]
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
							bateria_max : 0
						}
						if red_bateria > 0
							temp_red_2.bateria = floor(temp_red.bateria * isla_bateria / red_bateria)
						for(var a = 0; a < ds_list_size(isla); a++){
							var temp_edificio = isla[|a]
							temp_edificio.red = temp_red_2
							if edificio_energia_consumo[temp_edificio.index] > 0
								temp_red_2.consumo += temp_edificio.energia_consumo
							else
								temp_red_2.generacion += temp_edificio.energy_output
							if in(edificio_nombre[temp_edificio.index], "Batería")
								temp_red_2.bateria_max += 2500
						}
						ds_list_add(redes, temp_red_2)
					}
				}
				ds_list_destroy(temp_red.edificios)
				ds_list_remove(redes, temp_red)
			}
			ds_list_destroy(edificio.energia_link)
		}
		//Flujos de cañerias
		if edificio_flujo[index]{
			var temp_flujo = edificio.flujo
			change_flujo(0, edificio)
			ds_list_remove(temp_flujo.edificios, edificio)
			if ds_list_empty(temp_flujo.edificios){
				ds_list_remove(flujos, temp_flujo)
				ds_list_destroy(temp_flujo.edificios)
			}
			else{
				temp_flujo.almacen_max -= edificio_flujo_almacen[index]
				temp_flujo.almacen = min(temp_flujo.almacen, temp_flujo.almacen_max)
				//Reordenamiento de redes de cañerías
				if ds_list_size(edificio.flujo_link) > 1{
					//Eliminar conecciones directas
					for(var a = 0; a < ds_list_size(edificio.flujo_link); a++){
						var temp_edificio = edificio.flujo_link[|a]
						ds_list_remove(temp_edificio.flujo_link, edificio)
					}
					ds_list_clear(edificio.flujo_link)
					//Revisar nuevo estado de red
					var flujo_almacen = 0
					for(var a = 0; a < ds_list_size(temp_flujo.edificios); a++)
						flujo_almacen += edificio_flujo_almacen[temp_flujo.edificios[|a].index]
					var agregado = ds_list_create(), visited = array_create(edificio_count, false)
					while not ds_list_empty(temp_flujo.edificios){
						var nodo = temp_flujo.edificios[|0]
						if not visited[nodo.edificio_index]{
							var isla = ds_list_create(), isla_almacen = 0, pila = ds_stack_create()
							ds_stack_push(pila, nodo)
							ds_list_add(agregado, nodo)
							while not ds_stack_empty(pila){
								nodo = ds_stack_pop(pila)
								isla_almacen += edificio_flujo_almacen[nodo.index]
								ds_list_add(isla, nodo)
								ds_list_remove(temp_flujo.edificios, nodo)
								if not visited[nodo.edificio_index]{
									visited[nodo.edificio_index] = true
									for(var a = 0; a < ds_list_size(nodo.flujo_link); a++){
										var temp_edificio = nodo.flujo_link[|a]
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
								almacen_max : 0
							}
							if flujo_almacen > 0
								temp_flujo_2.almacen = floor(temp_flujo.almacen * isla_almacen / flujo_almacen)
							for(var a = 0; a < ds_list_size(isla); a++){
								var temp_edificio = isla[|a]
								temp_edificio.flujo = temp_flujo_2
								temp_flujo_2.almacen_max += edificio_flujo_almacen[temp_edificio.index]
								if edificio_flujo_consumo[temp_edificio.index] > 0
									temp_flujo_2.consumo += temp_edificio.flujo_consumo
								else
									temp_flujo_2.generacion -= temp_edificio.flujo_consumo
							}
							ds_list_add(flujos, temp_flujo_2)
						}
					}
				ds_list_destroy(temp_flujo.edificios)
				ds_list_remove(flujos, temp_flujo)
				}
			}
			//Eliminar links
			for(var a = 0; a < ds_list_size(edificio.flujo_link); a++){
				var temp_edificio = edificio.flujo_link[|a]
				ds_list_remove(temp_edificio.flujo_link, edificio)
			}
			ds_list_destroy(edificio.flujo_link)
		}
		//Retorno de recursos
		if not cheat and not enemigo
			for(var a = 0; a < array_length(edificio_precio_id[index]); a++){
				nucleo.carga[edificio_precio_id[index, a]] += floor(edificio_precio_num[index, a] / 2)
				nucleo.carga_total += floor(edificio_precio_num[index, a] / 2)
			}
		//Camiar target de enemigos
		for(var a = 0; a < ds_list_size(enemigos); a++){
			var temp_enemigo = enemigos[|a]
			if temp_enemigo.target = edificio
				path_find(false, temp_enemigo)
		}
		delete(edificio)
	}
}