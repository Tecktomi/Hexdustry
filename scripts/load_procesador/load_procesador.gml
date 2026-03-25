function load_procesador(buffer, edificio = control.null_edificio){
	with control{
		var _version = buffer_read(buffer, buffer_u32)
		if _version < PROCESADOR_VERSION{
			//Retrocompatibilidad
			show_debug_message("Código obsoleto")
			return false
		}
		var size = real(buffer_read(buffer, buffer_u16))
		edificio.instruccion = array_create(size)
		for(var a = 0; a < size; a++){
			var size_2 = real(buffer_read(buffer, buffer_u8)), temp_array = array_create(size_2)
			for(var b = 0; b < size_2; b++){
				var esreal = buffer_read(buffer, buffer_bool)
				if esreal
					temp_array[b] = real(buffer_read(buffer, buffer_f16))
				else
					temp_array[b] = string(buffer_read(buffer, buffer_string))
			}
			edificio.instruccion[a] = temp_array
		}
		return true
	}
}