function server_add_edificio(index, dir, a, b, _cheat = control.cheat, _jugador = jugador){
	with control{
		var buffer = buffer_create(13, buffer_grow, 1)
		buffer_write(buffer, buffer_u8, 3) //Add edificio
		buffer_write(buffer, buffer_u32, real(timer))
		buffer_write(buffer, buffer_u8, real(index))
		buffer_write(buffer, buffer_u8, real(dir))
		buffer_write(buffer, buffer_u16, real(a))
		buffer_write(buffer, buffer_u16, real(b))
		buffer_write(buffer, buffer_bool, bool(_cheat))
		buffer_write(buffer, buffer_u8, _jugador)
		if index = id_tuberia
			buffer_write(buffer, buffer_u8, liquido_choose_array[liquido_choose])
		if servidor
			server_broadcast_buffer(buffer)
		else
			network_send_packet(socket, buffer, buffer_tell(buffer))
		buffer_delete(buffer)
	}
}