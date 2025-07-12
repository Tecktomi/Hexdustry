function delete_edificio(aa, bb){
	with control{
		var temp_terreno = terreno[aa, bb]
		if temp_terreno.edificio_bool
			var edificio = temp_terreno.edificio
		else
			exit
		ds_list_remove(edificios, edificio)
		//Cancelar coordenadas
		for(var a = 0; a < ds_list_size(edificio.coordenadas); a++){
			var temp_coordenada_2 = edificio.coordenadas[|a]
			var temp_terreno_2 = terreno[temp_coordenada_2.a, temp_coordenada_2.b]
			temp_terreno_2.edificio = null_edificio
			temp_terreno_2.edificio_bool = false
			temp_terreno_2.edificio_draw = false
		}
		ds_list_destroy(edificio.coordenadas)
		//Eliminar tuneles
		if edificio_nombre[edificio.index] = "Tunel" and not edificio.idle
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
		if edificio_electricidad[edificio.index]{
			var temp_red = edificio.red
			ds_list_remove(temp_red.edificios, edificio)
			//Eliminar conecciones directas
			for(var a = 0; a < ds_list_size(edificio.energy_link); a++){
				var temp_edificio = edificio.energy_link[|a]
				ds_list_remove(temp_edificio.energy_link, edificio)
			}
			ds_list_destroy(edificio.energy_link)
			//Eliminar la red si no hay más edificios
			if ds_list_empty(temp_red.edificios){
				ds_list_destroy(temp_red.edificios)
				ds_list_remove(redes, temp_red)
				delete(temp_red)
			}
			//Revisar nuevo estado de red
			else{
				var red_bateria = 0
				for(var a = 0; a < ds_list_size(temp_red.edificios); a++){
					var temp_edificio = temp_red.edificios[|a]
					if in(edificio_nombre[temp_edificio.index], "Bateria")
						red_bateria++}
				var visitado = ds_list_create(), agregado = ds_list_create()
				while not ds_list_empty(temp_red.edificios){
					var nodo = temp_red.edificios[|0]
					if not ds_list_in(visitado, nodo){
						var isla = ds_list_create(), isla_bateria = 0
						var pila = ds_stack_create()
						ds_stack_push(pila, nodo)
						ds_list_add(agregado, nodo)
						while not ds_stack_empty(pila){
							nodo = ds_stack_pop(pila)
							if in(edificio_nombre[nodo.index], "Bateria")
								isla_bateria ++
							ds_list_add(isla, nodo)
							ds_list_remove(temp_red.edificios, nodo)
							if not ds_list_in(visitado, nodo){
								ds_list_add(visitado, nodo)
								for(var a = 0; a < ds_list_size(nodo.energy_link); a++){
									var temp_edificio = nodo.energy_link[|a]
									if not ds_list_in(visitado, temp_edificio) and not ds_list_in(agregado, temp_edificio){
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
							if edificio_elec_consumo[temp_edificio.index] > 0
								temp_red_2.consumo += edificio_elec_consumo[temp_edificio.index]
							else
								temp_red_2.generacion += temp_edificio.energy_output
							if in(edificio_nombre[temp_edificio.index], "Bateria")
								temp_red_2.bateria_max += 1000
						}
						ds_list_add(redes, temp_red_2)
					}
				}
				ds_list_destroy(visitado)
				ds_list_destroy(temp_red.edificios)
				ds_list_remove(redes, temp_red)
				delete(temp_red)
			}
		}
		//Flujos de cañerias
		for(var a = 0; a < ds_list_size(edificio.flujo); a++){
			var temp_flujo = edificio.flujo[|a]
			ds_list_remove(temp_flujo.edificios, edificio)
			if ds_list_empty(temp_flujo.edificios){
				ds_list_remove(flujos, temp_flujo)
				ds_list_destroy(temp_flujo.edificios)
				delete(temp_flujo)
			}
		}
		ds_list_destroy(edificio.flujo)
		for(var a = 0; a < ds_list_size(edificio.flujo_link); a++){
			var temp_edificio = edificio.flujo_link[|a]
			ds_list_remove(temp_edificio.flujo_link, edificio)
		}
		ds_list_destroy(edificio.flujo_link)
		//Retorno de recursos
		if not cheat
			for(var a = 0; a < array_length(edificio_precio_index[edificio.index]); a++){
				nucleo.carga[edificio_precio_index[edificio.index, a]] += floor(edificio_precio_num[edificio.index, a] / 2)
				nucleo.carga_total += floor(edificio_precio_num[edificio.index, a] / 2)
			}
		delete(edificio)
	}
}