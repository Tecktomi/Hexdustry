function handle_hello(socket, buffer, slot){
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
					buffer_write(reply, buffer_u8, net_error)
					buffer_write(reply, buffer_u8, net_error_server_lleno)
					network_send_packet(socket, reply, buffer_tell(reply))
					buffer_delete(reply)
					server_jugadores[slot] = -1
					break
				}
				construir(id_nucleo, 0, new_nucleo_x, new_nucleo_y,,,, slot + 2)
				jugador_recursos[slot + 2] = array_create(rss_max, 0)
			}
		#endregion
		array_push(chat, string(L.server_jugador_unido, player_name))
		array_push(chat_time, image_index)
		server_jugadores_nombre[slot] = player_name
		server_jugadores_timeout[slot] = -120
		//Informar del nuevo jugador a los otros jugadores
		if servidor{
			var buffer_2 = buffer_create(2, buffer_grow, 1)
			buffer_write(buffer_2, buffer_u8, net_jugador_unido)
			buffer_write(buffer_2, buffer_string, player_name)
			buffer_write(buffer_2, buffer_u8, slot)
			server_broadcast_buffer(buffer_2)
			buffer_delete(buffer_2)
		}
		#region Reply
			var reply = buffer_create(1024, buffer_grow, 1)
			buffer_write(reply, buffer_u8, net_welcome)
			buffer_write(reply, buffer_bool, server_pvp)
			buffer_write(reply, buffer_u8, slot)
			save_game_buffer(reply)
			buffer_write(reply, buffer_u32, random_get_seed())
			if server_pvp{
				buffer_write(reply, buffer_u8, new_nucleo_x)
				buffer_write(reply, buffer_u8, new_nucleo_y)
			}
			for(var i = 0; i < MAX_JUGADORES; i++)
				buffer_write(reply, buffer_string, server_jugadores_nombre[i])
			network_send_packet(socket, reply, buffer_tell(reply))
			buffer_delete(reply)
		#endregion
	}
}