function menu_pausa(_juego = true, _input_layer = 0){
	with control{
		var a, b, xpos, ypos, buffer, temp_text, temp_sprite, key, char
		var _show_idioma = true
		if _juego
			for(a = array_length(drones) - 1; a >= 0; a--)
				draw_dron(drones[a], true)
		image_index--
		var color = draw_get_color()
		draw_set_color(c_black)
		draw_set_alpha(0.2)
		draw_rectangle(0, 0, room_width, room_height, false)
		draw_set_alpha(1)
		draw_set_color(c_white)
		draw_set_halign(fa_center)
		if _juego{
			draw_set_font(font_titulo)
			draw_text(room_width / 2, 100, L.pausa)
		}
		draw_set_font(font_normal)
		xpos = room_width / 2
		ypos = 300
		//Ajustes generales
		if pausa_setting = pausa_general{
			var _max_width = max(string_width(L.pausa_continuar), string_width(L.guardado), string_width(L.guardar), string_width(L.abrir_en_LAN),
				string_width(L.descargar_para_jugar_en_LAN), string_width(L.ajustes), string_width(L.controles), string_width(L.salir)) + 8
			if _juego{
				//Continuar
				if draw_boton(xpos, ypos, L.pausa_continuar, ui_verde,,,, _input_layer,, _max_width) or keyboard_check_pressed(CONTROL_MENU){
					keyboard_clear(CONTROL_MENU)
					pausa = 0
					guardado = false
				}
				ypos += text_y * 1.5
				//Guardar
				if BROWSER{
					if guardado{
						draw_boton(xpos, ypos, L.guardado, ui_verde,,,, _input_layer,, _max_width)
						ypos += text_y * 1.2
					}
					else if not mapa_editado{
						if draw_boton(xpos, ypos, L.guardar, ui_azul,,,, _input_layer,, _max_width)
							save()
						ypos += text_y * 1.2
					}
					//Online
					if server = -1 and menu = MENU_JUEGO{
						if draw_boton(xpos, ypos, L.abrir_en_LAN, ui_azul,,,, _input_layer,, _max_width)
							pausa_setting = pausa_online
					}
					else{
						b = 0
						for(a = 0; a < MAX_JUGADORES; a++)
							b += (server_jugadores[a] != -1)
						draw_boton(xpos, ypos, $"{b} {L.jugadores}", ui_verde,,,, _input_layer,, _max_width)
					}
				}
				else
					draw_boton(xpos, ypos, L.descargar_para_jugar_en_LAN, ui_gris,,,, _input_layer,, _max_width)
				ypos += text_y * 1.5
			}
			//Ajustes
			if draw_boton(xpos, ypos, L.ajustes, ui_azul,,,, _input_layer,, _max_width)
				pausa_setting = pausa_ajuste
			//Controles
			if DEVISE{
				ypos += text_y * 1.2
				if draw_boton(xpos, ypos, L.controles, ui_azul,,,, _input_layer,, _max_width)
					pausa_setting = pausa_control
			}
			ypos += text_y * 1.5
			//Salir
			if draw_boton(xpos, ypos, L.salir, ui_rojo,,,, _input_layer,, _max_width){
				clear_edit()
				pausa = 0
				cheat = false
				jugador = 2
				if _juego{
					if menu = MENU_JUEGO{
						if BROWSER and not mapa_editado
							save()
						if online{
							if servidor
								server_break()
							else
								server_jugador_irse()
						}
						menu = MENU_PRINCIPAL
						clear_edificios()
						return true
					}
					else if menu = MENU_EDITOR_JUEGO{
						array_copy(categoria_nombre_disponible, 0, categoria_nombre, 0, array_length(categoria_nombre) - 1)
						menu = MENU_EDITOR
						build_index = -1
						draw_set_halign(fa_left)
						draw_set_color(color)
						return true
					}
				}
				else{
					input_layer = 0
					get_file = 0
				}
				return true
			}
		}
		//Ajustes ONLINE
		else if pausa_setting = pausa_online{
			if draw_boton(xpos, ypos, L.abrir_en_LAN, ui_azul,,,, _input_layer){
				open_server()
				pausa_setting = pausa_general
			}
			ypos += text_y * 1.2
			if draw_boton(xpos, ypos, server_pvp ? "PVP" : "COOP", server_pvp ? ui_rojo : ui_verde,,,, _input_layer)
				server_pvp = not server_pvp
			if draw_boton(xpos, room_height - 200, L.volver, ui_rojo,,,, _input_layer) or (not DEVISE and keyboard_check_pressed(vk_backspace)){
				if not DEVISE
					keyboard_clear(vk_backspace)
				pausa_setting = pausa_general
			}
		}
		//Ajustes
		else if pausa_setting = pausa_ajuste{
			draw_set_color(ui_fondo)
			draw_rectangle(100, 100, room_width - 100, room_height - 100, false)
			draw_set_color(ui_texto)
			draw_rectangle(100, 100, room_width - 100, room_height - 100, true)
			draw_set_halign(fa_center)
			draw_text(room_width / 2, 120, L.ajustes)
			draw_set_halign(fa_left)
			xpos = 140
			ypos = 200
			draw_text(xpos, ypos, L.pausa_graficos)
			ypos += 40
			draw_text(xpos, ypos, L.pausa_animacion)
			grafic_tile_animation = draw_toggle(room_width / 2 - 40 - 48, ypos, grafic_tile_animation)
			ypos += 40
			draw_text(xpos, ypos, L.pausa_iluminacion)
			grafic_luz = draw_toggle(room_width / 2 - 40 - 48, ypos, grafic_luz)
			ypos += 40
			draw_text(xpos, ypos, L.pausa_humo)
			grafic_humo = draw_toggle(room_width / 2 - 40 - 48, ypos, grafic_humo)
			ypos += 40
			draw_text(xpos, ypos, L.pausa_red_electrica)
			grafic_energia = draw_toggle(room_width / 2 - 40 - 48, ypos, grafic_energia)
			ypos += 80
			draw_text(xpos, ypos, L.pausa_interfaz)
			ypos += 40
			draw_text(xpos, ypos, L.pausa_info)
			info = draw_toggle(room_width / 2 - 40 - 48, ypos, info)
			ypos += 40
			draw_text(xpos, ypos, L.pausa_UI)
			grafic_hideui = draw_toggle(room_width / 2 - 40 - 48, ypos, grafic_hideui)
			ypos += 80
			if draw_boton(xpos, ypos, L.volver, ui_rojo,,,, _input_layer) or (not DEVISE and keyboard_check_pressed(vk_backspace)) or keyboard_check_pressed(CONTROL_MENU){
				keyboard_clear(CONTROL_MENU)
				if not DEVISE
					keyboard_clear(vk_backspace)
				pausa_setting = pausa_general
			}
			xpos = room_width / 2 + 40
			ypos = 200
			draw_text(xpos, ypos, L.pausa_audio)
			ypos += 40
			draw_text(xpos, ypos, L.pausa_sonido)
			if sonido != draw_toggle(room_width - 140 - 48, ypos, sonido)
				sound_change()
			ypos += 40
			draw_text(xpos, ypos, L.pausa_musica)
			if musica != draw_toggle(room_width - 140 - 48, ypos, musica){
				musica = not musica
				if not musica
					for(a = 0; a < MUSICA_MAX; a++)
						audio_pause_sound(MUSICA[a])
				save_setting("", "musica", musica)
			}
			ypos += 80
			draw_text(xpos, ypos, L.pausa_partida)
			ypos += 40
			draw_text(xpos, ypos, L.autoguardado)
			auto_guardado = draw_toggle(room_width - 140 - 48, ypos, auto_guardado)
		}
		//Controles
		else{
			ypos = 200
			if pausa_controles = -1
				for(a = 0; a < CONTROL_MAX; a++){
					key = CONTROL_USADAS[a]
					if key = vk_space
						char = "Espacio"
					else if key = vk_escape
						char = "Escape"
					else if key >= vk_f1 and key <= vk_f12
						char = $"F{key - vk_f1 + 1}"
					else if key = vk_tab
						char = "TAB"
					else
						char = chr(key)
					draw_set_halign((a & 1) ? fa_left : fa_right)
					if draw_boton(xpos + 40 * (a & 1) - 20, ypos, $"{CONTROL_NOMBRE[a]} \"{char}\"",,,,, _input_layer)
						pausa_controles = a
					if (a & 1)
						ypos += text_y * 1.2
				}
			draw_set_halign(fa_center)
			if pausa_controles >= 0{
				_show_idioma = false
				draw_set_color(c_black)
				draw_set_alpha(0.5)
				draw_rectangle(0, 0, room_width, room_height, false)
				draw_set_color(c_white)
				draw_set_alpha(1)
				draw_text(xpos, ypos, L.presiona_tecla)
				ypos += text_y * 1.5
				if keyboard_check_pressed(vk_anykey) and (keyboard_lastkey = CONTROL_USADAS[pausa_controles] or not array_contains(CONTROL_USADAS, keyboard_lastkey)){
					if pausa_controles = 0
						CONTROL_LEFT = keyboard_lastkey
					else if pausa_controles = 1
						CONTROL_RIGHT = keyboard_lastkey
					else if pausa_controles = 2
						CONTROL_UP = keyboard_lastkey
					else if pausa_controles = 3
						CONTROL_DOWN = keyboard_lastkey
					else if pausa_controles = 4
						CONTROL_PAUSE = keyboard_lastkey
					else if pausa_controles = 5
						CONTROL_MENU = keyboard_lastkey
					else if pausa_controles = 6
						CONTROL_MUSIC = keyboard_lastkey
					else if pausa_controles = 7
						CONTROL_WAVES = keyboard_lastkey
					else if pausa_controles = 8
						CONTROL_HIDEUI = keyboard_lastkey
					else if pausa_controles = 9
						CONTROL_INFO = keyboard_lastkey
					else if pausa_controles = 10
						CONTROL_FLOW = keyboard_lastkey
					else if pausa_controles = 11
						CONTROL_ENCICLOPEDIA = keyboard_lastkey
					else if pausa_controles = 12
						CONTROL_ROTAR = keyboard_lastkey
					else if pausa_controles = 13
						CONTROL_REPARAR = keyboard_lastkey
					else if pausa_controles = 14
						CONTROL_REDES = keyboard_lastkey
					else if pausa_controles = 15
						CONTROL_FLUJO = keyboard_lastkey
					else if pausa_controles = 16
						CONTROL_BLUEPRINT = keyboard_lastkey
					else if pausa_controles = 17
						CONTROL_TAB = keyboard_lastkey
					CONTROL_USADAS[pausa_controles] = keyboard_lastkey
					save_setting("Controles", $"{pausa_controles}", keyboard_lastkey, false)
					keyboard_clear(keyboard_lastkey)
					pausa_controles = -1
					pausa_setting = pausa_control
				}
			}
			if draw_boton(xpos, ypos, L.volver, ui_rojo,,,, _input_layer) or (not DEVISE and keyboard_check_pressed(vk_backspace)) or keyboard_check_pressed(CONTROL_MENU){
				keyboard_clear(CONTROL_MENU)
				if not DEVISE
					keyboard_clear(vk_backspace)
				pausa_setting = pausa_general
			}
		}
		draw_set_halign(fa_left)
		draw_set_color(color)
		if _show_idioma{
			for(a = 0; a < IDIOMAS; a++)
				if draw_sprite_boton(spr_bandera, a, 20 + 80 * a, 20, 64, 48, input_layer, function(data){draw_text_background(0, 80, IDIOMA_NAME[data.a])}, {a : a}){
					idioma = a
					save_setting("", "Idioma", idioma, true)
					set_idioma()
				}
		}
		return false
	}
}