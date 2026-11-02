function load_mision(buffer){
	with control{
		var a, b, c
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
			var len_tiles = real(buffer_read(buffer, buffer_u8))
			var _tiles = array_create(len_tiles, 0)
			for(b = 0; b < len_tiles; b++)
				_tiles[b] = real(buffer_read(buffer, buffer_u16))
			misiones[a] = def_mision(_nombre, _nombre_idioma, _objetivo, _target_id, _target_num, _texto, _tiempo_edit, _tiempo, _tiempo_victoria, _tiempo_show, _camera_move, _camera_x, _camera_y, _switch_oleadas, _tiles)
		}
	}
}