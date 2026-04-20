function handle_exit(buffer){
	with control{
		var player_name = buffer_read(buffer, buffer_string), pos = 0
		var buffer_2 = buffer_create(2, buffer_grow, 1)
		buffer_write(buffer_2, buffer_u8, 14)
		buffer_write(buffer_2, buffer_string, player_name)
		for(var i = 1; i < array_length(server_jugadores); i++)
			network_send_packet(server_jugadores[i], buffer_2, buffer_tell(buffer_2))
		buffer_delete(buffer_2)
		for(pos = 0; pos < array_length(server_jugadores); pos++)
			if player_name = server_jugadores_nombre[pos]
				break
		array_delete(server_jugadores, pos, 1)
		array_delete(server_jugadores_nombre, pos, 1)
		array_delete(server_jugadores_timeout, pos, 1)
		array_push(chat, $"{player_name} se ha ido")
		array_push(chat_time, image_index)
	}
}