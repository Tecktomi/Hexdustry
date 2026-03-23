function handle_welcome(buffer){
	with control{
		online = true
		if not load_game_buffer(buffer)
			show_message("Error, archivo obsoleto")
	}
}