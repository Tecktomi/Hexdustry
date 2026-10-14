function server_construir(index, dir, a, b, _cheat = control.cheat, _jugador = jugador){
	with control{
		var buffer = buffer_create(13, buffer_grow, 1)
		buffer_write(buffer, buffer_u8, net_construir)
		buffer_write(buffer, buffer_u32, real(timer))
		buffer_write(buffer, buffer_u8, real(index))
		if index = id_tunel or index = id_tunel_salida{
			buffer_write(buffer, buffer_bool, build_able)
			buffer_write(buffer, buffer_u16, build_target.a)
			buffer_write(buffer, buffer_u16, build_target.b)
		}
		else if in(index, id_fabrica_de_drones, id_cinta_grande, id_fabrica_de_drones_grande){
			buffer_write(buffer, buffer_bool, build_agua)
			buffer_write(buffer, buffer_u16, build_agua_x)
			buffer_write(buffer, buffer_u16, build_agua_y)
		}
		buffer_write(buffer, buffer_u8, real(dir mod 6))
		buffer_write(buffer, buffer_u16, real(a))
		buffer_write(buffer, buffer_u16, real(b))
		buffer_write(buffer, buffer_bool, bool(_cheat))
		buffer_write(buffer, buffer_u8, _jugador)
		if index = id_tuberia
			buffer_write(buffer, buffer_u8, liquido_choose_array[liquido_choose])
		if online{
			if servidor
				server_broadcast_buffer(buffer)
			else
				network_send_packet(socket, buffer, buffer_tell(buffer))
		}
		if GRABANDO
			grabar_buffer(buffer)
		buffer_delete(buffer)
	}
}