var type = async_load[? "type"]
if type = network_type_data{
	var buffer = async_load[? "buffer"]
    buffer_seek(buffer, buffer_seek_start, 0)
    var msg = buffer_read(buffer, buffer_u8)
	if msg = net_hello{
		var temp_socket = async_load[? "id"]
		var player_name = string(buffer_read(buffer, buffer_string))
		//Detectar nombre utilizado
		if array_contains(server_jugadores_nombre, player_name){
			var reply = buffer_create(2, buffer_grow, 1)
			buffer_write(reply, buffer_u8, net_error)
			buffer_write(reply, buffer_u8, net_error_nombre_usado)
			network_send_packet(temp_socket, reply, buffer_tell(reply))
			buffer_delete(reply)
		}
		else{
			var slot = find_server_slot()
			if slot = -1{
				var reply = buffer_create(2, buffer_grow, 1)
				buffer_write(reply, buffer_u8, net_error)
				buffer_write(reply, buffer_u8, net_error_server_lleno)
				network_send_packet(temp_socket, reply, buffer_tell(reply))
				buffer_delete(reply)
			}
			else{
				server_jugadores[slot] = temp_socket
				handle_hello(temp_socket, buffer, slot)
			}
		}
	}
	else if msg = net_welcome
		handle_welcome(buffer)
	else if msg = net_add_edificio
		handle_add_edificio(buffer)
	else if msg = net_delete_edificio
		handle_delete_edificio(buffer)
    else if msg = net_buscar_server{
		if servidor{
			var reply = buffer_create(1, buffer_grow, 1)
			buffer_write(reply, buffer_u8, net_respuesta_buscar)
			network_send_udp(udp_socket, async_load[? "ip"], async_load[? "port"], reply, buffer_tell(reply))
			buffer_delete(reply)
		}
	}
	else if msg = net_respuesta_buscar{
		server_ip = async_load[? "ip"]
		server_buscando_lan = false
	}
	else if msg = net_set_edificio
		handle_set_edificio(buffer)
	else if msg = net_timer
		handle_sync_timer(buffer)
	else if msg = net_mover_dron
		handle_mover_dron(buffer)
	else if msg = net_add_modulo
		handle_add_modulo(buffer)
	else if msg = net_investigar
		handle_investigar(buffer)
	else if msg = net_jugador_unido
		handle_nuevo_jugador(buffer)
	else if msg = net_jugador_ido
		handle_jugador_ido(buffer)
	else if msg = net_jugador_eliminado
		handle_jugador_eliminado(buffer)
	else if msg = net_server_break
		handle_server_break()
	else if msg = net_error{
		var _error = buffer_read(buffer, buffer_u8)
		if _error = net_error_nombre_usado
			show_message(string(L.server_error_nombre, online_nombre))
		else if _error = net_error_server_lleno
			show_message(L.server_error_lleno)
	}
	else if msg = net_expulsado
		handle_jugador_expulsado(buffer)
	else if msg = net_timeout
		handle_jugador_expulsado(buffer, true)
	else if msg = net_heartbeat{
		handle_timeout(buffer)
		//Timeout jugadores
		if not servidor
			server_jugadores_timeout = [0]
	}
	else if msg = net_mensaje
		handle_mensaje(buffer)
	
}