function load_escenario_buffer(filename, _misiones = true, _edificios = true){
	with control{
		clear_edificios()
		var buffer = buffer_load(filename)
		if buffer = -1
			return ""
		//Variables globales
		var prev_xsize = xsize, prev_ysize = ysize
		xsize = real(buffer_read(buffer, buffer_u16))
		if prev_xsize != xsize
			resize_grid(min(prev_xsize, xsize), 0)
		ysize = real(buffer_read(buffer, buffer_u16))
		if prev_ysize != ysize
			resize_grid(0, min(prev_ysize, ysize))
		spawn_x = real(buffer_read(buffer, buffer_u16))
		spawn_y = real(buffer_read(buffer, buffer_u16))
		var seek_config = real(buffer_read(buffer, buffer_u32)), a, b, c, temp_array_string
		if _misiones{
			for(a = 0; a < rss_max; a++)
				carga_inicial[a] = real(buffer_read(buffer, buffer_u16))
			for(a = 0; a < edificio_max; a++){
				b = real(buffer_read(buffer, buffer_u8))
				if b = 0{
					mision_edificios[a] = false
					for(c = 0; c < EQUIPOS; c++)
						array_set(edificio_tecnologia[c], a, false)
				}
				else if b = 1{
					mision_edificios[a] = true
					for(c = 0; c < EQUIPOS; c++)
						array_set(edificio_tecnologia[c], a, false)
				}
				else if b = 2{
					mision_edificios[a] = true
					for(c = 0; c < EQUIPOS; c++)
						array_set(edificio_tecnologia[c], a, true)
				}
			}
			categoria_nombre_disponible = array_create(0, "")
			categoria_index_disponible = array_create(0, 0)
			for(a = 0; a < array_length(categoria_nombre) - 1; a++){
				categoria_edificios_disponible[a] = array_create(0, 0)
				for(b = 0; b < array_length(categoria_edificios[a]); b++)
					if mision_edificios[categoria_edificios[a, b]]
						array_push(categoria_edificios_disponible[a], categoria_edificios[a, b])
				if array_length(categoria_edificios_disponible[a]) > 0{
					array_push(categoria_nombre_disponible, categoria_nombre[a])
					array_push(categoria_index_disponible, a)
				}
			}
			oleadas = bool(buffer_read(buffer, buffer_bool))
			oleadas_tiempo = real(buffer_read(buffer, buffer_u8))
			oleadas_tiempo_primera = real(buffer_read(buffer, buffer_u8))
			multiplicador_vida_enemigos = real(buffer_read(buffer, buffer_u8))
			//Misiones
			var len_mis = real(buffer_read(buffer, buffer_u8))
			if len_mis > 0
				mision_texto_victoria = string(buffer_read(buffer, buffer_string))
			array_resize(misiones, len_mis)
			for(a = 0; a < len_mis; a++){
				var _nombre_idioma = array_create(IDIOMAS, "")
				for(b = 0; b < IDIOMAS; b++)
					_nombre_idioma[b] = string(buffer_read(buffer, buffer_string))
				var _nombre = _nombre_idioma[idioma]
				var _objetivo = real(buffer_read(buffer, buffer_u8))
				var _target_id = real(buffer_read(buffer, buffer_u8))
				var _target_num = real(buffer_read(buffer, buffer_u16))
				var _tiempo_edit = bool(buffer_read(buffer, buffer_bool))
				var _tiempo = real(buffer_read(buffer, buffer_u16))
				var _tiempo_victoria = bool(buffer_read(buffer, buffer_bool))
				var _tiempo_show = bool(buffer_read(buffer, buffer_bool))
				var _camera_move = bool(buffer_read(buffer, buffer_bool))
				var _camera_x = _camera_move ? real(buffer_read(buffer, buffer_u16)) : 0
				var _camera_y = _camera_move ? real(buffer_read(buffer, buffer_u16)) : 0
				var _switch_oleadas = bool(buffer_read(buffer, buffer_bool))
				var len_text = real(buffer_read(buffer, buffer_u8))
				var _texto = array_create(len_text)
				for(b = 0; b < len_text; b++){
					_texto[b] = array_create(IDIOMAS, "")
					for(c = 0; c < IDIOMAS; c++)
						array_set(_texto[b], c, string(buffer_read(buffer, buffer_string)))
				}
				misiones[a] = def_mision(_nombre, _nombre_idioma, _objetivo, _target_id, _target_num, _texto, _tiempo_edit, _tiempo, _tiempo_victoria, _tiempo_show, _camera_move, _camera_x, _camera_y, _switch_oleadas)
			}
		}
		else
			buffer_seek(buffer, buffer_seek_start, seek_config)
		//Terreno
		for(a = 0; a < xsize; a++)
			for(b = 0; b < ysize; b++){
				terreno[# a, b] = real(buffer_read(buffer, buffer_u8))
				ore[# a, b] = real(buffer_read(buffer, buffer_s8))
				if ore[# a, b] >= 0
					ore_amount[# a, b] = real(buffer_read(buffer, buffer_u16))
			}
		//Edificios
		if _edificios{
			var len_edi = real(buffer_read(buffer, buffer_u16))
			repeat(len_edi){
				var index = real(buffer_read(buffer, buffer_u8))
				var dir = real(buffer_read(buffer, buffer_u8))
				a = real(buffer_read(buffer, buffer_u16))
				b = real(buffer_read(buffer, buffer_u16))
				var _jugador = real(buffer_read(buffer, buffer_u8))
				if tag_edificio_tuberia[index]{
					var _liquido = real(buffer_read(buffer, buffer_s8))
					liquido_choose_array = array_create(2, _liquido)
					liquido_choose = 0
				}
				var edificio = add_edificio(index, dir, a, b, _jugador)
				if tag_edificio_seteable[index]{
					var mode = bool(buffer_read(buffer, buffer_bool))
					var select = real(buffer_read(buffer, buffer_f64))
					set_edificio(mode, select, edificio)
				}
			}
		}
		buffer_delete(buffer)
		clear_olas()
		for(a = 0; a < chunk_xsize; a++)
			for(b = 0; b < chunk_ysize; b++)
				update_background(CHUNK_WIDTH * a, CHUNK_HEIGHT * b)
		if array_length(edificios_jugador_index[jugador, id_nucleo]) > 0{
			camx = clamp(edificios_jugador_index[jugador, id_nucleo][0].a * 48 - room_width / 2, 0, xsize * 48 * zoom - room_width)
			camy = clamp(edificios_jugador_index[jugador, id_nucleo][0].b * 14 - room_height / 2, 0, ysize * 14 * zoom - room_height)
		}
		if file_exists($"{string_delete(filename, string_pos(".txt", filename), string_width(filename))}.lang"){
			ini_open($"{string_delete(filename, string_pos(".txt", filename), string_width(filename))}.lang")
			for(c = 0; c < IDIOMAS; c++){
				if ini_key_exists(IDIOMA_NAME[c], "Victoria")
					mision_texto_victoria_idioma[c] = ini_read_string(IDIOMA_NAME[c], "Victoria", "")
				for(a = 0; a < array_length(misiones); a++){
					var mision = misiones[a]
					if ini_key_exists(IDIOMA_NAME[c], $"M{a} nombre")
						mision.nombre_idioma[c] = ini_read_string(IDIOMA_NAME[c], $"M{a} nombre", "")
					for(b = 0; b < array_length(mision.texto); b++)
						if ini_key_exists(IDIOMA_NAME[c], $"M{a} T{b}")
							array_set(mision.texto[b], c, ini_read_string(IDIOMA_NAME[c], $"M{a} T{b}", ""))
				}
			}
			ini_close()
		}
		return filename
	}
}