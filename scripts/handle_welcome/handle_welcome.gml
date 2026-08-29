function handle_welcome(buffer){
	with control{
		online = true
		server_pvp = bool(buffer_read(buffer, buffer_bool))
		var slot = real(buffer_read(buffer, buffer_u8))
		jugador = server_pvp ? slot + 2 : 2
		if not load_game_buffer(buffer)
			show_message(L.archivo_obsoleto)
		random_set_seed(real(buffer_read(buffer, buffer_u32)))
		drones_propios = drones_jugador[jugador]
		//Asignar núcleo y recursos
		if server_pvp{
			var a = real(buffer_read(buffer, buffer_u8)), b = real(buffer_read(buffer, buffer_u8))
			nucleos[jugador] = edificio_id[# a, b]
			for(a = 0; a < rss_max; a++)
				array_set(jugador_recursos[jugador], a, carga_inicial[a])
			camx = clamp(nucleos[jugador].a * 48 - room_width / 2, 0, xsize * 48 * zoom - room_width)
			camy = clamp(nucleos[jugador].b * 14 - room_height / 2, 0, ysize * 14 * zoom - room_height)
		}
		for(var a = 0; a < MAX_JUGADORES; a++)
			server_jugadores_nombre[a] = string(buffer_read(buffer, buffer_string))
		server_jugadores_nombre[slot] = online_nombre
		server_jugadores_timeout[slot] = -120
	}
}