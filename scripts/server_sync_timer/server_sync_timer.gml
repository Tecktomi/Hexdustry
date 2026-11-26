function server_sync_timer(){
	var buffer = buffer_create(5, buffer_grow, 1)
	buffer_write(buffer, buffer_u8, net_timer)
	buffer_write(buffer, buffer_u32, timer)
	server_broadcast_buffer(buffer)
	buffer_delete(buffer)
}