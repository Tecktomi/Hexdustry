function dron_chunk_remove(dron = control.null_dron){
	with control{
		var a = dron.chunk_x, b = dron.chunk_y, temp_array_dron = array_create(0, null_dron)
		if dron.enemigo
			temp_array_dron = chunk_dron_enemigo[# a, b]
		else
			temp_array_dron = chunk_dron_aliado[# a, b]
		var temp_dron = temp_array_dron[array_length(temp_array_dron) - 1], point = dron.punteros[1]
		array_set(temp_array_dron, point, temp_dron)
		temp_dron.punteros[1] = point
		array_pop(temp_array_dron)
		if dron.enemigo
			ds_grid_set(chunk_dron_enemigo, a, b, temp_array_dron)
		else
			ds_grid_set(chunk_dron_aliado, a, b, temp_array_dron)
	}
}