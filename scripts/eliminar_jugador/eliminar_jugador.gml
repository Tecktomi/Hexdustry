function eliminar_jugador(index){
	with control{
		if not is_real(index){
			var pos
			for(pos = 0; pos < array_length(server_jugadores_nombre); pos++)
				if index = server_jugadores_nombre[pos]
					break
			index = pos
		}
		array_delete(server_jugadores_nombre, index, 1)
		if server_pvp{
			var len = array_length(edificios_totales) - 1
			for(var a = len; a >= 0; a--){
				var edificio = edificios_totales[a]
				if edificio.jugador = index + 2{
					if edificio.index = id_nucleo
						delete_edificio(edificio, true)
					else{
						edificio.jugador = 0
						array_disorder_remove(edificios_enemigos, edificio, 0)
						array_disorder_remove(chunk_edificios_enemigo[# edificio.chunk_x, edificio.chunk_y], edificio, 1)
						desactivar_edificio(edificio)
					}
				}
			}
			if servidor
				array_delete(jugador_recursos, index, 1)
		}
	}
}