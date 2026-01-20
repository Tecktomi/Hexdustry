function dron_chunk_remove(dron = control.null_enemigo){
	with control{
		var a = dron.chunk_x, b = dron.chunk_y
		if dron.enemigo
			var temp_array = chunk_dron_enemigo[# a, b]
		else
			temp_array = chunk_dron_aliado[# a, b]
		var temp_dron = temp_array[array_length(temp_array) - 1], point = dron.punteros[1]
		temp_array[point] = temp_dron
		temp_dron.punteros[1] = point
		array_pop(temp_array)
		if dron.enemigo
			ds_grid_set(chunk_dron_enemigo, a, b, temp_array)
		else
			ds_grid_set(chunk_dron_aliado, a, b, temp_array)
	}
}