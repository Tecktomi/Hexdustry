function panel_partida_nueva(xpos = 0, ypos = 0, param = {}){
	with control{
		var des_count = 0
		draw_boton_text_counter = 0
		ypos = draw_text_ypos(xpos, ypos, L.dificultad)
		if draw_boton(xpos, ypos, L.facil, flow = 0 ? ui_azul : ui_gris,,,, 1){
			tecnologia = false
			oleadas_tiempo_primera = 240
			oleadas_tiempo = 90
			multiplicador_vida_enemigos = 50
			cheat = false
			misiones = array_create(1, null_mision)
			misiones[0].objetivo = 4
			misiones[0].target_num = 15
			flow = 0
			dificultad = 0
		}
		xpos += text_x + 20
		if draw_boton(xpos, ypos, L.medio, flow = 1 ? ui_azul : ui_gris,,,, 1){
			tecnologia = true
			tecnologia_precio_multiplicador = 1 
			oleadas_tiempo_primera = 180
			oleadas_tiempo = 75
			multiplicador_vida_enemigos = 100
			cheat = false
			misiones = array_create(1, null_mision)
			misiones[0].objetivo = 4
			misiones[0].target_num = 22
			flow = 1
			dificultad = 1
		}
		xpos += text_x + 20
		if draw_boton(xpos, ypos, L.dificil, flow = 2 ? ui_azul : ui_gris,,,, 1){
			tecnologia = true
			tecnologia_precio_multiplicador = 1.5 
			oleadas_tiempo_primera = 150
			oleadas_tiempo = 60
			multiplicador_vida_enemigos = 160
			cheat = false
			misiones = array_create(1, null_mision)
			misiones[0].objetivo = 4
			misiones[0].target_num = 35
			flow = 2
			dificultad = 2
		}
		xpos += text_x + 20
		if draw_boton(xpos, ypos, L.personalizado, flow > 2 ? ui_azul : ui_gris,,,, 1){
			flow = 4
			dificultad = -1
		}
		//Personalizado
		if flow > 2{
			xpos = 140
			ypos += text_y * 1.25
			//Tecnología
			draw_text_xpos(xpos, ypos, $"{L.enciclopedia_tecnologia}: {tecnologia ? L.activado : L.desactivado}")
			xpos += max(string_width($"{L.enciclopedia_tecnologia}: {L.activado}"), string_width($"{L.enciclopedia_tecnologia}: {L.desactivado}"))
			tecnologia = draw_toggle(xpos + 10, ypos - 5, tecnologia, 1)
			ypos += text_y * 1.2
			if tecnologia{
				xpos = draw_text_xpos(160, ypos, $"{L.menu_precio_tecnologia}")
				tecnologia_precio_multiplicador = draw_deslizante(xpos + 10, xpos + 135, ypos + 10, tecnologia_precio_multiplicador, 0.5, 3, des_count++, 1)
				ypos = 10 + draw_text_ypos(xpos + 145, ypos, $"{floor(100 * tecnologia_precio_multiplicador)}%")
			}
			//Primera oleada
			ypos = draw_text_ypos(140, ypos, L.tiempo)
			xpos = draw_text_xpos(160, ypos, $"{L.editor_primera_ronda}")
			oleadas_tiempo_primera = round(draw_deslizante(xpos + 10, xpos + 135, ypos + 10, oleadas_tiempo_primera, 60, 300, des_count++, 1))
			ypos = 10 + draw_text_ypos(xpos + 145, ypos, $"{oleadas_tiempo_primera >= 60 ? string(floor(oleadas_tiempo_primera / 60)) + "m " : ""}{oleadas_tiempo_primera mod 60}s")
			//Siguientes oleadas
			xpos = draw_text_xpos(160, ypos, $"{L.editor_siguiente_ronda}")
			oleadas_tiempo = round(draw_deslizante(xpos + 10, xpos + 135, ypos + 10, oleadas_tiempo, 30, 120, des_count++, 1))
			ypos = 10 + draw_text_ypos(xpos + 145, ypos, $"{oleadas_tiempo >= 60 ? string(floor(oleadas_tiempo / 60)) + "m " : ""}{oleadas_tiempo mod 60}s")
			//Multiplicador de vida
			xpos = draw_text_xpos(140, ypos, $"{L.editor_multiplicador_vida}")
			multiplicador_vida_enemigos = round(draw_deslizante(xpos + 10, xpos + 135, ypos + 10, multiplicador_vida_enemigos, 20, 200, des_count++, 1))
			ypos = 10 + draw_text_ypos(xpos + 145, ypos, $"{multiplicador_vida_enemigos}%")
			//Modo creativo
			xpos = 140
			draw_text_xpos(xpos, ypos, $"{L.menu_claves}: {cheat ? L.activado : L.desactivado}")
			xpos += max(string_width($"{L.menu_claves}: {L.activado}"), string_width($"{L.menu_claves}: {L.desactivado}"))
			cheat = draw_toggle(xpos + 10, ypos - 5, cheat, 1)
			oleadas = not cheat
			ypos += text_y + 20
			//Modos de Juego
			xpos = 200
			if draw_boton(xpos, ypos, L.menu_modo_infinito, flow = 3 ? ui_azul : ui_gris,,,, 1){
				misiones = array_create(0, null_mision)
				flow = 3
			}
			xpos += text_x + 20
			if draw_boton(xpos, ypos, L.menu_modo_oleadas, flow = 4 ? ui_azul : ui_gris,,,, 1){
				misiones = array_create(1, null_mision)
				misiones[0].objetivo = 4
				misiones[0].target_num = 20
				flow = 4
			}
			xpos += text_x + 20
			if draw_boton(xpos, ypos, L.menu_modo_misiones, flow = 5 ? ui_azul : ui_gris,,,, 1){
				modo_misiones = true
				add_mision()
				mision_actual = -1
				flow = 5
			}
			if flow = 4{
				ypos += text_y + 10
				xpos = draw_text_xpos(160, ypos, L.menu_numero_oleadas)
				misiones[0].target_num = round(draw_deslizante(xpos + 10, xpos + 135, ypos + 10, misiones[0].target_num, 10, 50, des_count++, 1))
				draw_text_ypos(xpos + 145, ypos, misiones[0].target_num)
			}
		}
		ypos += text_y * 1.25
		//Mapas
		xpos = 200
		if mapa = -1{
			draw_set_color(c_blue)
			draw_rectangle(xpos - 2, ypos - 2, xpos + 97, ypos + 97, false)
		}
		if draw_sprite_boton(spr_random_map,, xpos, ypos, 96, 96, 1){
			biome_seed = irandom(2)
			seed = random_get_seed()
			generar_bioma(biome_seed)
			randomize()
			mapa = -1
		}
		xpos += 120
		for(var a = 0; a < array_length(DEFAULT_MAPS); a++){
			if mapa = a{
				draw_set_color(c_blue)
				draw_rectangle(xpos - 2, ypos - 2, xpos + 97, ypos + 97, false)
			}
			if draw_sprite_boton(default_maps_image[a],, xpos, ypos, 96, 96, 1, hover_sprite_boton_text, {a : a}) and mapa != a{
				var file = load_escenario_buffer($"{DEFAULT_MAPS[a]}.txt", false)
				if file != ""
					mapa = a
			}
			for(var b = 0; b < 3; b++)
				if medallas[a, b]
					draw_sprite(spr_medallas, b, xpos + 32 * b + 16, ypos + 110)
			xpos += 120
		}
		draw_set_color(c_white)
		ypos += 140
		//Tamaño del mapa aleatorio
		if mapa = -1{
			xpos = 200
			if draw_boton(xpos, ypos, L.menu_size_little, xsize = 48 ? ui_azul : ui_gris,,,, 1) and xsize != 48{
				xsize = 48
				ysize = 96
				set_grid_size()
				biome_seed = irandom(2)
				seed = random_get_seed()
				generar_bioma(biome_seed)
				randomize()
			}
			xpos += text_x * 1.2
			if draw_boton(xpos, ypos, L.menu_size_medium, xsize = 72 ? ui_azul : ui_gris,,,, 1) and xsize != 72{
				xsize = 72
				ysize = 144
				set_grid_size()
				biome_seed = irandom(2)
				seed = random_get_seed()
				generar_bioma(biome_seed)
				randomize()
			}
			xpos += text_x * 1.2
			if draw_boton(xpos, ypos, L.menu_size_large, xsize = 128 ? ui_azul : ui_gris,,,, 1) and xsize != 128{
				xsize = 128
				ysize = 256
				set_grid_size()
				biome_seed = irandom(2)
				seed = random_get_seed()
				generar_bioma(biome_seed)
				randomize()
			}
			ypos += text_y * 1.2
		}
		return [xpos, ypos]
	}
}