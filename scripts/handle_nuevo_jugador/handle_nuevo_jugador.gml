function handle_nuevo_jugador(buffer){
	with control{
		var player_name = string(buffer_read(buffer, buffer_string))
		array_push(chat, $"{player_name} se ha unido")
		array_push(chat_time, image_index)
		array_push(server_jugadores_nombre, player_name)
	}
}