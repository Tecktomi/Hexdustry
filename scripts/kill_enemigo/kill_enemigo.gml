function kill_enemigo(enemigo = null_enemigo){
	with control{
		var temp_list = ds_grid_get(chunk_enemigos, enemigo.chunk_x, enemigo.chunk_y)
		ds_list_remove(temp_list, enemigo)
		ds_list_remove(enemigos, enemigo)
		if mision_actual >= 0 and mision_objetivo[mision_actual] = 4 and ++mision_counter >= mision_target_num[mision_actual]
			pasar_mision()
	}
}