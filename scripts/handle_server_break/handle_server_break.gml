function handle_server_break(){
	with control{
		game_terminar(fin_desconexion, MENU_PRINCIPAL)
		show_message(L.server_muerto)
	}
}