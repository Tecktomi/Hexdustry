function handle_set_instrucciones(buffer){
	with control{
		var _timer = real(buffer_read(buffer, buffer_u32))
		var a = real(buffer_read(buffer, buffer_u16))
		var b = real(buffer_read(buffer, buffer_u16))
		var cambio = real(buffer_read(buffer, buffer_u8))
		var edificio = edificio_id[# a, b]
		var new_cambio = {
			step : _timer,
			tipo : cambio_instrucciones,
			data : {}
		}
		var data = {
			a : a,
			b : b,
			cambio : cambio
		}
		if cambio = cambio_activar{}
		else if cambio = cambio_rotar_tunel{}
		else if cambio = cambio_silo_target{
			data._x = real(buffer_read(buffer, buffer_f64))
			data._y = real(buffer_read(buffer, buffer_f64))
		}
		else if edificio.index = id_puerto_de_carga{
			var _jugador = edificio.jugador
			if cambio = cambio_instrucciones_delete_comando
				data.instruccion = real(buffer_read(buffer, buffer_u8))
			else if cambio = cambio_instrucciones_cambio_recurso{
				data.instruccion = real(buffer_read(buffer, buffer_u8))
				data.rss = real(buffer_read(buffer, buffer_u8))
			}
			else if cambio = cambio_instrucciones_cambio_input{
				data.instruccion = real(buffer_read(buffer, buffer_u8))
				data.a = real(buffer_read(buffer, buffer_u16))
				data.b = real(buffer_read(buffer, buffer_u16))
			}
			else if cambio = cambio_instrucciones_cambio_output{
				data.instruccion = real(buffer_read(buffer, buffer_u8))
				data.a = real(buffer_read(buffer, buffer_u16))
				data.b = real(buffer_read(buffer, buffer_u16))
			}
		}
		else if edificio.index = id_procesador{
			data.instruccion = real(buffer_read(buffer, buffer_u8))
			if cambio = cambio_vincular{
				data.desa = real(buffer_read(buffer, buffer_u16))
				data.desb = real(buffer_read(buffer, buffer_u16))
			}
			else if cambio = cambio_instrucciones_set_variable{
				if buffer_read(buffer, buffer_bool)
					data.valor = real(buffer_read(buffer, buffer_f64))
				else
					data.valor = string(buffer_read(buffer, buffer_string))
			}
			else if cambio = cambio_instruccion_mover
				data.prev = real(buffer_read(buffer, buffer_u8))
			else if cambio = cambio_instruccion_set{
				data.pos = real(buffer_read(buffer, buffer_u8))
				if buffer_read(buffer, buffer_bool)
					data.valor = real(buffer_read(buffer, buffer_f64))
				else
					data.valor = string(buffer_read(buffer, buffer_string))
			}
		}
		else if edificio.index = id_memoria{
			data.instruccion = real(buffer_read(buffer, buffer_u8))
			if buffer_read(buffer, buffer_bool)
				data.valor = real(buffer_read(buffer, buffer_f64))
			else
				data.valor = string(buffer_read(buffer, buffer_string))
		}
		else if cambio = cambio_target_drones{
			data.desa = real(buffer_read(buffer, buffer_u16))
			data.desb = real(buffer_read(buffer, buffer_u16))
		}
		if servidor{
			set_edificio_instruccion(edificio, data.cambio, data)
			server_set_instrucciones(edificio, data.cambio, data)
		}
		else{
			new_cambio.data = data
			array_push(cambios, new_cambio)
		}
	}
}