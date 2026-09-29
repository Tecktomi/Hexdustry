function terminar_partida(motivo, destino = MENU_PRINCIPAL){
	with control{
		if menu != MENU_JUEGO and menu != MENU_EDITOR_JUEGO
			return false
		if motivo != fin_desconexion and win = 0 and BROWSER and not mapa_editado
			save()
		if GRABANDO
			grabacion_end($"Grabaciones/grabacion_{day_format()}.rec")
		if motivo = fin_desconexion{
			network_destroy(server)
			server = -1
			servidor = false
		}
		else if online{
			if servidor
				server_break()
			else
				server_jugador_irse()
		}
		if motivo != fin_cerrar_juego{
			clear_edificios()
			jugador = 2
			drones_propios = drones_jugador[jugador]
			win = 0
			clear_edit()
			build_index = -1
			pausa = 0
			menu = destino
			GRABANDO = false
			REPRODUCIENDO = false
		}
		return true
	}
}