function handle_welcome(buffer){
	with control{
		online = true
		if not load_game_buffer(buffer)
			show_message("Error, archivo obsoleto")
		var len = real(buffer_read(buffer, buffer_u8))
		repeat(len)
			array_push(server_jugadores_nombre, string(buffer_read(buffer, buffer_string)))
	}
}