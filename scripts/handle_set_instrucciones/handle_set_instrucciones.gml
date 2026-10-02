function handle_set_instrucciones(buffer){
	with control{
		var _timer = real(buffer_read(buffer, buffer_u32))
		var a = real(buffer_read(buffer, buffer_u16))
		var b = real(buffer_read(buffer, buffer_u16))
		var edificio = edificio_id[# a, b]
		var cambio = {
			step : _timer,
			tipo : cambio_instrucciones,
			data : {}
		}
		var data = {
			a : a,
			b : b
		}
		if edificio.index = id_puerto_de_carga{
			var _jugador = edificio.jugador
			data.cambio = real(buffer_read(buffer, buffer_u8))
			if data.cambio = cambio_instrucciones_delete_comando
				data.instruccion = real(buffer_read(buffer, buffer_u8))
			else if data.cambio = cambio_instrucciones_cambio_recurso{
				data.instruccion = real(buffer_read(buffer, buffer_u8))
				data.rss = real(buffer_read(buffer, buffer_u8))
			}
			else if data.cambio = cambio_instrucciones_cambio_input{
				data.instruccion = real(buffer_read(buffer, buffer_u8))
				data.pointer = real(buffer_read(buffer, buffer_u16))
			}
			else if data.cambio = cambio_instrucciones_cambio_output{
				data.instruccion = real(buffer_read(buffer, buffer_u8))
				data.pointer = real(buffer_read(buffer, buffer_u16))
			}
		}
		else if edificio = id_procesador{
			//PLACEHOLDER
		}
		if servidor{
			set_edificio_instruccion(edificio, data, true)
			server_set_instrucciones(edificio, data)
		}
		else{
			cambio.data = data
			array_push(cambios, cambio)
		}
	}
}