function jugador_unido(slot, limite){
	with control{
		if server_pvp{
			array_copy(jugador_recursos[slot + 2], 0, carga_inicial, 0, rss_max)
			pvp_rivales = true
		}
		EQUIPO_LIMIT = limite
	}
}