function clear_edificios(){
	with control{
		array_resize(edificios_activos, 0)
		array_resize(edificios_pendientes, 0)
		array_resize(edificios_totales, 0)
		var a, b
		for(a = 0; a < EQUIPOS; a++){
			array_resize(puerto_carga_array[a], 0)
			array_resize(edificios_jugador[a], 0)
			array_resize(drones_jugador[a], 0)
			nucleos[a] = null_edificio
		}
		for(a = 0; a < chunk_xsize; a++)
			for(b = 0; b < chunk_ysize; b++){
				array_resize(chunk_edificios[# a, b], 0)
				array_resize(chunk_edificios_estatico[# a, b], 0)
				array_resize(chunk_edificios_dinamico[# a, b], 0)
				array_resize(chunk_edificios_draw[# a, b], 0)
			}
		array_resize(edificios, 0)
		array_resize(edificios_targeteables, 0)
		array_resize(edificios_salida_drones, 0)
		for(a = 0; a < edificio_max; a++)
			array_resize(edificios_index[a], 0)
		ds_grid_clear(edificio_bool, false)
		ds_grid_clear(edificio_id, null_edificio)
		array_resize(redes, 0)
		array_resize(flujos, 0)
		array_resize(luces, 0)
		array_resize(cambios, 0)
		ds_grid_clear(chunk_edificios_dirty, true)
		ds_grid_clear(chunk_edificios_background, spr_hexagono)
	}
}