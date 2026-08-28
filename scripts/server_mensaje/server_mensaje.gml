function server_mensaje(mensaje){
	if mensaje = ""
		exit
	with control{
		var buffer = buffer_create(1, buffer_grow, 1)
		buffer_write(buffer, buffer_u8, 20)
		buffer_write(buffer, buffer_string, string(mensaje))
		if servidor
			server_broadcast_buffer(buffer)
		else
			network_send_packet(socket, buffer, buffer_tell(buffer))
		buffer_delete(buffer)
	}
}