function load_game_buffer(buffer){
	with control{
		var _version = buffer_read(buffer, buffer_u32)
		if _version != FILE_VERSION
			return false
		mapa = buffer_read(buffer, buffer_s8)
		if mapa = -1{
			seed = buffer_read(buffer, buffer_u32)
			biome_seed = buffer_read(buffer, buffer_u8)
			generar_bioma(biome_seed)
		}
		else if mapa < -1{
			tutorial = -1 - mapa
			load_escenario_buffer(tutorial_nombre[tutorial - 1], false, false)
		}
		else
			load_escenario_buffer($"{DEFAULT_MAPS[mapa]}.txt", false)
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
		var a, b, c, d, _texto
		#region Misiones
			var len = buffer_read(buffer, buffer_u8)
			misiones = array_create(len, null_mision)
			for(a = 0; a < len; a++){
				var _nombre = buffer_read(buffer, buffer_string)
				var _objetivo = buffer_read(buffer, buffer_s8)
				var _target_id = buffer_read(buffer, buffer_s8)
				var _target_num = buffer_read(buffer, buffer_u16)
				var _tiempo = buffer_read(buffer, buffer_u16)
				var _tiempo_edit = buffer_read(buffer, buffer_bool)
				var _tiempo_victoria = buffer_read(buffer, buffer_bool)
				var _tiempo_show = buffer_read(buffer, buffer_bool)
				var len_2 = buffer_read(buffer, buffer_u8)
				_texto = array_create(len_2, {x : 0, y : 0, texto : "", texto_idioma : array_create(0, "")})
				for(b = 0; b < len_2; b++){
					var _x = real(buffer_read(buffer, buffer_u16))
					var _y = real(buffer_read(buffer, buffer_u16))
					var temp_texto = string(buffer_read(buffer, buffer_string))
					array_set(_texto, b, {
						x : _x,
						y : _y,
						texto : temp_texto,
						texto_idioma : array_create(0, "")
					})
				}
				var _camera_move = buffer_read(buffer, buffer_bool)
				var _camera_x = buffer_read(buffer, buffer_u16)
				var _camera_y = buffer_read(buffer, buffer_u16)
				var _switch_oleadas = buffer_read(buffer, buffer_bool)
				misiones[a] = def_mision(_nombre,, _objetivo, _target_id, _target_num, _texto, _tiempo_edit, _tiempo, _tiempo_victoria, _tiempo_show, _camera_move, _camera_x, _camera_y, _switch_oleadas)
			}
			mision_camara_step = buffer_read(buffer, buffer_u8)
			mision_camera_x_start = buffer_read(buffer, buffer_f64)
			mision_camera_y_start = buffer_read(buffer, buffer_f64)
			mision_texto_victoria = buffer_read(buffer, buffer_string)
			mision_actual = buffer_read(buffer, buffer_s8)
			mision_counter = buffer_read(buffer, buffer_u16)
			mision_current_tiempo = buffer_read(buffer, buffer_s16)
			mision_choosing_coord = buffer_read(buffer, buffer_bool)
			if mision_actual >= 0 and mision_actual < len
				mision = misiones[mision_actual]
		#endregion
		for(a = 0; a < rss_max; a++)
			for(b = 0; b < EQUIPOS; b++)
				array_set(jugador_recursos[b], a, real(buffer_read(buffer, buffer_u16)))
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
		var temp_edificios_target = array_create(len, -1)
		for(var i = 0; i < len; i++){
			var index = real(buffer_read(buffer, buffer_u8))
			var dir = real(buffer_read(buffer, buffer_u8))
			a = real(buffer_read(buffer, buffer_u16))
			b = real(buffer_read(buffer, buffer_u16))
			var _jugador = real(buffer_read(buffer, buffer_u8))
			if index = id_nucleo
				var edificio = add_edificio(index, dir, a, b, _jugador)
			else
				edificio = construir(index, dir, a, b,, true, true, _jugador)
			if index = id_procesador
				load_procesador(buffer, edificio)
		}
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
			b = real(buffer_read(buffer, buffer_u16))
			c = real(buffer_read(buffer, buffer_f64))
			d = real(buffer_read(buffer, buffer_u8))
			if b < 65535{
				var flujo = edificios_totales[b].flujo
				flujo.almacen = c
				flujo.liquido = (d = 255) ? -1 : d
			}
		}
		//Drones
		len = real(buffer_read(buffer, buffer_u16))
		var temp_dron_target = array_create(len, -1)
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
			var mask = real(buffer_read(buffer, buffer_u64))
			c = 0
			dron.x = real(buffer_read(buffer, buffer_f64))
			dron.y = real(buffer_read(buffer, buffer_f64))
			if mask & (1 << c++) dron.vida_max = real(buffer_read(buffer, buffer_f64))
			if mask & (1 << c++) herir_dron(dron.vida_max - real(buffer_read(buffer, buffer_f64)), dron)
			if mask & (1 << c++) dron.target = edificios_totales[real(buffer_read(buffer, buffer_u16))]
			if mask & (1 << c++) dron.temp_target = edificios_totales[real(buffer_read(buffer, buffer_u16))]
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
			if mask & (1 << c++) dron.oleada = real(buffer_read(buffer, buffer_u8))
			if mask & (1 << c++) dron.change_pos = true
			if mask & (1 << c++) dron.move_dir = real(buffer_read(buffer, buffer_u8))
		}
		//Referencias cruzadas dron-dron
		for(var i = 0; i < len; i++)
			if temp_dron_target[i] != -1
				drones[i].target_dron = drones[temp_dron_target[i]]
		//Referencias cruzadas edificio-dron
		len = array_length(temp_edificios_target)
		for(a = 0; a < len; a++)
			if temp_edificios_target[a] != -1{
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
			var tipo = municion_tipo_normal, radio = 2500, humo = false, rastreador = false, _jugador = jugador, _target = -1, _target_build = -1
			if mask & (1 << c++) tipo = real(buffer_read(buffer, buffer_u8))
			var dis = real(buffer_read(buffer, buffer_f64))
			var dmg = real(buffer_read(buffer, buffer_f64))
			if mask & (1 << c++) radio = real(buffer_read(buffer, buffer_f64))
			if mask & (1 << c++) humo = true
			if mask & (1 << c++) rastreador = true
			if mask & (1 << c++) _jugador = real(buffer_read(buffer, buffer_u8))
			if mask & (1 << c++) _target = buffer_read(buffer, buffer_u16)
			if mask & (1 << c++) _target_build = buffer_read(buffer, buffer_u16)
			var municion = add_municion(a, b, hmove, vmove, tipo, dis, dmg, radio,,,, humo, rastreador, _jugador)
			municion.origen_x = a
			municion.origen_y = b
			if _target != -1
				municion.target = drones[_target]
			if _target_build != -1
				municion.target_build = edificios_totales[_target_build]
		}
		return true
	}
}