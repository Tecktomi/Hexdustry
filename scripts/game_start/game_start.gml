function game_start(){
	with control{
		if not nucleo.vivo
			game_restart()
		redo_pathfind()
		if array_length(mision_nombre) > 0{
			mision_actual = -1
			pasar_mision()
		}
		if tecnologia
			for(var a = 0; a < edificio_max; a++){
				var temp_array = edificio_tecnologia_precio[a]
				for(var b = 0; b < array_length(temp_array); b++)
					temp_array[b].num = round(tecnologia_precio_multiplicador * temp_array[b].num)
			}
		input_layer = 0
		get_file = 0
		win_step = 0
		menu = 1
		image_index = 0
		build_index = 0
		mision_counter = 0
		oleadas_timer = 0
		timer = 0
		win = 0
		oleada_count = 0
		edificios_construidos = 0
		drones_construidos = 0
		enemigos_eliminados = 0
		tecnologias_estudiadas = 0
		flow = 0
		recursos_obtenidos = array_create(rss_max, 0)
		recursos_obtenidos_time_temp = array_create(rss_max, 0)
		recursos_obtenidos_time = array_create(0, array_create(rss_max, 0))
		camx = clamp(nucleo.a * 48 - room_width / 2, 0, xsize * 48 * zoom - room_width)
		camy = clamp(nucleo.b * 14 - room_height / 2, 0, ysize * 14 * zoom - room_height)
		luces = array_create(0, {a : 0, b : 0, x : 0, y : 0, r : 0})
		clic_sound = false
		editor_enemigo = false
		for(var a = 0; a < xsize; a++)
			for(var b = 0; b < ysize; b++){
				if terreno[# a, b] = idt_lava{
					var temp_complex = abtoxy(a, b)
					array_push(luces, {a : a, b : b, x : temp_complex.a, y : temp_complex.b, r : 10, source : null_edificio})
				}
				if edificio_bool[# a, b]{
					var edificio = edificio_id[# a, b]
					if edificio != nucleo and not edificio.enemigo
						delete_edificio(edificio)
				}
			}
		for(var a = array_length(enemigos) - 1; a >= 0; a--)
			delete_dron(enemigos[a])
		for(var a = array_length(drones_aliados) - 1; a >= 0; a--)
			delete_dron(drones_aliados[a])
		for(var a = 0; a < rss_max; a++)
			nucleo.carga[a] = carga_inicial[a]
		for(var a = 0; a < chunk_xsize; a++)
			for(var b = 0; b < chunk_ysize; b++)
				update_background(a * chunk_width, b * chunk_height)
		ini_open("settings.ini")
			info = bool(ini_read_real("", "info", 0))
			grafic_tile_animation = bool(ini_read_real("", "grafic_tile_animation", 1))
			grafic_luz = bool(ini_read_real("", "grafic_luz", 0))
			grafic_humo = bool(ini_read_real("", "grafic_humo", 1))
			grafic_hideui = false
		ini_close()
	}
}