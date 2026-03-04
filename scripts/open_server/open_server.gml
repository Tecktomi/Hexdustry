function open_server(){
	with control{
		server = network_create_server(network_socket_tcp, 6500, 8)
		if server != -1{
			network_create_server(network_socket_udp, 6501, 8)
			servidor = true
		}
	}
}