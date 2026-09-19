function handle_server_break(){
	with control{
		network_destroy(server)
		server = -1
		servidor = false
		clear_edit()
		menu = MENU_PRINCIPAL
		jugador = 2
		drones_propios = drones_jugador[jugador]
		show_message(L.server_muerto)
	}
}