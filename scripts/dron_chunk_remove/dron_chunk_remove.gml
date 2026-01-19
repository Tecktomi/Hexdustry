function dron_chunk_remove(dron = control.null_enemigo){
	with control{
		var a = dron.chunk_x, b = dron.chunk_y, temp_array = chunk_enemigos[# a, b], temp_dron = temp_array[array_length(temp_array) - 1], point = dron.punteros[1]
		temp_array[point] = temp_dron
		temp_dron.punteros[1] = point
		array_pop(temp_array)
		ds_grid_set(chunk_enemigos, a, b, temp_array)
	}
}