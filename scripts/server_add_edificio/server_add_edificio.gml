function server_add_edificio(index, dir, a, b, enemigo, _cheat = control.cheat){
	with control{
		var buffer = buffer_create(13, buffer_grow, 1)
		buffer_write(buffer, buffer_u8, 3) //Add edificio
		buffer_write(buffer, buffer_u32, real(timer))
		buffer_write(buffer, buffer_u8, real(index))
		buffer_write(buffer, buffer_u8, real(dir))
		buffer_write(buffer, buffer_u16, real(a))
		buffer_write(buffer, buffer_u16, real(b))
		buffer_write(buffer, buffer_bool, bool(enemigo))
		buffer_write(buffer, buffer_bool, bool(_cheat))
		if servidor{
			for(var i = 0; i < array_length(server_jugadores); i++)
				network_send_packet(server_jugadores[i], buffer, buffer_tell(buffer))
		}
		else
			network_send_packet(socket, buffer, buffer_tell(buffer))
		buffer_delete(buffer)
	}
}