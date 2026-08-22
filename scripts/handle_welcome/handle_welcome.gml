function handle_welcome(buffer){
	with control{
		online = true
		server_pvp = bool(buffer_read(buffer, buffer_bool))
		var len = real(buffer_read(buffer, buffer_u8))
		jugador = server_pvp ? len + 2 : 2
		if not load_game_buffer(buffer)
			show_message(L.archivo_obsoleto)
		//Asignar núcleo y recursos
		if server_pvp{
			var a = real(buffer_read(buffer, buffer_u8)), b = real(buffer_read(buffer, buffer_u8)), edificio, aa, bb
			nucleo = edificio_id[# a, b]
			jugador_recursos = array_create(1, array_create(rss_max, 0))
			for(a = 0; a < rss_max; a++)
				array_set(jugador_recursos[0], a, carga_inicial[a])
			camx = clamp(nucleo.a * 48 - room_width / 2, 0, xsize * 48 * zoom - room_width)
			camy = clamp(nucleo.b * 14 - room_height / 2, 0, ysize * 14 * zoom - room_height)
			for(a = array_length(nucleos) - 1; a >= 0; a--){
				edificio = nucleos[a]
				if edificio != nucleo and not edificio.enemigo{
					aa = edificio.chunk_x
					bb = edificio.chunk_y
					edificio.enemigo = true
					array_disorder_remove(edificios, edificio, 0)
					array_disorder_push(edificios_enemigos, edificio, 0)
					array_disorder_remove(chunk_edificios[# aa, bb], edificio, 2)
					array_disorder_push(chunk_edificios_enemigo[# aa, bb], edificio, 2)
				}
			}
		}
		server_jugadores_nombre = array_create(0, "")
		repeat(len)
			array_push(server_jugadores_nombre, string(buffer_read(buffer, buffer_string)))
		array_push(server_jugadores_nombre, online_nombre)
		server_jugadores_timeout = [-120]
	}
}