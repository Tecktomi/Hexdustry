function load_escenario_buffer(filename, _misiones = true, _edificios = true){
	with control{
		clear_edificios()
		var buffer = buffer_load(filename)
		//Variables globales
		var prev_xsize = xsize, prev_ysize = ysize
		xsize = real(buffer_read(buffer, buffer_u8))
		if prev_xsize != xsize
			resize_grid(min(prev_xsize, xsize), 0)
		ysize = real(buffer_read(buffer, buffer_u8))
		if prev_ysize != ysize
			resize_grid(0, min(prev_ysize, ysize))
		spawn_x = real(buffer_read(buffer, buffer_u8))
		spawn_y = real(buffer_read(buffer, buffer_u8))
		var seek_config = real(buffer_read(buffer, buffer_u16))
		if _misiones{
			for(var a = 0; a < rss_max; a++)
				carga_inicial[a] = real(buffer_read(buffer, buffer_u16))
			for(var a = 0; a < edificio_max; a++){
				var b = real(buffer_read(buffer, buffer_u8))
				if b = 0{
					mision_edificios[a] = false
					edificio_tecnologia[a] = false
				}
				else if b = 1{
					mision_edificios[a] = true
					edificio_tecnologia[a] = false
				}
				else if b = 2{
					mision_edificios[a] = true
					edificio_tecnologia[a] = true
				}
			}
			categoria_nombre_disponible = array_create(0, "")
			categoria_index_disponible = array_create(0, 0)
			for(var a = 0; a < array_length(categoria_nombre); a++){
				categoria_edificios_disponible[a] = array_create(0, 0)
				for(var b = 0; b < array_length(categoria_edificios[a]); b++)
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
			for(var a = 0; a < len_mis; a++){
				var _nombre_idioma = array_create(IDIOMAS, "")
				for(var b = 0; b < IDIOMAS; b++)
					_nombre_idioma[b] = string(buffer_read(buffer, buffer_string))
				var _nombre = _nombre_idioma[idioma]
				var _objetivo = real(buffer_read(buffer, buffer_u8))
				var _target_id = real(buffer_read(buffer, buffer_u8))
				var _target_num = real(buffer_read(buffer, buffer_u16))
				var _tiempo = real(buffer_read(buffer, buffer_u16))
				var _tiempo_victoria = bool(buffer_read(buffer, buffer_bool))
				var _tiempo_show = bool(buffer_read(buffer, buffer_bool))
				var _camera_move = bool(buffer_read(buffer, buffer_bool))
				var _camera_x = _camera_move ? real(buffer_read(buffer, buffer_u16)) : 0
				var _camera_y = _camera_move ? real(buffer_read(buffer, buffer_u16)) : 0
				var _switch_oleadas = bool(buffer_read(buffer, buffer_bool))
				var len_text = real(buffer_read(buffer, buffer_u8))
				var _texto = array_create(len_text, {x : 0, y : 0, texto : "", texto_idioma : array_create(0, "")})
				for(var b = 0; b < len_text; b++){
					var temp_array_string = array_create(IDIOMAS, "")
					for(var c = 0; c < IDIOMAS; c++)
						temp_array_string[c] = string(buffer_read(buffer, buffer_string))
					var xx = real(buffer_read(buffer, buffer_u16))
					var yy = real(buffer_read(buffer, buffer_u16))
					var temp_text = {
						x : xx,
						y : yy,
						texto : temp_array_string[idioma],
						texto_idioma : temp_array_string
					}
					_texto[b] = temp_text
				}
				misiones[a] = def_mision(_nombre, _nombre_idioma, _objetivo, _target_id, _target_num, _texto, false, _tiempo, _tiempo_victoria, _tiempo_show, _camera_move, _camera_x, _camera_y, _switch_oleadas)
			}
		}
		else
			buffer_seek(buffer, buffer_seek_start, seek_config)
		//Terreno
		for(var a = 0; a < xsize; a++)
			for(var b = 0; b < ysize; b++){
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
				var a = real(buffer_read(buffer, buffer_u8))
				var b = real(buffer_read(buffer, buffer_u8))
				var _jugador = real(buffer_read(buffer, buffer_u8))
				var edificio = add_edificio(index, dir, a, b, _jugador)
				if tag_edificio_seteable[index]{
					var mode = bool(buffer_read(buffer, buffer_bool))
					var select = real(buffer_read(buffer, buffer_f16))
					set_edificio(mode, select, edificio, true)
				}
			}
		}
		buffer_delete(buffer)
		clear_olas()
		for(var a = 0; a < chunk_xsize; a++)
			for(var b = 0; b < chunk_ysize; b++)
				update_background(chunk_width * a, chunk_height * b)
		if array_length(nucleos) > 0{
			camx = clamp(nucleos[0].a * 48 - room_width / 2, 0, xsize * 48 * zoom - room_width)
			camy = clamp(nucleos[0].b * 14 - room_height / 2, 0, ysize * 14 * zoom - room_height)
		}
		return filename
	}
}