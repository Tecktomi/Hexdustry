function delete_edificio_flujo(edificio = control.null_edificio, flujo = control.null_flujo){
	with control{
		var index = edificio.index, a, temp_edificio, temp_complex
		var flujo_link = (flujo = edificio.flujo) ? edificio.flujo_link : edificio.flujo_2_link
		change_flujo(0, edificio, flujo)
		array_remove(flujo.edificios, edificio)
		if array_length(flujo.edificios) = 0{
			array_disorder_remove(flujos, flujo, 0)
			delete(flujo.edificios)
		}
		else{
			flujo.almacen_max -= edificio_flujo_almacen[index]
			flujo.almacen = min(flujo.almacen, flujo.almacen_max)
			//Reordenamiento de redes de cañerías
			if array_length(flujo_link) > 1{
				//Eliminar conecciones directas
				for(a = array_length(flujo_link) - 1; a >= 0; a--){
					temp_edificio = flujo_link[a]
					array_remove((temp_edificio.flujo = flujo) ? temp_edificio.flujo_link : temp_edificio.flujo_2_link, edificio)
				}
				array_resize((flujo = edificio.flujo) ? edificio.flujo_link : edificio.flujo_2_link, 0)
				//Revisar nuevo estado de red
				var flujo_almacen = 0, agregado = array_create(0, null_edificio), visited = array_create(edificio_count, false), nodo, isla, isla_almacen, pila, temp_flujo_link, temp_flujo_2
				for(a = array_length(flujo.edificios) - 1; a >= 0; a--)
					flujo_almacen += edificio_flujo_almacen[flujo.edificios[a].index]
				while array_length(flujo.edificios) > 0{
					nodo = flujo.edificios[array_length(flujo.edificios) - 1]
					if not visited[nodo.edificio_index]{
						isla = array_create(0)
						isla_almacen = 0
						pila = ds_stack_create()
						ds_stack_push(pila, nodo)
						array_push(agregado, nodo)
						while not ds_stack_empty(pila){
							nodo = ds_stack_pop(pila)
							isla_almacen += edificio_flujo_almacen[nodo.index]
							array_push(isla, nodo)
							array_remove(flujo.edificios, nodo)
							if not visited[nodo.edificio_index]{
								visited[nodo.edificio_index] = true
								temp_flujo_link = (nodo.flujo = flujo) ? nodo.flujo_link : nodo.flujo_2_link
								for(a = array_length(temp_flujo_link) - 1; a >= 0; a--){
									temp_edificio = temp_flujo_link[a]
									if not visited[temp_edificio.edificio_index] and not array_contains(agregado, temp_edificio){
										ds_stack_push(pila, temp_edificio)
										array_push(agregado, temp_edificio)
									}
								}
							}
						}
						ds_stack_destroy(pila)
						temp_flujo_2 = def_flujo()
						temp_flujo_2.edificios = isla
						temp_flujo_2.liquido = flujo.liquido
						if flujo_almacen > 0
							temp_flujo_2.almacen = floor(flujo.almacen * isla_almacen / flujo_almacen)
						for(a = array_length(isla) - 1; a >= 0; a--){
							temp_edificio = isla[a]
							if temp_edificio.flujo = flujo
								temp_edificio.flujo = temp_flujo_2
							else
								temp_edificio.flujo_2 = temp_flujo_2
							temp_flujo_2.almacen_max += edificio_flujo_almacen[temp_edificio.index]
							if edificio_flujo_consumo[temp_edificio.index] > 0
								temp_flujo_2.consumo += temp_edificio.flujo_consumo
							else
								temp_flujo_2.generacion -= temp_edificio.flujo_consumo
						}
						array_disorder_push(flujos, temp_flujo_2, 0)
					}
				}
			delete(flujo.edificios)
			array_disorder_remove(flujos, flujo, 0)
			}
		}
		//Eliminar links
		flujo_link = (flujo = edificio.flujo) ? edificio.flujo_link : edificio.flujo_2_link
		for(a = array_length(flujo_link) - 1; a >= 0; a--){
			temp_edificio = flujo_link[a]
			array_remove((temp_edificio.flujo = flujo) ? temp_edificio.flujo_link : temp_edificio.flujo_2_link, edificio)
		}
		array_resize((flujo = edificio.flujo) ? edificio.flujo_link : edificio.flujo_2_link, 0)
		if index = id_tuberia_subterranea
			edificio.link.link = null_edificio
		var temp_list = get_arround(edificio.a, edificio.b, edificio.dir, edificio_size[index]), aaa, bbb
		for(a = array_length(temp_list) - 1; a >= 0; a--){
			temp_complex = temp_list[a]
			aaa = temp_complex[0]
			bbb = temp_complex[1]
			if aaa < 0 or bbb < 0 or aaa >= xsize or bbb >= ysize or not edificio_bool[# aaa, bbb]
				continue
			temp_edificio = edificio_id[# aaa, bbb]
			if temp_edificio.index = id_tuberia
				tuberia_arround(temp_edificio)
		}
	}
}