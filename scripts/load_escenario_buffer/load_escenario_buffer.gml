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
			oleadas = bool(buffer_read(buffer, buffer_bool))
			oleadas_tiempo = real(buffer_read(buffer, buffer_u8))
			oleadas_tiempo_primera = real(buffer_read(buffer, buffer_u8))
			multiplicador_vida_enemigos = real(buffer_read(buffer, buffer_u8))
			//Misiones
			var len_mis = real(buffer_read(buffer, buffer_u8))
			if len_mis > 0
				mision_texto_victoria = string(buffer_read(buffer, buffer_string))
			array_resize(mision_nombre_idioma, len_mis)
			array_resize(mision_nombre, len_mis)
			array_resize(mision_target_id, len_mis)
			array_resize(mision_target_num, len_mis)
			array_resize(mision_tiempo, len_mis)
			array_resize(mision_tiempo_victoria, len_mis)
			array_resize(mision_tiempo_show, len_mis)
			array_resize(mision_camara_move, len_mis)
			array_resize(mision_camara_x, len_mis)
			array_resize(mision_camara_y, len_mis)
			array_resize(mision_switch_oleadas, len_mis)
			array_resize(mision_texto, len_mis)
			array_resize(mision_tiempo_edit, len_mis)
			for(var a = 0; a < len_mis; a++){
				mision_nombre_idioma[a] = array_create(idiomas, "")
				for(var b = 0; b < idiomas; b++)
					array_set(mision_nombre_idioma[a], b, string(buffer_read(buffer, buffer_string)))
				mision_nombre[a] = mision_nombre_idioma[a, idioma]
				mision_objetivo[a] = real(buffer_read(buffer, buffer_u8))
				mision_target_id[a] = real(buffer_read(buffer, buffer_u8))
				mision_target_num[a] = real(buffer_read(buffer, buffer_u16))
				mision_tiempo[a] = real(buffer_read(buffer, buffer_u16))
				mision_tiempo_victoria[a] = bool(buffer_read(buffer, buffer_bool))
				mision_tiempo_show[a] = bool(buffer_read(buffer, buffer_bool))
				mision_camara_move[a] = bool(buffer_read(buffer, buffer_bool))
				if mision_camara_move[a]{
					mision_camara_x[a] = real(buffer_read(buffer, buffer_u16))
					mision_camara_y[a] = real(buffer_read(buffer, buffer_u16))
				}
				else{
					mision_camara_x[a] = 0
					mision_camara_y[a] = 0
				}
				mision_switch_oleadas[a] = bool(buffer_read(buffer, buffer_bool))
				var len_text = real(buffer_read(buffer, buffer_u8))
				mision_texto[a] = array_create(len_text, {x : 0, y : 0, texto : "", texto_idioma : array_create(0, "")})
				for(var b = 0; b < len_text; b++){
					var temp_array_string = array_create(idiomas, "")
					for(var c = 0; c < idiomas; c++)
						temp_array_string[c] = string(buffer_read(buffer, buffer_string))
					var temp_text = {
						x : real(buffer_read(buffer, buffer_u16)),
						y : real(buffer_read(buffer, buffer_u16)),
						texto : temp_array_string[idioma],
						texto_idioma : temp_array_string
					}
					array_set(mision_texto[a], b, temp_text)
				}
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
		return filename
	}
}