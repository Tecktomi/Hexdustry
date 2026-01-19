function dron_chunk_push(dron = control.null_enemigo){
	with control{
		var a = dron.chunk_x, b = dron.chunk_y, temp_array = chunk_enemigos[# a, b]
		dron.punteros[1] = array_length(temp_array)
		array_push(temp_array, dron)
		ds_grid_set(chunk_enemigos, a, b, temp_array)
	}
}