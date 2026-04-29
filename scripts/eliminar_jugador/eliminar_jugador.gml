function eliminar_jugador(index){
	with control{
		//Buscar index
		if not is_real(index){
			var pos
			for(pos = 0; pos < array_length(server_jugadores_nombre); pos++)
				if index = server_jugadores_nombre[pos]
					break
			index = pos
		}
		array_delete(server_jugadores_nombre, index, 1)
		if server_pvp{
			if servidor
				array_delete(jugador_recursos, index, 1)
			index = index + 2
			//Los edificios pasarán a ser salvajes
			var len = array_length(edificios_totales) - 1
			for(var a = len; a >= 0; a--){
				var edificio = edificios_totales[a]
				if edificio.jugador = index{
					if edificio.index = id_nucleo
						delete_edificio(edificio, true)
					else{
						edificio.jugador = 0
						desactivar_edificio(edificio)
						array_disorder_remove(edificios_enemigos, edificio, 0)
						array_disorder_push(edificios_abandonados, edificio, 0)
						array_disorder_remove(chunk_edificios_enemigo[# edificio.chunk_x, edificio.chunk_y], edificio, 1)
						array_disorder_push(chunk_edificios_abandonado[# edificio.chunk_x, edificio.chunk_y], edificio, 1)
					}
				}
			}
			//Los drones se destruirán
			len = array_length(drones) - 1
			for(var a = len; a >= 0; a--){
				var dron = drones[a]
				if dron.jugador = index
					delete_dron(dron)
			}
		}
	}
}