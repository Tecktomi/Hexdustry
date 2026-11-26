function handle_jugador_ido(buffer){
	with control{
		var _timer = real(buffer_read(buffer, buffer_u32))
		var player_name = string(buffer_read(buffer, buffer_string))
		var pos = buscar_jugador(player_name)
		if pos <= 0
			exit
		var limite = servidor ? calcular_equipo_limite(, pos) : EQUIPO_LIMIT
		var buffer_2 = buffer_create(8, buffer_grow, 1)
		buffer_write(buffer_2, buffer_u8, net_jugador_eliminado)
		buffer_write(buffer_2, buffer_u32, real(timer))
		buffer_write(buffer_2, buffer_string, player_name)
		buffer_write(buffer_2, buffer_u8, pos)
		buffer_write(buffer_2, buffer_u8, limite)
		server_broadcast_buffer(buffer_2)
		buffer_delete(buffer_2)
		server_jugadores[pos] = -1
		server_jugadores_timeout[pos] = 0
		array_push(chat, string(L.server_jugador_ido, player_name))
		array_push(chat_time, image_index)
		if servidor
			eliminar_jugador(pos, limite)
		else
			array_push(cambios, {step : _timer, tipo : cambio_eliminar_jugador, data : {pos : pos, limite : limite}})
	}
}