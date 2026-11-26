function handle_timeout(buffer){
	with control{
		var pos = buscar_jugador(string(buffer_read(buffer, buffer_string)))
		if pos >= 0
			server_jugadores_timeout[pos] = 0
	}
}