function game_start(){
	with control{
		if not nucleo.vivo
			game_restart()
		if array_length(mision_nombre) > 0{
			mision_actual = -1
			pasar_mision()
		}
		win_step = 0
		menu = 1
		image_index = 0
		build_index = 0
		mision_counter = 0
		oleadas_timer = 0
		timer = 0
		enemigos_spawned = 3
		edificios_construidos = 0
		drones_construidos = 0
		enemigos_eliminados = 0
		ds_grid_clear(luz, 0)
		for(var a = 0; a < xsize; a++)
			for(var b = 0; b < ysize; b++){
				if terreno[# a, b] = 14
					add_luz(a, b, 1)
				if edificio_bool[# a, b]{
					var edificio = edificio_id[# a, b]
					if edificio != nucleo
						delete_edificio(a, b)
				}
			}
		for(var a = array_length(enemigos); a > 0; a--)
			destroy_dron(enemigos[a - 1])
		for(var a = array_length(drones_aliados); a > 0; a--)
			destroy_dron(drones_aliados[a - 1])
		for(var a = 0; a < rss_max; a++)
			nucleo.carga[a] = carga_inicial[a]
		for(var a = 0; a < xsize / chunk_width; a++)
			for(var b = 0; b < ysize / chunk_height; b++)
				update_background(a * chunk_width, b * chunk_height)
	}
}