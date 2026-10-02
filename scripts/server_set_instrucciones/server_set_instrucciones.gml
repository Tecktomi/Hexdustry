function server_set_instrucciones(edificio = control.null_edificio, data = {}){
	with control{
		var buffer = buffer_create(10, buffer_grow, 1)
		buffer_write(buffer, buffer_u8, net_set_instrucciones)
		buffer_write(buffer, buffer_u32, real(timer))
		buffer_write(buffer, buffer_u16, real(edificio.a))
		buffer_write(buffer, buffer_u16, real(edificio.b))
		if edificio.index = id_puerto_de_carga{
			buffer_write(buffer, buffer_u8, real(data.cambio))
			if data.cambio = cambio_instrucciones_delete_comando
				buffer_write(buffer, buffer_u8, real(data.instruccion))
			if data.cambio = cambio_instrucciones_cambio_recurso{
				buffer_write(buffer, buffer_u8, real(data.instruccion))
				buffer_write(buffer, buffer_u8, real(data.rss))
			}
			if data.cambio = cambio_instrucciones_cambio_input{
				buffer_write(buffer, buffer_u8, real(data.instruccion))
				buffer_write(buffer, buffer_u16, real(data.pointer))
			}
			if data.cambio = cambio_instrucciones_cambio_output{
				buffer_write(buffer, buffer_u8, real(data.instruccion))
				buffer_write(buffer, buffer_u16, real(data.pointer))
			}
		}
		else if edificio.index = id_procesador{
			//PLACEHOLDER
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