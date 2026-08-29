function server_hello(){
	with control{
		clear_edificios()
		var buffer = buffer_create(2, buffer_grow, 1)
		buffer_write(buffer, buffer_u8, net_hello)
		buffer_write(buffer, buffer_string, online_nombre)
		network_send_packet(socket, buffer, buffer_tell(buffer))
		buffer_delete(buffer)
	}
}