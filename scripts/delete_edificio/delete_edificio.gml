function delete_edificio(aa, bb, enemigo = false){
	with control{
		if not edificio_bool[# aa, bb]
			exit
		var edificio = edificio_id[# aa, bb], index = edificio.index, var_edificio_nombre = edificio_nombre[index]
		var pre_vida = edificio.vida
		edificio.vida = 0
		if index = 0{
			array_remove(nucleos, edificio)
			if menu = 1 and array_length(nucleos) = 0
				win = 2
		}
		array_remove(edificios, edificio)
		edificios_counter[index]--
		ds_grid_destroy(edificio.coordenadas_dis)
		if index = 0
			array_remove(edificios_targeteables, edificio)
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
		desactivar_edificio(edificio)
		for(var i = real(var_edificio_nombre = "Procesador"); i < array_length(edificio.procesador_link); i++)
			array_remove(edificio.procesador_link[i].procesador_link, edificio)
		var temp_array = chunk_edificios[# edificio.chunk_x, edificio.chunk_y], temp_edificio = temp_array[array_length(temp_array) - 1]
		temp_array[edificio.chunk_pointer] = temp_edificio
		temp_edificio.chunk_pointer = edificio.chunk_pointer
		array_pop(temp_array)
		#region Torres reparadoras
			if var_edificio_nombre = "Torre Reparadora"{
				array_remove(torres_reparadoras, edificio)
				for(var c = array_length(edificio.edificios_cercanos) - 1; c >= 0; c--){
					temp_edificio = edificio.edificios_cercanos[c]
					array_remove(temp_edificio.reparadores_cercanos, edificio)
				}
			}
			var flag = pre_vida < edificio_vida[index]
			for(var c = array_length(edificio.reparadores_cercanos) - 1; c >= 0; c--){
				temp_edificio = edificio.reparadores_cercanos[c]
				array_remove(temp_edificio.edificios_cercanos, edificio)
				if flag
					array_remove(temp_edificio.edificios_cercanos_heridos, edificio)
				if temp_edificio.link = edificio
					temp_edificio.link = null_edificio
			}
		#endregion
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
		if grafic_luz and edificio.luz{
			var temp_list = edificio.coordenadas
			for(var b = ds_list_size(temp_list) - 1; b >= 0; b--){
				var temp_complex = temp_list[|b]
				add_luz(temp_complex.a, temp_complex.b, -1)
			}
		}
		if enemigo{
			ds_grid_set(repair_id, aa, bb, index)
			ds_grid_set(repair_dir, aa, bb, edificio.dir)
		}
		ds_list_destroy(edificio.coordenadas)
		if index = 0 and array_length(edificios_targeteables) > 0
			for(var a = 0; a < xsize; a++)
				for(var b = 0; b < ysize; b++)
					if terreno_caminable[terreno[# a, b]]{
						var temp_priority = ds_grid_get(edificio_cercano_priority, a, b)
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
		ds_grid_clear(edificio_cercano_dir, -1)
		if edificio_armas[index]{
			if edificio.target != null_enemigo and edificio.target.vida > 0
				array_remove(edificio.target.torres, edificio)
		}
		//Eliminar tuneles
		if in(var_edificio_nombre, "Túnel", "Túnel salida") and not edificio.idle
			edificio.link.idle = true
		//Cancelar outputs
		for(var a = array_length(edificio.outputs) - 1; a >= 0; a--){
			temp_edificio = edificio.outputs[a]
			array_remove(temp_edificio.inputs, edificio)
			if edificio_nombre[temp_edificio.index] = "Cinta Transportadora"
				camino_calcular_in(temp_edificio)
		}
		delete(edificio.outputs)
		//Cancelar inputs
		for(var a = array_length(edificio.inputs) - 1; a >= 0; a--){
			temp_edificio = edificio.inputs[a]
			array_remove(temp_edificio.outputs, edificio)
			if temp_edificio.output_index >= array_length(temp_edificio.outputs)
				temp_edificio.output_index = 0
		}
		delete(edificio.inputs)
		//Cancelar red
		if edificio_energia[index]{
			var temp_red = edificio.red
			array_remove(temp_red.edificios, edificio)
			if var_edificio_nombre = "Torre de Alta Tensión"{
				var a = array_get_index(torres_de_tension, edificio)
				torres_de_tension[a] = torres_de_tension[array_length(torres_de_tension) - 1]
				array_pop(torres_de_tension)
			}
			//Eliminar la red si no hay más edificios
			if array_length(temp_red.edificios) = 0{
				delete(temp_red.edificios)
				array_remove(redes, temp_red)
			}
			else{
				change_energia(0, edificio)
				//Eliminar conecciones directas
				for(var a = array_length(edificio.energia_link) - 1; a >= 0; a--){
					temp_edificio = edificio.energia_link[a]
					array_remove(temp_edificio.energia_link, edificio)
				}
				//Revisar nuevo estado de red
				var red_bateria = 0
				for(var a = array_length(temp_red.edificios) - 1; a >= 0; a--){
					temp_edificio = temp_red.edificios[a]
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
									temp_edificio = nodo.energia_link[a]
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
							eficiencia : 0
						}
						if red_bateria > 0
							temp_red_2.bateria = floor(temp_red.bateria * isla_bateria / red_bateria)
						for(var a = array_length(isla) - 1; a >= 0; a--){
							temp_edificio = isla[a]
							temp_edificio.red = temp_red_2
							if edificio_energia_consumo[temp_edificio.index] > 0
								temp_red_2.consumo += abs(temp_edificio.energia_consumo)
							else
								temp_red_2.generacion += abs(temp_edificio.energia_consumo)
							if temp_edificio.index = id_bateria
								temp_red_2.bateria_max += 2500
						}
						array_push(redes, temp_red_2)
					}
				}
				delete(temp_red.edificios)
				array_remove(redes, temp_red)
			}
			delete(edificio.energia_link)
		}
		//Flujos de cañerias
		if edificio_flujo[index]{
			var temp_flujo = edificio.flujo
			change_flujo(0, edificio)
			array_remove(temp_flujo.edificios, edificio)
			if array_length(temp_flujo.edificios) = 0{
				array_remove(flujos, temp_flujo)
				delete(temp_flujo.edificios)
			}
			else{
				temp_flujo.almacen_max -= edificio_flujo_almacen[index]
				temp_flujo.almacen = min(temp_flujo.almacen, temp_flujo.almacen_max)
				//Reordenamiento de redes de cañerías
				if array_length(edificio.flujo_link) > 1{
					//Eliminar conecciones directas
					for(var a = array_length(edificio.flujo_link) - 1; a >= 0; a--){
						temp_edificio = edificio.flujo_link[a]
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
										temp_edificio = nodo.flujo_link[a]
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
								eficiencia : 0
							}
							if flujo_almacen > 0
								temp_flujo_2.almacen = floor(temp_flujo.almacen * isla_almacen / flujo_almacen)
							for(var a = array_length(isla) - 1; a >= 0; a--){
								temp_edificio = isla[a]
								temp_edificio.flujo = temp_flujo_2
								temp_flujo_2.almacen_max += edificio_flujo_almacen[temp_edificio.index]
								if edificio_flujo_consumo[temp_edificio.index] > 0
									temp_flujo_2.consumo += temp_edificio.flujo_consumo
								else
									temp_flujo_2.generacion -= temp_edificio.flujo_consumo
							}
							array_push(flujos, temp_flujo_2)
						}
					}
				delete(temp_flujo.edificios)
				array_remove(flujos, temp_flujo)
				}
			}
			//Eliminar links
			for(var a = array_length(edificio.flujo_link) - 1; a >= 0; a--){
				temp_edificio = edificio.flujo_link[a]
				array_remove(temp_edificio.flujo_link, edificio)
			}
			delete(edificio.flujo_link)
			if var_edificio_nombre = "Tubería Subterránea"
				edificio.link.link = null_edificio
		}
		//Retorno de recursos
		if not cheat and not enemigo{
			var b = pre_vida / edificio_vida[index]
			for(var a = array_length(edificio_precio_id[index]) - 1; a >= 0; a--){
				var c = floor(b * edificio_precio_num[index, a] / 2)
				nucleo.carga[edificio_precio_id[index, a]] += c
				nucleo.carga_total += c
			}
		}
		//Camiar target de enemigos
		size = array_length(enemigos)
		for(var a = 0; a < size; a++){
			var temp_enemigo = enemigos[a]
			if temp_enemigo.target = edificio{
				var temp_complex = xytoab(temp_enemigo.a, temp_enemigo.b)
				if temp_complex.a >= 0
					enemigo.target = edificio_cercano[# temp_complex.a, temp_complex.b]
			}
		}
		//Explosión Nuclear
		if enemigo and var_edificio_nombre = "Planta Nuclear" and edificio.fuel > 0{
			var xpos = edificio.x, ypos = edificio.y
			//Daño edificios
			for(var i = array_length(edificios) - 1; i >= 0; i--){
				temp_edificio = edificios[i]
				var dis = distance_sqr(xpos, ypos, temp_edificio.x, temp_edificio.y)
				if dis > 160_000 //400^2
					continue
				if edificio_herir(temp_edificio, 9_000_000 / dis * random_range(0.7, 1.3)){
					size--
					i--
				}
			}
			//Daño enemigos
			size = array_length(enemigos)
			for(var i = 0; i < size; i++){
				enemigo = enemigos[i]
				var dis = distance_sqr(xpos, ypos, enemigo.a, enemigo.b)
				if dis > 160_000//400^2
					continue
				enemigo.vida -= 9_000_000 / dis * random_range(0.7, 1.3)
				if enemigo.vida > 0
					continue
				destroy_dron(enemigo)
				size--
				i--
			}
			//Daño drones aliados
			size = array_length(drones_aliados)
			for(var i = 0; i < size; i++){
				var dron = drones_aliados[i], dis = distance_sqr(xpos, ypos, dron.a, dron.b)
				if dis > 160_000//400^2
					continue
				dron.vida -= 9_000_000 / dis * random_range(0.7, 1.3)
				if dron.vida > 0
					continue
				var temp_dron = drones_aliados[array_length(drones_aliados) - 1]
				drones_aliados[dron.pointer] = temp_dron
				temp_dron.pointer = dron.pointer
				array_pop(drones_aliados)
				size--
				i--
			}
			nuclear_x = xpos
			nuclear_y = ypos
			nuclear_step = 300
		}
		delete(edificio)
	}
}