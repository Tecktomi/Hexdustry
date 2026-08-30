function redo_pathfind(){
	with control{
		var a, b, temp_priority, edificio
		for(a = 0; a < xsize; a++)
			for(b = 0; b < ysize; b++){
				temp_priority = ds_grid_get(edificio_cercano_priority, a, b)
				ds_priority_clear(temp_priority)
			}
		ds_grid_clear(edificio_cercano, null_edificio)
		ds_grid_clear(edificio_cercano_dis, infinity)
		ds_grid_clear(edificio_cercano_dir, -1)
		for(a = array_length(edificios_index[id_nucleo]) - 1; a >= 0; a--){
			edificio = edificios_index[id_nucleo][a]
			ds_grid_clear(edificio.coordenadas_dis, infinity)
			edificio_pathfind(edificio)
		}
	}
}