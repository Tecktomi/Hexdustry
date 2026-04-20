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
				show_message("Se ha perdido la conexión con el servidor")
			else
				show_message("Te han expulsado del servidor")
		}
		else{
			if timeout
				array_push(chat, $"{player_name} se ha desconectado")
			else
				array_push(chat, $"{player_name} ha sido expulsado")
			array_push(chat_time, image_index)
			array_remove(server_jugadores_nombre, player_name)
		}
	}
}