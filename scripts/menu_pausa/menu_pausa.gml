function menu_pausa(_juego = true, _input_layer = 0){
	with control{
		var a, b, xpos, ypos, buffer, temp_text, temp_sprite, key, char
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
		if pausa_setting = 0{
			if _juego
				draw_text(room_width / 2, 150,	$"\"{chr(CONTROL_REDES)}\" {L.pausa_red}\n\"{chr(CONTROL_FLUJO)}\" {L.pausa_liquido}\n\"{chr(CONTROL_ENCICLOPEDIA)}\" {L.pausa_enciclopedia}\n\"{chr(CONTROL_REPARAR)}\" {L.pausa_reparar}")
			if DEVISE{
				if draw_boton(xpos, ypos, L.controles, ui_azul,,,, _input_layer)
					pausa_setting = 3
				ypos += text_y * 1.2
			}
			if draw_boton(xpos, ypos, L.ajustes, ui_azul,,,, _input_layer)
				pausa_setting = 2
			ypos += text_y * 1.2
			if _juego{
				//Guardar / Abrir en LAN
				if menu = MENU_JUEGO{
					if os_browser = browser_not_a_browser{
						if not mapa_editado{
							if server = -1 and menu = MENU_JUEGO{
								if draw_boton(xpos, ypos, L.abrir_en_LAN, ui_azul,,,, _input_layer)
									pausa_setting = 1
							}
							else{
								b = 0
								for(a = 0; a < MAX_JUGADORES; a++)
									b += (server_jugadores[a] != -1)
								draw_boton(xpos, ypos, $"{b} {L.jugadores}", ui_verde,,,, _input_layer)
							}
							ypos += text_y * 1.2
							if guardado
								draw_boton(xpos, ypos, L.guardado, ui_verde,,,, _input_layer)
							else if tutorial = 0 and draw_boton(xpos, ypos, L.guardar, ui_azul,,,, _input_layer){
								guardado = true
								buffer = buffer_create(4096, buffer_grow, 1)
								save_game_buffer(buffer)
								temp_text = $"Saves/{day_format()}"
								buffer_save(buffer, $"{temp_text}.save")
								buffer_delete(buffer)
								temp_sprite = minimapa()
								sprite_save(temp_sprite, 0, $"{temp_text}.png")
								sprite_delete(temp_sprite)
							}
							ypos += text_y * 1.2
						}
					}
					else{
						draw_boton(xpos, ypos, L.descargar_para_jugar_en_LAN, ui_gris,,,, _input_layer)
						ypos += text_y * 1.2
					}
				}
				if draw_boton(xpos, ypos, L.pausa_continuar, ui_verde,,,, _input_layer){
					pausa = 0
					guardado = false
				}
				ypos += text_y * 1.2
			}
			if draw_boton(xpos, ypos, L.salir, ui_rojo,,,, _input_layer){
				clear_edit()
				pausa = 0
				cheat = false
				pausa_setting = 0
				jugador = 2
				if _juego{
					if menu = MENU_JUEGO{
						if tutorial = 0 and os_browser = browser_not_a_browser and not mapa_editado{
							buffer = buffer_create(1024, buffer_grow, 1)
							save_game_buffer(buffer)
							buffer_save(buffer, "last_save.save")
							buffer_delete(buffer)
						}
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
		else if pausa_setting = 1{
			if draw_boton(xpos, ypos, L.abrir_en_LAN, ui_azul,,,, _input_layer){
				open_server()
				pausa_setting = 0
			}
			ypos += text_y * 1.2
			if draw_boton(xpos, ypos, server_pvp ? "PVP" : "COOP", server_pvp ? ui_rojo : ui_verde,,,, _input_layer)
				server_pvp = not server_pvp
			if draw_boton(xpos, room_height - 200, L.volver, ui_rojo,,,, _input_layer) or (not DEVISE and keyboard_check_pressed(vk_backspace)){
				if not DEVISE
					keyboard_clear(vk_backspace)
				pausa_setting = 0
			}
		}
		//Ajustes
		else if pausa_setting = 2{
			if draw_boton(xpos, ypos, (info ? L.pausa_desactivar : L.pausa_activar) + $" {L.pausa_info}", info ? ui_verde : ui_rojo,,,, _input_layer){
				info = not info
				save_setting("", "info", info)
			}
			ypos += text_y * 1.2
			if draw_boton(xpos, ypos, (grafic_tile_animation ? L.pausa_desactivar : L.pausa_activar) + $" {L.pausa_animacion}", grafic_tile_animation ? ui_verde : ui_rojo,,,, _input_layer){
				grafic_tile_animation = not grafic_tile_animation
				save_setting("", "grafic_tile_animation", grafic_tile_animation)
			}
			ypos += text_y * 1.2
			if draw_boton(xpos, ypos, (grafic_luz ? L.pausa_desactivar : L.pausa_activar) + $" {L.pausa_iluminacion}", grafic_luz ? ui_verde : ui_rojo,,,, _input_layer){
				grafic_luz = not grafic_luz
				save_setting("", "grafic_luz", grafic_luz)
			}
			ypos += text_y * 1.2
			if draw_boton(xpos, ypos, (grafic_humo ? L.pausa_desactivar : L.pausa_activar) + $" {L.pausa_humo}", grafic_humo ? ui_verde : ui_rojo,,,, _input_layer){
				grafic_humo = not grafic_humo
				save_setting("", "grafic_humo", grafic_humo)
			}
			ypos += text_y * 1.2
			if draw_boton(xpos, ypos, (grafic_hideui ? L.pausa_desactivar : L.pausa_activar) + $" {L.pausa_UI}", grafic_hideui ? ui_rojo : ui_verde,,,, _input_layer)
				grafic_hideui = not grafic_hideui
			ypos += text_y * 1.2
			if draw_boton(xpos, ypos, (sonido ? L.pausa_desactivar : L.pausa_activar) + $" {L.pausa_sonido}", sonido ? ui_verde : ui_rojo,,,, _input_layer)
				sound_change()
			ypos += text_y * 1.2
			if draw_boton(xpos, ypos, (musica ? L.pausa_desactivar : L.pausa_activar) + $" Music", musica ? ui_verde : ui_rojo,,,, _input_layer){
				musica = not musica
				if not musica
					for(a = 0; a < MUSICA_MAX; a++)
						audio_pause_sound(MUSICA[a])
				save_setting("", "musica", musica)
			}
			ypos += text_y * 1.2
			if draw_boton(xpos, ypos, (grafic_energia ? L.pausa_desactivar : L.pausa_activar) + $" {L.red_energia}", grafic_energia ? ui_verde : ui_rojo,,,, _input_layer){
				grafic_energia = not grafic_energia
				save_setting("", "grafic_energia", grafic_energia)
			}
			ypos += text_y * 1.2
			if draw_boton(xpos, ypos, (auto_guardado ? L.pausa_desactivar : L.pausa_activar) + $" {L.autoguardado}", auto_guardado ? ui_verde : ui_rojo,,,, _input_layer){
				auto_guardado = not auto_guardado
				save_setting("", "auto_guardado", auto_guardado)
			}
			if draw_boton(xpos, room_height - 200, L.volver, ui_rojo,,,, _input_layer) or (not DEVISE and keyboard_check_pressed(vk_backspace)){
				if not DEVISE
					keyboard_clear(vk_backspace)
				pausa_setting = 0
			}
		}
		//Controles
		else{
			ypos = 200
			for(a = 0; a < CONTROL_MAX; a++){
				key = CONTROL_USADAS[a]
				if key = vk_space
					char = "Espacio"
				else if key = vk_escape
					char = "Escape"
				else if key >= vk_f1 and key <= vk_f12
					char = $"F{chr(key - ord("p") + ord(1))}"
				else if key = vk_tab
					char = "TAB"
				else
					char = chr(key)
				draw_set_halign((a & 1) ? fa_left : fa_right)
				if draw_boton(xpos + 40 * (a & 1) - 20, ypos, $"{CONTROL_NOMBRE[a]} \"{char}\"",,,,, _input_layer)
					pausa_setting = 4 + a
				if (a & 1)
					ypos += text_y * 1.2
			}
			draw_set_halign(fa_center)
			if pausa_setting > 3{
				draw_set_color(c_black)
				draw_set_alpha(0.5)
				draw_rectangle(0, 0, room_width, room_height, false)
				draw_set_color(c_white)
				draw_set_alpha(1)
				draw_text(xpos, ypos, L.presiona_tecla)
				if keyboard_check_pressed(vk_anykey) and (keyboard_lastkey = CONTROL_USADAS[pausa_setting - 4] or not array_contains(CONTROL_USADAS, keyboard_lastkey)){
					pausa_setting -= 2
					if pausa_setting = 2
						CONTROL_LEFT = keyboard_lastkey
					else if pausa_setting = 3
						CONTROL_RIGHT = keyboard_lastkey
					else if pausa_setting = 4
						CONTROL_UP = keyboard_lastkey
					else if pausa_setting = 5
						CONTROL_DOWN = keyboard_lastkey
					else if pausa_setting = 6
						CONTROL_PAUSE = keyboard_lastkey
					else if pausa_setting = 7
						CONTROL_MENU = keyboard_lastkey
					else if pausa_setting = 8
						CONTROL_MUSIC = keyboard_lastkey
					else if pausa_setting = 9
						CONTROL_WAVES = keyboard_lastkey
					else if pausa_setting = 10
						CONTROL_HIDEUI = keyboard_lastkey
					else if pausa_setting = 11
						CONTROL_INFO = keyboard_lastkey
					else if pausa_setting = 12
						CONTROL_FLOW = keyboard_lastkey
					else if pausa_setting = 13
						CONTROL_ENCICLOPEDIA = keyboard_lastkey
					else if pausa_setting = 14
						CONTROL_ROTAR = keyboard_lastkey
					else if pausa_setting = 15
						CONTROL_REPARAR = keyboard_lastkey
					else if pausa_setting = 16
						CONTROL_REDES = keyboard_lastkey
					else if pausa_setting = 17
						CONTROL_FLUJO = keyboard_lastkey
					else if pausa_setting = 18
						CONTROL_BLUEPRINT = keyboard_lastkey
					else if pausa_setting = 19
						CONTROL_TAB = keyboard_lastkey
					CONTROL_USADAS[pausa_setting - 2] = keyboard_lastkey
					save_setting("Controles", $"{pausa_setting - 2}", keyboard_lastkey, false)
					keyboard_clear(keyboard_lastkey)
					pausa_setting = 1
				}
			}
			if draw_boton(xpos, room_height - 200, L.volver, ui_rojo,,,, _input_layer) or (not DEVISE and keyboard_check_pressed(vk_backspace)){
				if not DEVISE
					keyboard_clear(vk_backspace)
				pausa_setting = 0
			}
		}
		draw_set_halign(fa_left)
		for(a = 0; a < IDIOMAS; a++)
			if draw_sprite_boton(spr_bandera, a, 20 + 80 * a, 20, 64, 48,, function(data){draw_text_background(0, 80, IDIOMA_NAME[data.a])}, {a : a}){
				idioma = a
				save_setting("", "Idioma", idioma, true)
				set_idioma()
			}
		draw_set_color(color)
		if keyboard_check_pressed(CONTROL_MENU) or (not DEVISE and keyboard_check_pressed(vk_backspace)){
			if not DEVISE
				keyboard_clear(vk_backspace)
			keyboard_clear(CONTROL_MENU)
			if pausa_setting = 0{
				pausa = 0
				guardado = false
			}
			else if pausa_setting = 1
				pausa_setting = 0
		}
		return false
	}
}