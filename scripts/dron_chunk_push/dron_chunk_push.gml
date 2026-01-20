function dron_chunk_push(dron = control.null_enemigo){
	with control{
		var a = dron.chunk_x, b = dron.chunk_y
		if dron.enemigo
			var temp_array = chunk_dron_enemigo[# a, b]
		else
			temp_array = chunk_dron_aliado[# a, b]
		dron.punteros[1] = array_length(temp_array)
		array_push(temp_array, dron)
		if dron.enemigo
			ds_grid_set(chunk_dron_enemigo, a, b, temp_array)
		else
			ds_grid_set(chunk_dron_aliado, a, b, temp_array)
	}
}