function load_game_buffer(buffer){
	with control{
		var _version = buffer_read(buffer, buffer_u32)
		if _version != FILE_VERSION
			return false
		mapa = buffer_read(buffer, buffer_s8)
		if mapa = -1{
			seed = buffer_read(buffer, buffer_u32)
			biome_seed = buffer_read(buffer, buffer_u8)
			var _xsize = real(buffer_read(buffer, buffer_u16))
			var _ysize = real(buffer_read(buffer, buffer_u16))
			if _xsize != xsize or _ysize != ysize{
				xsize = _xsize
				ysize = _ysize
				set_grid_size()
			}
			while not generar_bioma(biome_seed){}
		}
		else if mapa < -1{
			tutorial = -1 - mapa
			load_escenario_buffer(tutorial_nombre[tutorial - 1], false, false)
		}
		else
			load_escenario_buffer($"{DEFAULT_MAPS[mapa]}.txt", false, false)
		sim_seed[0] = real(buffer_read(buffer, buffer_u32))
		game_start(false)
		camx = buffer_read(buffer, buffer_f64)
		camy = buffer_read(buffer, buffer_f64)
		zoom = buffer_read(buffer, buffer_f64)
		timer = buffer_read(buffer, buffer_u32)
		oleadas_timer = buffer_read(buffer, buffer_u32)
		oleadas_tiempo = buffer_read(buffer, buffer_u32)
		oleadas_tiempo_primera = buffer_read(buffer, buffer_u32)
		oleada_count = buffer_read(buffer, buffer_u8)
		tecnologia = buffer_read(buffer, buffer_bool)
		tecnologia_precio_multiplicador = buffer_read(buffer, buffer_f64)
		multiplicador_vida_enemigos = buffer_read(buffer, buffer_f64)
		dificultad = buffer_read(buffer, buffer_s8)
		modo_misiones = buffer_read(buffer, buffer_bool)
		var a, b, c, d, e, _texto, len
		#region Misiones
			load_mision(buffer)
			mision_camara_step = buffer_read(buffer, buffer_u8)
			mision_camera_x_start = buffer_read(buffer, buffer_f64)
			mision_camera_y_start = buffer_read(buffer, buffer_f64)
			mision_texto_victoria = buffer_read(buffer, buffer_string)
			mision_actual = buffer_read(buffer, buffer_s8)
			mision_counter = buffer_read(buffer, buffer_u16)
			mision_current_tiempo = buffer_read(buffer, buffer_s16)
			mision_choosing_coord = buffer_read(buffer, buffer_bool)
			if mision_actual >= 0 and mision_actual < array_length(misiones)
				mision = misiones[mision_actual]
		#endregion
		for(a = 0; a < rss_max; a++)
			for(b = 0; b < EQUIPOS; b++)
				array_set(jugador_recursos[b], a, real(buffer_read(buffer, buffer_u32)))
		image_index = buffer_read(buffer, buffer_u32)
		for(b = 0; b < EQUIPOS; b++){
			var mask_tecnologia = buffer_read(buffer, buffer_u64)
			var mask_tecnologia_desbloqueable = buffer_read(buffer, buffer_u64)
			for(a = 0; a < edificio_max; a++){
				array_set(edificio_tecnologia[b], a, bool(mask_tecnologia & (1 << a)))
				array_set(edificio_tecnologia_desbloqueable[b], a, bool(mask_tecnologia_desbloqueable & (1 << a)))
			}
		}
		//Construir edificios
		len = real(buffer_read(buffer, buffer_u16))
		var temp_edificios_target = array_create(len, U16_1)
		for(var i = 0; i < len; i++){
			var index = real(buffer_read(buffer, buffer_u8))
			var dir = real(buffer_read(buffer, buffer_u8))
			a = real(buffer_read(buffer, buffer_u16))
			b = real(buffer_read(buffer, buffer_u16))
			var _jugador = real(buffer_read(buffer, buffer_u8))
			if tag_edificio_tuberia[index]{
				liquido_choose_array = array_create(2, real(buffer_read(buffer, buffer_s8)))
				liquido_choose = 0
			}
			if index = id_nucleo
				var edificio = add_edificio(index, dir, a, b, _jugador)
			else
				edificio = construir(index, dir, a, b,, true, _jugador)
			if index = id_procesador
				load_procesador(buffer, edificio)
		}
		check_water_target()
		//Cargar estado
		for(a = 0; a < len; a++)
			temp_edificios_target[a] = load_edificio(buffer, edificios_totales[a])
		//Redes
		len = real(buffer_read(buffer, buffer_u16))
		for(a = 0; a < len; a++){
			b = real(buffer_read(buffer, buffer_u16))
			c = real(buffer_read(buffer, buffer_f64))
			if b < 65535
				edificios_totales[b].red.bateria = c
		}
		//Flujos
		len = real(buffer_read(buffer, buffer_u16))
		for(a = 0; a < len; a++){
			e = real(buffer_read(buffer, buffer_u8))
			b = real(buffer_read(buffer, buffer_u16))
			c = real(buffer_read(buffer, buffer_f64))
			d = real(buffer_read(buffer, buffer_u8))
			if b < 65535{
				var flujo = (e = 0 ? edificios_totales[b].flujo : edificios_totales[b].flujo_2)
				flujo.almacen = c
				flujo.liquido = (d = 255) ? -1 : d
			}
		}
		//Drones
		len = real(buffer_read(buffer, buffer_u16))
		var temp_dron_target = array_create(len, U16_1)
		for(var i = 0; i < len; i++){
			a = real(buffer_read(buffer, buffer_u16))
			b = real(buffer_read(buffer, buffer_u16))
			var index = real(buffer_read(buffer, buffer_u8))
			var _jugador = real(buffer_read(buffer, buffer_u8))
			var dron = add_dron(a, b, index, _jugador)
		}
		//Dron - estados
		for(var i = 0; i < len; i++){
			var dron = drones[i]
			dron.dron_counter = real(buffer_read(buffer, buffer_u32))
			var mask = real(buffer_read(buffer, buffer_u64))
			c = 0
			dron.x = real(buffer_read(buffer, buffer_f64))
			dron.y = real(buffer_read(buffer, buffer_f64))
			if mask & (1 << c++) dron.vida_max = real(buffer_read(buffer, buffer_f64))
			if mask & (1 << c++) herir_dron(dron.vida_max - real(buffer_read(buffer, buffer_f64)), dron)
			if mask & (1 << c++) dron.target = edificios_totales[real(buffer_read(buffer, buffer_u16))]
			if mask & (1 << c++){
				a = real(buffer_read(buffer, buffer_u16))
				dron.temp_target = (a = U16_1) ? null_edificio : edificios_totales[a]
			}
			if mask & (1 << c++) temp_dron_target[i] = real(buffer_read(buffer, buffer_u16))
			for(var j = 0; j < rss_max; j++)
				if mask & (1 << c++){
					dron.carga[j] = real(buffer_read(buffer, buffer_f64))
					dron.carga_total += dron.carga[j]
				}
			if mask & (1 << c++) dron.modo = real(buffer_read(buffer, buffer_u8))
			if mask & (1 << c++) dron.dir = real(buffer_read(buffer, buffer_f64))
			if mask & (1 << c++) dron.dir_move = real(buffer_read(buffer, buffer_f64))
			if mask & (1 << c++) dron.step = real(buffer_read(buffer, buffer_s16))
			for(var j = 0; j < efectos_max; j++)
				if mask & (1 << c++) dron.efecto[j] = real(buffer_read(buffer, buffer_f64))
			if mask & (1 << c++) dron.move_xmove = real(buffer_read(buffer, buffer_f64))
			if mask & (1 << c++) dron.move_ymove = real(buffer_read(buffer, buffer_f64))
			if mask & (1 << c++) dron.move_dis = real(buffer_read(buffer, buffer_f64))
			if mask & (1 << c++) dron.move_x = real(buffer_read(buffer, buffer_f64))
			if mask & (1 << c++) dron.move_y = real(buffer_read(buffer, buffer_f64))
			if mask & (1 << c++) dron.move_a = real(buffer_read(buffer, buffer_u16))
			if mask & (1 << c++) dron.move_b = real(buffer_read(buffer, buffer_u16))
			if mask & (1 << c++) dron.oleada = real(buffer_read(buffer, buffer_u8))
			if mask & (1 << c++) dron.change_pos = true
			if mask & (1 << c++) dron.move_dir = real(buffer_read(buffer, buffer_u8))
			if mask & (1 << c++){
				var _rss = real(buffer_read(buffer, buffer_u8))
				var a1 = real(buffer_read(buffer, buffer_u16))
				var b1 = real(buffer_read(buffer, buffer_u16))
				var a2 = real(buffer_read(buffer, buffer_u16))
				var b2 = real(buffer_read(buffer, buffer_u16))
				dron.instruccion = [_rss, a1, b1, a2, b2]
			}
		}
		dron_counter = buffer_read(buffer, buffer_u32)
		//Referencias cruzadas dron-dron
		for(var i = 0; i < len; i++)
			if temp_dron_target[i] != U16_1
				drones[i].target_dron = drones[temp_dron_target[i]]
		//Referencias cruzadas edificio-dron
		len = array_length(temp_edificios_target)
		for(a = 0; a < len; a++)
			if temp_edificios_target[a] != U16_1{
				var edificio = edificios_totales[a], dron = drones[temp_edificios_target[a]]
				array_disorder_push(dron.torres, edificio, ptre_torre_dron)
				edificio.target = dron
			}
		//Municiones
		len = real(buffer_read(buffer, buffer_u16))
		repeat(len){
			a = buffer_read(buffer, buffer_f64)
			b = buffer_read(buffer, buffer_f64)
			var hmove = real(buffer_read(buffer, buffer_f64))
			var vmove = real(buffer_read(buffer, buffer_f64))
			var mask = real(buffer_read(buffer, buffer_u8))
			c = 0
			var tipo = municion_tipo_normal, radio = 2500, humo = false, rastreador = false, _jugador = 2, _target = U16_1, _target_build = U16_1
			if mask & (1 << c++) tipo = real(buffer_read(buffer, buffer_u8))
			var dis = real(buffer_read(buffer, buffer_f64))
			var dmg = real(buffer_read(buffer, buffer_f64))
			if mask & (1 << c++) radio = real(buffer_read(buffer, buffer_f64))
			if mask & (1 << c++) humo = true
			if mask & (1 << c++) rastreador = true
			if mask & (1 << c++) _jugador = real(buffer_read(buffer, buffer_u8))
			if mask & (1 << c++) _target = buffer_read(buffer, buffer_u16)
			if mask & (1 << c++) _target_build = buffer_read(buffer, buffer_u16)
			var municion = add_municion(a, b, hmove, vmove, tipo, dis, dmg, radio,,, humo, rastreador, _jugador)
			municion.origen_x = a
			municion.origen_y = b
			if _target != U16_1
				municion.target = drones[_target]
			if _target_build != U16_1
				municion.target_build = edificios_totales[_target_build]
		}
		//Frecuencias
		b = buffer_read(buffer, buffer_u8)
		var isreal
		for(a = 0; a < b; a++){
			c = buffer_read(buffer, buffer_u8)
			isreal = buffer_read(buffer, buffer_bool)
			if isreal
				frecuencias[c] = real(buffer_read(buffer, buffer_f64))
			else
				frecuencias[c] = string(buffer_read(buffer, buffer_string))
		}
		//Debug
		var temp_text = ""
		for(a = 0; a < edificio_max; a++)
			if array_length(edificios_index[a]) > 0
				temp_text += $"{edificio_nombre[a]}: {array_length(edificios_index[a])}, "
		show_debug_message(temp_text)
		return true
	}
}