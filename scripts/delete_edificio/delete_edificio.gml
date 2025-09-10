function delete_edificio(aa, bb, enemigo = false){
	with control{
		var temp_terreno = terreno[aa, bb]
		if not temp_terreno.edificio_bool
			exit
		var edificio = temp_terreno.edificio, index = edificio.index, var_edificio_nombre = edificio_nombre[index]
		if index = 0 and menu = 1{
			if show_question("Has perdido, jugar de nuevo?")
				game_restart()
			else
				game_end()
		}
		ds_list_remove(edificios, edificio)
		ds_grid_destroy(edificio.coordenadas_dis)
		if not edificio_camino[index] and not in(var_edificio_nombre, "Tubería")
			ds_list_remove(edificios_targeteables, edificio)
		//Cancelar coordenadas
		for(var i = 0; i < ds_list_size(edificio.coordenadas); i++){
			var temp_coordenada_2 = edificio.coordenadas[|i], a = temp_coordenada_2.a, b = temp_coordenada_2.b
			var temp_terreno_2 = terreno[a, b]
			temp_terreno_2.edificio = null_edificio
			temp_terreno_2.edificio_bool = false
			temp_terreno_2.edificio_draw = false
			ds_grid_set(edificio_cercano, a, b, null_edificio)
			ds_grid_set(edificio_cercano_dis, a, b, infinity)
		}
		ds_list_destroy(edificio.coordenadas)
		if not ds_list_empty(edificios_targeteables)
			for(var a = 0; a < xsize; a++)
				for(var b = 0; b < ysize; b++)
					if terreno_caminable[terreno[a, b].terreno]{
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
								while not temp_edificio.vivo{
									ds_priority_delete_min(temp_priority)
									temp_edificio = ds_priority_find_min(temp_priority)
								}
								ds_grid_set(edificio_cercano, a, b, temp_edificio)
								ds_grid_set(edificio_cercano_dis, a, b, temp_edificio.coordenadas_dis[# a, b])
							}
						}
					}
		edificio.vivo = false
		/*
		var temp_priority = ds_priority_create()
	    for(var i = 0; i < ds_list_size(edificio.coordenadas_close); i++){
	        var a = edificio.coordenadas_close[|i].a, b = edificio.coordenadas_close[|i].b
			ds_priority_add(temp_priority, {a : a, b : b}, edificio_cercano_dis[# a, b])
	        ds_grid_set(edificio_cercano_dis, a, b, infinity)
	        ds_grid_set(edificio_cercano, a, b, null_edificio)
			var temp_priority_2 = ds_grid_get(edificio_cercano_priority, a, b)
			ds_priority_delete_min(temp_priority_2)
			var temp_edificio = ds_priority_find_min(temp_priority_2)
			show_debug_message(edificio_nombre[temp_edificio.index])
			ds_grid_set(edificio_cercano, a, b, temp_edificio)
			ds_grid_set(edificio_cercano_dis, a, b, temp_edificio.coordenadas_dis[# a, b])
	    }
	    ds_list_destroy(edificio.coordenadas_close)
		if false
	    while not ds_priority_empty(temp_priority){
	        var cell = ds_priority_delete_max(temp_priority), ca = cell.a, cb = cell.b
	        for(var i = 0; i < 6; i++){
	            var n = next_to(ca, cb, i), na = n.a, nb = n.b;
	            if na < 0 or nb < 0 or na >= xsize or nb >= ysize or not terreno_caminable[terreno[na, nb].terreno]
					continue
	            var vecino_dis = edificio_cercano_dis[# na, nb]
				if vecino_dis = infinity
					continue
				var dist_actual = edificio_cercano_dis[# ca, cb]
				var vecino_obj = ds_grid_get(edificio_cercano, na, nb)
	            if vecino_obj != null_edificio and vecino_obj != edificio{
	                var nueva_dist = vecino_dis + 1
	                if nueva_dist < edificio_cercano_dis[# ca, cb]{
	                    ds_grid_set(edificio_cercano_dis, ca, cb, nueva_dist)
	                    ds_grid_set(edificio_cercano, ca, cb, vecino_obj)
	                    ds_list_add(vecino_obj.coordenadas_close, {a: ca, b: cb})
	                    ds_priority_add(temp_priority, {a: ca, b: cb}, nueva_dist)
	                }
	            }
	        }
	    }
	    ds_priority_destroy(temp_priority)
		*/
		ds_grid_clear(edificio_cercano_dir, -1)
		//Eliminar tuneles
		if var_edificio_nombre = "Túnel" and not edificio.idle
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
				var agregado = ds_list_create(), visited = array_create(edificio_max, false)
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
					var agregado = ds_list_create(), visited = array_create(edificio_max, false)
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