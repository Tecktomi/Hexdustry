function eliminar_jugador(index){
	with control{
		//Buscar index
		if not is_real(index){
			var pos
			for(pos = 0; pos < MAX_JUGADORES; pos++)
				if index = server_jugadores_nombre[pos]
					break
			index = pos
		}
		server_jugadores_nombre[index] = ""
		if server_pvp{
			index = index + 2
			if servidor
				jugador_recursos[index] = array_create(rss_max, 0)
			//Los edificios pasarán a ser salvajes
			var len = array_length(edificios_totales) - 1, a, edificio, dron
			for(a = len; a >= 0; a--){
				edificio = edificios_totales[a]
				if edificio.jugador = index{
					if edificio.index = id_nucleo
						delete_edificio(edificio, true)
					else{
						edificio.jugador = jugador_salvaje
						desactivar_edificio(edificio)
						array_disorder_remove(edificios_jugador[index], edificio, ptre_jugador)
						array_disorder_push(edificios_jugador[jugador_salvaje], edificio, ptre_jugador)
					}
				}
			}
			//Los drones se destruirán
			len = array_length(drones) - 1
			for(a = len; a >= 0; a--){
				dron = drones[a]
				if dron.jugador = index
					delete_dron(dron)
			}
			array_resize(puerto_carga_array[index], 0)
			puerto_carga_atended[index] = 0
			nucleos[index] = null_edificio
		}
	}
}