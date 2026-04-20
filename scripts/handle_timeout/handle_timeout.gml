function handle_timeout(buffer){
	with control{
		var player_name = string(buffer_read(buffer, buffer_string))
		var pos
		for(pos = 0; pos < array_length(server_jugadores_nombre); pos++)
			if player_name = server_jugadores_nombre[pos]
				break
		server_jugadores_timeout[pos] = 0
	}
}