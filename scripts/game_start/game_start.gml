function game_start(_nucleo = true, mision_cumplida = false){
	with control{
		var a, temp_array, b, temp_complex
		if _nucleo and array_length(edificios_index[id_nucleo]) = 0{
			if mapa >= 0
			    load_escenario_buffer($"{DEFAULT_MAPS[mapa]}.txt", false)
			else{
			    biome_seed = irandom(2)
			    seed = random_get_seed()
			    generar_bioma(biome_seed)
			}
		}
		redo_pathfind()
		if mision_cumplida
			oleadas = false
		else
		if array_length(misiones) > 0{
			mision_actual = -1
			pasar_mision()
		}
		if tecnologia
			for(a = 0; a < edificio_max; a++){
				temp_array = tecnologia_precio_num[a]
				for(b = 0; b < array_length(temp_array); b++)
					temp_array[b] = round(tecnologia_precio_multiplicador * temp_array[b])
			}
		clear_edit()
		pausa = 0
		input_layer = 0
		get_file = 0
		win_step = 0
		menu = 1
		image_index = 0
		mision_counter = 0
		oleadas_timer = 0
		timer = 0
		win = 0
		oleada_count = 0
		edificios_construidos = 0
		drones_construidos = 0
		enemigos_eliminados = 0
		tecnologias_estudiadas = 0
		recursos_obtenidos = array_create(rss_max, 0)
		recursos_obtenidos_time_temp = array_create(rss_max, 0)
		recursos_obtenidos_time = array_create(0, array_create(rss_max, 0))
		luces = array_create(0, {a : 0, b : 0, x : 0, y : 0, r : 0})
		clic_sound = false
		editor_enemigo = false
		for(a = 0; a < xsize; a++)
			for(b = 0; b < ysize; b++)
				if terreno[# a, b] = idt_lava{
					temp_complex = abtoxy(a, b)
					array_push(luces, {a : a, b : b, x : temp_complex[0], y : temp_complex[1], r : 10, source : null_edificio})
				}
		for(a = array_length(drones) - 1; a >= 0; a--)
			delete_dron(drones[a])
		for(a = 0; a < rss_max; a++)
			for(b = 0; b < EQUIPOS; b++)
				array_set(jugador_recursos[b], a, carga_inicial[a])
		for(a = 0; a < chunk_xsize; a++)
			for(b = 0; b < chunk_ysize; b++)
				update_background(a * CHUNK_WIDTH, b * CHUNK_HEIGHT)
		grafic_hideui = false
		check_water_target()
	}
}