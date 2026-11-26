function server_revisar_conexiones(){
	with control{
		for(var i = 1; i < MAX_JUGADORES; i++)
			if server_jugadores[i] != -1 and ++server_jugadores_timeout[i] >= TIMEOUT_EXPULSION
				server_jugador_expulsar(i, true)
	}
}