function calcular_equipo_limite(_incluir = -1, _excluir = -1){
	with control{
		var limite = 3, i
		if server_pvp
			for(i = 1; i < MAX_JUGADORES; i++)
				if (server_jugadores[i] != -1 or i = _incluir) and i != _excluir
					limite = i + 3
		return limite
	}
}