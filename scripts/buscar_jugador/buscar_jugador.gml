function buscar_jugador(nombre){
	with control{
		if nombre = ""
			return -1
		for(var pos = 0; pos < MAX_JUGADORES; pos++)
			if server_jugadores_nombre[pos] = nombre
				return pos
		return -1
	}
}