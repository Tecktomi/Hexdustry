function server_sync_timer(){
	var buffer = buffer_create(5, buffer_grow, 1)
	buffer_write(buffer, buffer_u8, net_timer)
	buffer_write(buffer, buffer_u32, timer)
	for(var i = 0; i < MAX_JUGADORES; i++)
		if server_jugadores[i] != -1{
			network_send_packet(server_jugadores[i], buffer, buffer_tell(buffer))
			if server_jugadores_timeout[i]++ >= 18{
				server_jugadores_timeout[i] = 0
				server_jugador_expulsar(i, true)
			}
		}
	buffer_delete(buffer)
}