function dron_chunk_remove(dron = control.null_dron){
	with control{
		var a = dron.chunk_x, b = dron.chunk_y, temp_array_dron = array_create(0, null_dron)
		temp_array_dron = ds_grid_get(chunk_dron, a, b)
		var temp_dron = array_last(temp_array_dron), point = dron.punteros[ptrd_chunk]
		temp_array_dron[point] = temp_dron
		temp_dron.punteros[ptrd_chunk] = point
		array_pop(temp_array_dron)
		chunk_dron[# a, b] = temp_array_dron
		temp_array_dron = ds_grid_get(chunk_dron_jugador[dron.jugador], a, b)
		temp_dron = array_last(temp_array_dron)
		point = dron.punteros[ptrd_chunk_jugador]
		temp_array_dron[point] = temp_dron
		temp_dron.punteros[ptrd_chunk_jugador] = point
		array_pop(temp_array_dron)
		ds_grid_set(chunk_dron_jugador[dron.jugador], a, b, temp_array_dron)
	}
}