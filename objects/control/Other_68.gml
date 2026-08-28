var type = async_load[? "type"]
if type = network_type_data{
	var buffer = async_load[? "buffer"]
    buffer_seek(buffer, buffer_seek_start, 0)
    var msg = buffer_read(buffer, buffer_u8)
	if not in(msg, 8, 19)
		show_debug_message($"msg: {msg}")
	if msg = 1{ //Handle Hello
		var temp_socket = async_load[? "id"]
		var player_name = string(buffer_read(buffer, buffer_string))
		//Detectar nombre utilizado
		if array_contains(server_jugadores_nombre, player_name){
			var reply = buffer_create(1, buffer_grow, 1)
			buffer_write(reply, buffer_u8, 16)
			buffer_write(reply, buffer_u8, 0)
			network_send_packet(temp_socket, reply, buffer_tell(reply))
			buffer_delete(reply)
		}
		else{
			var slot = find_server_slot()
			if slot = -1{
				var reply = buffer_create(1, buffer_grow, 1)
				buffer_write(reply, buffer_u8, 16)
				buffer_write(reply, buffer_u8, 1)
				network_send_packet(temp_socket, reply, buffer_tell(reply))
				buffer_delete(reply)
			}
			else{
				server_jugadores[slot] = temp_socket
				handle_hello(temp_socket, buffer, slot)
			}
		}
	}
	else if msg = 2 //Handle Welcome
		handle_welcome(buffer)
	else if msg = 3 //Handle add edificio
		handle_add_edificio(buffer)
	else if msg = 4 //Handle delete edificio
		handle_delete_edificio(buffer)
    else if msg = 5 and servidor{ //Handle buscar servidor
		var reply = buffer_create(1, buffer_grow, 1)
		buffer_write(reply, buffer_u8, 6)
		network_send_udp(udp_socket, async_load[? "ip"], async_load[? "port"], reply, buffer_tell(reply))
		buffer_delete(reply)
	}
	else if msg = 6{ //Handle respuesta buscar servidor
		server_ip = async_load[? "ip"]
		server_buscando_lan = false
	}
	else if msg = 7 //Handle set edificio
		handle_set_edificio(buffer)
	else if msg = 8 //Handle timer
		handle_sync_timer(buffer)
	else if msg = 9 //Handle mover dron
		handle_mover_dron(buffer)
	else if msg = 10 //Handle add modulo
		handle_add_modulo(buffer)
	else if msg = 11 //Handle investigar
		handle_investigar(buffer)
	else if msg = 12 //Nuevo jugador unido
		handle_nuevo_jugador(buffer)
	else if msg = 13 //Handle jugador ido
		handle_jugador_ido(buffer)
	else if msg = 14 //Jugador eliminado
		handle_jugador_eliminado(buffer)
	else if msg = 15 //Server break
		handle_server_break()
	else if msg = 16{ //Error: Nombre utilizado
		var _error = buffer_read(buffer, buffer_u8)
		if _error = 0
			show_message(string(L.server_error_nombre, online_nombre))
		else if _error = 1
			show_message(L.server_error_lleno)
	}
	else if msg = 17 //Expulsado
		handle_jugador_expulsado(buffer)
	else if msg = 18 //Timeout
		handle_jugador_expulsado(buffer, true)
	else if msg = 19{ //Dar señales de vida
		handle_timeout(buffer)
		//Timeout jugadores
		if not servidor
			server_jugadores_timeout = [0]
	}
	else if msg = 20 //Mensaje
		handle_mensaje(buffer)
	
}