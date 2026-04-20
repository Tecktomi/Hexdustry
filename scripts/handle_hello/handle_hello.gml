function handle_hello(socket, buffer){
	with control{
		online = true
		var player_name = buffer_read(buffer, buffer_string)
		//Detectar nombre utilizado
		if array_contains(server_jugadores_nombre, player_name){
			var reply = buffer_create(1, buffer_grow, 1)
			buffer_write(reply, buffer_u8, 16)
			network_send_packet(socket, reply, buffer_tell(reply))
			array_pop(server_jugadores)
			break
		}
		array_push(chat, $"{player_name} se ha unido")
		array_push(chat_time, image_index)
		array_push(server_jugadores_nombre, player_name)
		array_push(server_jugadores_timeout, -120)
		if servidor{
			var buffer_2 = buffer_create(2, buffer_grow, 1)
			buffer_write(buffer_2, buffer_u8, 12)
			buffer_write(buffer_2, buffer_string, player_name)
			for(var i = 1; i < array_length(server_jugadores) - 1; i++)
				network_send_packet(server_jugadores[i], buffer_2, buffer_tell(buffer_2))
			buffer_delete(buffer_2)
		}
		var reply = buffer_create(1024, buffer_grow, 1)
		buffer_write(reply, buffer_u8, 2)
		save_game_buffer(reply)
		buffer_write(reply, buffer_u8, array_length(server_jugadores_nombre) - 1)
		for(var i = 0; i < array_length(server_jugadores_nombre) - 1; i++)
			buffer_write(reply, buffer_string, server_jugadores_nombre[i])
		network_send_packet(socket, reply, buffer_tell(reply))
		buffer_delete(reply)
	}
}