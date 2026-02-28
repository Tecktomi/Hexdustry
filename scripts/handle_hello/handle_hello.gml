function handle_hello(socket, buffer){
	with control{
		online = true
		var player_name = buffer_read(buffer, buffer_string)
		var reply = buffer_create(256, buffer_grow, 1)
		buffer_write(reply, buffer_u8, 2) //Welcome
		buffer_write(reply, buffer_u32, seed)
		buffer_write(reply, buffer_u8, biome_seed)
		buffer_write(reply, buffer_u32, timer)
		buffer_write(reply, buffer_u32, oleadas_timer)
		network_send_packet(socket, reply, buffer_tell(reply))
		buffer_delete(reply)
	}
}