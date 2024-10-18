function delete_edificio(edificio = control.null_edificio){
	ds_list_remove(control.edificios, edificio)
	//Cancelar coordenadas
	for(var a = 0; a < ds_list_size(edificio.coordenadas); a++){
		var temp_coordenada_2 = ds_list_find_value(edificio.coordenadas, a)
		var temp_terreno_2 = control.terreno[temp_coordenada_2.a, temp_coordenada_2.b]
		temp_terreno_2.edificio = control.null_edificio
		temp_terreno_2.edificio_bool = false
		temp_terreno_2.edificio_draw = false
	}
	ds_list_destroy(edificio.coordenadas)
	//Eliminar tuneles
	if control.edificio_nombre[edificio.index] = "Tunel" and not edificio.idle
		edificio.link.idle = true
	//Cancelar outputs
	for(var a = 0; a < ds_list_size(edificio.outputs); a++){
		var temp_edificio = ds_list_find_value(edificio.outputs, a)
		ds_list_remove(temp_edificio.inputs, edificio)
	}
	ds_list_destroy(edificio.outputs)
	//Cancelar inputs
	for(var a = 0; a < ds_list_size(edificio.inputs); a++){
		var temp_edificio = ds_list_find_value(edificio.inputs, a)
		ds_list_remove(temp_edificio.outputs, edificio)
		if temp_edificio.output_index >= ds_list_size(temp_edificio.outputs)
			temp_edificio.output_index = 0
	}
	//Cancelar red
	if control.edificio_electricidad[edificio.index]{
		var temp_red = edificio.red
		ds_list_remove(temp_red.edificios, edificio)
		//Eliminar conecciones directas
		for(var a = 0; a < ds_list_size(edificio.energy_link); a++){
			var temp_edificio = ds_list_find_value(edificio.energy_link, a)
			ds_list_remove(temp_edificio.energy_link, edificio)
		}
		ds_list_destroy(edificio.energy_link)
		//Eliminar la red si no hay más edificios
		if ds_list_empty(temp_red.edificios){
			ds_list_destroy(temp_red.edificios)
			ds_list_remove(control.redes, temp_red)
			delete(temp_red)
		}
		//Revisar nuevo estado de red
		else{
			var visitado = ds_list_create(), agregado = ds_list_create()
			while not ds_list_empty(temp_red.edificios){
				var nodo = ds_list_find_value(temp_red.edificios, 0)
				if not ds_list_in(visitado, nodo){
					var isla = ds_list_create()
					var pila = ds_stack_create()
					ds_stack_push(pila, nodo)
					ds_list_add(agregado, nodo)
					while not ds_stack_empty(pila){
						nodo = ds_stack_pop(pila)
						ds_list_add(isla, nodo)
						ds_list_remove(temp_red.edificios, nodo)
						if not ds_list_in(visitado, nodo){
							ds_list_add(visitado, nodo)
							for(var a = 0; a < ds_list_size(nodo.energy_link); a++){
								var temp_edificio = ds_list_find_value(nodo.energy_link, a)
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
						bateria: 0
					}
					for(var a = 0; a < ds_list_size(isla); a++){
						var temp_edificio = ds_list_find_value(isla, a)
						temp_edificio.red = temp_red_2
						if control.edificio_elec_consumo[temp_edificio.index] > 0
							temp_red_2.consumo += control.edificio_elec_consumo[temp_edificio.index]
						else
							temp_red_2.generacion -= control.edificio_elec_consumo[temp_edificio.index]
					}
					ds_list_add(control.redes, temp_red_2)
				}
			}
			ds_list_destroy(visitado)
			ds_list_destroy(temp_red.edificios)
			ds_list_remove(control.redes, temp_red)
			delete(temp_red)
		}
		ds_list_remove(control.edificios_cable, edificio)
	}
	ds_list_destroy(edificio.inputs)
	delete(edificio)
}