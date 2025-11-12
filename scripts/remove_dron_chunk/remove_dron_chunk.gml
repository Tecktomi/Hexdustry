function remove_dron_chunk(dron = control.null_enemigo){
	with control{
		var a = dron.chunk_x, b = dron.chunk_y, temp_array = chunk_enemigos[# a, b], len = array_length(temp_array)
		if dron.chunk_pointer != len - 1{
			var temp_dron = temp_array[len - 1]
			temp_array[dron.chunk_pointer] = temp_dron
			temp_dron.chunk_pointer = dron.chunk_pointer
		}
		array_pop(temp_array)
		ds_grid_set(chunk_enemigos, a, b, temp_array)
	}
}