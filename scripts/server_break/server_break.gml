function server_break(){
	with control{
		var buffer = buffer_create(1, buffer_grow, 1)
		buffer_write(buffer, buffer_u8, 15)
		for(var i = 1; i < array_length(server_jugadores); i++)
			network_send_packet(server_jugadores[i], buffer, buffer_tell(buffer))
		buffer_delete(buffer)
	}
}