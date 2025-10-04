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
		var size = ds_list_size(edificios_targeteables)
		for(var a = 0; a < size; a++){
			var edificio = edificios_targeteables[|a]
			ds_grid_clear(edificio.coordenadas_dis, infinity)
			ds_list_clear(edificio.coordenadas_close)
			edificio_pathfind(edificio)
		}
	}
}