function new_data(){
	with control{
		data = {
			edificios : array_create(0, null_edificio),
			drones : array_create(0, null_dron),
			chunk_edificios : ds_grid_create(chunk_xsize, chunk_ysize),
			chunk_drones : ds_grid_create(chunk_xsize, chunk_ysize),
			edificios_id : array_create(edificio_max, array_create(0, null_edificio))
		}
		ds_grid_clear(data.chunk_edificios, array_create(0, null_edificio))
		ds_grid_clear(data.chunk_drones, array_create(0, null_dron))
		for(var a = 0; a < edificio_max; a++)
			data.edificios_id[a] = array_create(0, null_edificio)
		return data
	}
}