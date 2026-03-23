function server_mover_dron(x, y, dron = control.null_dron){
	with control{
		var buffer = buffer_create(11, buffer_grow, 1)
		buffer_write(buffer, buffer_u8, 9) //Mover dron
		buffer_write(buffer, buffer_u32, real(timer))
		buffer_write(buffer, buffer_f32, real(x))
		buffer_write(buffer, buffer_f32, real(y))
		buffer_write(buffer, buffer_u16, real(dron.punteros[2]))
		if servidor{
			for(var i = 0; i < array_length(server_jugadores); i++)
				network_send_packet(server_jugadores[i], buffer, buffer_tell(buffer))
		}
		else
			network_send_packet(socket, buffer, buffer_tell(buffer))
		buffer_delete(buffer)
	}
}