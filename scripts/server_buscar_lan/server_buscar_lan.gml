function server_buscar_lan(){
	with control{
		var buffer = buffer_create(256, buffer_grow, 1)
		buffer_write(buffer, buffer_u8, net_buscar_server)
		network_send_broadcast(udp_socket, 6501, buffer, buffer_tell(buffer))
		buffer_delete(buffer)
		server_buscando_lan = true
		server_buscando_lan_step = 150
	}
}