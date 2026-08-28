function save_escenario_buffer(filename){
	with control{
		var len_edi = array_length(edificios_totales), len_mis = array_length(misiones)
		var buffer = buffer_create(1024, buffer_grow, 1)
		//Variables globales
		buffer_write(buffer, buffer_u8, xsize)
		buffer_write(buffer, buffer_u8, ysize)
		buffer_write(buffer, buffer_u8, spawn_x)
		buffer_write(buffer, buffer_u8, spawn_y)
		//Config
		var seek_config = buffer_tell(buffer), a, b, _mision, len_text, c, temp_text
		buffer_write(buffer, buffer_u16, 0) //Placeholder
		for(a = 0; a < rss_max; a++)
			buffer_write(buffer, buffer_u16, carga_inicial[a])
		for(a = 0; a < edificio_max; a++)
			buffer_write(buffer, buffer_u8, (not mision_edificios[a]) ? 0 : (edificio_tecnologia[jugador, a] ? 2 : 1))
		buffer_write(buffer, buffer_bool, oleadas)
		buffer_write(buffer, buffer_u8, oleadas_tiempo)
		buffer_write(buffer, buffer_u8, oleadas_tiempo_primera)
		buffer_write(buffer, buffer_u8, multiplicador_vida_enemigos)
		//Misiones
		buffer_write(buffer, buffer_u8, len_mis)
		if len_mis > 0
			buffer_write(buffer, buffer_string, mision_texto_victoria)
		for(a = 0; a < len_mis; a++){
			_mision = misiones[a]
			for(b = 0; b < IDIOMAS; b++)
				buffer_write(buffer, buffer_string, _mision.nombre_idioma[b])
			buffer_write(buffer, buffer_u8, _mision.objetivo)
			buffer_write(buffer, buffer_u8, _mision.target_id)
			buffer_write(buffer, buffer_u16, _mision.target_num)
			buffer_write(buffer, buffer_u16, _mision.tiempo)
			buffer_write(buffer, buffer_bool, _mision.tiempo_victoria)
			buffer_write(buffer, buffer_bool, _mision.tiempo_show)
			buffer_write(buffer, buffer_bool, _mision.camera_move)
			if _mision.camera_move{
				buffer_write(buffer, buffer_u16, _mision.camera_x)
				buffer_write(buffer, buffer_u16, _mision.camera_y)
			}
			buffer_write(buffer, buffer_bool, _mision.switch_oleadas)
			len_text = array_length(_mision.texto)
			buffer_write(buffer, buffer_u8, len_text)
			for(b = 0; b < len_text; b++){
				temp_text = _mision.texto[b]
				for(c = 0; c < IDIOMAS; c++)
					buffer_write(buffer, buffer_string, temp_text.texto_idioma[c])
				buffer_write(buffer, buffer_u16, temp_text.x)
				buffer_write(buffer, buffer_u16, temp_text.y)
			}
		}
		var seek_config_end = buffer_tell(buffer)
		buffer_seek(buffer, buffer_seek_start, seek_config)
		buffer_write(buffer, buffer_u16, seek_config_end)
		buffer_seek(buffer, buffer_seek_start, seek_config_end)
		//Terreno
		for(a = 0; a < xsize; a++)
			for(b = 0; b < ysize; b++){
				buffer_write(buffer, buffer_u8, terreno[# a, b])
				buffer_write(buffer, buffer_s8, ore[# a, b])
				if ore[# a, b] >= 0
					buffer_write(buffer, buffer_u16, ore_amount[# a, b])
			}
		//Edificios
		buffer_write(buffer, buffer_u16, len_edi)
		for(a = 0; a < len_edi; a++){
			var edificio = edificios_totales[a]
			buffer_write(buffer, buffer_u8, edificio.index)
			buffer_write(buffer, buffer_u8, edificio.dir)
			buffer_write(buffer, buffer_u8, edificio.a)
			buffer_write(buffer, buffer_u8, edificio.b)
			buffer_write(buffer, buffer_u8, edificio.jugador)
			if tag_edificio_seteable[edificio.index]{
				buffer_write(buffer, buffer_bool, edificio.mode)
				buffer_write(buffer, buffer_f64, edificio.select)
			}
		}
		buffer_write(buffer, buffer_u16, seek_config)
		buffer_save(buffer, filename)
		buffer_delete(buffer)
		//Minimapa
		b = array_get_index(save_files, filename)
		filename = file_format(filename)
		var temp_sprite = minimapa()
		sprite_save(temp_sprite, 0, $"Scenarios/{filename}.png")
		if b = -1
			array_push(save_files_png, temp_sprite)
	}
}