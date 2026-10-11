function server_set_instrucciones(edificio = control.null_edificio, cambio, data = {}){
	with control{
		var buffer = buffer_create(10, buffer_grow, 1)
		buffer_write(buffer, buffer_u8, net_set_instrucciones)
		buffer_write(buffer, buffer_u32, real(timer))
		buffer_write(buffer, buffer_u16, real(edificio.a))
		buffer_write(buffer, buffer_u16, real(edificio.b))
		buffer_write(buffer, buffer_s8, real(cambio))
		if cambio = cambio_activar{}
		else if cambio = cambio_rotar{}
		else if cambio = cambio_silo_target{
			buffer_write(buffer, buffer_f64, real(data._x))
			buffer_write(buffer, buffer_f64, real(data._y))
		}
		else if edificio.index = id_puerto_de_carga{
			if cambio = cambio_instrucciones_delete_comando
				buffer_write(buffer, buffer_u8, real(data.instruccion))
			else if cambio = cambio_instrucciones_cambio_recurso{
				buffer_write(buffer, buffer_u8, real(data.instruccion))
				buffer_write(buffer, buffer_u8, real(data.rss))
			}
			else if cambio = cambio_instrucciones_cambio_input{
				buffer_write(buffer, buffer_u8, real(data.instruccion))
				buffer_write(buffer, buffer_u16, real(data.a))
				buffer_write(buffer, buffer_u16, real(data.b))
			}
			else if cambio = cambio_instrucciones_cambio_output{
				buffer_write(buffer, buffer_u8, real(data.instruccion))
				buffer_write(buffer, buffer_u16, real(data.a))
				buffer_write(buffer, buffer_u16, real(data.b))
			}
		}
		else if edificio.index = id_procesador{
			buffer_write(buffer, buffer_u8, real(data.instruccion))
			if cambio = cambio_instrucciones_set_variable{
				buffer_write(buffer, buffer_bool, is_real(data.valor))
				if is_real(data.valor)
					buffer_write(buffer, buffer_f64, real(data.valor))
				else
					buffer_write(buffer, buffer_string, string(data.valor))
			}
			else if cambio = cambio_instruccion_mover
				buffer_write(buffer, buffer_u8, real(data.prev))
			else if cambio = cambio_instruccion_set{
				buffer_write(buffer, buffer_u8, real(data.pos))
				buffer_write(buffer, buffer_bool, is_real(data.valor))
				if is_real(data.valor)
					buffer_write(buffer, buffer_f64, real(data.valor))
				else
					buffer_write(buffer, buffer_string, string(data.valor))
			}
			else if cambio = cambio_vincular{
				buffer_write(buffer, buffer_u16,real(data.desa))
				buffer_write(buffer, buffer_u16,real(data.desb))
			}
		}
		else if edificio.index = id_memoria{
			buffer_write(buffer, buffer_u8, real(data.instruccion))
			buffer_write(buffer, buffer_bool, is_real(data.valor))
			if is_real(data.valor)
				buffer_write(buffer, buffer_f64, real(data.valor))
			else
				buffer_write(buffer, buffer_string, string(data.valor))
		}
		if online{
			if servidor
				server_broadcast_buffer(buffer)
			else
				network_send_packet(socket, buffer, buffer_tell(buffer))
		}
		if GRABANDO
			grabar_buffer(buffer)
		buffer_delete(buffer)
	}
}