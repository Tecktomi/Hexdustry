function server_hello(){
	with control{
		var buffer = buffer_create(256, buffer_grow, 1)
		buffer_write(buffer, buffer_u8, 1) //Hello
		buffer_write(buffer, buffer_string, "Jugador1")
		network_send_packet(socket, buffer, buffer_tell(buffer))
		buffer_delete(buffer)
	}
}