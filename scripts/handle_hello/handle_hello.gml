function handle_hello(socket, buffer){
	with control{
		online = true
		#region Crear núcleo PvP
			var new_nucleo_x, new_nucleo_y, tries = 0
			if server_pvp{
				do{
					new_nucleo_x = irandom_range(10, xsize - 11)
					new_nucleo_y = irandom_range(10, ysize - 11)
				}
				until (far_from_nucleus(new_nucleo_x, new_nucleo_y) and check_colision(new_nucleo_x, new_nucleo_y, id_nucleo, 0)) or tries++ = 100
				if tries = 100{
					var reply = buffer_create(1, buffer_grow, 1)
					buffer_write(reply, buffer_u8, 16)
					network_send_packet(socket, reply, buffer_tell(reply))
					array_pop(server_jugadores)
					break
				}
				construir(id_nucleo, 0, new_nucleo_x, new_nucleo_y,,,, array_length(server_jugadores_nombre) + 2)
				array_push(jugador_recursos, array_create(rss_max, 0))
			}
		#endregion
		array_push(chat, string(L.server_jugador_unido, player_name))
		array_push(chat_time, image_index)
		array_push(server_jugadores_nombre, player_name)
		array_push(server_jugadores_timeout, -120)
		//Informar del nuevo jugador a los otros jugadores
		if servidor{
			var buffer_2 = buffer_create(2, buffer_grow, 1)
			buffer_write(buffer_2, buffer_u8, 12)
			buffer_write(buffer_2, buffer_string, player_name)
			for(var i = 1; i < array_length(server_jugadores) - 1; i++)
				network_send_packet(server_jugadores[i], buffer_2, buffer_tell(buffer_2))
			buffer_delete(buffer_2)
		}
		#region Reply
			var reply = buffer_create(1024, buffer_grow, 1)
			buffer_write(reply, buffer_u8, 2)
			buffer_write(reply, buffer_bool, server_pvp)
			buffer_write(reply, buffer_u8, array_length(server_jugadores_nombre) - 1)
			save_game_buffer(reply)
			if server_pvp{
				buffer_write(reply, buffer_u8, new_nucleo_x)
				buffer_write(reply, buffer_u8, new_nucleo_y)
			}
			for(var i = 0; i < array_length(server_jugadores_nombre) - 1; i++)
				buffer_write(reply, buffer_string, server_jugadores_nombre[i])
			network_send_packet(socket, reply, buffer_tell(reply))
			buffer_delete(reply)
		#endregion
	}
}