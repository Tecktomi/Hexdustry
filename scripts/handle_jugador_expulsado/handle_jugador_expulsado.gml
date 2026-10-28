function handle_jugador_expulsado(buffer, timeout = false){
	with control{
		var _timer = real(buffer_read(buffer, buffer_u32))
		var player_name = string(buffer_read(buffer, buffer_string))
		if player_name = online_nombre{
			game_terminar(fin_desconexion, MENU_PRINCIPAL)
			show_message(timeout ? L.server_desconectado : L.server_expulsado)
		}
		else{
			if timeout
				array_push(chat, string(L.server_jugador_desconectado, player_name))
			else
				array_push(chat, string(L.server_jugador_expulsado, player_name))
			array_push(chat_time, image_index)
			if servidor
				eliminar_jugador(player_name)
			else
				array_push(cambios, {step : _timer, tipo : cambio_eliminar_jugador, data : {pos : player_name}})
		}
	}
}