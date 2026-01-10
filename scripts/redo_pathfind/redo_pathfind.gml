function redo_pathfind(){
	with control{
		for(var a = 0; a < xsize; a++)
			for(var b = 0; b < ysize; b++){
				var temp_priority = ds_grid_get(edificio_cercano_priority, a, b)
				ds_priority_clear(temp_priority)
				ds_grid_clear(edificio_cercano, null_edificio)
				ds_grid_clear(edificio_cercano_dis, infinity)
				ds_grid_clear(edificio_cercano_dir, -1)
			}
		edificios_targeteables = array_create(0, null_edificio)
		for(var a = array_length(edificios) - 1; a >= 0; a--){
			var temp_edificio = edificios[a]
			if temp_edificio.index = id_nucleo
				array_push(edificios_targeteables, temp_edificio)
		}
		for(var a = array_length(edificios_targeteables) - 1; a >= 0; a--){
			var edificio = edificios_targeteables[a]
			ds_grid_clear(edificio.coordenadas_dis, infinity)
			ds_list_clear(edificio.coordenadas_close)
			edificio_pathfind(edificio)
		}
	}
}