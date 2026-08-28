function server_broadcast_buffer(buffer){
	with control{
		for(var i = 1; i < MAX_JUGADORES; i++)
			if server_jugadores[i] != -1
				network_send_packet(server_jugadores[i], buffer, buffer_tell(buffer))
	}
}