function server_expulsar(index, timeout = false){
	with control{
		var buffer = buffer_create(1, buffer_grow, 1)
		buffer_write(buffer, buffer_u8, 17 + timeout)
		buffer_write(buffer, buffer_string, server_jugadores_nombre[index])
		for(var i = 1; i < array_length(server_jugadores); i++)
			network_send_packet(server_jugadores[i], buffer, buffer_tell(buffer))
		buffer_delete(buffer)
		if timeout
			array_push(chat, $"{server_jugadores_nombre[index]} se ha desconectado")
		else
			array_push(chat, $"{server_jugadores_nombre[index]} ha sido expulsado")
		array_push(chat_time, image_index)
		array_delete(server_jugadores, index, 1)
		array_delete(server_jugadores_nombre, index, 1)
		array_delete(server_jugadores_timeout, index, 1)
	}
}