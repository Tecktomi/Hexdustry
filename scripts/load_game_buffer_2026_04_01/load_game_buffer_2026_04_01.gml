function load_game_buffer_2026_04_01(buffer){
	with control{
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
		camx = buffer_read(buffer, buffer_f16)
		camy = buffer_read(buffer, buffer_f16)
		zoom = buffer_read(buffer, buffer_f16)
		timer = buffer_read(buffer, buffer_u32)
		oleadas_timer = buffer_read(buffer, buffer_u32)
		oleadas_tiempo = buffer_read(buffer, buffer_u32)
		oleadas_tiempo_primera = buffer_read(buffer, buffer_u32)
		tecnologia = buffer_read(buffer, buffer_bool)
		tecnologia_precio_multiplicador = buffer_read(buffer, buffer_f16)
		multiplicador_vida_enemigos = buffer_read(buffer, buffer_u16)
		dificultad = buffer_read(buffer, buffer_s8)
		modo_misiones = buffer_read(buffer, buffer_bool)
		#region Misiones
			var len = buffer_read(buffer, buffer_u8)
			misiones = array_create(len, null_mision)
			for(var a = 0; a < len; a++){
				var _nombre = buffer_read(buffer, buffer_string)
				var _objetivo = buffer_read(buffer, buffer_s8)
				var _target_id = buffer_read(buffer, buffer_s8)
				var _target_num = buffer_read(buffer, buffer_u16)
				var _tiempo = buffer_read(buffer, buffer_u16)
				var _tiempo_edit = buffer_read(buffer, buffer_bool)
				var _tiempo_victoria = buffer_read(buffer, buffer_bool)
				var _tiempo_show = buffer_read(buffer, buffer_bool)
				var len_2 = buffer_read(buffer, buffer_u8)
				var _texto = array_create(len_2, {x : 0, y : 0, texto : "", texto_idioma : array_create(0, "")})
				for(var b = 0; b < len_2; b++){
					var _x = real(buffer_read(buffer, buffer_f16))
					var _y = real(buffer_read(buffer, buffer_f16))
					var temp_texto = string(buffer_read(buffer, buffer_string))
					array_set(_texto, b, {
						x : _x,
						y : _y,
						texto : temp_texto,
						texto_idioma : array_create(0, "")
					})
				}
				var _camera_move = buffer_read(buffer, buffer_bool)
				var _camera_x = buffer_read(buffer, buffer_f16)
				var _camera_y = buffer_read(buffer, buffer_f16)
				var _switch_oleadas = buffer_read(buffer, buffer_bool)
				misiones[a] = def_mision(_nombre,, _objetivo, _target_id, _target_num, _texto, _tiempo_edit, _tiempo, _tiempo_victoria, _tiempo_show, _camera_move, _camera_x, _camera_y, _switch_oleadas)
			}
			mision_camara_step = buffer_read(buffer, buffer_u8)
			mision_camera_x_start = buffer_read(buffer, buffer_f16)
			mision_camera_y_start = buffer_read(buffer, buffer_f16)
			mision_texto_victoria = buffer_read(buffer, buffer_string)
			mision_actual = buffer_read(buffer, buffer_s8)
			mision_counter = buffer_read(buffer, buffer_u16)
			mision_current_tiempo = buffer_read(buffer, buffer_s16)
			mision_choosing_coord = buffer_read(buffer, buffer_bool)
		#endregion
		//Construir edificios
		len = real(buffer_read(buffer, buffer_u16))
		var temp_edificios_target = array_create(len, -1)
		for(var i = 0; i < len; i++){
			var index = real(buffer_read(buffer, buffer_u8))
			var dir = real(buffer_read(buffer, buffer_u8))
			var a = real(buffer_read(buffer, buffer_u16))
			var b = real(buffer_read(buffer, buffer_u16))
			var enemigo = bool(buffer_read(buffer, buffer_bool))
			if index = id_nucleo
				var edificio = add_edificio(index, dir, a, b, enemigo)
			else
				edificio = construir(index, dir, a, b, enemigo, true)
			if index = id_procesador
				load_procesador(buffer, edificio)
		}
		//Cargar estado
		for(var a = 0; a < len; a++)
			temp_edificios_target[a] = load_edificio(buffer, edificios_totales[a])
		//Redes
		len = real(buffer_read(buffer, buffer_u16))
		for(var a = 0; a < len; a++){
			var b = real(buffer_read(buffer, buffer_u16)), c = real(buffer_read(buffer, buffer_f32))
			if b < 65535
				edificios_totales[b].red.bateria = c
		}
		//Flujos
		len = real(buffer_read(buffer, buffer_u16))
		for(var a = 0; a < len; a++){
			var b = real(buffer_read(buffer, buffer_u16)), c = real(buffer_read(buffer, buffer_f32)), d = real(buffer_read(buffer, buffer_u8))
			if b < 65535{
				var flujo = edificios_totales[b].flujo
				flujo.capacidad = c
				flujo.liquido = (d = 255) ? -1 : d
			}
		}
		//Drones
		len = real(buffer_read(buffer, buffer_u16))
		var temp_dron_target = array_create(len, -1)
		for(var i = 0; i < len; i++){
			var a = real(buffer_read(buffer, buffer_u16))
			var b = real(buffer_read(buffer, buffer_u16))
			var index = real(buffer_read(buffer, buffer_u8))
			var enemigo = bool(buffer_read(buffer, buffer_bool))
			var dron = add_dron(a, b, index, enemigo)
		}
		//Dron - estados
		for(var i = 0; i < len; i++){
			var dron = drones[i]
			var mask = real(buffer_read(buffer, buffer_u64)), c = 0
			dron.x = real(buffer_read(buffer, buffer_f16))
			dron.y = real(buffer_read(buffer, buffer_f16))
			if mask & (1 << c++) dron.vida_max = real(buffer_read(buffer, buffer_f16))
			if mask & (1 << c++) herir_dron(dron.vida_max - real(buffer_read(buffer, buffer_f16)), dron)
			if mask & (1 << c++) dron.target = edificios_totales[real(buffer_read(buffer, buffer_u16))]
			if mask & (1 << c++) dron.temp_target = edificios_totales[real(buffer_read(buffer, buffer_u16))]
			if mask & (1 << c++) temp_dron_target[i] = real(buffer_read(buffer, buffer_u16))
			for(var j = 0; j < rss_max; j++)
				if mask & (1 << c++){
					dron.carga[j] = real(buffer_read(buffer, buffer_f16))
					dron.carga_total += dron.carga[j]
				}
			if mask & (1 << c++) dron.modo = real(buffer_read(buffer, buffer_u8))
			if mask & (1 << c++) dron.dir = real(buffer_read(buffer, buffer_f16))
			if mask & (1 << c++) dron.dir_move = real(buffer_read(buffer, buffer_f16))
			if mask & (1 << c++) dron.step = real(buffer_read(buffer, buffer_s16))
			for(var j = 0; j < efectos_max; j++)
				if mask & (1 << c++) dron.efecto[j] = real(buffer_read(buffer, buffer_f16))
			if mask & (1 << c++) dron.move_xmove = real(buffer_read(buffer, buffer_f16))
			if mask & (1 << c++) dron.move_ymove = real(buffer_read(buffer, buffer_f16))
			if mask & (1 << c++) dron.move_dis = real(buffer_read(buffer, buffer_f16))
			if mask & (1 << c++) dron.move_x = real(buffer_read(buffer, buffer_f16))
			if mask & (1 << c++) dron.move_y = real(buffer_read(buffer, buffer_f16))
			if mask & (1 << c++) dron.oleada = real(buffer_read(buffer, buffer_u8))
		}
		//Referencias cruzadas dron-dron
		for(var i = 0; i < len; i++)
			if temp_dron_target[i] != -1
				drones[i].target_dron = drones[temp_dron_target[i]]
		//Referencias cruzadas edificio-dron
		len = array_length(edificios_totales)
		for(var a = 0; a < len; a++)
			if a < array_length(edificios_totales) and temp_edificios_target[a] != -1{
				var edificio = edificios_totales[a], dron = drones[temp_edificios_target[a]]
				array_disorder_push(dron.torres, edificio, 2)
				edificio.target = dron
			}
		//Municiones
		len = real(buffer_read(buffer, buffer_u16))
		repeat(len){
			var a = buffer_read(buffer, buffer_f16), b = buffer_read(buffer, buffer_f16)
			var municion = add_municion(
				buffer_read(buffer, buffer_f16),
				buffer_read(buffer, buffer_f16),
				buffer_read(buffer, buffer_f16),
				buffer_read(buffer, buffer_f16),
				buffer_read(buffer, buffer_u8),
				buffer_read(buffer, buffer_f16),
				buffer_read(buffer, buffer_f16),
				buffer_read(buffer, buffer_f16),,,
				buffer_read(buffer, buffer_bool),
				buffer_read(buffer, buffer_bool))
			municion.x = a
			municion.y = b
			a = buffer_read(buffer, buffer_u16)
			if a < 65535
				municion.target = drones[a]
			a = buffer_read(buffer, buffer_u16)
			if a < 65535
				municion.target_build = edificios_totales[a]
		}
		return true
	}
}