function handle_jugador_nuevo(buffer){
	with control{
		var _timer = real(buffer_read(buffer, buffer_u32))
		var player_name = string(buffer_read(buffer, buffer_string))
		var slot = real(buffer_read(buffer, buffer_u8))
		var limite = real(buffer_read(buffer, buffer_u8))
		array_push(chat, string(L.server_jugador_unido, player_name))
		array_push(chat_time, image_index)
		server_jugadores_nombre[slot] = player_name
		array_push(cambios, {step : _timer, tipo : cambio_jugador_unido, data : {slot : slot, limite : limite}})
	}
}