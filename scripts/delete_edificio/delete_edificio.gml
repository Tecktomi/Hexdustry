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
	ds_list_destroy(edificio.inputs)
	delete(edificio)
}