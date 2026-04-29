function dron_chunk_push(dron = control.null_dron){
	with control{
		var a = dron.chunk_x, b = dron.chunk_y, temp_array_dron = array_create(0, null_dron)
		if dron.enemigo
			temp_array_dron = chunk_dron_enemigo[# a, b]
		else
			temp_array_dron = chunk_dron_aliado[# a, b]
		dron.punteros[1] = array_length(temp_array_dron)
		array_push(temp_array_dron, dron)
		if dron.enemigo
			ds_grid_set(chunk_dron_enemigo, a, b, temp_array_dron)
		else
			ds_grid_set(chunk_dron_aliado, a, b, temp_array_dron)
	}
}