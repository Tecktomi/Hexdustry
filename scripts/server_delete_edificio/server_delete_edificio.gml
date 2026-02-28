function server_delete_edificio(a, b, destruccion){
	with control{
		var buffer = buffer_create(256, buffer_grow, 1)
		buffer_write(buffer, buffer_u8, 4) //Delete edificio
		buffer_write(buffer, buffer_u16, real(a))
		buffer_write(buffer, buffer_u16, real(b))
		buffer_write(buffer, buffer_bool, bool(destruccion))
		if servidor{
			for(var i = 0; i < array_length(server_jugadores); i++)
				network_send_packet(server_jugadores[i], buffer, buffer_tell(buffer))
		}
		else
			network_send_packet(socket, buffer, buffer_tell(buffer))
		buffer_delete(buffer)
	}
}