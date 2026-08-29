function dron_chunk_remove(dron = control.null_dron, _jugador = 0){
	with control{
		var a = dron.chunk_x, b = dron.chunk_y, temp_array_dron = array_create(0, null_dron)
		temp_array_dron = chunk_dron[# a, b]
		var temp_dron = temp_array_dron[array_length(temp_array_dron) - 1], point = dron.punteros[1]
		array_set(temp_array_dron, point, temp_dron)
		temp_dron.punteros[ptrd_chunk] = point
		array_pop(temp_array_dron)
		ds_grid_set(chunk_dron, a, b, temp_array_dron)
	}
}