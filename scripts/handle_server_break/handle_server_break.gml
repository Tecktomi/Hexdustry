function handle_server_break(){
	with control{
		network_destroy(server)
		server = -1
		servidor = false
		clear_edit()
		menu = 0
		show_message(L.server_muerto)
	}
}