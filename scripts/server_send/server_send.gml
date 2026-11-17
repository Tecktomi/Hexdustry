function server_send(buffer){
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