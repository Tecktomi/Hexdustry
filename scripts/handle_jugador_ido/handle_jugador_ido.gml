function handle_jugador_ido(buffer){
	with control{
		var player_name = buffer_read(buffer, buffer_string), pos = 0
		var buffer_2 = buffer_create(2, buffer_grow, 1)
		buffer_write(buffer_2, buffer_u8, net_jugador_eliminado)
		buffer_write(buffer_2, buffer_string, player_name)
		server_broadcast_buffer(buffer_2)
		buffer_delete(buffer_2)
		for(pos = 0; pos < MAX_JUGADORES; pos++)
			if player_name = server_jugadores_nombre[pos]
				break
		server_jugadores[pos] = -1
		server_jugadores_timeout[pos] = 0
		array_push(chat, string(L.server_jugador_ido, player_name))
		array_push(chat_time, image_index)
		eliminar_jugador(pos)
	}
}