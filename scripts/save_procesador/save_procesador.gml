function save_procesador(buffer, edificio = control.null_edificio){
	with control{
		var size = array_length(edificio.instruccion)
		buffer_write(buffer, buffer_u32, PROCESADOR_VERSION)
		buffer_write(buffer, buffer_u16, real(size))
		for(var a = 0; a < size; a++){
			var size_2 = array_length(edificio.instruccion[a])
			buffer_write(buffer, buffer_u8, real(size_2))
			for(var b = 0; b < size_2; b++){
				var esreal = is_real(edificio.instruccion[a, b])
				buffer_write(buffer, buffer_bool, bool(esreal))
				if esreal
					buffer_write(buffer, buffer_f16, real(edificio.instruccion[a, b]))
				else
					buffer_write(buffer, buffer_string, string(edificio.instruccion[a, b]))
			}
		}
	}
}