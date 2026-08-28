function server_break(){
	with control{
		var buffer = buffer_create(1, buffer_grow, 1)
		buffer_write(buffer, buffer_u8, 15)
		server_broadcast_buffer(buffer)
		buffer_delete(buffer)
	}
}