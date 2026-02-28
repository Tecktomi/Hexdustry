function open_server(){
	with control{
		server = network_create_server(network_socket_tcp, 6500, 8)
		if server = -1
			show_message("Error de conexión")
		else{
			show_debug_message("Servidor creado")
			udp_socket = network_create_server(network_socket_udp, 6501, 8)
			servidor = true
		}
	}
}