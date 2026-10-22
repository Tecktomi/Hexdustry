function handle_mensaje(buffer){
	with control{
		var _jugador = string(buffer_read(buffer, buffer_string))
		var mensaje = string(buffer_read(buffer, buffer_string))
		if servidor
			server_mensaje(_jugador, mensaje)
		if _jugador != online_nombre{
			array_push(chat, $"{_jugador}: {mensaje}")
			array_push(chat_time, image_index)
		}
	}
}