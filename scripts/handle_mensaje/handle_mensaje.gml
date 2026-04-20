function handle_mensaje(buffer){
	with control{
		var mensaje = string(buffer_read(buffer, buffer_string))
		if server
			server_mensaje(mensaje)
		array_push(chat, mensaje)
		array_push(chat_time, image_index)
	}
}