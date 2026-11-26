function save_game_buffer(buffer){
	with control{
		buffer_write(buffer, buffer_u32, FILE_VERSION)
		if tutorial > 0
			buffer_write(buffer, buffer_s8, -1 - tutorial)
		else{
			buffer_write(buffer, buffer_s8, mapa)
			if mapa = -1{
				buffer_write(buffer, buffer_u32, seed)
				buffer_write(buffer, buffer_u8, biome_seed)
				buffer_write(buffer, buffer_u16, xsize)
				buffer_write(buffer, buffer_u16, ysize)
			}
		}
		buffer_write(buffer, buffer_u32, sim_seed[0])
		buffer_write(buffer, buffer_f64, camx)
		buffer_write(buffer, buffer_f64, camy)
		buffer_write(buffer, buffer_f64, zoom)
		buffer_write(buffer, buffer_u32, timer)
		buffer_write(buffer, buffer_u32, oleadas_timer)
		buffer_write(buffer, buffer_u32, oleadas_tiempo)
		buffer_write(buffer, buffer_u32, oleadas_tiempo_primera)
		buffer_write(buffer, buffer_u8, oleada_count)
		buffer_write(buffer, buffer_bool, tecnologia)
		buffer_write(buffer, buffer_f64, tecnologia_precio_multiplicador)
		buffer_write(buffer, buffer_f64, multiplicador_vida_enemigos)
		buffer_write(buffer, buffer_s8, dificultad)
		buffer_write(buffer, buffer_bool, modo_misiones)
		buffer_write(buffer, buffer_u8, clima)
		buffer_write(buffer, buffer_u64, clima_change)
		buffer_write(buffer, buffer_bool, oleadas)
		buffer_write(buffer, buffer_u8, game_mode)
		buffer_write(buffer, buffer_u8, EQUIPO_LIMIT)
		buffer_write(buffer, buffer_bool, ia_spawn_preparado)
		var len, a, b, c, _mision, len_2, temp_texto, edificio, dron, red, flujo, i, municion, mask, _repair_array = repair_array[jugador]
		#region Menas
			for(a = 0; a < xsize; a++)
				for(b = 0; b < ysize; b++){
					buffer_write(buffer, buffer_s8, ore[# a, b])
					if ore[# a, b] >= 0
						buffer_write(buffer, buffer_u16, ore_amount[# a, b])
				}
			len = array_length(betas)
			buffer_write(buffer, buffer_u16, len)
			for(a = 0; a < len; a++){
				len_2 = array_length(betas[a].terrenos)
				buffer_write(buffer, buffer_u16, len_2)
				for(b = 0; b < len_2; b++)
					buffer_write(buffer, buffer_u16, betas[a].terrenos[b])
			}
		#endregion
		#region Misiones
			save_mision(buffer)
			buffer_write(buffer, buffer_u8, min(mision_camara_step, 255))
			buffer_write(buffer, buffer_f64, mision_camera_x_start)
			buffer_write(buffer, buffer_f64, mision_camera_y_start)
			buffer_write(buffer, buffer_string, mision_texto_victoria)
			buffer_write(buffer, buffer_s8, mision_actual)
			buffer_write(buffer, buffer_u16, mision_counter)
			buffer_write(buffer, buffer_s16, mision_current_tiempo)
			buffer_write(buffer, buffer_bool, mision_choosing_coord)
		#endregion
		for(a = 0; a < rss_max; a++)
			for(b = 0; b < EQUIPOS; b++)
				buffer_write(buffer, buffer_u32, max(jugador_recursos[b, a], 0))
		buffer_write(buffer, buffer_u32, image_index)
		len = array_length(_repair_array)
		buffer_write(buffer,buffer_u64, len)
		buffer_write(buffer,buffer_u8, jugador)
		for(a = 0; a < len; a += 6){
			buffer_write(buffer, buffer_u16, _repair_array[a])
			buffer_write(buffer, buffer_u16, _repair_array[a + 1])
			buffer_write(buffer, buffer_u8, _repair_array[a + 2])
			buffer_write(buffer, buffer_u8, _repair_array[a + 3])
			buffer_write(buffer, buffer_bool, _repair_array[a + 4])
			buffer_write(buffer, buffer_f64, _repair_array[a + 5])
		}
		for(b = 0; b < EQUIPOS; b++){
			var mask_tecnologia = 0, mask_tecnologia_desbloqueable = 0
			for(a = 0; a < 64; a++){
				if edificio_tecnologia[b, a]
					mask_tecnologia |= 1 << a
				if edificio_tecnologia_desbloqueable[b, a]
					mask_tecnologia_desbloqueable |= 1 << a
			}
			buffer_write(buffer, buffer_u64, mask_tecnologia)
			buffer_write(buffer, buffer_u64, mask_tecnologia_desbloqueable)
			mask_tecnologia = 0
			mask_tecnologia_desbloqueable = 0
			for(a = 64; a < edificio_max; a++){
				if edificio_tecnologia[b, a]
					mask_tecnologia |= 1 << (a - 64)
				if edificio_tecnologia_desbloqueable[b, a]
					mask_tecnologia_desbloqueable |= 1 << (a - 64)
			}
			buffer_write(buffer, buffer_u64, mask_tecnologia)
			buffer_write(buffer, buffer_u64, mask_tecnologia_desbloqueable)
		}
		//Filtrar Edificios
		len = array_length(edificios_totales)
		for(a = len - 1; a >= 0; a--){
			edificio = edificios_totales[a]
			if not edificio.vivo or edificio.vida <= 0
				delete_edificio(edificio)
		}
		len = array_length(edificios_totales)
		buffer_write(buffer, buffer_u16, real(len))
		//Guardar Edificios
		for(a = 0; a < len; a++){
			edificio = edificios_totales[a]
			buffer_write(buffer, buffer_u8, real(edificio.index))
			buffer_write(buffer, buffer_u8, real(edificio.dir))
			buffer_write(buffer, buffer_u16, real(edificio.a))
			buffer_write(buffer, buffer_u16, real(edificio.b))
			buffer_write(buffer, buffer_u8, real(edificio.jugador))
			if tag_edificio_tuberia[edificio.index]
				buffer_write(buffer, buffer_s8, real(edificio.flujo.liquido))
			if edificio.index = id_procesador
				save_procesador(buffer, edificio)
		}
		//Estado edificios
		for(a = 0; a < len; a++)
			save_edificio(buffer, edificios_totales[a])
		for(a = 0; a < len; a++)
			buffer_write(buffer, buffer_u32, real(edificios_totales[a].edificio_index))
		buffer_write(buffer, buffer_u32, real(edificio_count))
		//Redes
		len = array_length(redes)
		buffer_write(buffer, buffer_u16, len)
		for(a = 0; a < len; a++){
			red = redes[a]
			buffer_write(buffer, buffer_u16, real(red.edificios[0].punteros[ptre_total]))
			buffer_write(buffer, buffer_f64, real(red.bateria))
		}
		//Flujos
		len = array_length(flujos)
		buffer_write(buffer, buffer_u16, len)
		for(a = 0; a < len; a++){
			flujo = flujos[a]
			buffer_write(buffer, buffer_u8, flujo.edificios[0].flujo = flujo ? 0 : 1)
			buffer_write(buffer, buffer_u16, real(flujo.edificios[0].punteros[ptre_total]))
			buffer_write(buffer, buffer_f64, real(flujo.almacen))
			buffer_write(buffer, buffer_u8, real(flujo.liquido))
		}
		//Filtrar drones
		len = array_length(drones)
		for(a = len - 1; a >= 0; a--){
			dron = drones[a]
			if dron.vida <= 0
				delete_dron(dron)
		}
		len = array_length(drones)
		buffer_write(buffer, buffer_u16, real(len))
		//Guardar drones
		for(a = 0; a < len; a++){
			dron = drones[a]
			buffer_write(buffer, buffer_u16, real(dron.a))
			buffer_write(buffer, buffer_u16, real(dron.b))
			buffer_write(buffer, buffer_u8, real(dron.index))
			buffer_write(buffer, buffer_u8, real(dron.jugador))
		}
		//Estado drones
		for(a = 0; a < len; a++){
			dron = drones[a]
			buffer_write(buffer, buffer_u32, dron.dron_counter)
			mask = 0
			c = 0
			mask += (dron.vida_max != dron_vida_max[dron.index]) << c++
			mask += (dron.vida != dron.vida_max) << c++
			mask += (dron.target != null_edificio) << c++
			mask += (dron.temp_target != null_edificio) << c++
			mask += (dron.target_dron != null_dron) << c++
			for(i = 0; i < rss_max; i++)
				mask += (dron.carga[i] != 0) << c++
			mask += (dron.modo != DRON_IDLE) << c++
			mask += (dron.dir != 0) << c++
			mask += (dron.dir_move != 0) << c++
			mask += (dron.step != 0) << c++
			for(i = 0; i < efectos_max; i++)
				mask += (dron.efecto[i] != 0) << c++
			mask += (dron.move_xmove != 0) << c++
			mask += (dron.move_ymove != 0) << c++
			mask += (dron.move_dis != 0) << c++
			mask += (dron.move_x != 0) << c++
			mask += (dron.move_y != 0) << c++
			mask += (dron.move_a != 0) << c++
			mask += (dron.move_b != 0) << c++
			mask += (dron.oleada != 0) << c++
			mask += (dron.change_pos) << c++
			mask += (dron.move_dir != 0) << c++
			mask += (array_length(dron.instruccion) > 0) << c++
			buffer_write(buffer, buffer_u64, real(mask))
			c = 0
			buffer_write(buffer, buffer_f64, real(dron.x))
			buffer_write(buffer, buffer_f64, real(dron.y))
			if mask & (1 << c++) buffer_write(buffer, buffer_f64, real(dron.vida_max))
			if mask & (1 << c++) buffer_write(buffer, buffer_f64, real(dron.vida))
			if mask & (1 << c++) buffer_write(buffer, buffer_u16, real(dron.target.punteros[ptre_total]))
			if mask & (1 << c++) buffer_write(buffer, buffer_u16, real(dron.temp_target.punteros[ptre_total]))
			if mask & (1 << c++) buffer_write(buffer, buffer_u16, real(dron.target_dron.punteros[ptrd_total]))
			for(i = 0; i < rss_max; i++)
				if mask & (1 << c++) buffer_write(buffer, buffer_f64, real(dron.carga[i]))
			if mask & (1 << c++) buffer_write(buffer, buffer_u8, real(dron.modo))
			if mask & (1 << c++) buffer_write(buffer, buffer_f64, real(dron.dir))
			if mask & (1 << c++) buffer_write(buffer, buffer_f64, real(dron.dir_move))
			if mask & (1 << c++) buffer_write(buffer, buffer_s16, real(dron.step))
			for(i = 0; i < efectos_max; i++)
				if mask & (1 << c++) buffer_write(buffer, buffer_f64, real(dron.efecto[i]))
			if mask & (1 << c++) buffer_write(buffer, buffer_f64, real(dron.move_xmove))
			if mask & (1 << c++) buffer_write(buffer, buffer_f64, real(dron.move_ymove))
			if mask & (1 << c++) buffer_write(buffer, buffer_f64, real(dron.move_dis))
			if mask & (1 << c++) buffer_write(buffer, buffer_f64, real(dron.move_x))
			if mask & (1 << c++) buffer_write(buffer, buffer_f64, real(dron.move_y))
			if mask & (1 << c++) buffer_write(buffer, buffer_u16, real(dron.move_a))
			if mask & (1 << c++) buffer_write(buffer, buffer_u16, real(dron.move_b))
			if mask & (1 << c++) buffer_write(buffer, buffer_u8, real(dron.oleada))
			c++
			if mask & (1 << c++) buffer_write(buffer, buffer_u8, real(dron.move_dir))
			if mask & (1 << c++){
				buffer_write(buffer, buffer_u8, dron.instruccion[0])
				buffer_write(buffer, buffer_u16, dron.instruccion[1])
				buffer_write(buffer, buffer_u16, dron.instruccion[2])
				buffer_write(buffer, buffer_u16, dron.instruccion[3])
				buffer_write(buffer, buffer_u16, dron.instruccion[4])
			}
		}
		buffer_write(buffer, buffer_u32, dron_counter)
		//Municiones
		len = real(array_length(municiones))
		buffer_write(buffer, buffer_u16, len)
		for(a = 0; a < len; a++){
			municion = municiones[a]
			buffer_write(buffer, buffer_f64, real(municion.x))
			buffer_write(buffer, buffer_f64, real(municion.y))
			buffer_write(buffer, buffer_f64, real(municion.hmove))
			buffer_write(buffer, buffer_f64, real(municion.vmove))
			mask = 0
			c = 0
			mask += (municion.tipo != 0) << c++
			mask += (municion.radio != 2500) << c++
			mask += (municion.humo) << c++
			mask += (municion.rastreador) << c++
			mask += (municion.jugador != 2) << c++
			mask += (municion.target != null_dron) << c++
			mask += (municion.target_build != null_edificio) << c++
			buffer_write(buffer, buffer_u8, mask)
			c = 0
			if mask & (1 << c++) buffer_write(buffer, buffer_u8, real(municion.tipo))
			buffer_write(buffer, buffer_f64, real(municion.dis))
			buffer_write(buffer, buffer_f64, real(municion.dmg))
			if mask & (1 << c++) buffer_write(buffer, buffer_f64, real(municion.radio))
			c++
			c++
			if mask & (1 << c++) buffer_write(buffer, buffer_u8, real(municion.jugador))
			if mask & (1 << c++) buffer_write(buffer, buffer_u16, real(municion.target.punteros[ptrd_total]))
			if mask & (1 << c++) buffer_write(buffer, buffer_u16, real(municion.target_build.punteros[ptre_total]))
		}
		//Frecuencias
		b = 0
		for(a = 0; a < frecuencia_max; a++)
			if frecuencias[a] != 0
				b++
		buffer_write(buffer, buffer_u8, b)
		for(a = 0; a < frecuencia_max; a++)
			if frecuencias[a] != 0{
				buffer_write(buffer, buffer_u8, a)
				if is_real(frecuencias[a]){
					buffer_write(buffer, buffer_bool, true)
					buffer_write(buffer, buffer_f64, real(frecuencias[a]))
				}
				else{
					buffer_write(buffer, buffer_bool, false)
					buffer_write(buffer, buffer_string, string(frecuencias[a]))
				}
			}
		#region IA
			buffer_write(buffer, buffer_bool, IA)
			if not IA
				exit
			buffer_write(buffer, buffer_u16, real(ia_build_pos))
			buffer_write(buffer, buffer_u16, real(ia_queue_count))
			buffer_write(buffer, buffer_s16, real(ia_build_rss))
			len = array_length(ia_build_queue)
			buffer_write(buffer, buffer_u16, len)
			var temp_array
			for(a = 0; a < len; a++){
				temp_array = ia_build_queue[a]
				buffer_write(buffer, buffer_u8, array_length(temp_array))
				for(b = 0; b < array_length(temp_array); b++)
					buffer_write(buffer, buffer_s32, real(temp_array[b]))
			}
			len = array_length(ia_chunk_construidos_array)
			buffer_write(buffer, buffer_u16, len)
			for(a = 0; a < len; a++){
				buffer_write(buffer, buffer_u16, ia_chunk_construidos_array[a, 0])
				buffer_write(buffer, buffer_u16, ia_chunk_construidos_array[a, 1])
			}
			for(a = 0; a < chunk_xsize; a++)
				for(b = 0; b < chunk_ysize; b++){
					buffer_write(buffer, buffer_bool, ia_chunk_construidos[# a, b])
					buffer_write(buffer, buffer_bool, ia_chunk_defendidos[# a, b])
				}
			//Grillas
			for(a = 0; a < xsize; a++)
				for(b = 0; b < ysize; b++){
					buffer_write(buffer, buffer_s16, real(ia_grid_camino[# a, b]))
					buffer_write(buffer, buffer_u16, is_infinity(ia_grid_real[# a, b]) ? U16_1 : real(ia_grid_real[# a, b]))
				}
			//Menas disponibles
			for(a = 0; a < ore_max; a++){
				len = array_length(ia_ores[a])
				buffer_write(buffer, buffer_u16, len)
				for(b = 0; b < len; b++){
					buffer_write(buffer, buffer_u16, ia_ores[a][b][0])
					buffer_write(buffer, buffer_u16, ia_ores[a][b][1])
				}
			}
			len = array_length(ia_tiles_nucleo)
			buffer_write(buffer, buffer_u16, len)
			for(a = 0; a < len; a++)
				buffer_write(buffer, buffer_u16, ia_tiles_nucleo[a])
		#endregion
	}
}