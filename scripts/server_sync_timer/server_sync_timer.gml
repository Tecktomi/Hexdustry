function server_sync_timer(){
	var buffer = buffer_create(5, buffer_grow, 1)
	buffer_write(buffer, buffer_u8, 8) //Synct timer
	buffer_write(buffer, buffer_u32, timer)
	for(var i = array_length(server_jugadores) - 1; i > 0; i--){
		network_send_packet(server_jugadores[i], buffer, buffer_tell(buffer))
		if server_jugadores_timeout[i]++ >= 18{
			server_jugadores_timeout[i] = 0
			server_expulsar(i, true)
		}
	}
	buffer_delete(buffer)
}