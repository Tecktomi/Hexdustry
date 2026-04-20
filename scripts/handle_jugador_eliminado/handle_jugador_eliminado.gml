function handle_jugador_eliminado(buffer){
	with control{
		if server_yendose{
			server_yendose = false
			network_destroy(server)
			server = -1
			servidor = false
		}
		else{
			var player_name = string(buffer_read(buffer, buffer_string))
			array_push(chat, $"{player_name} se ha ido")
			array_push(chat_time, image_index)
			array_remove(server_jugadores_nombre, player_name)
		}
	}
}