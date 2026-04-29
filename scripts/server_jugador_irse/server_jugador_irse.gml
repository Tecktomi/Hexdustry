function server_jugador_irse(){
	with control{
		var buffer = buffer_create(2 + string_length(online_nombre), buffer_grow, 1)
		buffer_write(buffer, buffer_u8, 13)
		buffer_write(buffer, buffer_string, online_nombre)
		network_send_packet(socket, buffer, buffer_tell(buffer))
		buffer_delete(buffer)
		server_yendose = true
		jugador = 2
	}
}