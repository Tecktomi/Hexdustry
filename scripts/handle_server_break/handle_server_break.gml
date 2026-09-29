function handle_server_break(){
	with control{
		terminar_partida(fin_desconexion, MENU_PRINCIPAL)
		show_message(L.server_muerto)
	}
}