function eliminar_jugador(_jugador, limite = -1){
	with control{
		//Buscar _jugador
		if not is_real(_jugador)
			_jugador = buscar_jugador(_jugador)
		if _jugador < 0 or _jugador >= MAX_JUGADORES
			exit
		server_jugadores_nombre[_jugador] = ""
		if limite >= 0
			EQUIPO_LIMIT = limite
		if server_pvp
			equipo_abandonar(_jugador + 2)
	}
}