function server_sync_timer(){
	var buffer = buffer_create(5, buffer_grow, 1)
	buffer_write(buffer, buffer_u8, 8) //Synct timer
	buffer_write(buffer, buffer_u32, timer)
	for(var i = 0; i < array_length(server_jugadores); i++)
		network_send_packet(server_jugadores[i], buffer, buffer_tell(buffer))
	buffer_delete(buffer)
}