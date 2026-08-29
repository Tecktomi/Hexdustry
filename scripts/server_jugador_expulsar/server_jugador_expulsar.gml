function server_jugador_expulsar(index, timeout = false){
	with control{
		var buffer = buffer_create(1, buffer_grow, 1)
		buffer_write(buffer, buffer_u8, timeout ? net_timeout : net_expulsado)
		buffer_write(buffer, buffer_string, server_jugadores_nombre[index])
		server_broadcast_buffer(buffer)
		buffer_delete(buffer)
		if timeout
			array_push(chat, string(L.server_jugador_desconectado, server_jugadores_nombre[index]))
		else
			array_push(chat, string(L.server_jugador_expulsado, server_jugadores_nombre[index]))
		array_push(chat_time, image_index)
		server_jugadores[index] = -1
		server_jugadores_timeout[index] = -1
		eliminar_jugador(index)
	}
}