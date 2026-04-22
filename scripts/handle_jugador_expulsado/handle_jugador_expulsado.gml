function handle_jugador_expulsado(buffer, timeout = false){
	with control{
		var player_name = string(buffer_read(buffer, buffer_string))
		if player_name = online_nombre{
			network_destroy(server)
			server = -1
			servidor = false
			clear_edit()
			menu = 0
			if timeout
				show_message(L.server_desconectado)
			else
				show_message(L.server_expulsado)
		}
		else{
			if timeout
				array_push(chat, string(L.server_jugador_desconectado, player_name))
			else
				array_push(chat, string(L.server_jugador_expulsado, player_name))
			array_push(chat_time, image_index)
			array_remove(server_jugadores_nombre, player_name)
		}
	}
}