function server_cerrar(){
	with control{
		if not servidor
			exit
		if online
			server_break()
		if server >= 0
			network_destroy(server)
		if server_udp >= 0
			network_destroy(server_udp)
		server = -1
		server_udp = -1
		servidor = false
		online = false
		server_jugadores = array_create(MAX_JUGADORES, -1)
		server_jugadores_nombre = array_create(MAX_JUGADORES, "")
		server_jugadores_nombre[0] = online_nombre
		server_jugadores_timeout = array_create(MAX_JUGADORES, 0)
	}
}