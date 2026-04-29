function handle_jugador_eliminado(buffer){
	with control{
		if server_yendose{
			server_yendose = false
			network_destroy(server)
			server = -1
			servidor = false
			jugador = 2
		}
		else{
			var player_name = string(buffer_read(buffer, buffer_string))
			array_push(chat, string(L.server_jugador_ido, player_name))
			array_push(chat_time, image_index)
			eliminar_jugador(player_name)
		}
	}
}