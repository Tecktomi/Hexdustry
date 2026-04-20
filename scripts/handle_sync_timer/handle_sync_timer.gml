function handle_sync_timer(buffer){
	server_timer = real(buffer_read(buffer, buffer_u32))
	if not servidor and server_sync_counter++ >= 6{ //Dar señales de vida
		server_sync_counter = 0
		var reply = buffer_create(2 + string_length(online_nombre), buffer_grow, 1)
		buffer_write(reply, buffer_u8, 19)
		buffer_write(reply, buffer_string, online_nombre)
		network_send_packet(socket, reply, buffer_tell(reply))
		buffer_delete(reply)
	}
}