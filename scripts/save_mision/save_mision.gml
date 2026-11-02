function save_mision(buffer){
	with control{
		var a, b, c, len_mis = array_length(misiones), len_text, _mision, len_tiles
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
			buffer_write(buffer, buffer_bool, _mision.tiempo_edit)
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
			for(b = 0; b < len_text; b++)
				for(c = 0; c < IDIOMAS; c++)
					buffer_write(buffer, buffer_string, _mision.texto[b, c])
			len_tiles = array_length(_mision.tiles)
			buffer_write(buffer, buffer_u8, len_tiles)
			for(b = 0; b < len_tiles; b++)
				buffer_write(buffer, buffer_u16, _mision.tiles[b])
			
		}
	}
}