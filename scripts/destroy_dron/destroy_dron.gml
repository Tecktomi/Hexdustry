function destroy_dron(enemigo = null_enemigo){
	with control{
		
		var temp_array = ds_grid_get(chunk_enemigos, enemigo.chunk_x, enemigo.chunk_y), temp_enemigo = temp_array[array_length(temp_array) - 1]
		temp_array[enemigo.chunk_pointer] = temp_enemigo
		temp_enemigo.chunk_pointer = enemigo.chunk_pointer
		array_pop(temp_array)
		temp_enemigo = enemigos[array_length(enemigos) - 1]
		enemigos[enemigo.pointer] = temp_enemigo
		temp_enemigo.pointer = enemigo.pointer
		array_pop(enemigos)
		if mision_actual >= 0 and mision_objetivo[mision_actual] = 4 and ++mision_counter >= mision_target_num[mision_actual]
			pasar_mision()
	}
}