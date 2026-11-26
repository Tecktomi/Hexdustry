function open_server(){
	with control{
		if servidor
			exit
		server = network_create_server(network_socket_tcp, 6500, 8)
		if server >= 0{
			server_udp = network_create_server(network_socket_udp, 6501, 8)
			servidor = true
			server_jugadores_nombre[0] = online_nombre
		}
	}
}