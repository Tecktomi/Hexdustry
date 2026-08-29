function dron_chunk_push(dron = control.null_dron){
	with control{
		var a = dron.chunk_x, b = dron.chunk_y, temp_array_dron = array_create(0, null_dron)
		temp_array_dron = chunk_dron[# a, b]
		dron.punteros[1] = array_length(temp_array_dron)
		array_disorder_push(temp_array_dron, dron, ptrd_chunk)
		ds_grid_set(chunk_dron, a, b, temp_array_dron)
	}
}