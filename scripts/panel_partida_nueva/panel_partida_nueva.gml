function panel_partida_nueva(xpos = 0, ypos = 0, param = {}){
	with control{
		var des_count = 0, a, b, file
		draw_boton_text_counter = 0
		//Mapas
		var _xpos = xpos + 10
		ypos = draw_text_ypos(_xpos + 10, ypos, "MAPA")
		if mapa = -1{
			draw_set_color(ui_boton_azul)
			draw_rectangle(_xpos - 2, ypos - 2, _xpos + 97, ypos + 97, false)
		}
		if draw_sprite_boton(spr_random_map,, _xpos, ypos, 96, 96, 1){
			biome_seed = irandom(2)
			seed = random_get_seed()
			while not generar_bioma(biome_seed){}
			randomize()
			mapa = -1
		}
		_xpos += 120
		for(a = 0; a < array_length(DEFAULT_MAPS); a++){
			if mapa = a{
				draw_set_color(ui_boton_azul)
				draw_rectangle(_xpos - 2, ypos - 2, _xpos + 97, ypos + 97, false)
			}
			if draw_sprite_boton(default_maps_image[a],, _xpos, ypos, 96, 96, 1, hover_sprite_boton_text, {a : variable_struct_get(L, DEFAULT_MAPS_L[a])}) and mapa != a{
				file = load_escenario_buffer($"{DEFAULT_MAPS[a]}.txt", false)
				if file != ""
					mapa = a
			}
			for(b = 0; b < 3; b++)
				if medallas[a, b]
					draw_sprite(spr_medallas, b, _xpos + 32 * b + 16, ypos + 110)
			_xpos += 120
		}
		if BROWSER and draw_sprite_boton(spr_load_map,, _xpos, ypos, 96, 96, 1){
			get_file = 1
			scan_files_save()
		}
		draw_set_color(ui_texto)
		ypos += 140
		//Tamaño del mapa
		_xpos = xpos + 50
		var _change_size = false
		if draw_boton(_xpos, ypos, L.menu_size_little, xsize = 48 ? ui_azul : ui_gris,,,, 1) and xsize != 48 and mapa = -1{
			xsize = 48
			ysize = 96
			_change_size = true
		}
		_xpos += text_x * 1.2
		if draw_boton(_xpos, ypos, L.menu_size_medium, xsize = 72 ? ui_azul : ui_gris,,,, 1) and xsize != 72 and mapa = -1{
			xsize = 72
			ysize = 144
			_change_size = true
		}
		_xpos += text_x * 1.2
		if draw_boton(_xpos, ypos, L.menu_size_large, xsize = 128 ? ui_azul : ui_gris,,,, 1) and xsize != 128 and mapa = -1{
			xsize = 128
			ysize = 256
			_change_size = true
		}
		_xpos += text_x * 1.2
		if DEVISE and draw_boton(_xpos, ypos, L.menu_size_huge, xsize = 256 ? ui_azul : ui_gris,,,, 1) and xsize != 256 and mapa = -1{
			xsize = 256
			ysize = 512
			_change_size = true
		}
		if _change_size{
			set_grid_size()
			biome_seed = irandom(2)
			seed = random_get_seed()
			while not generar_bioma(biome_seed){}
			randomize()
		}
		_change_size = false
		ypos += text_y * 1.2
		//Modos de Juego
		_xpos = xpos + 50
		if draw_boton(_xpos, ypos, L.menu_modo_oleadas, game_mode = GAMEMODE_OLEADAS ? ui_azul : ui_gris,,,, 1){
			_change_size = true
			game_mode = GAMEMODE_OLEADAS
		}
		_xpos += text_x * 1.2
		if draw_boton(_xpos, ypos, L.menu_modo_infinito, game_mode = GAMEMODE_INFINITO ? ui_azul : ui_gris,,,, 1){
			_change_size = true
			game_mode = GAMEMODE_INFINITO
		}
		_xpos += text_x * 1.2
		if draw_boton(_xpos, ypos, L.menu_modo_misiones, game_mode = GAMEMODE_MISIONES ? ui_azul : ui_gris,,,, 1){
			_change_size = true
			game_mode = GAMEMODE_MISIONES
		}
		_xpos += text_x * 1.2
		if draw_boton(_xpos, ypos, L.modo_ia, game_mode = GAMEMODE_IA ? ui_azul : ui_gris,,,, 1){
			_change_size = true
			game_mode = GAMEMODE_IA
		}
		ypos += text_y * 1.2
		//Modo oleadas
		if game_mode = GAMEMODE_OLEADAS and array_length(misiones) > 0{
			_xpos = draw_text_xpos(xpos + 30, ypos, L.menu_numero_oleadas)
			misiones[0].target_num = round(draw_deslizante(_xpos + 10, _xpos + 135, ypos + 10, misiones[0].target_num, 10, 50, des_count++, 1))
			draw_text_ypos(_xpos + 145, ypos, misiones[0].target_num)
			ypos += text_y * 1.2
		}
		_xpos = xpos + 10
		ypos = draw_text_ypos(_xpos, ypos, L.dificultad)
		if draw_boton(_xpos, ypos, L.facil, dificultad = 0 ? ui_azul : ui_gris,,,, 1){
			_change_size = true
			dificultad = 0
		}
		_xpos += text_x + 20
		if draw_boton(_xpos, ypos, L.medio, dificultad = 1 ? ui_azul : ui_gris,,,, 1){
			_change_size = true
			dificultad = 1
		}
		_xpos += text_x + 20
		if draw_boton(_xpos, ypos, L.dificil, dificultad = 2 ? ui_azul : ui_gris,,,, 1){
			_change_size = true
			dificultad = 2
		}
		_xpos += text_x + 20
		if draw_boton(_xpos, ypos, L.personalizado, dificultad = -1 ? ui_azul : ui_gris,,,, 1)
			dificultad = -1
		if _change_size{
			if dificultad = 0{
				tecnologia = false
				oleadas_tiempo_primera = 240
				oleadas_tiempo = 90
				multiplicador_vida_enemigos = 50
				cheat = false
				if game_mode = GAMEMODE_OLEADAS{
					misiones = array_create(1, null_mision)
					misiones[0].objetivo = idm_sobrevivir_oleadas
					misiones[0].target_num = 15
				}
			}
			else if dificultad = 1{
				tecnologia = true
				tecnologia_precio_multiplicador = 1 
				oleadas_tiempo_primera = 180
				oleadas_tiempo = 75
				multiplicador_vida_enemigos = 100
				cheat = false
				if game_mode = GAMEMODE_OLEADAS{
					misiones = array_create(1, null_mision)
					misiones[0].objetivo = idm_sobrevivir_oleadas
					misiones[0].target_num = 22
				}
			}
			else if dificultad = 2{
				tecnologia = true
				tecnologia_precio_multiplicador = 1.5 
				oleadas_tiempo_primera = 150
				oleadas_tiempo = 60
				multiplicador_vida_enemigos = 160
				cheat = false
				if game_mode = GAMEMODE_OLEADAS{
					misiones = array_create(1, null_mision)
					misiones[0].objetivo = idm_sobrevivir_oleadas
					misiones[0].target_num = 35
				}
			}
			if game_mode = GAMEMODE_INFINITO
				misiones = array_create(0, null_mision)
			else if game_mode = GAMEMODE_MISIONES{
				modo_misiones = true
				misiones = array_create(0, null_mision)
				add_mision()
				mision_actual = -1
			}
			else if game_mode = GAMEMODE_IA{
				misiones = array_create(1, null_mision)
				misiones[0].objetivo = idm_destruir_edificio
				misiones[0].target_id = id_nucleo
				misiones[0].target_num = 1
			}
		}
		//Personalizado
		if dificultad = -1{
			_xpos = 140
			ypos += text_y * 1.25
			//Tecnología
			draw_text_xpos(_xpos, ypos, $"{L.enciclopedia_tecnologia}: {tecnologia ? L.activado : L.desactivado}")
			_xpos += max(string_width($"{L.enciclopedia_tecnologia}: {L.activado}"), string_width($"{L.enciclopedia_tecnologia}: {L.desactivado}"))
			tecnologia = draw_toggle(_xpos + 10, ypos - 5, tecnologia, 1)
			ypos += text_y * 1.2
			if tecnologia{
				_xpos = draw_text_xpos(160, ypos, $"{L.menu_precio_tecnologia}")
				tecnologia_precio_multiplicador = draw_deslizante(_xpos + 10, _xpos + 135, ypos + 10, tecnologia_precio_multiplicador, 0.5, 3, des_count++, 1)
				ypos = 10 + draw_text_ypos(_xpos + 145, ypos, $"{floor(100 * tecnologia_precio_multiplicador)}%")
			}
			//Primera oleada
			ypos = draw_text_ypos(140, ypos, L.tiempo)
			_xpos = draw_text_xpos(160, ypos, $"{L.editor_primera_ronda}")
			oleadas_tiempo_primera = round(draw_deslizante(_xpos + 10, _xpos + 135, ypos + 10, oleadas_tiempo_primera, 60, 300, des_count++, 1))
			ypos = 10 + draw_text_ypos(_xpos + 145, ypos, $"{oleadas_tiempo_primera >= 60 ? string(floor(oleadas_tiempo_primera / 60)) + "m " : ""}{oleadas_tiempo_primera mod 60}s")
			//Siguientes oleadas
			_xpos = draw_text_xpos(160, ypos, $"{L.editor_siguiente_ronda}")
			oleadas_tiempo = round(draw_deslizante(_xpos + 10, _xpos + 135, ypos + 10, oleadas_tiempo, 30, 120, des_count++, 1))
			ypos = 10 + draw_text_ypos(_xpos + 145, ypos, $"{oleadas_tiempo >= 60 ? string(floor(oleadas_tiempo / 60)) + "m " : ""}{oleadas_tiempo mod 60}s")
			//Multiplicador de vida
			_xpos = draw_text_xpos(140, ypos, $"{L.editor_multiplicador_vida}")
			multiplicador_vida_enemigos = round(draw_deslizante(_xpos + 10, _xpos + 135, ypos + 10, multiplicador_vida_enemigos, 20, 200, des_count++, 1))
			ypos = 10 + draw_text_ypos(_xpos + 145, ypos, $"{multiplicador_vida_enemigos}%")
			//Permitir nuclear
			_xpos = xpos + 40
			draw_text_xpos(_xpos, ypos, $"{misiles_nombre[2]}: {permitir_nuclear ? L.activado : L.desactivado}")
			_xpos += max(string_width($"{misiles_nombre[2]}: {L.activado}"), string_width($"{misiles_nombre[2]}: {L.desactivado}"))
			permitir_nuclear = draw_toggle(_xpos + 10, ypos - 5, permitir_nuclear, 1)
			ypos += text_y * 1.2
			//Modo creativo
			_xpos = xpos + 40
			draw_text_xpos(_xpos, ypos, $"{L.menu_claves}: {cheat ? L.activado : L.desactivado}")
			_xpos += max(string_width($"{L.menu_claves}: {L.activado}"), string_width($"{L.menu_claves}: {L.desactivado}"))
			cheat = draw_toggle(_xpos + 10, ypos - 5, cheat, 1)
			oleadas = not cheat
		}
		ypos += text_y * 1.25
		_xpos = xpos + 10
		_xpos = draw_text_xpos(_xpos, ypos, "Grabar")
		GRABANDO = draw_toggle(_xpos + 20, ypos, GRABANDO, 1)
		ypos += text_y * 1.2
		return [xpos, ypos]
	}
}