function menu_principal(){
	with control{
		dibujar_fondo(1)
		draw_set_alpha(0.5)
		draw_set_color(c_black)
		draw_rectangle(0, 0, room_width, room_height, false)
		draw_set_alpha(1)
		draw_set_halign(fa_center)
		draw_set_font(font_titulo)
		draw_set_color(c_white)
		var ypos = 100
		draw_text_ypos(room_width / 2, ypos, L.menu_hexdustry)
		draw_set_font(font_normal)
		if os_browser != browser_not_a_browser{
			ypos += text_y
			draw_text_ypos(room_width / 2, ypos, L.menu_html)
			ypos += 3 * text_y
		}
		else
			ypos += 3 * text_y
		if draw_boton(room_width / 2, ypos, L.menu_juego_rapido, ui_verde){
			input_layer = 1
			get_file = 2
			if array_length(misiones) = 0{
				tecnologia = false
				oleadas_tiempo_primera = 240
				oleadas_tiempo = 90
				multiplicador_vida_enemigos = 50
				cheat = false
				misiones = array_create(1, null_mision)
				mision = misiones[0]
				mision.objetivo = idm_sobrevivir_oleadas
				mision.target_num = 15
				flow = 0
				dificultad = 0
			}
			else{
				flow = 4
				dificultad = -1
			}
			if mapa >= 0 and load_escenario_buffer($"{DEFAULT_MAPS[mapa]}.txt", false) = ""
				mapa = -1
		}
		if os_browser = browser_not_a_browser and DEVISE and file_exists("last_save.save"){
			ypos += text_y * 1.2
			if draw_boton(room_width / 2, ypos, L.continuar, ui_verde){
				var buffer = buffer_load("last_save.save")
				load_game_buffer(buffer)
				buffer_delete(buffer)
			}
		}
		ypos += text_y * 2
		if draw_boton(room_width / 2, ypos, L.menu_tutorial, ui_verde)
			menu = MENU_CAMPANNA
		ypos += text_y * 2
		if draw_boton(room_width / 2, ypos, L.menu_editor, ui_azul){
			build_index = -1
			mapa_editado = true
			menu = MENU_EDITOR
		}
		ypos += text_y * 2
		//Configuración online
		if os_browser = browser_not_a_browser{
			if draw_boton(room_width / 2, ypos, L.multijugador, ui_azul){
				input_layer = 1
				get_file = 4
				server_buscar_lan()
			}
		}
		else
			draw_boton(room_width / 2, ypos, L.descargar_para_jugar_en_LAN, ui_gris)
		ypos += text_y * 2
		if draw_boton(room_width / 2, ypos, L.game_enciclopedia, ui_gris){
			input_layer = 1
			enciclopedia = 1
		}
		if enciclopedia > 0{
			draw_enciclopedia(false, 1)
			if enciclopedia = 0
				input_layer = 0
		}
		draw_set_halign(fa_left)
		if get_file > 0{
			draw_set_color(c_dkgray)
			draw_rectangle(100, 100, room_width - 100, room_height - 100, false)
			draw_set_color(c_white)
			draw_rectangle(100, 100, room_width - 100, room_height - 100, true)
			draw_set_halign(fa_center)
			draw_text(room_width / 2, 110, get_file = 1 ? L.menu_cargar_escenario : L.menu_juego_rapido)
			draw_set_halign(fa_left)
			//Cargar Escenarios
			if get_file = 1{
				draw_set_valign(fa_bottom)
				var xpos = 120
				ypos = 200
				for(var a = 0; a < array_length(save_files); a++){
					var temp_text = file_format(save_files[a])
					if draw_sprite_boton(save_files_png[a],, xpos, ypos, 96, 96, 1){
						tecnologia = true
						load_escenario_buffer("Scenarios/" + save_files[a])
						game_start()
					}
					if draw_sprite_boton(spr_basura,, xpos - 10, ypos - 30,,, 1){
						file_delete("Scenarios/" + temp_text + ".txt")
						file_delete("Scenarios/" + temp_text + ".png")
						array_delete(save_files, a, 1)
						array_delete(save_files_png, a, 1)
						continue
					}
					draw_text(xpos + 20, ypos, text_wrap(temp_text, 100))
					xpos += 120
					if (a mod 9) = 8{
						xpos = 120
						ypos += 150
					}
				}
				draw_set_valign(fa_top)
				if array_length(save_files) = 0{
					draw_set_halign(fa_center)
					draw_text(room_width / 2, 200, L.menu_sin_archivos)
					draw_set_halign(fa_left)
				}
				if draw_boton(120, 120, L.cancelar, ui_rojo,,,, 1) or keyboard_check_pressed(vk_escape) or (not DEVISE and keyboard_check(vk_backspace)){
					if not DEVISE
						keyboard_clear(vk_backspace)
					keyboard_clear(vk_escape)
					get_file = 2
				}
			}
			//Partida Nueva
			else if get_file = 2{
				ypos = 110
				if draw_boton(120, ypos, L.cancelar, ui_rojo,,,, 1) or keyboard_check_pressed(vk_escape) or (not DEVISE and keyboard_check(vk_backspace)){
					if not DEVISE
						keyboard_clear(vk_backspace)
					keyboard_clear(vk_escape)
					get_file = 0
					input_layer = 0
					misiones = array_create(0, null_mision)
					exit
				}
				ypos += text_y * 1.2
				draw_panel(110, ypos, room_width - 220, room_height - 200 - ypos, 0, 1, 1, panel_partida_nueva)
				ypos = room_height - 180
				draw_set_halign(fa_right)
				//Cargar esenarios / partidas
				if BROWSER{
					if draw_boton(room_width / 2 - 200, ypos, L.menu_cargar_escenario, ui_azul,,,, 1){
						if not nucleos[jugador].vivo
							game_restart()
						get_file = 1
						scan_files_save()
					}
					if draw_boton(room_width / 2 - 200, ypos + text_y, L.cargar_partida, ui_azul,,,, 1){
						if not nucleos[jugador].vivo
							game_restart()
						get_file = 3
						partidas = scan_files("Saves/*.save", fa_none)
						var temp_image
						for(var a = array_length(partidas) - 1; a >= 0; a--){
							if array_length(partidas_png) > a and partidas_png[a] != spr_null_image
								sprite_delete(partidas_png[a])
							var temp_text = file_format(partidas[a])
							if file_exists("Saves/" + temp_text + ".png")
								temp_image = sprite_add("Saves/" + temp_text + ".png", 1, false, false, 0, 0)
							else
								temp_image = spr_null_image
							partidas_png[a] = temp_image
						}
					}
				}
				draw_set_halign(fa_left)
				if draw_boton(room_width / 2 + 200, ypos, L.menu_juego_rapido, ui_verde,,,, 1)
					game_start()
			}
			//Cargar partidas
			else if get_file = 3{
				draw_set_valign(fa_bottom)
				var xpos = 120
				ypos = 200
				for(var a = 0; a < array_length(partidas); a++){
					var temp_text = file_format(partidas[a])
					if draw_sprite_boton(partidas_png[a],, xpos, ypos, 96, 96, 1){
						var buffer = buffer_load("Saves/" + partidas[a])
						if not load_game_buffer(buffer)
							show_message(L.archivo_obsoleto)
						buffer_delete(buffer)
					}
					if draw_sprite_boton(spr_basura,, xpos - 10, ypos - 30,,, 1){
						file_delete("Saves/" + temp_text + ".png")
						file_delete("Saves/" + temp_text + ".save")
						array_delete(partidas, a, 1)
						continue
					}
					draw_text(xpos + 20, ypos, text_wrap(temp_text, 100))
					xpos += 120
					if a mod 9 = 8{
						xpos = 120
						ypos += 150
					}
				}
				draw_set_valign(fa_top)
				if array_length(partidas) = 0{
					draw_set_halign(fa_center)
					draw_text(room_width / 2, 200, L.menu_sin_archivos)
					draw_set_halign(fa_left)
				}
				if draw_boton(120, 120, L.cancelar, ui_rojo,,,, 1) or keyboard_check_pressed(vk_escape) or (not DEVISE and keyboard_check(vk_backspace)){
					if not DEVISE
						keyboard_clear(vk_backspace)
					keyboard_clear(vk_escape)
					get_file = 2
				}
			}
			//Multijugador
			else if get_file = 4{
				ypos = 110
				if draw_boton(120, ypos, L.cancelar, ui_rojo,,,, 1) or keyboard_check_pressed(vk_escape) or (not DEVISE and keyboard_check(vk_backspace)){
					if not DEVISE
						keyboard_clear(vk_backspace)
					keyboard_clear(vk_escape)
					get_file = 0
					input_layer = 0
					exit
				}
				draw_set_halign(fa_center)
				draw_boton_text_counter = 0
				ypos += text_y * 1.2
				var prev_online_nombre = online_nombre
				online_nombre = draw_boton_text(room_width / 2, ypos, online_nombre, false,, true, 1)
				if draw_sprite_boton(spr_random, 0, (room_width + text_x) / 2, ypos,,, 1){
					online_nombre = $"jugador_{irandom(255)}"
					ini_open("Settings.ini")
					ini_key_delete("", "online_nombre")
					ini_close()
				}
				else if online_nombre != prev_online_nombre
					save_setting("", "online_nombre", online_nombre, false)
				ypos += text_y * 1.2
				if draw_boton(room_width / 2, ypos, $"{L.buscar_servidores_en_LAN}{server_buscando_lan ? " ..." : ""}", ui_azul,,,, 1)
					server_buscar_lan()
				ypos += text_y * 1.2
				if server_ip != "" and draw_boton(room_width / 2, ypos, $"{L.conectarse_a} {server_ip}", ui_verde,,,, 1){
					server = network_connect(socket, server_ip, 6500)
					if server != -1
						server_hello()
				}
				ypos += text_y * 2
				server_ip = draw_boton_text(room_width / 2, ypos, server_ip, false,, true, 1)
				input_layer = 1
				get_file = 4
				if --server_buscando_lan_step <= 0
					server_buscando_lan = false
			}
		}
		else if not DEVISE and keyboard_check(vk_backspace)
			game_end()
		draw_set_valign(fa_bottom)
		draw_text(10, room_height - 10, "Tomás Ramdohr")
		draw_set_valign(fa_top)
		update_cursor()
		if keyboard_check_pressed(vk_escape)
			game_end()
		for(var a = 0; a < IDIOMAS; a++)
			if draw_sprite_boton(spr_bandera, a, 20 + 80 * a, 20, 64, 48,, function(data){draw_text_background(0, 80, IDIOMA_NAME[data.a])}, {a : a}){
				idioma = a
				save_setting("", "Idioma", idioma, true)
				set_idioma()
			}
	}
}