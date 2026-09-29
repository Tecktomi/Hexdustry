function server_investigar(index, _cheat = control.cheat, _jugador = jugador){
	with control{
		var buffer = buffer_create(7, buffer_grow, 1)
		buffer_write(buffer, buffer_u8, net_investigar)
		buffer_write(buffer, buffer_u32, real(timer))
		buffer_write(buffer, buffer_u8, real(index))
		buffer_write(buffer, buffer_bool, bool(_cheat))
		buffer_write(buffer, buffer_u8, real(_jugador))
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