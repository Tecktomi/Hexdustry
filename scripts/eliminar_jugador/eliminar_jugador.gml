function eliminar_jugador(_jugador){
	with control{
		//Buscar _jugador
		if not is_real(_jugador){
			var pos
			for(pos = 0; pos < MAX_JUGADORES; pos++)
				if _jugador = server_jugadores_nombre[pos]
					break
			_jugador = pos
		}
		server_jugadores_nombre[_jugador] = ""
		if server_pvp{
			_jugador = _jugador + 2
			if servidor
				jugador_recursos[_jugador] = array_create(rss_max, 0)
			//Los edificios pasarán a ser salvajes
			var len = array_length(edificios_totales) - 1, a, edificio, dron
			for(a = len; a >= 0; a--){
				edificio = edificios_totales[a]
				if edificio.jugador = _jugador{
					if edificio.index = id_nucleo
						delete_edificio(edificio, true)
					else{
						edificio.jugador = JUGADOR_SALVAJE
						desactivar_edificio(edificio)
						array_disorder_remove(edificios_jugador[_jugador], edificio, ptre_jugador)
						array_disorder_remove(edificios_jugador_index[_jugador, edificio.index], edificio, ptre_jugador_index)
						array_disorder_remove(chunk_edificios_jugador[_jugador][# edificio.chunk_x, edificio.chunk_y], edificio, ptre_chunk_jugador)
						array_disorder_push(edificios_jugador[JUGADOR_SALVAJE], edificio, ptre_jugador)
						array_disorder_push(edificios_jugador_index[JUGADOR_SALVAJE, edificio.index], edificio, ptre_jugador_index)
						array_disorder_push(chunk_edificios_jugador[JUGADOR_SALVAJE][# edificio.chunk_x, edificio.chunk_y], edificio, ptre_chunk_jugador)
					}
				}
			}
			//Los drones se destruirán
			len = array_length(drones) - 1
			for(a = len; a >= 0; a--){
				dron = drones[a]
				if dron.jugador = _jugador
					delete_dron(dron)
			}
			array_resize(puerto_carga_array[_jugador], 0)
			puerto_carga_atended[_jugador] = 0
			nucleos[_jugador] = null_edificio
		}
	}
}