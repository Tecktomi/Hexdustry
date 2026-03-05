function handle_hello(socket, buffer){
	with control{
		online = true
		var player_name = buffer_read(buffer, buffer_string)
		var reply = buffer_create(4096, buffer_grow, 1)
		save_game_buffer(reply)
		network_send_packet(socket, reply, buffer_tell(reply))
		buffer_delete(reply)
	}
}