function game_terminar(motivo, destino = MENU_PRINCIPAL){
	with control{
		if menu != MENU_JUEGO and menu != MENU_EDITOR_JUEGO
			return false
		if menu = MENU_EDITOR_JUEGO{
			array_pop(categoria_index_disponible)
			array_pop(categoria_nombre_disponible)
			array_pop(categoria_edificios_disponible)
		}
		if motivo != fin_desconexion and win = 0 and BROWSER and not mapa_editado and not online
			save()
		if GRABANDO
			grabacion_end($"Grabaciones/grabacion_{day_format()}.rec")
		if motivo = fin_desconexion{
			online = false
			network_destroy(server)
			server = -1
			servidor = false
		}
		else if online and not servidor{
			online = false
			server_jugador_irse()
		}
		if servidor
			server_cerrar()
		if motivo != fin_cerrar_juego{
			if destino != MENU_EDITOR
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
			if destino = MENU_PRINCIPAL
				reset_sesion()
		}
		if sonido{
			for(var a = 0; a < SONIDOS_MAX; a++)
				audio_pause_sound(sonido_id[a])
			if clima
				audio_pause_sound(clima_tipo = clima_lluvia ? snd_rain : snd_wind)
		}
		return true
	}
}