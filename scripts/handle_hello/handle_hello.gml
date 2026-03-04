function handle_hello(socket, buffer){
	with control{
		online = true
		var player_name = buffer_read(buffer, buffer_string)
		var reply = buffer_create(256, buffer_grow, 1)
		buffer_write(reply, buffer_u8, 2) //Welcome
		buffer_write(reply, buffer_u32, seed)
		buffer_write(reply, buffer_u8, biome_seed)
		buffer_write(reply, buffer_u32, timer)
		buffer_write(reply, buffer_u32, oleadas_timer)
		//Historial de cambios
		var len = array_length(historial)
		show_debug_message(historial)
		buffer_write(reply, buffer_u16, len)
		for(var a = 0; a < len; a++){
			var log = historial[a], tipo = historial_tipo[a]
			buffer_write(reply, buffer_u8, tipo)
			if tipo = 0{
				buffer_write(reply, buffer_u8, real(log.index))
				buffer_write(reply, buffer_u8, real(log.dir))
				buffer_write(reply, buffer_u16, real(log.a))
				buffer_write(reply, buffer_u16, real(log.b))
				buffer_write(reply, buffer_bool, bool(log.enemigo))
			}
			else if tipo = 1{
				buffer_write(reply, buffer_u16, real(log.a))
				buffer_write(reply, buffer_u16, real(log.b))
				buffer_write(reply, buffer_bool, bool(log.destruccion))
			}
		}
		network_send_packet(socket, reply, buffer_tell(reply))
		buffer_delete(reply)
	}
}