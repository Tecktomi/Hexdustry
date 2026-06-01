#region Pre-event
	mina = max(0, floor(camx / zoom / 48))
	minb = max(0, floor(camy / zoom / 14) - 1)
	maxa = min(xsize, ceil(1 + (camx + room_width) / zoom / 48))
	maxb = min(ysize, ceil(1 + (camy + room_height) / zoom / 14))
	min_chunka = max(0, floor(mina / chunk_width))
	min_chunkb = max(0, floor(minb / chunk_height))
	max_chunka = min(ceil(maxa / chunk_width), chunk_xsize)
	max_chunkb = min(ceil(maxb / chunk_height), chunk_ysize)
	if keyboard_check_pressed(vk_f4){
		keyboard_clear(vk_f4)
		window_set_fullscreen(not window_get_fullscreen())
		save_setting("", "fullscreen", window_get_fullscreen())
	}
#endregion
//Menú principal
if menu = 0{
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
			mision.objetivo = 4
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
	if os_browser = browser_not_a_browser and devise and file_exists("last_save.save"){
		ypos += text_y * 1.2
		if draw_boton(room_width / 2, ypos, L.continuar, ui_verde){
			var buffer = buffer_create(128, buffer_grow, 1)
			buffer = buffer_load("last_save.save")
			load_game_buffer(buffer)
			buffer_delete(buffer)
		}
	}
	ypos += text_y * 2
	if draw_boton(room_width / 2, ypos, L.menu_tutorial, ui_verde)
		menu = 4
	ypos += text_y * 2
	if draw_boton(room_width / 2, ypos, L.menu_editor, ui_azul){
		build_index = -1
		mapa_editado = true
		menu = 2
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
			if draw_boton(120, 120, L.cancelar, ui_rojo,,,, 1) or keyboard_check_pressed(vk_escape) or (not devise and keyboard_check(vk_backspace)){
				if not devise
					keyboard_clear(vk_backspace)
				keyboard_clear(vk_escape)
				get_file = 2
			}
		}
		//Partida Nueva
		else if get_file = 2{
			ypos = 110
			if draw_boton(120, ypos, L.cancelar, ui_rojo,,,, 1) or keyboard_check_pressed(vk_escape) or (not devise and keyboard_check(vk_backspace)){
				if not devise
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
			if browser{
				if draw_boton(room_width / 2 - 200, ypos, L.menu_cargar_escenario, ui_azul,,,, 1){
					if not nucleo.vivo
						game_restart()
					get_file = 1
					scan_files_save()
				}
				if draw_boton(room_width / 2 - 200, ypos + text_y, L.cargar_partida, ui_azul,,,, 1){
					if not nucleo.vivo
						game_restart()
					get_file = 3
					partidas = scan_files("Saves/*.save", fa_none)
					for(var a = array_length(partidas) - 1; a >= 0; a--){
						if array_length(partidas_png) > a and partidas_png[a] != spr_null_image
							sprite_delete(partidas_png[a])
						var temp_text = file_format(partidas[a])
						if file_exists("Saves/" + temp_text + ".png")
							var temp_image = sprite_add("Saves/" + temp_text + ".png", 1, false, false, 0, 0)
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
					var buffer = buffer_create(4096, buffer_grow, 1)
					buffer = buffer_load("Saves/" + partidas[a])
					if not load_game_buffer(buffer)
						show_message(L.archivo_obsoleto)
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
			if draw_boton(120, 120, L.cancelar, ui_rojo,,,, 1) or keyboard_check_pressed(vk_escape) or (not devise and keyboard_check(vk_backspace)){
				if not devise
					keyboard_clear(vk_backspace)
				keyboard_clear(vk_escape)
				get_file = 2
			}
		}
		//Multijugador
		else if get_file = 4{
			ypos = 110
			if draw_boton(120, ypos, L.cancelar, ui_rojo,,,, 1) or keyboard_check_pressed(vk_escape) or (not devise and keyboard_check(vk_backspace)){
				if not devise
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
	else if not devise and keyboard_check(vk_backspace)
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
	exit
}
//Editor
if menu = 2{
	menu_editor()
	exit
}
//Campaña
if menu = 4{
	menu_campanna()
	exit
}
//Dibujo
if in(menu, 1, 3){
	dibujar_fondo()
	if grafic_tile_animation
		dibujar_fondo(2)
	dibujar_edificios()
	var show_humo = (grafic_humo and pausa = 0 and enciclopedia = 0 and ((image_index mod 5) = 0))
	for(var a = min_chunka; a < max_chunka; a++)
		for(var b = min_chunkb; b < max_chunkb; b++){
			var chunk = chunk_edificios_draw[# a, b], len = array_length(chunk)
			for(var c = 0; c < len; c++){
				var edificio = chunk[c], index = edificio.index, aa = edificio.x, bb = edificio.y, aaa = aa * zoom - camx, bbb = bb * zoom - camy, center_x = edificio.center_x, center_y = edificio.center_y, alert_count = 0, _jugador = edificio.jugador
				//Recursos sobre caminos
				if tag_camino_o_tunel[index] and edificio.carga_total > 0{
					var proceso = edificio_proceso[index]
					var d = 1.2 * (max(edificio.proceso, edificio.waiting * proceso) - proceso / 2) * 20 / proceso
					draw_sprite_off(recurso_sprite[edificio.carga_id], 0, aa + d * edificio.array_real[0], bb + d * edificio.array_real[1])
				}
				//Munición armas
				else if tag_municion_armas[index] and edificio.carga_total = 0{
					draw_sprite_off(spr_ammo, 0, aa, bb - 28 * ++alert_count)
					draw_sprite_off(spr_falta, 0, aa, bb - 28 * alert_count)
				}
				//Dibujo de los links eléctricos
				else if edificio_energia[index]{
					if grafic_energia{
						draw_set_color(c_yellow)
						for(var d = array_length(edificio.energia_link) - 1; d >= 0; d--){
							var edificio_2 = edificio.energia_link[d]
							draw_line_off(center_x, center_y, edificio_2.center_x, edificio_2.center_y)
						}
					}
					if edificio.red.generacion = 0 and edificio.red.bateria = 0 and edificio.energia_consumo_max > 0{
						draw_sprite_off(spr_energia, 1, aa, bb - 28 * ++alert_count)
						draw_sprite_off(spr_falta, 0, aa, bb - 28 * alert_count)
					}
				}
				//Receta planta química
				if index = id_planta_quimica and edificio.select >= 0
					draw_sprite_off(planta_quimica_sprite[edificio.select], 0, aa, bb)
				//Humo
				if show_humo and tag_generadores_de_humo[index]{
					if ((tag_generadores_de_humo_combustion[index] and edificio.fuel > 0) or (index = id_generador_geotermico and in(edificio.flujo.liquido, 0, 4)) or (index = id_refineria_de_petroleo and edificio.flujo.liquido = 2 and edificio.red.eficiencia > 0)) and image_index & 1{
						var dir = direccion_viento + random_range(-pi / 4, pi / 4)
						array_push(humos, add_humo(aa, bb, edificio.a, edificio.b, cos(dir), sin(dir), irandom_range(70, 100)))
					}
				}
				//Mensajes
				if index = id_mensaje{
					draw_set_halign(fa_center)
					draw_text_background(aaa, bbb + 20, edificio.variables[0])
					draw_set_halign(fa_left)
				}
				//Planta de Reciclaje
				else if tag_dron_encima[index] and edificio.select >= 0{
					if edificio.mode
						draw_sprite_off(edificio_sprite[edificio.select], 0, center_x, center_y, 0.8, 0.8,,, 0.5)
					else
						draw_sprite_off(dron_sprite[edificio.select], 0, center_x, center_y,,,,, 0.5)
				}
				//Dibujo falta líquido
				if tag_liquido_obligatorio[index]{
					if edificio.flujo_consumo_max > 0 and not array_contains(edificio_flujo_liquido[index], edificio.flujo.liquido){
						draw_sprite_off(liquido_sprite[edificio_flujo_liquido[index, (image_index / 300) mod array_length(edificio_flujo_liquido[index])]], 0, aa, bb - 28 * ++alert_count)
						draw_sprite_off(spr_falta, 0, aa, bb - 28 * alert_count)
					}
				}
				draw_vida(aaa, bbb, edificio.vida, edificio_vida[index])
				//Dibujo estados
				if _jugador != jugador or edificio.enemigo{
					if edificio.enemigo{
						draw_set_color(#7f0000)
						draw_circle_off(aa + 8, bb, 5, false)
					}
					draw_set_color((_jugador = -1) ? c_ltgray : EQUIPO_COLOR[_jugador])
					draw_circle_off(aa + 8, bb, 4, false)
				}
				if info and edificio.waiting{
					draw_set_color(c_yellow)
					draw_circle_off(aa, bb + 16, 4, false)
				}
				if edificio.idle{
					draw_set_color(c_red)
					draw_circle_off(aa, bb + 8, 4, false)
				}
			}
		}
	//Reconstruir
	if keyboard_check(CONTROL_REPARAR)
		for(var a = mina; a < maxa; a++)
			for(var b = minb; b < maxb; b++)
				if repair_id[# a, b] >= 0{
					var temp_complex = abtoxy(a, b)
					draw_edificio(temp_complex[0], temp_complex[1], repair_id[# a, b], repair_dir[# a, b], 0.5)
				}
	//Luz
	if energia_solar < 1{
		var luz_alpha = 0.6 * (1 - energia_solar)
		if grafic_luz{
			var surf = surface_create(room_width, room_height)
			surface_set_target(surf)
			draw_clear_alpha(c_black, 1)
			gpu_set_blendmode(bm_subtract)
			for(var a = array_length(luces) - 1; a >= 0; a--){
				var temp_luz = luces[a]
				if temp_luz.a > mina and temp_luz.b > minb and temp_luz.a < maxa and temp_luz.b < maxb{
					draw_sprite_off(spr_blur_32, 0, temp_luz.x, temp_luz.y, temp_luz.r, temp_luz.r, 0, c_white, 1)
				}
			}
			gpu_set_blendmode(bm_normal)
			surface_reset_target()
			draw_set_alpha(luz_alpha)
			draw_surface(surf, 0, 0)
			draw_set_alpha(1)
			surface_free(surf)
		}
		else{
			draw_set_alpha(luz_alpha)
			draw_set_color(c_black)
			draw_rectangle(0, 0, room_width, room_height, false)
			draw_set_alpha(1)
		}
	}
	draw_set_halign(fa_center)
	if mision_actual >= 0 and win = 0
		for(var b = 0; b < array_length(mision.texto); b++){
			var texto = mision.texto[b]
			draw_text_background(texto.x * zoom - camx, texto.y * zoom - camy, text_wrap(texto.texto_idioma[idioma], 250),, false)
		}
	var temp_text = "", b = 0
	for(var a = 0; a < rss_max; a++)
		if jugador_recursos[0, rss_sort[a]] != 0{
			if ++b mod 2
				temp_text += "\n"
			temp_text += $"/{recurso_keyword[rss_sort[a]]}{jugador_recursos[0, rss_sort[a]]} "
		}
	if temp_text != ""
		draw_text_background(room_width / 2, 0, temp_text, true)
	draw_set_halign(fa_left)
	if enciclopedia > 0{
		image_index--
		draw_enciclopedia()
		exit
	}
	if sonido and random(1) < 0.1{
		var a = irandom_range(mina, maxa - 1)
		b = irandom_range(minb, maxb - 1)
		if terreno[# a, b] = idt_lava{
			var temp_complex = abtoxy(a, b), aa = temp_complex[0], bb = temp_complex[1]
			sound_play(snd_lava, aa, bb, 0.5)
		}
	}
	sprite_boton_text = ""
	clic_sound = false
	if menu = 3{
		draw_set_halign(fa_right)
		if draw_boton(room_width - 40, 20, build_enemigo ? "ENEMIGO" : "ALIADO", build_enemigo ? ui_rojo : ui_azul)
			build_enemigo = not build_enemigo
		draw_set_halign(fa_left)
	}
}
//Pausa - Menú
if pausa = 1{
	for(var a = array_length(enemigos) - 1; a >= 0; a--)
		draw_dron(enemigos[a], true)
	for(var a = array_length(drones_aliados) - 1; a >= 0; a--)
		draw_dron(drones_aliados[a], false)
	image_index--
	var color = draw_get_color()
	draw_set_color(c_black)
	draw_set_alpha(0.2)
	draw_rectangle(0, 0, room_width, room_height, false)
	draw_set_alpha(1)
	draw_set_color(c_white)
	draw_set_halign(fa_center)
	draw_set_font(font_titulo)
	draw_text(room_width / 2, 100, L.pausa)
	draw_set_font(font_normal)
	var xpos = room_width / 2, ypos = 300
	//Ajustes generales
	if get_file = 0{
		draw_text(room_width / 2, 150,	$"{L.pausa_continuar}\n\"{chr(CONTROL_REDES)}\" {L.pausa_red}\n\"{chr(CONTROL_FLUJO)}\" {L.pausa_liquido}\n\"{chr(CONTROL_ENCICLOPEDIA)}\" {L.pausa_enciclopedia}\n\"{chr(CONTROL_REPARAR)}\" {L.pausa_reparar}")
		if devise{
			if draw_boton(xpos, ypos, L.controles, ui_azul)
				get_file = 3
			ypos += text_y * 1.2
		}
		if draw_boton(xpos, ypos, "AJUSTES", ui_azul)
			get_file = 2
		ypos += text_y * 1.2
		//Guardar / Abrir en LAN
		if menu = 1{
			if os_browser = browser_not_a_browser{
				if not mapa_editado{
					if server = -1 and menu = 1{
						if draw_boton(xpos, ypos, L.abrir_en_LAN, ui_azul)
							get_file = 1
					}
					else
						draw_boton(xpos, ypos, $"{array_length(server_jugadores_nombre)} {L.jugadores}", ui_verde)
					ypos += text_y * 1.2
					if guardado
						draw_boton(xpos, ypos, "Guardado", ui_verde)
					else if tutorial = 0 and draw_boton(xpos, ypos, L.guardar, ui_azul){
						guardado = true
						var buffer = buffer_create(4096, buffer_grow, 1)
						save_game_buffer(buffer)
						var temp_text = $"Saves/{day_format()}"
						buffer_save(buffer, $"{temp_text}.save")
						buffer_delete(buffer)
						var temp_sprite = minimapa()
						sprite_save(temp_sprite, 0, $"{temp_text}.png")
					}
					ypos += text_y * 1.2
				}
			}
			else{
				draw_boton(xpos, ypos, L.descargar_para_jugar_en_LAN, ui_gris)
				ypos += text_y * 1.2
			}
		}
		if draw_boton(xpos, ypos, L.salir, ui_rojo){
			clear_edit()
			pausa = 0
			cheat = false
			if menu = 1{
				if tutorial = 0 and os_browser = browser_not_a_browser and not mapa_editado{
					var buffer = buffer_create(1024, buffer_grow, 1)
					save_game_buffer(buffer)
					buffer_save(buffer, "last_save.save")
					buffer_delete(buffer)
				}
				menu = 0
				if online{
					if servidor
						server_break()
					else
						server_jugador_irse()
				}
				clear_edificios()
				exit
			}
			else if menu = 3{
				menu = 2
				build_index = -1
				build_enemigo = false
				draw_set_halign(fa_left)
				draw_set_color(color)
				exit
			}
			jugador = 2
			exit
		}
	}
	//Ajustes ONLINE
	else if get_file = 1{
		if draw_boton(xpos, ypos, L.abrir_en_LAN, ui_azul){
			open_server()
			get_file = 0
		}
		ypos += text_y * 1.2
		if draw_boton(xpos, ypos, server_pvp ? "PVP" : "COOP", server_pvp ? ui_rojo : ui_verde)
			server_pvp = not server_pvp
		if draw_boton(xpos, room_height - 200, L.volver, ui_rojo) or (not devise and keyboard_check_pressed(vk_backspace)){
			if not devise
				keyboard_clear(vk_backspace)
			get_file = 0
		}
	}
	//Ajustes
	else if get_file = 2{
		if draw_boton(xpos, ypos, (info ? L.pausa_desactivar : L.pausa_activar) + $" {L.pausa_info}", info ? ui_verde : ui_rojo){
			info = not info
			save_setting("", "info", info)
		}
		ypos += text_y * 1.2
		if draw_boton(xpos, ypos, (grafic_tile_animation ? L.pausa_desactivar : L.pausa_activar) + $" {L.pausa_animacion}", grafic_tile_animation ? ui_verde : ui_rojo){
			grafic_tile_animation = not grafic_tile_animation
			save_setting("", "grafic_tile_animation", grafic_tile_animation)
		}
		ypos += text_y * 1.2
		if draw_boton(xpos, ypos, (grafic_luz ? L.pausa_desactivar : L.pausa_activar) + $" {L.pausa_iluminacion}", grafic_luz ? ui_verde : ui_rojo){
			grafic_luz = not grafic_luz
			save_setting("", "grafic_luz", grafic_luz)
		}
		ypos += text_y * 1.2
		if draw_boton(xpos, ypos, (grafic_humo ? L.pausa_desactivar : L.pausa_activar) + $" {L.pausa_humo}", grafic_humo ? ui_verde : ui_rojo){
			grafic_humo = not grafic_humo
			save_setting("", "grafic_humo", grafic_humo)
		}
		ypos += text_y * 1.2
		if draw_boton(xpos, ypos, (grafic_hideui ? L.pausa_desactivar : L.pausa_activar) + $" {L.pausa_UI}", grafic_hideui ? ui_rojo : ui_verde)
			grafic_hideui = not grafic_hideui
		ypos += text_y * 1.2
		if draw_boton(xpos, ypos, (sonido ? L.pausa_desactivar : L.pausa_activar) + $" {L.pausa_sonido}", sonido ? ui_verde : ui_rojo)
			sound_change()
		ypos += text_y * 1.2
		if draw_boton(xpos, ypos, (grafic_energia ? L.pausa_desactivar : L.pausa_activar) + $" {L.red_energia}", grafic_energia ? ui_verde : ui_rojo){
			grafic_energia = not grafic_energia
			save_setting("", "grafic_energia", grafic_energia)
		}
		ypos += text_y * 1.2
		if draw_boton(xpos, ypos, (auto_guardado ? L.pausa_desactivar : L.pausa_activar) + $" {L.autoguardado}", auto_guardado ? ui_verde : ui_rojo){
			auto_guardado = not auto_guardado
			save_setting("", "auto_guardado", auto_guardado)
		}
		if draw_boton(xpos, room_height - 200, L.volver, ui_rojo) or (not devise and keyboard_check_pressed(vk_backspace)){
			if not devise
				keyboard_clear(vk_backspace)
			get_file = 0
		}
	}
	//Controles
	else{
		ypos = 200
		for(var a = 0; a < CONTROL_MAX; a++){
			var key = CONTROL_USADAS[a]
			if key = vk_space
				var char = "Espacio"
			else if key = vk_escape
				char = "Escape"
			else if key >= vk_f1 and key <= vk_f12
				char = $"F{chr(key - ord("p") + ord(1))}"
			else if key = vk_tab
				char = "TAB"
			else
				char = chr(key)
			draw_set_halign((a & 1) ? fa_left : fa_right)
			if draw_boton(xpos + 40 * (a & 1) - 20, ypos, $"{CONTROL_NOMBRE[a]} \"{char}\"")
				get_file = 4 + a
			if (a & 1)
				ypos += text_y * 1.2
		}
		draw_set_halign(fa_center)
		if get_file > 3{
			draw_set_color(c_black)
			draw_set_alpha(0.5)
			draw_rectangle(0, 0, room_width, room_height, false)
			draw_set_color(c_white)
			draw_set_alpha(1)
			draw_text(xpos, ypos, "PRESIONA CUALQUIER TECLA")
			if keyboard_check_pressed(vk_anykey) and (keyboard_lastkey = CONTROL_USADAS[get_file - 2] or not array_contains(CONTROL_USADAS, keyboard_lastkey)){
				get_file -= 2
				if get_file = 2
					CONTROL_LEFT = keyboard_lastkey
				else if get_file = 3
					CONTROL_RIGHT = keyboard_lastkey
				else if get_file = 4
					CONTROL_UP = keyboard_lastkey
				else if get_file = 5
					CONTROL_DOWN = keyboard_lastkey
				else if get_file = 6
					CONTROL_PAUSE = keyboard_lastkey
				else if get_file = 7
					CONTROL_MENU = keyboard_lastkey
				else if get_file = 8
					CONTROL_MUSIC = keyboard_lastkey
				else if get_file = 9
					CONTROL_WAVES = keyboard_lastkey
				else if get_file = 10
					CONTROL_HIDEUI = keyboard_lastkey
				else if get_file = 11
					CONTROL_INFO = keyboard_lastkey
				else if get_file = 12
					CONTROL_FLOW = keyboard_lastkey
				else if get_file = 13
					CONTROL_ENCICLOPEDIA = keyboard_lastkey
				else if get_file = 14
					CONTROL_ROTAR = keyboard_lastkey
				else if get_file = 15
					CONTROL_REPARAR = keyboard_lastkey
				else if get_file = 16
					CONTROL_REDES = keyboard_lastkey
				else if get_file = 17
					CONTROL_FLUJO = keyboard_lastkey
				else if get_file = 18
					CONTROL_BLUEPRINT = keyboard_lastkey
				else if get_file = 19
					CONTROL_TAB = keyboard_lastkey
				CONTROL_USADAS[get_file - 2] = keyboard_lastkey
				save_setting("Controles", $"{get_file - 2}", keyboard_lastkey, false)
				keyboard_clear(keyboard_lastkey)
				get_file = 1
			}
		}
		if draw_boton(xpos, room_height - 200, L.volver, ui_rojo) or (not devise and keyboard_check_pressed(vk_backspace)){
			if not devise
				keyboard_clear(vk_backspace)
			get_file = 0
		}
	}
	draw_set_halign(fa_left)
	for(var a = 0; a < IDIOMAS; a++)
		if draw_sprite_boton(spr_bandera, a, 20 + 80 * a, 20, 64, 48,, function(data){draw_text_background(0, 80, IDIOMA_NAME[data.a])}, {a : a}){
			idioma = a
			save_setting("", "Idioma", idioma, true)
			set_idioma()
		}
	draw_set_color(color)
	if keyboard_check_pressed(CONTROL_MENU) or (not devise and keyboard_check_pressed(vk_backspace)){
		if not devise
			keyboard_clear(vk_backspace)
		keyboard_clear(CONTROL_MENU)
		if get_file = 0{
			pausa = 0
			guardado = false
		}
		else if get_file = 1
			get_file = 0
	}
}
//Solo pausa
if pausa = 2{
	for(var a = array_length(enemigos) - 1; a >= 0; a--)
		draw_dron(enemigos[a], true)
	for(var a = array_length(drones_aliados) - 1; a >= 0; a--)
		draw_dron(drones_aliados[a], false)
	image_index--
	draw_set_color(c_white)
	draw_set_halign(fa_center)
	draw_set_font(font_titulo)
	draw_text(room_width / 2, 100, L.pausa)
	draw_set_halign(fa_left)
	draw_set_font(font_normal)
}
var xmouse = (mouse_x + camx) / zoom, ymouse = (mouse_y + camy) / zoom
//Editar edificio
if show_menu{
	var edificio = show_menu_build, index = edificio.index
	if index = id_procesador{
		draw_boton_text_counter = 0
		show_smoke = false
		draw_set_color(make_color_rgb(189, 140, 191))
		draw_roundrect(100, 100, room_width - 100, room_height - 100, false)
		draw_set_color(c_white)
		draw_roundrect(100, 100, room_width - 100, room_height - 100, true)
		var b = 0
		draw_set_halign(fa_center)
		if draw_boton(room_width / 2, 110, L.procesador_vincular,,,, false){
			procesador_select = edificio
			show_menu = false
		}
		draw_set_halign(fa_left)
		var xpos, ypos = 150, size = array_length(edificio.instruccion)
		//SCROLL
		scroll(110, ypos, size, devise ? 25 : 12, devise ? 20 : 40, scroll_procesador, {xpos : 150, ypos : ypos, edificio : edificio, size : size, b : 0})
		draw_boton_text_list_end()
		xpos = 150
		ypos += min(size, 25) * 20
		if draw_boton(xpos, ypos, L.procesador_add, ui_azul,,, false) or keyboard_check_pressed(vk_enter){
			keyboard_clear(vk_enter)
			procesador_add = true
			input_layer = 1
		}
		if procesador_add{
			var width = 0
			for(var a = 0; a < array_length(PROCESADOR_INSTRUCCIONES_LENGTH); a++)
				width = max(width, string_width($"{procesador_instrucciones_nombre[a]} ({a})"))
			draw_set_color(c_gray)
			draw_rectangle((room_width - width) / 2, 200, (room_width + width) / 2, 200 + 20 * array_length(PROCESADOR_INSTRUCCIONES_LENGTH), false)
			draw_set_color(c_white)
			draw_rectangle((room_width - width) / 2, 200, (room_width + width) / 2, 200 + 20 * array_length(PROCESADOR_INSTRUCCIONES_LENGTH), true)
			draw_set_halign(fa_center)
			for(var a = 0; a < array_length(PROCESADOR_INSTRUCCIONES_LENGTH); a++)
				if draw_boton(room_width / 2, 200 + 20 * a, $"{procesador_instrucciones_nombre[a]} ({a})",,,, false, 1) or keyboard_check_pressed(ord(string(a))){
					var new_instruccion = array_create(PROCESADOR_INSTRUCCIONES_LENGTH[a], 0)
					for(var i = 0; i < array_length(procesador_default_instruccion[a]); i++)
						new_instruccion[i] = procesador_default_instruccion[a, i]
					new_instruccion[0] = a
					array_push(edificio.instruccion, new_instruccion)
					procesador_add = false
					input_layer = 0
					break
				}
			draw_set_halign(fa_left)
			if mouse_check_button_pressed(mb_right) or keyboard_check_pressed(vk_enter){
				keyboard_clear(vk_enter)
				mouse_clear(mb_right)
				procesador_add = false
				input_layer = 0
			}
		}
		ypos = 150
		for(var a = 0; a < array_length(edificio.variables); a++){
			draw_set_halign(fa_right)
			draw_text(room_width - 120, ypos, $"VAR_{a}: ")
			draw_set_halign(fa_left)
			edificio.variables[a] = draw_boton_text(room_width - 120, ypos, edificio.variables[a],, true)
			ypos += 20
		}
		draw_set_halign(fa_right)
		if draw_boton(room_width - 120, 500, L.procesador_next_step, ui_azul,,, false) or keyboard_check_pressed(vk_space){
			keyboard_clear(vk_space)
			edificio.proceso = 1
		}
		if browser and draw_boton(room_width - 120, 530, L.procesador_guardar, ui_azul,,, false) or (keyboard_check(vk_control) and keyboard_check_pressed(ord("S"))){
			save_codes = scan_files("Codes/*.txt", fa_none)
			get_file = 1
			input_layer = 1
			keyboard_clear(ord("S"))
		}
		if browser and draw_boton(room_width - 120, 560, L.procesador_cargar, ui_azul,,, false) or (keyboard_check(vk_control) and keyboard_check_pressed(ord("A"))){
			save_codes = scan_files("Codes/*.txt", fa_none)
			get_file = 2
			input_layer = 1
			keyboard_clear(ord("A"))
		}
		draw_set_halign(fa_left)
		if get_file > 0{
			draw_set_color(c_dkgray)
			draw_rectangle(100, 100, room_width - 100, room_height - 100, false)
			draw_set_color(c_white)
			//Cargar
			if get_file = 2{
				for(var a = 0; a < array_length(save_codes); a++)
					if draw_boton(140, 160 + 30 * a, save_codes[a],,,,, 1){
						input_layer = 0
						get_file = 0
						var buffer = buffer_create(6, buffer_grow, 1)
						buffer = buffer_load("Codes/" + save_codes[a])
						load_procesador(buffer, edificio)
						buffer_delete(buffer)
						edificio.select = 0
					}
			}
			//Guardar
			else if get_file = 1{
				var flag = false
				for(var a = 0; a < array_length(save_codes); a++)
					if draw_boton(140, 160 + 30 * a, save_codes[a],,,,, 1){
						save_file = save_codes[a]
						if string_count(".txt", save_file)
							save_file = string_delete(save_file, string_pos(".txt", save_file), string_length(save_file))
						flag = true
					}
				save_file = string(draw_boton_text(140, 160 + 30 * (array_length(save_codes) + 1), save_file, false,,, 1))
				draw_text(140 + text_x, 160 + 30 * (array_length(save_codes) + 1), ".txt")
				input_layer = 1
				if save_file != "" and (draw_boton(120, 160 + 30 * array_length(save_codes), L.nuevo_archivo,,,,, 1) or keyboard_check_pressed(vk_enter)){
					keyboard_clear(vk_enter)
					save_file += ".txt"
					flag = true
					input_layer = 0
					get_file = 0
				}
				if flag{
					var buffer = buffer_create(6, buffer_grow, 1)
					save_procesador(buffer, edificio)
					buffer_save(buffer, "Codes/" + save_file)
					buffer_delete(buffer)
				}
			}
			if draw_boton(120, 120, L.cancelar, ui_rojo,,,, 1) or keyboard_check_pressed(vk_escape){
				keyboard_clear(vk_escape)
				input_layer = 0
				get_file = 0
			}
		}
	}
	else if index = id_memoria{
		draw_boton_text_counter = 0
		show_smoke = false
		draw_set_color(make_color_rgb(189, 140, 191))
		draw_rectangle((room_width - 840) / 2, 100, (room_width + 840) / 2, 480, false)
		draw_set_color(c_white)
		draw_rectangle((room_width - 840) / 2, 100, (room_width + 840) / 2, 480, true)
		draw_set_halign(fa_center)
		draw_text(room_width / 2, 110, edificio_nombre[edificio.index])
		draw_set_halign(fa_left)
		for(var a = 0; a < 128; a++){
			var xpos = (a mod 8) * 100 + (room_width - 800) / 2, ypos = (a div 8) * 20 + 140
			if is_real(edificio.variables[a]){
				draw_set_color(make_color_rgb(127, 127, 255))
				draw_set_halign(fa_right)
			}
			else{
				draw_set_color(make_color_rgb(255, 91, 91))
				draw_set_halign(fa_left)
			}
			draw_rectangle(xpos, ypos, xpos + 100, ypos + 20, false)
			draw_set_color(c_white)
			draw_rectangle(xpos, ypos, xpos + 100, ypos + 20, true)
			if string_length(edificio.variables[a]) > 9
				var temp_text = string_copy(edificio.variables[a], 1, 6) + "..."
			else
				temp_text = edificio.variables[a]
			edificio.variables[a] = draw_boton_text(xpos + 100 * (is_real(edificio.variables[a])), ypos, temp_text,, true)
		}
		draw_set_halign(fa_left)
	}
	else{
		var temp_complex = abtoxy(edificio.a, edificio.b)
		var width = 80 * zoom, height = 80 * zoom
		var aa = clamp(temp_complex[0] * zoom - camx, width, room_width - width), bb = clamp(temp_complex[1] * zoom - camy, 0, room_height - height)
		draw_set_color(c_gray)
		draw_triangle(aa - 10 * zoom, bb + 20 * zoom, aa + 10 * zoom, bb + 20 * zoom, aa, bb + 10 * zoom, false)
		draw_rectangle(aa - 80 * zoom, bb + 20 * zoom, aa + 80 * zoom, bb + 40 * zoom, false)
		if in(index, id_selector, id_recurso_infinito)
			draw_rectangle(aa - 80 * zoom, bb + 40 * zoom, aa + 80 * zoom, bb + (40 + 28 * ceil(rss_max / 5)) * zoom, false)
		else if index = id_liquido_infinito
			draw_rectangle(aa - 80 * zoom, bb + 40 * zoom, aa + 80 * zoom, bb + (40 + 20 * lq_max) * zoom, false)
		else if index = id_planta_quimica
			draw_rectangle(aa - 90 * zoom, bb + 40 * zoom, aa + 90 * zoom, bb + (40 + 20 * array_length(planta_quimica_receta)) * zoom, false)
		else if in(index, id_fabrica_de_drones, id_fabrica_de_drones_grande){
			var temp_array = index = id_fabrica_de_drones ? [idd_mula, idd_kamikaze] : [idd_reparador, idd_helicoptero, idd_bombardero, idd_reconstructor, idd_minero], len = array_length(temp_array)
			if edificio.enemigo{
				if index = id_fabrica_de_drones
					array_push(temp_array, idd_arana)
				else if index = id_fabrica_de_drones_grande
					array_push(temp_array, idd_tanque)
				len++
			}
			draw_rectangle(aa - 80 * zoom, bb + 40 * zoom, aa + 80 * zoom, bb + (40 + 20 * len) * zoom, false)
		}
		else if index = id_refineria_de_petroleo{
			var c = max(max(string_width(recurso_nombre[idr_compuesto_incendiario]), string_width(recurso_nombre[idr_plastico]), string_width(recurso_nombre[idr_piedra_sulfatada])) + string_width(": 100%"), 200)
			draw_rectangle(aa - c * zoom / 2, bb + 40 * zoom, aa + c * zoom / 2, bb + 120 * zoom, false)
		}
		else if index = id_silo_de_misiles
			draw_rectangle(aa - 80 * zoom, bb + 40 * zoom, aa + 80 * zoom, bb + (40 + 20 * array_length(misiles_nombre)) * zoom, false)
		draw_set_color(c_dkgray)
		draw_triangle(aa - 10 * zoom, bb + 20 * zoom, aa + 10 * zoom, bb + 20 * zoom, aa, bb + 10 * zoom, true)
		draw_rectangle(aa - 80 * zoom, bb + 20 * zoom, aa + 80 * zoom, bb + 40 * zoom, true)
		if in(index, id_selector, id_overflow)
			draw_text(aa - 80 * zoom, bb + 20 * zoom, L.show_menu_invertir)
		if in(index, id_selector, id_recurso_infinito){
			draw_rectangle(aa - 80 * zoom, bb + 40 * zoom, aa + 80 * zoom, bb + (40 + 28 * ceil(rss_max / 5)) * zoom, true)
			for(var a = 0; a < rss_max; a++)
				draw_sprite_stretched(recurso_sprite[a], 0, aa + (-80 + 32 * (a mod 5)) * zoom, bb + (40 + 28 * floor(a / 5)) * zoom, 32 * zoom, 28 * zoom)
		}
		if index = id_liquido_infinito{
			draw_rectangle(aa - 80 * zoom, bb + 40 * zoom, aa + 80 * zoom, bb + (40 + 20 * lq_max) * zoom, true)
			draw_text(aa - 80 * zoom, bb + 20 * zoom, L.show_menu_ningun_liquido)
			for(var a = 0; a < lq_max; a++)
				draw_text(aa - 80 * zoom, bb + (40 + 20 * a) * zoom, liquido_nombre[a])
		}
		if index = id_planta_quimica{
			draw_rectangle(aa - 90 * zoom, bb + 40 * zoom, aa + 90 * zoom, bb + (40 + 20 * array_length(planta_quimica_receta)) * zoom, true)
			draw_text(aa - 80 * zoom, bb + 20 * zoom, L.show_menu_receta)
			for(var a = 0; a < array_length(planta_quimica_receta); a++){
				draw_sprite(planta_quimica_sprite[a], 0, aa - 80 * zoom, bb + (50 + 20 * a) * zoom)
				draw_text(aa - 70 * zoom, bb + (40 + 20 * a) * zoom, planta_quimica_receta[a])
			}
		}
		if in(index, id_fabrica_de_drones, id_fabrica_de_drones_grande){
			var temp_array = index = id_fabrica_de_drones ? [idd_mula, idd_kamikaze] : [idd_reparador, idd_helicoptero, idd_bombardero, idd_reconstructor, idd_minero], len = array_length(temp_array)
			if edificio.enemigo{
				if index = id_fabrica_de_drones
					array_push(temp_array, idd_arana)
				else if index = id_fabrica_de_drones_grande
					array_push(temp_array, idd_tanque)
				len++
			}
			draw_rectangle(aa - 80 * zoom, bb + 40 * zoom, aa + 80 * zoom, bb + (40 + 20 * len) * zoom, true)
			draw_text(aa - 80 * zoom, bb + 20 * zoom, L.show_menu_unidad)
			for(var a = 0; a < len; a++)
				draw_text(aa - 80 * zoom, bb + (40 + 20 * a) * zoom, dron_nombre[temp_array[a]])
			if edificio.array_real[0] != -1
				draw_sprite_off(spr_target, 0, edificio.array_real[0], edificio.array_real[1])
			if mouse_check_button_pressed(mb_right){
				mouse_clear(mb_right)
				if edificio.array_real[0] = -1{
					edificio.array_real[0] = xmouse
					edificio.array_real[1] = ymouse
				}
				else{
					edificio.array_real[0] = -1
					edificio.array_real[1] = -1
				}
			}
		}
		else if index = id_deposito
			draw_text(aa - 80 * zoom, bb + 20 * zoom, "Vaciar")
		else if index = id_embotelladora
			draw_text(aa - 80 * zoom, bb + 20 * zoom, edificio.mode ? "Embotellar" : "Desembotellar")
		else if index = id_refineria_de_petroleo{
			edificio.select = round(draw_deslizante(aa - 100 * zoom, aa + 100 * zoom, bb + 50 * zoom, edificio.select, 0, 100, 0))
			draw_set_halign(fa_center)
			if draw_boton(aa, bb + 60 * zoom, $"{recurso_nombre[idr_compuesto_incendiario]}: {edificio.select}%",,,, false)
				edificio.select = 100
			if draw_boton(aa, bb + 80 * zoom, $"{recurso_nombre[idr_plastico]}: {round(100 * (1 - edificio.select / 100) * (sqr(1 - abs(edificio.select - 50) / 100)))}%",,,, false)
				edificio.select = 50
			if draw_boton(aa, bb + 100 * zoom, $"{recurso_nombre[idr_piedra_sulfatada]}: {100 - edificio.select - round(100 * (1 - edificio.select / 100) * (sqr(1 - abs(edificio.select - 50) / 100)))}%",,,, false)
				edificio.select = 0
			draw_set_halign(fa_left)
		}
		else if index = id_silo_de_misiles{
			draw_rectangle(aa - 90 * zoom, bb + 40 * zoom, aa + 90 * zoom, bb + (40 + 20 * array_length(misiles_nombre)) * zoom, true)
			draw_text(aa - 80 * zoom, bb + 20 * zoom, L.show_menu_receta)
			for(var a = 0; a < array_length(misiles_nombre); a++)
				draw_text(aa - 70 * zoom, bb + (40 + 20 * a) * zoom, misiles_nombre[a])
		}
		if mouse_x > aa - 80 * zoom and mouse_y > bb + 20 * zoom and mouse_x < aa + 80 * zoom{
			if in(index, id_selector, id_overflow, id_embotelladora){
				if mouse_check_button_pressed(mb_left) and mouse_y < bb + 40 * zoom{
					mouse_clear(mb_left)
					show_menu = false
					set_edificio(not edificio.mode, edificio.select, edificio)
				}
			}
			if in(index, id_selector, id_recurso_infinito){
				if mouse_y < bb + (40 + 28 * ceil(rss_max / 5)) * zoom{
					var a = floor((mouse_x - (aa - 80 * zoom)) / (32 * zoom)) + 5 * floor((mouse_y - (bb + 40 * zoom)) / (28 * zoom))
					if a >= 0 and a < rss_max{
						draw_text_background(mouse_x + 20, mouse_y, recurso_nombre[a])
						cursor = cr_handpoint
						if mouse_check_button_pressed(mb_left){
							mouse_clear(mb_left)
							show_menu = false
							set_edificio(edificio.mode, a, edificio)
						}
					}
				}
			}
			else if index = id_liquido_infinito{
				if mouse_check_button_pressed(mb_left) and mouse_y < bb + (40 + 20 * lq_max) * zoom{
					mouse_clear(mb_left)
					show_menu = false
					var a = floor((mouse_y - (bb + 20 * (1 + zoom))) / (20 * zoom))
					set_edificio(edificio.mode, a, edificio)
				}
			}
			else if index = id_planta_quimica{
				if mouse_y > bb + 40 * zoom and mouse_y < bb + (40 + 20 * array_length(planta_quimica_receta)) * zoom{
					var a = clamp(floor((mouse_y - (bb + 20 * (1 + zoom))) / (20 * zoom)), 0, array_length(planta_quimica_receta) - 1)
					draw_text_background(mouse_x + 20, mouse_y, planta_quimica_descripcion[a])
					cursor = cr_handpoint
					if mouse_check_button_pressed(mb_left){
						mouse_clear(mb_left)
						show_menu = false
						set_edificio(edificio.mode, a, edificio)
					}
				}
			}
			else if in(index, id_fabrica_de_drones, id_fabrica_de_drones_grande){
				var temp_array = index = id_fabrica_de_drones ? [idd_mula, idd_kamikaze] : [idd_reparador, idd_helicoptero, idd_bombardero, idd_reconstructor, idd_minero], len = array_length(temp_array)
				if edificio.enemigo{
					if index = id_fabrica_de_drones
						array_push(temp_array, idd_arana)
					else if index = id_fabrica_de_drones_grande
						array_push(temp_array, idd_tanque)
					len++
				}
				if mouse_y > bb + 40 * zoom and mouse_y < bb + (40 + 20 * len) * zoom{
					var a = temp_array[floor((mouse_y - (bb + 20 * (1 + zoom))) / (20 * zoom))], temp_text = $"{dron_descripcion[a]}\n"
					for(var b = array_length(dron_precio_id[a]) - 1; b >= 0; b--)
						temp_text += $"  {recurso_nombre[dron_precio_id[a, b]]}: {dron_precio_num[a, b]}\n"
					draw_text_background(mouse_x + 20, mouse_y, temp_text)
					cursor = cr_handpoint
					if mouse_check_button_pressed(mb_left){
						mouse_clear(mb_left)
						show_menu = false
						set_edificio(edificio.mode, a, edificio)
					}
				}
			}
			else if index = id_deposito{
				if mouse_check_button_pressed(mb_left){
					mouse_clear(mb_left)
					show_menu = false
					edificio.flujo.almacen = 0
					edificio.flujo.liquido = -1
				}
			}
			else if index = id_silo_de_misiles{
				if mouse_y > bb + 40 * zoom and mouse_y < bb + (40 + 20 * array_length(misiles_nombre)) * zoom{
					var a = clamp(floor((mouse_y - (bb + 20 * (1 + zoom))) / (20 * zoom)), 0, array_length(misiles_nombre) - 1)
					draw_text_background(mouse_x + 20, mouse_y, misiles_descripcion[a])
					cursor = cr_handpoint
					if mouse_check_button_pressed(mb_left){
						mouse_clear(mb_left)
						show_menu = false
						set_edificio(edificio.mode, a, edificio)
					}
				}
			}
		}
		else if mouse_check_button_pressed(mb_left)
			show_menu = false
	}
	if mouse_check_button_pressed(mb_right) or keyboard_check_pressed(vk_escape){
		show_smoke = true
		keyboard_clear(vk_escape)
		mouse_clear(mb_right)
		show_menu = false
		input_layer = 0
	}
}
//Terreno bajo el mouse
var temp_complex_mouse = xytoab(xmouse, ymouse), mx = temp_complex_mouse[0], my = temp_complex_mouse[1], outside = false, prev_change = false
if mx < 0 or my < 0 or mx >= xsize or my >= ysize{
	outside = true
	mx = clamp(mx, 0, xsize - 1)
	my = clamp(my, 0, ysize - 1)
}
if mx != prev_x or my != prev_y{
	prev_x = mx
	prev_y = my
	prev_change = true
}
var edificio = edificio_id[# mx, my], temp_coordenada = edificio.coordenadas
//Blueprint
if keyboard_check(CONTROL_BLUEPRINT){
	if keyboard_check_pressed(CONTROL_BLUEPRINT){
		ds_grid_clear(blueprint_grid, false)
		array_resize(blueprint, 0)
	}
	draw_set_halign(fa_center)
	if array_length(blueprint) = 0 and draw_boton(room_width / 2, 40, L.cargar_plano){
		get_file = 3
		input_layer = 1
		blueprints_files = scan_files("Blueprints/*.txt", fa_none)
		for(var a = 0; a < array_length(blueprints_image); a++)
			if blueprints_image[a] != spr_null_image
				sprite_delete(blueprints_image[a])
		for(var a = 0; a < array_length(blueprints_files); a++){
			var temp_text = "Blueprints/" + file_format(blueprints_files[a])
			if file_exists(temp_text + ".png")
				var temp_image = sprite_add(temp_text + ".png", 1, false, false, 0, 0)
			else
				temp_image = spr_null_image
			blueprints_image[a] = temp_image
		}
	}
	draw_set_halign(fa_left)
	var temp_mina = max(mina, blueprint_mina), temp_maxa = min(maxa, blueprint_maxa + 1), temp_minb = max(minb, blueprint_minb), temp_maxb = min(maxb, blueprint_maxb + 1)
	for(var a = temp_mina; a < temp_maxa; a++)
		for(var b = temp_minb; b < temp_maxb; b++)
			if blueprint_grid[# a, b]{
				var temp_complex = abtoxy(a, b)
				draw_sprite_off(spr_hexagono, 0, temp_complex[0], temp_complex[1],,,, c_blue, 0.5)
			}
	if mouse_check_button_released(mb_left){
		blueprint_safe = false
		blueprint_mod2 = (blueprint_minb & 1)
		blueprint = array_create(0, null_blueprint)
		var temp_array_bool = array_create(array_length(edificios), true)
		var temp_blueprint_mina = infinity, temp_blueprint_maxa = 0, temp_blueprint_minb = infinity, temp_blueprint_maxb = 0
		for(var a = blueprint_mina; a <= blueprint_maxa; a++)
			for(var b = blueprint_minb; b <= blueprint_maxb; b++)
				if blueprint_grid[# a, b] and edificio_bool[# a, b]{
					var temp_edificio = edificio_id[# a, b]
					if temp_array_bool[temp_edificio.punteros[0]]{
						temp_array_bool[temp_edificio.punteros[0]] = false
						var temp_a = blueprint_mina, temp_b = blueprint_minb, rot4 = real(floor((temp_edificio.b - blueprint_minb) / 2)), rot0 = real(temp_edificio.a - blueprint_mina), rot5 = rot0
						temp_a += rot0
						temp_b += 2 * rot4
						if temp_a != temp_edificio.a or temp_b != temp_edificio.b
							for(var i = 0; i < 6; i++){
								var temp_complex = next_to(temp_a, temp_b, i)
								if temp_complex[0] = temp_edificio.a and temp_complex[1] = temp_edificio.b{
									if i = 0
										rot0++
									else if i = 2
										rot5--
									else if i = 3
										rot0--
									else if i = 5
										rot5++
									break
								}
							}
						var temp_blueprint = {
							construible : true,
							a : real(temp_edificio.a - blueprint_mina),
							b : real(temp_edificio.b - blueprint_minb),
							index : real(temp_edificio.index),
							dir : real(temp_edificio.dir),
							rot0 : rot0,
							rot4 : rot4,
							rot5 : rot5
						}
						array_push(blueprint, temp_blueprint)
					}
				}
		if array_length(blueprint) > 0
			build_index = -1
	}
}
if pausa != 1 and get_file = 3{
	var color = draw_get_color(), halign = draw_get_halign()
	draw_set_color(ui_fondo)
	draw_rectangle(100, 100, room_width - 100, room_height - 100, false)
	draw_set_color(ui_texto)
	draw_rectangle(100, 100, room_width - 100, room_height - 100, true)
	if array_length(blueprints_files) = 0{
		draw_set_halign(fa_center)
		draw_text(room_width / 2, 150, L.menu_sin_blueprints)
	}
	else{
		var xpos = 120, ypos = 200
		for(var i = 0; i < array_length(blueprints_files); i++){
			draw_set_color(ui_panel_secundario)
			draw_rectangle(xpos, ypos, xpos + 100, ypos + 100, false)
			if draw_sprite_boton(blueprints_image[i],, xpos, ypos, 100, 100, 1){
				get_file = 0
				input_layer = 0
				blueprint_safe = true
				build_index = -1
				var buffer = buffer_create(2, buffer_grow, 1)
				buffer = buffer_load($"Blueprints\\{blueprints_files[i]}")
				var len = real(buffer_read(buffer, buffer_u8))
				blueprint_mod2 = bool(buffer_read(buffer, buffer_bool))
				array_resize(blueprint, len)
				for(var j = 0; j < len; j++){
					var a = real(buffer_read(buffer, buffer_u8)), b = real(buffer_read(buffer, buffer_u8)), index = real(buffer_read(buffer, buffer_u8))
					var dir = real(buffer_read(buffer, buffer_u8)), rot0 = real(buffer_read(buffer, buffer_u8)), rot4 = real(buffer_read(buffer, buffer_u8)), rot5 = real(buffer_read(buffer, buffer_u8))
					var temp_blueprint = {
						construible : true,
						a : a,
						b : b,
						index : index,
						dir : dir,
						rot0 : rot0,
						rot4 : rot4,
						rot5 : rot5
					}
					blueprint[j] = temp_blueprint
				}
				buffer_delete(buffer)
			}
			draw_set_color(ui_texto)
			draw_rectangle(xpos, ypos, xpos + 100, ypos + 100, true)
			if draw_sprite_boton(spr_basura,, xpos, ypos - 20,,, 1){
				file_delete($"Blueprints\\{blueprints_files[i]}")
				file_delete($"Blueprints\\{blueprints_image[i]}")
				array_delete(blueprints_files, i, 1)
				array_delete(blueprints_image, i, 1)
				break
			}
			draw_text(xpos + 20, ypos - 20, file_format(blueprints_files[i]))
			xpos += 120
			if (i mod 9) = 8{
				xpos = 120
				ypos += 150
			}
		}
	}
	draw_set_halign(fa_center)
	if draw_boton(room_width / 2, room_height - 150, L.volver,,,,, 1) or keyboard_check_pressed(CONTROL_MENU){
		keyboard_clear(CONTROL_MENU)
		get_file = 0
		input_layer = 0
	}
	draw_set_color(color)
	draw_set_color(halign)
}
//Mostrar detalles de edificios al pasar el mouse_por encima
if pausa != 1 and not outside and not (show_menu and show_menu_build.index = id_procesador){
	//Mostrar terreno
	var temp_text = $"{terreno_nombre[terreno[# mx, my]]}\n"
	//Seleccionar Dron
	if mouse_check_button_pressed(mb_left) and false{
		var flag_dron = true, min_dis = 900 * sqr(zoom) //(30 / zoom)^2
		for(var a = array_length(drones_aliados) - 1; a >= 0; a--){
			var temp_dron = drones_aliados[a], dis = distance_sqr(mouse_x, mouse_y, temp_dron.x * zoom - camx, temp_dron.y * zoom - camy)
			if dis < min_dis{
				mouse_clear(mb_left)
				min_dis = dis
				selected_dron = temp_dron
				flag_dron = false
			}
		}
		if flag_dron{
			selected_drones = array_create(0, null_dron)
			selected_dron = null_dron
		}
	}
	if ore[# mx, my] >= 0
		temp_text += $"{recurso_nombre[ore_recurso[ore[# mx, my]]]}: {ore_amount[# mx, my]}\n"
	if edificio_bool[# mx, my]{
		var index = edificio.index
		temp_text += $"{edificio_nombre[index]}\n"
		if (edificio.jugador != jugador or edificio.enemigo) and menu = 1 and not cheat{
			if online and edificio.jugador > 1
				temp_text += server_jugadores_nombre[edificio.jugador - 2]
			else
				temp_text += (edificio.jugador = 0) ? "SALVAJE\n" : "ENEMIGO\n"
		}
		else{
			//Blueprint
			if keyboard_check(CONTROL_BLUEPRINT) and mouse_check_button(mb_left){
				if mouse_check_button_pressed(mb_left){
					blueprint_mina = infinity
					blueprint_maxa = 0
					blueprint_minb = infinity
					blueprint_maxb = 0
				}
				if not (mx = last_mx and my = last_my) and edificio.index != id_nucleo{
					var size = edificio.coordenadas
					for(var a = 0; a < array_length(size); a++){
						ds_grid_set(blueprint_grid, size[a, 0], size[a, 1], true)
						blueprint_mina = min(blueprint_mina, size[a, 0])
						blueprint_maxa = max(blueprint_maxa, size[a, 0])
						blueprint_minb = min(blueprint_minb, size[a, 1])
						blueprint_maxb = max(blueprint_maxb, size[a, 1])
					}
				}
				last_mx = mx
				last_my = my
			}
			if not edificio_inerte[index] and edificio.punteros[4] = -1{
				draw_sprite_off(spr_diseneabled, 0, edificio.center_x, edificio.center_y)
				if draw_boton(edificio.center_x * zoom - camx, edificio.center_y * zoom - camy, L.game_activar)
					activar_edificio(edificio)
			}
			//Seleccionar edificios
			if mouse_check_button_pressed(mb_left) and build_index = 0 and build_menu = 0{
				if procesador_select != null_edificio{
					mouse_clear(mb_left)
					if procesador_select != edificio{
						if not array_contains(procesador_select.procesador_link, edificio){
							array_push(procesador_select.procesador_link, edificio)
							array_push(edificio.procesador_link, procesador_select)
						}
						else{
							array_remove(procesador_select.procesador_link, edificio)
							array_remove(edificio.procesador_link, procesador_select)
						}
						if not keyboard_check(vk_lshift)
							procesador_select = null_edificio
					}
				}
				else if tag_edificio_seteable[index] or in(index, id_procesador, id_memoria, id_deposito){
					mouse_clear(mb_left)
					deselect_drones()
					if index = id_silo_de_misiles and edificio.mode{
						if edificio.fuel = 0
							misil_set_target = edificio
					}
					else{
						show_menu = true
						show_menu_build = edificio
						show_menu_x = edificio.center_x * zoom
						show_menu_y = edificio.center_y * zoom
					}
				}
			}
			//Modificar puertos de carga
			if index = id_puerto_de_carga{
				if edificio.link != null_edificio{
					draw_set_color(c_green)
					if edificio.receptor
						draw_arrow_off(edificio.center_x, edificio.center_y, edificio.link.center_x, edificio.link.center_y, 8)
					else
						draw_arrow_off(edificio.link.center_x, edificio.link.center_y, edificio.center_x, edificio.center_y, 8)
				}
				if mouse_check_button_pressed(mb_left){
					mouse_clear(mb_left)
					if puerto_carga_bool and edificio != puerto_carga_link{
						var temp_puerto_carga = edificio.enemigo ? puerto_carga_array_enemigo : puerto_carga_array
						if puerto_carga_link.link != null_edificio{
							if puerto_carga_link.receptor
								array_disorder_remove(temp_puerto_carga, puerto_carga_link, 2)
							else
								array_disorder_remove(temp_puerto_carga, puerto_carga_link.link, 2)
							if puerto_carga_atended >= array_length(temp_puerto_carga)
								puerto_carga_atended = 0
							puerto_carga_link.link.receptor = false
							puerto_carga_link.link.emisor = false
							calcular_edificios_adyascentes(puerto_carga_link.link)
							puerto_carga_link.link.link = null_edificio
						}
						puerto_carga_link.receptor = true
						puerto_carga_link.emisor = false
						puerto_carga_link.link = edificio
						calcular_inputs_outputs(puerto_carga_link)
						calcular_edificios_adyascentes(puerto_carga_link, false)
						if edificio.link != null_edificio{
							if edificio.receptor
								array_disorder_remove(temp_puerto_carga, edificio, 2)
							else
								array_disorder_remove(temp_puerto_carga, edificio.link, 2)
							if puerto_carga_atended >= array_length(temp_puerto_carga)
								puerto_carga_atended = 0
							edificio.link.receptor = false
							edificio.link.emisor = false
							calcular_edificios_adyascentes(edificio.link)
							edificio.link.link = null_edificio
						}
						edificio.receptor = false
						edificio.emisor = true
						edificio.link = puerto_carga_link
						calcular_inputs_outputs(edificio)
						calcular_edificios_adyascentes(edificio, false)
						array_disorder_push(temp_puerto_carga, puerto_carga_link, 2)
						puerto_carga_link = null_edificio
						puerto_carga_bool = false
					}
					else{
						puerto_carga_link = edificio
						puerto_carga_bool = true
					}
				}
			}
			else if index = id_procesador{
				for(var a = 1; a < array_length(edificio.procesador_link); a++){
					var temp_edificio = edificio.procesador_link[a]
					draw_set_color(c_green)
					draw_arrow_off(edificio.center_x, edificio.center_y, temp_edificio.center_x, temp_edificio.center_y, 8)
					draw_set_color(c_black)
					draw_text_off((edificio.center_x + temp_edificio.center_x) / 2, (edificio.center_y + temp_edificio.center_y) / 2, a)
				}
			}
			if info{
				var center_x = edificio.center_x, center_y = edificio.center_y
				//Mostrar inputs
				draw_set_color(c_blue)
				for(var a = array_length(edificio.inputs) - 1; a >= 0; a--){
					var edificio_2 = edificio.inputs[a]
					draw_arrow_off(edificio_2.center_x, edificio_2.center_y, center_x, center_y, 12)
				}
				//Mostrar outputs
				draw_set_color(c_red)
				for(var a = array_length(edificio.outputs) - 1; a >= 0; a--){
					var edificio_2 = edificio.outputs[a]
					draw_arrow_off(center_x, center_y, edificio_2.center_x, edificio_2.center_y, 12)
				}
			}
			//Mostrar carga
			if edificio.index = id_ensambladora and edificio.mode{
				var temp_edificio = edificio.link, flag = false
				draw_arrow_off(edificio.center_x, edificio.center_y, temp_edificio.center_x, temp_edificio.center_y, 4)
				for(var a = 0; a < rss_max; a++)
					if (edificio.carga[a] + temp_edificio.carga[a]) > 0{
						if not flag{
							temp_text += $"{L.almacen_almacen}:\n"
							flag = true
						}
						temp_text += $"  {recurso_nombre[a]}: {floor(edificio.carga[a] + temp_edificio.carga[a])}\n"
					}
			}
			else if edificio.carga_total > 0 and index != id_silo_de_misiles{
				var flag = false
				for(var a = 0; a < rss_max; a++)
					if edificio.carga[a] > 0{
						if not flag{
							temp_text += $"{L.almacen_almacen}:\n"
							flag = true
						}
						temp_text += $"  {recurso_nombre[a]}: {floor(edificio.carga[a])}\n"
					}
				if info and edificio.carga_total > 0
					temp_text += $"    {L.almacen_total}: {floor(edificio.carga_total)}\n"
			}
			//Mostrar recursos subterraneos
			if in(index, id_taladro, id_taladro_electrico){
				if edificio.idle
					temp_text += $"{L.almacen_sin_recursos}\n"
				else{
					var temp_array = [0], temp_text_2 = ""
					for(var a = 0; a < rss_max; a++)
						temp_array[a] = 0
					for(var a = array_length(edificio.coordenadas) - 1; a >= 0; a--){
						var temp_complex = edificio.coordenadas[a], aa = temp_complex[0], bb = temp_complex[1]
						if in(ore[# aa, bb], 0, 1, 2)
							temp_array[ore_recurso[ore[# aa, bb]]] += ore_amount[# aa, bb]
						else if terreno_recurso_bool[terreno[# aa, bb]] and index = id_taladro_electrico
							temp_array[terreno_recurso_id[terreno[# aa, bb]]] = -1
					}
					for(var a = 0; a < rss_max; a++)
						if temp_array[a] > 0
							temp_text_2 += $"  {recurso_nombre[a]}: {temp_array[a]}\n"
						else if temp_array[a] = -1
							temp_text_2 += $"  {recurso_nombre[a]}\n"
					if temp_text_2 != ""
						temp_text += $"{L.almacen_recursos_disponibles}:\n{temp_text_2}"
				}
			}
			else if index = id_taladro_de_explosion{
				if edificio.idle
					temp_text += $"{L.almacen_sin_recursos}\n"
				else{
					var temp_array = [0], temp_text_2 = "", temp_array_coord = get_size(edificio.a, edificio.b, 0, 5)
					for(var a = 0; a < rss_max; a++)
						temp_array[a] = 0
					for(var a = array_length(temp_array_coord) - 1; a >= 0; a--){
						var temp_complex = temp_array_coord[a], aa = temp_complex[0], bb = temp_complex[1]
						if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
							continue
						if in(ore[# aa, bb], 0, 1, 2)
							temp_array[ore_recurso[ore[# aa, bb]]] += ore_amount[# aa, bb]
						else if terreno_recurso_bool[terreno[# aa, bb]]
							temp_array[terreno_recurso_id[terreno[# aa, bb]]] = -1
					}
					for(var a = 0; a < rss_max; a++)
						if temp_array[a] > 0
							temp_text_2 += $"  {recurso_nombre[a]}: {temp_array[a]}\n"
						else if temp_array[a] = -1
							temp_text_2 += $"  {recurso_nombre[a]}\n"
					if temp_text_2 != ""
						temp_text += $"{L.almacen_recursos_disponibles}:\n{temp_text_2}"
				}
			}
			//Mostrar combustión
			if tag_mostrar_combustion[index]
				temp_text += $"{L.almacen_combustion}: {floor(edificio.fuel / 30)} s\n"
			//Mostrar rango de cables
			if index = id_cable{
				draw_set_color(c_white)
				draw_circle_off(edificio.center_x, edificio.center_y, 90, true)
			}
			//Mostrar rango de torres
			if edificio_armas[index]{
				var alc = edificio_alcance[index]
				draw_set_color(c_white)
				draw_circle_off(edificio.center_x, edificio.center_y, alc, true)
				if index = id_mortero
					draw_circle_off(edificio.center_x, edificio.center_y, 100, true)
				if edificio.target != null_dron
					draw_sprite_off(spr_target, 0, edificio.target.a, edificio.target.b)
				if info{
					draw_set_alpha(0.3)
					for(var a = array_length(edificio.target_chunks) - 1; a >= 0; a--){
						var temp_coord = edificio.target_chunks[a]
						var temp_coord_2 = abtoxy(chunk_width * (temp_coord[0] + 1), chunk_height * (temp_coord[1] + 1))
						temp_coord = abtoxy(chunk_width * temp_coord[0], chunk_height * temp_coord[1])
						draw_rectangle_off(temp_coord[0], temp_coord[1], temp_coord_2[0], temp_coord_2[1], false)
					}
					draw_set_color(c_red)
					var temp_coord = abtoxy(chunk_width * edificio.chunk_x, chunk_height * edificio.chunk_y)
					draw_rectangle_off(temp_coord[0], temp_coord[1], temp_coord[0] + chunk_width * 48, temp_coord[1] + chunk_height * 14, false)
					draw_set_alpha(1)
				}
			}
			//Mostrar rutas de tuneles
			if in(index, id_tunel, id_tunel_salida){
				if keyboard_check_pressed(CONTROL_ROTAR) and edificio.link != null_edificio{
					keyboard_clear(CONTROL_ROTAR)
					if edificio.index = 16{
						edificio.index = 6
						edificio.link.index = 16
						calcular_inputs_outputs(edificio)
						calcular_inputs_outputs(edificio.link)
						calcular_edificios_adyascentes(edificio)
						calcular_edificios_adyascentes(edificio.link)
						array_push(edificio.outputs, edificio.link)
						array_push(edificio.link.inputs, edificio)
					}
					else{
						edificio.index = 16
						edificio.link.index = 6
						calcular_inputs_outputs(edificio)
						calcular_inputs_outputs(edificio.link)
						calcular_edificios_adyascentes(edificio)
						calcular_edificios_adyascentes(edificio.link)
						array_push(edificio.inputs, edificio.link)
						array_push(edificio.link.outputs, edificio)
					}
					set_camino_dir(edificio)
					set_camino_dir(edificio.link)
				}
			}
			else if tag_dron_encima[index]{
				if in(index, id_fabrica_de_drones, id_fabrica_de_drones_grande) and edificio.select >= 0{
					temp_text += $"{L.game_creando_dron} {dron_nombre[edificio.select]} ({array_length(drones_aliados)}/{8 + 2 * nucleo.modulo})\n"
					for(var a = 0; a < array_length(dron_precio_id[edificio.select]); a++)
						temp_text += $"  {recurso_nombre[dron_precio_id[edificio.select, a]]} {edificio.carga[dron_precio_id[edificio.select, a]]}/{dron_precio_num[edificio.select, a]}\n"
					if edificio.proceso > 0
						temp_text += $"  {L.game_creando_dron} {floor(100 * edificio.proceso / dron_time[edificio.select])}%\n"
					else if array_length(drones_aliados) = 8 + 2 * nucleo.modulo
						temp_text += $"  {L.game_limite_dron} ({array_length(drones_aliados)}/{8 + 2 * nucleo.modulo})\n"
				}
				else if index = id_planta_de_reciclaje{
					draw_set_color(c_lime)
					draw_circle_off(edificio.center_x, edificio.center_y, 250, true)
					if edificio.select >= 0{
						if edificio.mode
							temp_text += $"{L.almacen_consumiendo} {edificio_nombre[edificio.select]}: {floor(100 * edificio.proceso / max(5, 5 * edificio_precio[edificio.select]))}%\n"
						else
							temp_text += $"{L.almacen_consumiendo} {dron_nombre[edificio.select]}: {floor(100 * edificio.proceso / dron_time[edificio.select])}%\n"
					}
				}
				draw_set_color(c_blue)
				for(var a = array_length(edificio.inputs_carga) - 1; a >= 0; a--){
					var temp_edificio = edificio.inputs_carga[a]
					draw_arrow_off(temp_edificio.center_x, temp_edificio.center_y, edificio.center_x, edificio.center_y, 10)
				}
				draw_set_color(c_red)
				for(var a = array_length(edificio.outputs_carga) - 1; a >= 0; a--){
					var temp_edificio = edificio.outputs_carga[a]
					draw_arrow_off(edificio.center_x, edificio.center_y, temp_edificio.center_x, temp_edificio.center_y, 10)
				}
			}
			else if index = id_mensaje
				temp_text += $"{edificio.variables[0]}\n"
			else if index = id_tuberia_subterranea and edificio.link != null_edificio{
				draw_set_color(c_blue)
				draw_line_off(edificio.center_x, edificio.center_y, edificio.link.center_x, edificio.link.center_y)
			}
			else if index = id_planta_quimica{
				if edificio.select = -1
					temp_text += $"{L.almacen_sin_receta}\n"
				else
					temp_text += $"{L.almacen_produciendo} {planta_quimica_receta[edificio.select]}\n  {planta_quimica_descripcion[edificio.select]}\n"
			}
			else if index = id_silo_de_misiles{
				var select = edificio.select
				if select != -1{
					if edificio.mode
						temp_text += $"{misiles_nombre[select]} listo\n"
					else
						temp_text += $"Fabricando {misiles_nombre[select]}\n"
					for(var a = 0; a < array_length(misiles_precio_id[select]); a++)
						temp_text += $"  {recurso_nombre[misiles_precio_id[select, a]]}: {edificio.carga[misiles_precio_id[select, a]]}/{misiles_precio_num[select, a]}\n"
					temp_text += $"  {terreno_nombre[idt_petroleo]}: {misiles_petroleo[select] - edificio.array_real[0]}/{misiles_petroleo[select]}\n"
					if edificio.proceso > 0
						temp_text += $"  {floor(100 * edificio.proceso / edificio.array_real[1])}%\n"
				}
			}
			else if index = id_cinta_transportadora
				temp_text += $"{edificio.array_real[4]}\n"
			//Mostrar inputs
			if info and edificio.receptor{
				if edificio_input_all[index]
					temp_text += $"{L.almacen_acepta_todo}\n"
				else{
					var temp_text_2 = ""
					for(var a = 0; a < rss_max; a++)
						if edificio.carga_input[a]
							temp_text_2 += $"  {recurso_nombre[a]}: {edificio.carga_max[a]}\n"
					if temp_text_2 != ""
						temp_text += $"{L.almacen_acepta}:\n{temp_text_2}"
				}
			}
			//Mostrar outputs
			if info and edificio.emisor{
				if edificio_output_all[index]
					temp_text += $"{L.almacen_entrega_todo}\n"
				else{
					var temp_text_2 = ""
					for(var a = 0; a < rss_max; a++)
						if edificio.carga_output[a]
							temp_text_2 += $"  {recurso_nombre[a]}\n"
					if temp_text_2 != ""
						temp_text += $"{L.almacen_entrega}:\n{temp_text_2}"
				}
			}
			//Funcionando al x% de su capacidad
			if edificio_energia[index] or edificio_flujo[index]{
				var capacidad = 0, red = edificio.red, flujo = edificio.flujo
				if edificio_energia[index] and edificio_energia_consumo[index] > 0{
					if flujo.liquido != -1 and edificio_flujo_consumo[index] > 0
						capacidad = min(clamp((red.generacion + red.bateria) / max(red.consumo, 1), 0, 1), clamp((flujo.generacion + flujo.almacen) / max(flujo.consumo, 1), 0, 1))
					else
						capacidad = clamp((red.generacion + red.bateria) / max(red.consumo, 1), 0, 1)
				}
				else
					capacidad = clamp((flujo.generacion + flujo.almacen) / max(flujo.consumo, 1), 0, 1)
				temp_text += $"{L.almacen_funcionando_al} {round(100 * capacidad)}% {L.almacen_de_su_capacidad}\n"
				//Mostrar red electrica
				if edificio_energia[index]{
					var center_x = edificio.center_x, center_y = edificio.center_y
					if edificio_energia_consumo[index] != 0{
						if edificio_energia_consumo[index] > 0
							temp_text += $"  {L.almacen_consumiendo} {edificio.energia_consumo} {L.red_energia}\n"
						else
							temp_text += $"  {L.almacen_produciendo} {abs(edificio.energia_consumo)} {L.red_energia}\n"
					}
					temp_text += $"  {red.promedio > 0 ? L.almacen_produciendo : L.almacen_consumiendo} {round(abs(red.promedio))} {L.red_energia}\n"
					if red.bateria_max > 0
						temp_text += $"  {L.red_bateria}: {round(red.bateria)}/{round(red.bateria_max)}\n"
					if info
						temp_text += red_text(red)
					draw_set_color(c_red)
					for(var a = array_length(edificio.energia_link) - 1; a >= 0; a--){
						var edificio_2 = edificio.energia_link[a]
						draw_line_off(center_x, center_y, edificio_2.center_x, edificio_2.center_y)
					}
				}
				//Mostrar red de líquido
				if edificio_flujo[index]{
					if flujo.liquido = -1
						temp_text += $"{L.flujo_sin_liquido}!\n"
					else{
						if edificio_flujo_consumo[index] > 0
							temp_text += $"  {L.almacen_consumiendo} {round(edificio.flujo_consumo)} {liquido_nombre[flujo.liquido]}\n"
						else
							temp_text += $"  {L.almacen_produciendo} {abs(round(edificio.flujo_consumo))} {liquido_nombre[flujo.liquido]}\n"
						temp_text += $"  {flujo.promedio > 0 ? L.almacen_produciendo : L.almacen_consumiendo} {round(abs(flujo.promedio))} {liquido_nombre[flujo.liquido]}\n"
						if flujo.almacen_max > 0
							temp_text += $"  {L.flujo_almacenado}: {round(flujo.almacen)}/{round(flujo.almacen_max)}\n"
					}
					if info
						temp_text += flujo_text(flujo)
				}
			}
			if info{
				var flag_rss = false
				for(var a = 0; a < rss_max; a++)
					if edificio.carga[a] != 0{
						flag_rss = true
						break
					}
				if flag_rss{
					temp_text += "Almacén"
					for(var a = 0; a < rss_max; a++)
						if edificio.carga[a] != 0
							temp_text += $"  {recurso_nombre[a]}: {edificio.carga[a]}\n"
				}
				if edificio_proceso[index] > 1
					temp_text += $"{L.almacen_proceso}: {floor(edificio.proceso)}/{edificio_proceso[index]}\n"
				temp_text += $"select: {edificio.select}, mode: {edificio.mode}, fuel: {edificio.fuel}, jugador: {edificio.jugador}\n"
				temp_text += $"carga_total: {edificio.carga_total}"
			}
		}
	}
	//Reconstruir edificios
	else if keyboard_check(CONTROL_REPARAR){
		var b = repair_id[# mx, my], temp_text_2 = ""
		if b > 0{
			var comprable = true
			if not cheat
				comprable = check_reconstruible(b).comprable
			if not comprable{
				var temp_complex = abtoxy(mx, my)
				draw_sprite_off(spr_rojo, 0, temp_complex[0], temp_complex[1],,,,, 0.5)
				draw_text_background_off(temp_complex[0] + 20, temp_complex[1], temp_text_2)
			}
			else if mouse_check_button(mb_left){
				var temp_edificio = construir(b, repair_dir[# mx, my], mx, my)
				if tag_edificio_seteable[b]
					set_edificio(repair_mode[# mx, my], repair_select[# mx, my], temp_edificio)
			}
			if mouse_check_button(mb_right)
				ds_grid_set(repair_id, mx, my, -1)
		}
	}
	//Seleccionar drones
	else if devise and mouse_check_button_pressed(mb_left) and build_index = 0{
		mx_clic = xmouse
		my_clic = ymouse
		clicked = true
	}
	if devise and mouse_check_button(mb_left) and clicked and build_index = 0 and not keyboard_check(CONTROL_REPARAR){
		draw_set_alpha(0.5)
		draw_set_color(c_black)
		draw_rectangle_off(mx_clic, my_clic, xmouse, ymouse, false)
		draw_set_color(c_white)
		var minx = min(mx_clic, xmouse), miny = min(my_clic, ymouse), maxx = max(mx_clic, xmouse), maxy = max(my_clic, ymouse)
		for(var a = array_length(drones_aliados) - 1; a >= 0; a--){
			var dron = drones_aliados[a]
			if in(dron.index, idd_kamikaze, idd_helicoptero, idd_bombardero, idd_minero){
				var xx = dron.x, yy = dron.y
				if xx > minx and yy > miny and xx < maxx and yy < maxy
					draw_circle_off(xx, yy, 30, true)
			}
		}
		draw_set_alpha(1)
	}
	if devise and mouse_check_button_released(mb_left) and clicked and build_index = 0{
		deselect_drones()
		var minx = min(mx_clic, xmouse), miny = min(my_clic, ymouse), maxx = max(mx_clic, xmouse), maxy = max(my_clic, ymouse)
		for(var a = array_length(drones_aliados) - 1; a >= 0; a--){
			var dron = drones_aliados[a]
			if in(dron.index, idd_kamikaze, idd_helicoptero, idd_bombardero, idd_minero){
				var xx = dron.x, yy = dron.y
				if xx > minx and yy > miny and xx < maxx and yy < maxy{
					array_push(selected_drones, dron)
					dron.selected = true
				}
			}
		}
		clicked = false
	}
	//Pasar dron
	var chunk_mx = floor(mx / chunk_width), chunk_my = floor(my / chunk_height), min_dis = 900, min_dron = null_dron, temp_array_dron
	var next_chunk_x = ((mx mod chunk_width) > (chunk_width / 2)) ? [0, 1, 0, 1] : [0, -1, 0, -1]
	var next_chunk_y = ((my mod chunk_height) > (chunk_height / 2)) ? [0, 0, 1, 1] : [0, 0, -1, -1]
	if array_length(enemigos) > 0
		for(var i = 0; i < 4; i++){
			var aa = chunk_mx + next_chunk_x[i], bb = chunk_my + next_chunk_y[i]
			if aa < 0 or bb < 0 or aa >= chunk_xsize or bb >= chunk_ysize
				continue
			temp_array_dron = ds_grid_get(chunk_dron_enemigo, aa, bb)
			for(var a = 0; a < array_length(temp_array_dron); a++){
				var dron = temp_array_dron[a], dis = distance_sqr(dron.x, dron.y, xmouse, ymouse)
				if dis < min_dis{
					min_dis = dis
					min_dron = dron
				}
			}
		}
	if array_length(drones_aliados) > 0
		for(var i = 0; i < 4; i++){
			var aa = chunk_mx + next_chunk_x[i], bb = chunk_my + next_chunk_y[i]
			if aa < 0 or bb < 0 or aa >= chunk_xsize or bb >= chunk_ysize
				continue
			temp_array_dron = ds_grid_get(chunk_dron_aliado, aa, bb)
			for(var a = 0; a < array_length(temp_array_dron); a++){
				var dron = temp_array_dron[a], dis = distance_sqr(dron.x, dron.y, xmouse, ymouse)
				if dis < min_dis{
					min_dis = dis
					min_dron = dron
				}
			}
		}
	if min_dis < 900{
		var dron = min_dron
		draw_set_color(c_white)
		draw_circle_off(dron.x, dron.y, 20, true)
		temp_text += $"{dron_nombre[dron.index]}\n"
		temp_text += $"{dron.enemigo ? "ENEMIGO" : "ALIADO"}\n"
		temp_text += $"vida: {dron.vida}/{dron.vida_max}\n"
		var flag_dron = false
		for(var a = 0; a < rss_max; a++)
			if dron.carga[a] > 0{
				flag_dron = true
				break
			}
		if flag_dron{
			temp_text += "Carga:\n"
			for(var a = 0; a < rss_max; a++)
				if dron.carga[a] > 0
					temp_text += $"  {recurso_nombre[a]}: {floor(dron.carga[a])}\n"
		}
		temp_text += $"step: {dron.step}\n"
	}
	draw_text_background(0, 0, temp_text)
}
//Comandar drones
if array_length(selected_drones) > 0{
	var right_clicked = mouse_check_button_pressed(mb_right)
	for(var a = array_length(selected_drones) - 1; a >= 0; a--){
		var dron = selected_drones[a]
		draw_set_color(c_white)
		draw_circle_off(dron.x, dron.y, 30, true)
		if dron.modo = 1 and not dron.index = idd_minero
			draw_sprite_off(spr_target, 0, dron.move_x, dron.move_y)
		if right_clicked and in(dron.index, idd_kamikaze, idd_helicoptero, idd_bombardero, idd_minero){
			mouse_clear(mb_right)
			mover_dron(dron, xmouse, ymouse)
		}
		if dron.index = idd_minero{
			if dron.modo = 1{
				var temp_complex = xytoab(dron.move_x, dron.move_y)
				draw_sprite_off(spr_target, 0, temp_complex[0], temp_complex[1])
			}
			else if dron.target != null_edificio
				draw_sprite_off(spr_target, 0, dron.target.center_x, dron.target.center_y)
			if ore[# mx, my] >= 0
				draw_sprite(spr_minar, ore[# mx, my] = ido_uranio, mouse_x, mouse_y)
		}
		if dron.temp_target != null_dron
			draw_sprite_off(spr_target, 0, dron.temp_target.center_x, dron.temp_target.center_y)
		if dron.target_dron != null_edificio
			draw_sprite_off(spr_target, 0, dron.target_dron.x, dron.target_dron.y)
	}
}
//Seleccionar target edificio
if puerto_carga_bool or (procesador_select != null_edificio) or (misil_set_target != null_edificio){
	draw_set_halign(fa_center)
	if puerto_carga_bool
		var temp_text = L.game_puerto_carga
	else if procesador_select != null_edificio{
		temp_text = L.game_vincular_procesador
		for(var a = 1; a < array_length(procesador_select.procesador_link); a++){
			var temp_edificio = procesador_select.procesador_link[a]
			draw_set_color(c_green)
			draw_arrow_off(procesador_select.center_x, procesador_select.center_y, temp_edificio.center_x, temp_edificio.center_y, 8)
			draw_set_color(c_black)
			draw_text_off((procesador_select.center_x + temp_edificio.center_x) / 2, (procesador_select.center_y + temp_edificio.center_y) / 2, a)
		}
	}
	else if misil_set_target != null_edificio
		temp_text = L.marcar_objetivo
	draw_text_background(room_width / 2, 100, temp_text)
	draw_set_halign(fa_left)
	if misil_set_target{
		if mouse_check_button_pressed(mb_left){
			misil_set_target.array_real[2] = xmouse
			misil_set_target.array_real[3] = ymouse
			misil_set_target.fuel = 200
		}
		if mouse_check_button_pressed(mb_any){
			mouse_clear(mouse_lastbutton)
			misil_set_target = null_edificio
		}	
	}
	else if mouse_check_button_pressed(mb_any){
		mouse_clear(mouse_lastbutton)
		puerto_carga_bool = false
		procesador_select = null_edificio
	}
}
if sonido
	for(var a = 0; a < SONIDOS_MAX; a++)
		volumen[a] = 0
#region Menú de edificios
	//ANDROID
	if not devise and build_menu = 0 and build_index = 0 and draw_sprite_boton(spr_construir, 0, room_width - 80, room_height - 80, 68, 68){
		build_menu = 1
		menu_x = room_width / 2
		menu_y = room_height / 2
		android_building = false
	}
	var just_pressed = false, _size = devise ? 100 : 200, _size_sqr = devise ? 10_000 : 40_000, _size_sqrx = devise ? 32 : 64, _size_sqry = devise ? 28 : 56
	if devise and mouse_check_button_pressed(mb_right) and build_index = 0 and not edificio_bool[# mx, my] and not keyboard_check(CONTROL_REPARAR) and pausa != 1{
		mouse_clear(mb_right)
		if build_menu = 0{
			build_menu = 1
			menu_x = clamp(mouse_x, 100, room_width - 100)
			menu_y = clamp(mouse_y, 100, room_height - 100)
		}
		else if build_menu = 1
			build_menu = 0
		else
			build_menu = 1
	}
	if build_menu = 1{
		if not devise and draw_sprite_boton(spr_construir, 1, room_width - 80, room_height - 80, 64, 56)
			build_menu = 0
		var b = 2 * pi / array_length(categoria_nombre_disponible)
		draw_set_color(c_white)
		draw_circle(menu_x, menu_y, _size, true)
		if mision_actual >= 0 and in(mision.objetivo, 2, 3){
			var flag = false
			draw_set_color(c_blue)
			draw_set_alpha(0.5)
			for(var a = 0; a < array_length(categoria_index_disponible); a++){
				for(var i = 0; i < array_length(categoria_edificios[categoria_index_disponible[a]]); i++)
					if categoria_edificios[categoria_index_disponible[a], i] = mision.target_id{
						flag = true
						draw_arco(menu_x, menu_y, _size, a * b, (a + 1) * b)
						break
					}
				if flag
					break
			}
			draw_set_color(c_white)
			draw_set_alpha(1)
		}
		draw_circle(menu_x, menu_y, _size / 10, false)
		for(var a = 0; a < array_length(categoria_nombre_disponible); a++){
			var angle = a * b
			draw_sprite_stretched(spr_items, categoria_index_disponible[a], menu_x - 15 + _size * cos(angle + b / 2), menu_y - 15 - _size * sin(angle + b / 2), _size_sqrx, _size_sqry)
			draw_line(menu_x, menu_y, menu_x + _size * cos(angle), menu_y - _size * sin(angle))
		}
		if distance_sqr(mouse_x, mouse_y, menu_x, menu_y) < _size_sqr{//100^2
			var temp_text = ""
			var a = floor((array_length(categoria_nombre_disponible) - arctan2(mouse_y - menu_y, mouse_x - menu_x) / b) mod array_length(categoria_nombre_disponible))
			draw_set_alpha(0.5)
			draw_arco(menu_x, menu_y, _size, a * b, (a + 1) * b)
			draw_set_alpha(1)
			draw_sprite_stretched(spr_items, categoria_index_disponible[a], menu_x - 15 + _size * cos((a + 0.5) * b), menu_y - 15 - _size * sin((a + 0.5) * b), _size_sqrx, _size_sqry)
			if devise{
				temp_text = categoria_nombre[categoria_index_disponible[a]]
				draw_text_background(min(room_width - string_width(temp_text), mouse_x + 20), min(room_height - string_height(temp_text), mouse_y), temp_text)
			}
			if mouse_check_button_pressed(mb_left){
				mouse_clear(mb_left)
				build_menu = 2
				menu_array = categoria_edificios_disponible[categoria_index_disponible[a]]
			}
		}
		else if devise and mouse_check_button_pressed(mb_left){
			mouse_clear(mb_left)
			build_menu = 0
		}
	}
	else if build_menu = 2{
		if not devise and draw_sprite_boton(spr_construir, 1, room_width - 80, room_height - 80, 64, 56)
			build_menu = 1
		var b = 2 * pi / array_length(menu_array)
		draw_set_color(c_white)
		draw_circle(menu_x, menu_y, _size, true)
		for(var a = 0; a < array_length(menu_array); a++){
			var angle = a * b, comprable = true, index = menu_array[a]
			draw_line(menu_x, menu_y, menu_x + _size * cos(angle), menu_y - _size * sin(angle))
			if not cheat{
				comprable = edificio_tecnologia[index] or not tecnologia
				if comprable
					comprable = is_comprable(edificio_precio_id[index], edificio_precio_num[index])
				if not comprable{
					draw_set_alpha(0.5)
					draw_set_color(c_red)
					draw_arco(menu_x, menu_y, _size, angle, angle + b)
					draw_set_alpha(1)
					draw_set_color(c_white)
				}
			}
			draw_sprite_stretched(edificio_sprite[index], 0, menu_x - 15 + _size * cos(angle + b / 2), menu_y - 15 - _size * sin(angle + b / 2), _size_sqrx, _size_sqry)
		}
		draw_circle(menu_x, menu_y, 10, false)
		if distance_sqr(mouse_x, mouse_y, menu_x, menu_y) < _size_sqr{//100^2
			var a = floor((array_length(menu_array) - arctan2(mouse_y - menu_y, mouse_x - menu_x) / b) mod array_length(menu_array))
			draw_set_alpha(0.5)
			draw_arco(menu_x, menu_y, _size, a * b, (a + 1) * b)
			draw_set_alpha(1)
			draw_sprite_stretched(edificio_sprite[menu_array[a]], 0, menu_x - 15 + _size * cos((a + 0.5) * b), menu_y - 15 - _size * sin((a + 0.5) * b), _size_sqrx, _size_sqry)
			a = menu_array[a]
			if devise{
				var temp_text = $"{edificio_nombre[a]} (hotkey: {edificio_key[a]})\n"
				if not cheat{
					if tecnologia and not edificio_tecnologia[a]
						temp_text += "  Falta Tecnología\n"
					for(var c = 0; c < array_length(edificio_precio_id[a]); c++)
						temp_text += $"  {recurso_nombre[edificio_precio_id[a, c]]}: {edificio_precio_num[a, c]}\n"
				}
				temp_text += $"{edificio_descripcion[a]}\n"
				draw_text_background(min(room_width - string_width(temp_text), mouse_x + 20), min(room_height - string_height(temp_text), mouse_y), temp_text)
			}
			if mouse_check_button_pressed(mb_left){
				mouse_clear(mb_left)
				build_menu = 0
				if tecnologia and not cheat and not edificio_tecnologia[a]{
					enciclopedia_item = a
					enciclopedia = 4
				}
				else{
					build_index = a
					just_pressed = true
					prev_change = true
					clicked = false
					android_clic = false
				}
			}
		}
		else if devise and mouse_check_button_pressed(mb_left){
			mouse_clear(mb_left)
			build_menu = 1
		}
	}
#endregion
//Acceso directo
if keyboard_check_pressed(vk_anykey) and (not in(keyboard_lastchar, CONTROL_LEFT, CONTROL_RIGHT, CONTROL_UP, CONTROL_DOWN, " ") or cheat) and win = 0 and not show_menu{
	for(var a = 1; a < edificio_max; a++)
		if edificio_key[a] != "" and string_ends_with(keyboard_string, edificio_key[a]){
			if tecnologia and not cheat and not edificio_tecnologia[a]{
				enciclopedia_item = a
				enciclopedia = 4
			}
			else
				build_index = a
			selected_dron = null_dron
			keyboard_string = ""
			build_menu = 0
			just_pressed = true
			deselect_drones()
			clicked = false
			prev_change = true
		}
	keyboard_step = 30
}
if keyboard_step-- = 0 and not show_menu
	keyboard_string = ""
//Cancelar construcción o cerrar menú del selector
if devise and (mouse_check_button_pressed(mb_right) or keyboard_check_pressed(vk_escape)) and (build_index > 0 or show_menu) and selected_dron = null_dron{
	mouse_clear(mb_right)
	keyboard_clear(vk_escape)
	clear_edit()
}
//CONSTRUCCIÓN
if build_index > 0 and win = 0{
	var construible = true
	if just_pressed{
		if not edificio_rotable[build_index]
			build_dir = 0
		if edificio_size[build_index] mod 2 = 0
			build_dir = 5 * (build_dir mod 2)
	}
	if devise{
		temp_mx = mx
		temp_my = my
		if (edificio_rotable[build_index] or edificio_size[build_index] mod 2 = 0) and not keyboard_check(vk_lcontrol){
			if mouse_wheel_up() or (not keyboard_check(vk_lshift) and keyboard_check_pressed(CONTROL_ROTAR)){
				keyboard_clear(CONTROL_ROTAR)
				if not edificio_rotable[build_index] and edificio_size[build_index] mod 2 = 0
					build_dir = 5 - build_dir
				else
					build_dir = (build_dir + 1) mod 6
				prev_change = true
			}
			if mouse_wheel_down() or (keyboard_check(vk_lshift) and keyboard_check_pressed(CONTROL_ROTAR)){
				keyboard_clear(CONTROL_ROTAR)
				if not edificio_rotable[build_index] and edificio_size[build_index] mod 2 = 0
					build_dir = 5 - build_dir
				else
					build_dir = (build_dir + 5) mod 6
				prev_change = true
			}
		}
	}
	//ANDROID
	else{
		var xpos = room_width - 80
		if draw_sprite_boton(spr_construir, 1, xpos, room_height - 80, 64, 56){
			build_index = 0
			clicked = false
		}
		xpos -= 80
		if draw_sprite_boton(spr_construir, 2, xpos, room_height - 80, 64, 56){
			construir(build_index, build_dir, mx_clic, my_clic)
			clicked = false
			android_clic = false
		}
		xpos -= 80
		if (edificio_rotable[build_index] or edificio_size[build_index] & 1 = 0){
			if draw_sprite_boton(spr_construir, 3, xpos, room_height - 80, 64, 56){
				if edificio_size[build_index] & 1
					build_dir = (build_dir + 1) mod 6
				else
					build_dir = 5 - build_dir
				prev_change = true
			}
			xpos -= 80
		}
		if edificio_rotable[build_index]{
			if draw_sprite_boton(spr_construir, 4, xpos, room_height - 80, 64, 56){
				if edificio_size[build_index] & 1
					build_dir = (build_dir + 5) mod 6
				else
					build_dir = 5 - build_dir
				prev_change = true
			}
			xpos -= 80
		}
		if not (mouse_x > xpos - 80 and mouse_y > room_height - 120){
			temp_mx = mx
			temp_my = my
		}
		else
			construible = false
		if mouse_check_button_pressed(mb_left)
			android_building = true
	}
	if last_mx != temp_mx or last_my != temp_my or prev_change{
		build_list = get_size(temp_mx, temp_my, build_dir, edificio_size[build_index])
		if build_index = id_taladro_de_explosion
			build_list_arround = get_size(temp_mx, temp_my, build_dir, edificio_size[build_index] + 2)
		else if in(build_index, id_fabrica_de_drones, id_ensambladora, id_planta_de_reciclaje, id_fabrica_de_drones_grande, id_cinta_grande)
			build_list_arround = get_arround(temp_mx, temp_my, build_dir, edificio_size[build_index])
		else if build_index = id_cable
			build_list_arround = get_size(temp_mx, temp_my, 0, 7)
		show_menu = false
		build_array_edificios_input = array_create(0, null_edificio)
		build_array_edificios_output = array_create(0, null_edificio)
	}
	var comprable = true, temp_text = ""
	//Detectar si el terreno existe
	for(var a = array_length(build_list) - 1; a >= 0; a--){
		var temp_complex_2 = build_list[a], aa = temp_complex_2[0], bb = temp_complex_2[1]
		if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize{
			comprable = false
			break
		}
	}
	if comprable and not outside and not just_pressed{
		//Módulos
		if build_index = id_modulo{
			var temp_complex = abtoxy(temp_mx, temp_my)
			draw_sprite_off(spr_item_modulo, 0, temp_complex[0], temp_complex[1],,,,, 0.5)
			if edificio_bool[# temp_mx, temp_my]{
				var temp_edificio = edificio_id[# temp_mx, temp_my], index = edificio.index, temp_modulo_tier = edificio_modulo_tier[index], flag_2 = true
				if temp_modulo_tier = -1{
					temp_text = L.modulo_edificio_sin_modulo
					flag_2 = false
				}
				if temp_edificio.modulo{
					temp_text = L.modulo_edificio_con_modulo
					flag_2 = false
				}
				if flag_2 and temp_edificio.enemigo = build_enemigo{
					#region Efectos
						//Más extracción
						if in(index, id_taladro, id_taladro_electrico, id_taladro_de_explosion)
							temp_text = L.modulo_extraccion
						//Mejor canalización
						else if index = id_laser
							temp_text = L.modulo_canalizar
						//Más cadencia de fuego
						else if in(index, id_torre_basica, id_rifle, id_mortero)
							temp_text = L.modulo_cadencia
						//Más daño
						else if index = id_lanzallamas
							temp_text = L.modulo_dmg
						//Aturdir
						else if index = id_onda_de_choque
							temp_text = L.modulo_aturdir
						//Más producción líquido
						else if index = id_bomba_hidraulica
							temp_text = $"{L.modulo_mas_liquido} {liquido_nombre[temp_edificio.fuel]}\n"
						//Menos consumo electricidad
						else if in(index, id_ensambladora, id_perforadora_de_petroleo, id_refineria_de_petroleo)
							temp_text = L.modulo_menos_electricidad
						//Menos consumo líquido
						else if in(index, id_fabrica_de_concreto, id_generador_geotermico, id_turbina)
							temp_text = $"{L.modulo_menos_liquido} {liquido_nombre[0]}\n"
						//Velocidad
						else if in(index, id_fabrica_de_drones, id_fabrica_de_drones_grande, id_planta_de_reciclaje, id_planta_de_enriquecimiento, id_planta_quimica, id_refineria_de_metales, id_triturador)
							temp_text = L.modulo_produccion
						//Más producción de sal
						else if index = id_planta_desalinizadora
							temp_text = $"{L.modulo_sal} {recurso_nombre[idr_sal]}\n"
						//Evitar desastres nucleares
						else if index = id_planta_nuclear
							temp_text = L.modulo_nuclear
						//Más reparación
						else if index = id_torre_reparadora
							temp_text = L.modulo_reparadora
						//Más drones máximos
						else if index = id_nucleo
							temp_text = L.modulo_nucleo
					#endregion
					if flag_2{
						if not cheat 
							for(var a = array_length(modulo_precio_id[temp_modulo_tier]) - 1; a >= 0; a--){
								temp_text += $"  {recurso_nombre[modulo_precio_id[temp_modulo_tier, a]]}: {modulo_precio_num[temp_modulo_tier, a]}\n"
								if flag_2 and jugador_recursos[0, modulo_precio_id[temp_modulo_tier, a]] < modulo_precio_num[temp_modulo_tier, a]
									flag_2 = false
							}
						if not flag_2
							temp_text += $"{L.construir_recursos_insuficientes}\n"
						else if (devise and mouse_check_button_pressed(mb_left)) or (not devise and mouse_check_button_released(mb_left)){
							add_modulo(temp_edificio)
							mouse_clear(mb_left)
						}
					}
				}
			}
			else
				temp_text = L.modulo_sin_edificio
			draw_text_background(min(room_width - string_width(temp_text), mouse_x + 20), min(room_height - string_height(temp_text), mouse_y), temp_text)
		}
		//Edificios
		else{
			//Detectar recursos y enemigos cerca
			if not cheat{
				for(var a = array_length(edificio_precio_id[build_index]) - 1; a >= 0; a--)
					if jugador_recursos[0, edificio_precio_id[build_index, a]] < edificio_precio_num[build_index, a]{
						comprable = false
						temp_text += $"  {recurso_nombre[edificio_precio_id[build_index, a]]} {jugador_recursos[0, edificio_precio_id[build_index, a]]}/{edificio_precio_num[build_index, a]}\n"
					}
				if not comprable
					temp_text = $"{L.construir_recursos_insuficientes}\n" + temp_text
				draw_set_color(c_red)
				var flag_3 = false
				for(var a = array_length(enemigos) - 1; a >= 0; a--){
					var enemigo = enemigos[a]
					draw_circle_off(enemigo.x, enemigo.y, 100, true)
					if not flag_3 and distance_sqr(mouse_x, mouse_y, enemigo.x * zoom - camx, enemigo.y * zoom - camy) < 10000 * sqr(zoom){//100^2
						temp_text += $"{L.construir_enemigos_cerca}\n"
						comprable = false
						flag_3 = true
					}
				}
				draw_set_color(c_white)
			}
			draw_set_color(c_red)
			var temp_complex = abtoxy(spawn_x, spawn_y), aaa = temp_complex[0], bbb = temp_complex[1]
			draw_circle_off(aaa, bbb, 250, true)
			if distance_sqr(mouse_x, mouse_y, aaa * zoom - camx, bbb * zoom - camy) < 62500 * sqr(zoom){//(250 * zoom)^2
				temp_text += $"{L.construir_zona_enemigos}\n"
				comprable = false
			}
			for(var a = array_length(build_list) - 1; a >= 0; a--){
				var temp_complex_2 = build_list[a], aa = temp_complex_2[0], bb =  temp_complex_2[1]
				if terreno[# aa, bb] = idt_hielo and edificio_size[build_index] > 1 and build_index != id_extractor_atmosferico{
					temp_text += $"{L.construir_terreno_hielo}\n"
					comprable = false
					break
				}
				if terreno_pared[terreno[# aa, bb]]{
					temp_text += $"{L.construir_terreno_invalido}\n"
					comprable = false
					break
				}
			}
			//Detectar que no esté en terreno prohíbido
			if not in(build_index, id_tuberia, id_bomba_de_evaporacion, id_bomba_hidraulica, id_generador_geotermico)
				for(var a = array_length(build_list) - 1; a >= 0; a--){
					var temp_complex_2 = build_list[a], aa = temp_complex_2[0], bb = temp_complex_2[1]
					if terreno_liquido[terreno[# aa, bb]]{
						temp_text += $"{L.construir_terreno_invalido}\n"
						comprable = false
						break
					}
				}
			if build_index = id_bomba_de_evaporacion
				for(var a = array_length(build_list) - 1; a >= 0; a--){
					var temp_complex_2 = build_list[a], aa = temp_complex_2[0], bb = temp_complex_2[1]
					if in(terreno[# aa, bb], idt_agua_profunda, idt_agua_salada_profunda){
						temp_text += $"{L.construir_terreno_invalido}\n"
						comprable = false
						break
					}
				}
			//Detectar que las bombas tengan líquidos
			if build_index = id_bomba_hidraulica{
				var flag = false
				var liquido = -1, count = 0
				for(var a = array_length(build_list) - 1; a >= 0; a--){
					var temp_complex_2 = build_list[a], aa = temp_complex_2[0], bb = temp_complex_2[1]
					if terreno_liquido[terreno[# aa, bb]]{
						flag = true
						if in(terreno[# aa, bb], idt_agua, idt_agua_profunda){
							if not in(liquido, -1, 0){
								flag = false
								temp_text += $"{L.construir_combinar_liquidos}\n"
								break
							}
							count++
							if terreno[# aa, bb] = idt_agua_profunda
								count += 0.2
							liquido = 0
						}
						else if terreno[# aa, bb] = idt_petroleo{
							if not in(liquido, -1, 2){
								flag = false
								temp_text += $"{L.construir_combinar_liquidos}\n"
								break
							}
							count++
							liquido = 2
						}
						else if terreno[# aa, bb] = idt_lava{
							if not in(liquido, -1, 3){
								flag = false
								temp_text += $"{L.construir_combinar_liquidos}\n"
								break
							}
							count++
							liquido = 3
						}
						else if tag_agua_salada[terreno[# aa, bb]]{
							if not in(liquido, -1, 4){
								flag = false
								temp_text += $"{L.construir_combinar_liquidos}\n"
								break
							}
							count++
							if terreno[# aa, bb] = idt_agua_salada_profunda
								count += 0.2
							liquido = 4
						}
					}
				}
				if not flag{
					comprable = false
					temp_text += $"{L.construir_sobre_agua_lava}\n"
				}
				else{
					temp_text += $"{L.game_producira} {round(abs(edificio_flujo_consumo[build_index]) * count / 3)} {liquido_nombre[liquido]}/s\n"
				}
			}
			else if build_index = id_generador_geotermico{
				var i = 0
				for(var a = array_length(build_list) - 1; a >= 0; a--){
					var temp_complex_2 = build_list[a], aa = temp_complex_2[0], bb = temp_complex_2[1]
					i += (terreno[# aa, bb] = idt_lava)
				}
				if i = 0{
					comprable = false
					temp_text += $"{L.construir_sobre_lava}\n"
				}
				else
					temp_text += $"{L.game_producira} {abs(edificio_energia_consumo[build_index]) * i / 3} {L.red_energia}/s"
			}
			else if build_index = id_bomba_de_evaporacion{
				var flag = false
				for(var a = array_length(build_list) - 1; a >= 0; a--){
					var temp_complex_2 = build_list[a], aa = temp_complex_2[0], bb = temp_complex_2[1]
					if tag_agua[terreno[# aa, bb]]{
						flag = true
						break
					}
				}
				if not flag{
					comprable = false
					temp_text += $"{L.construir_sobre_agua}\n"
				}
			}
			else if build_index = id_extractor_atmosferico{
				var i = 0
				for(var a = array_length(build_list) - 1; a >= 0; a--){
					var temp_complex_2 = build_list[a], aa = temp_complex_2[0], bb = temp_complex_2[1], b = terreno[# aa, bb]
					if b = idt_hielo
						i += 1.5
					else if b = idt_nieve
						i += 1.3
					else if b != idt_salar
						i++
				}
				if i = 0{
					comprable = false
					temp_text += $"{L.construir_sobre_salar}\n"
				}
				else
					temp_text += $"{L.game_producira} {abs(edificio_flujo_consumo[build_index]) * i} {liquido_nombre[0]}/s"
			}
			//Detectar que los taladros tengan recursos
			if in(build_index, id_taladro, id_taladro_electrico){
				var temp_array = array_create(rss_max, 0), temp_array_2 = array_create(rss_max, 0), b = 0, u = 0.85, flag = false
				//Buscar minerales superficiales
				for(var a = array_length(build_list) - 1; a >= 0; a--){
					var temp_complex_2 = build_list[a], aa = temp_complex_2[0], bb = temp_complex_2[1]
					if in(ore[# aa, bb], 0, 1, 2){
						temp_array[ore_recurso[ore[# aa, bb]]]++
						temp_array_2[ore_recurso[ore[# aa, bb]]] += ore_amount[# aa, bb]
						b++
						flag = true
						u += 0.05
					}
				}
				//Buscar piedra o arena
				if build_index = id_taladro_electrico{
					for(var a = array_length(build_list) - 1; a >= 0; a--){
						var temp_complex_2 = build_list[a], aa = temp_complex_2[0], bb = temp_complex_2[1]
						if terreno_recurso_bool[terreno[# aa, bb]]{
							u += 0.05
							if not in(ore[# aa, bb], 0, 1, 2){
								temp_array[terreno_recurso_id[terreno[# aa, bb]]]++
								temp_array_2[terreno_recurso_id[terreno[# aa, bb]]] = -1
								b++
								flag = true
							}
						}
					}
				}
				if not flag{
					comprable = false
					if build_index = id_taladro
						temp_text += L.construir_sobre_minerales
					else if build_index = id_taladro_electrico
						temp_text += L.construir_sobre_minerales_piedra
				}
				//Escribir porcentajes de recursos
				else{
					temp_text += $"{u * 60 / edificio_proceso[build_index]}/s\n"
					for(var a = 0; a < rss_max; a++){
						if temp_array_2[a] > 0
							temp_text += $"{recurso_nombre[a]}: {temp_array_2[a]}({round(temp_array[a] * 100 / b)}%)\n"
						else if temp_array_2[a] = -1
							temp_text += $"{recurso_nombre[a]}({round(temp_array[a] * 100 / b)}%)\n"
					}
				}
			}
			//Taladros de Explosión
			if build_index = id_taladro_de_explosion{
				var temp_array = array_create(rss_max, 0), temp_array_2 = array_create(rss_max, 0), flag = false
				for(var a = array_length(build_list_arround) - 1; a >= 0; a--){
					var temp_complex_2 = build_list_arround[a], aa = temp_complex_2[0], bb = temp_complex_2[1]
					if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
						continue
					var temp_complex_3 = abtoxy(aa, bb)
					draw_sprite_off(spr_blanco, 0, temp_complex_3[0], temp_complex_3[1],,,,, 0.5)
					if ore[# aa, bb] >= 0{
						temp_array[ore_recurso[ore[# aa, bb]]]++
						temp_array_2[ore_recurso[ore[# aa, bb]]] += ore_amount[# aa, bb]
						flag = true
					}
					else if terreno_recurso_bool[terreno[# aa, bb]]{
						temp_array[terreno_recurso_id[terreno[# aa, bb]]]++
						temp_array_2[terreno_recurso_id[terreno[# aa, bb]]] = -1
						flag = true
					}
				}
				if not flag{
					comprable = false
					temp_text += L.construir_sobre_minerales_piedra
				}
				else for(var a = 0; a < rss_max; a++){
					if temp_array_2[a] > 0
						temp_text += $"{recurso_nombre[a]}: {temp_array_2[a]} ({temp_array[a] / 5}/s)\n"
					else if temp_array_2[a] = -1
						temp_text += $"{recurso_nombre[a]} ({temp_array[a] / 5}/s)\n"
				}
			}
			//Detectar que no haya otros edificios debajo
			if edificio_camino[build_index] or in(build_index, id_tunel, id_tunel_salida, id_cruce){
				for(var a = array_length(build_list) - 1; a >= 0; a--){
					var temp_complex_2 = build_list[a], aa = temp_complex_2[0], bb = temp_complex_2[1]
					if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
						continue
					if edificio_bool[# aa, bb]{
						var temp_edificio = edificio_id[# aa, bb]
						if not (edificio_camino[temp_edificio.index] or temp_edificio.index = id_cruce){
							temp_text += $"{L.construir_ocupado}\n"
							comprable = false
							break
						}
					}
				}
			}
			else for(var a = array_length(build_list) - 1; a >= 0; a--){
				var temp_complex_2 = build_list[a], aa  = temp_complex_2[0], bb = temp_complex_2[1]
				if edificio_bool[# aa, bb]{
					temp_text += $"{L.construir_ocupado}\n"
					comprable = false
					break
				}
			}
			//No se puede construir
			if not comprable{
				var temp_complex_2 = abtoxy(temp_mx, temp_my)
				draw_edificio(temp_complex_2[0], temp_complex_2[1], build_index, build_dir, 0.5)
				for(var a = array_length(build_list) - 1; a >= 0; a--){
					temp_complex_2 = build_list[a]
					var temp_complex_3 = abtoxy(temp_complex_2[0], temp_complex_2[1])
					draw_sprite_off(spr_rojo, 0, temp_complex_3[0], temp_complex_3[1],,,,, 0.5)
				}
				draw_text_background(min(room_width - string_width(temp_text), mouse_x + 20), min(room_height - string_height(temp_text), mouse_y), temp_text)
			}
			//Sí se puede construir
			else{
				temp_complex = abtoxy(temp_mx, temp_my)
				if not (mouse_check_button(mb_left) and (edificio_camino[build_index] or build_index = id_tuberia)) and not (not devise and clicked and (edificio_camino[build_index] or in(build_index, id_tuberia, id_muro)))
					draw_edificio(temp_complex[0], temp_complex[1], build_index, build_dir, 0.5)
				var temp_array, temp_array_2, flag_camino = true
				//Vista previa caminos
				if edificio_camino[build_index] or in(build_index, id_tuberia, id_muro){
					//WINDOWS
					if devise{
						//Iniciar arrastre
						if mouse_check_button_pressed(mb_left){
							mx_clic = temp_mx
							my_clic = temp_my
							clicked = true
						}
						//Arrastre
						if mouse_check_button(mb_left) and construible{
							pre_build_list = [[mx_clic, my_clic]]
							pre_build_list_cruce = [false]
							var temp_complex_2 = abtoxy(mx_clic, my_clic), aa = temp_complex_2[0], bb = temp_complex_2[1]
							draw_edificio(aa, bb, build_index, build_dir, 0.5)
							if mx_clic != temp_mx or my_clic != temp_my{
								var angle = radtodeg((arctan2(bb * zoom - camy - mouse_y, mouse_x - aa * zoom + camx) + 2 * pi) mod (2 * pi))
								if (last_mx != temp_mx or last_my != temp_my) and edificio_camino[build_index]
									build_dir = floor(angle / 60)
								build_dir_camino = floor(angle / 60)
								var a = mx_clic, b = my_clic, temp_complex_3, _mina = max(xmouse, aa, 0), _minb = max(ymouse, bb, 0), _maxa = min(xmouse, aa, 48 * xsize), _maxb = min(ymouse, bb, 14 * ysize)
								do{
									temp_complex_3 = next_to(a, b, build_dir_camino)
									array_push(pre_build_list, temp_complex_3)
									a = temp_complex_3[0]
									b = temp_complex_3[1]
									temp_complex_3 = abtoxy(a, b)
									aaa = temp_complex_3[0]
									bbb = temp_complex_3[1]
									if in(build_index, id_cinta_transportadora, id_cinta_magnetica) and (a != temp_mx or b != temp_my) and (a != mx_clic or b != my_clic) and edificio_bool[# a, b] and not in(edificio_id[# a, b].dir, build_dir, (build_dir + 3) mod 6) and in(edificio_id[# a, b].index, id_cinta_transportadora, id_cinta_magnetica){
										draw_edificio(aaa, bbb, id_cruce, 0, 0.5)
										array_push(pre_build_list_cruce, true)
									}
									else{
										draw_edificio(aaa, bbb, build_index, build_dir, 0.5)
										array_push(pre_build_list_cruce, false)
									}
								}
								until(temp_complex_3[0] < _maxa or temp_complex_3[0] > _mina or temp_complex_3[1] < _maxb or temp_complex_3[1] > _minb)
							}
						}
						//Mostrar caminos solos
						else{
							temp_complex = next_to(temp_mx, temp_my, build_dir)
							var temp_complex_2 = abtoxy(temp_mx, temp_my), aa = temp_complex_2[0], bb = temp_complex_2[1]
							var temp_complex_3 = abtoxy(temp_complex[0], temp_complex[1])
							if not in(build_index, id_tuberia, id_muro){
								draw_set_color(c_black)
								draw_arrow_off(aa, bb, temp_complex_3[0], temp_complex_3[1], 8)
							}
							if in(build_index, id_enrutador, id_selector, id_overflow){
								temp_complex = next_to(temp_mx, temp_my, (build_dir + 1) mod 6)
								temp_complex_3 = abtoxy(temp_complex[0], temp_complex[1])
								draw_arrow_off(aa, bb, temp_complex_3[0], temp_complex_3[1], 8)
								temp_complex = next_to(temp_mx, temp_my, (build_dir + 5) mod 6)
								temp_complex_3 = abtoxy(temp_complex[0], temp_complex[1])
								draw_arrow_off(aa, bb, temp_complex_3[0], temp_complex_3[1], 8)
							}
						}
						//Construir en cadena
						if mouse_check_button_released(mb_left) and clicked and construible{
							flag_camino = false
							clicked = false
							for(var a = 0; a < array_length(pre_build_list); a++){
								comprable = true
								if not cheat
									comprable = is_comprable(edificio_precio_id[build_index], edificio_precio_num[build_index])
								if in(build_index, id_tuberia, id_muro)
									build_dir = 0
								if comprable{
									var temp_complex_2 = pre_build_list[a]
									if edificio_camino[build_index] and pre_build_list_cruce[a]
										construir(id_cruce, 0, temp_complex_2[0], temp_complex_2[1], build_enemigo)
									else
										construir(build_index, build_dir, temp_complex_2[0], temp_complex_2[1], build_enemigo)
								}
							}
						}
					}
					//Android
					else{
						//Confirmar
						if clicked{
							if mouse_check_button_released(mb_left) and distance(mouse_x, mouse_y, android_mouse_x, android_mouse_y) < 10{
								for(var i = array_length(pre_build_list) - 1; i >= 0; i--){
									var temp_complex2 = pre_build_list[i]
									if mx = temp_complex2[0] and my = temp_complex2[1]{
										build_dir = temp_complex2[2]
										var j = temp_complex2[3] + 1
										var a = mx_clic, b = my_clic
										for(var k = 0; k <= j; k++){
											if edificio_bool[# a, b] and edificio_camino[edificio_id[# a, b].index] and edificio_id[# a, b].dir mod 3 != build_dir mod 3
												construir(id_cruce, build_dir, a, b, build_enemigo)
											else
												construir(build_index, build_dir, a, b, build_enemigo)
											a += DESFACE[b & 1][build_dir, 0]
											b += DESFACE[b & 1][build_dir, 1]
										}
										clicked = false
										android_clic = false
										break
									}
								}
							}
							//Dibujo
							for(var i = array_length(pre_build_list) - 1; i >= 0; i--){
								var temp_complex2 = pre_build_list[i]
								var temp_complex3 = abtoxy(temp_complex2[0], temp_complex2[1])
								var j = temp_complex2[4] ? id_cruce : build_index
								if not is_comprable(edificio_precio_id[j], edificio_precio_num[j]) or not edificio_tecnologia[j] or not mision_edificios[j]
									draw_sprite_off(spr_rojo, 0, temp_complex3[0], temp_complex3[1],,,,, 0.3)
								draw_edificio(temp_complex3[0], temp_complex3[1], j, temp_complex2[2], 0.3)
							}
							var temp_complex3 = abtoxy(mx_clic, my_clic)
							draw_edificio(temp_complex3[0], temp_complex3[1], build_index, build_dir, 0.5)
						}
						//Iniciar
						else if mouse_check_button_released(mb_left) and android_clic and distance(mouse_x, mouse_y, android_mouse_x, android_mouse_y) < 10{
							mx_clic = mx
							my_clic = my
							clicked = true
							pre_build_list = array_create(0, array_create(4, 0))
							for(var i = 0; i < 6; i++){
								var a = mx_clic, b = my_clic
								for(var j = 0; j < 10; j++){
									a += DESFACE[b & 1][i, 0]
									b += DESFACE[b & 1][i, 1]
									if a < 0 or b < 0 or a >= xsize or b >= ysize
										continue
									if not terreno_caminable[terreno[# a, b]]
										break
									if edificio_bool[# a, b]{
										if edificio_camino[edificio_id[# a, b].index]{
											if edificio_id[# a, b].dir mod 3 = i mod 3
												array_push(pre_build_list, [a, b, i, j, 0])
											else
												array_push(pre_build_list, [a, b, i, j, 1])
										}
										else
											break
									}
									else
										array_push(pre_build_list, [a, b, i, j, 0])
								}
							}
						}
					}
				}
				//Cables
				else if build_index = id_cable{
					//Empezar a construir
					if mouse_check_button_pressed(mb_left){
						mx_clic = temp_mx
						my_clic = temp_my
						clicked = true
					}
					//Dibujar nodos cercanos
					var temp_complex_2 = abtoxy(temp_mx, temp_my), aa = temp_complex_2[0], bb = temp_complex_2[1]
					draw_circle_off(aa, bb, 90, true)
					for(var a = array_length(build_list_arround) - 1; a >= 0; a--){
						var temp_complex_3 = build_list_arround[a], aaaa = temp_complex_3[0], bbbb = temp_complex_3[1]
						if aaaa < 0 or bbbb < 0 or aaaa >= xsize or bbbb >= ysize
							continue
						if (aaaa != temp_mx or bbbb != temp_my) and edificio_bool[# aaaa, bbbb]{
							var temp_edificio = edificio_id[# aaaa, bbbb]
							if temp_edificio.enemigo = build_enemigo and edificio_energia[temp_edificio.index] and distance_sqr(aa, bb, temp_edificio.center_x, temp_edificio.center_y) <= 8100//90^2
								draw_line_off(aa, bb, temp_edificio.center_x, temp_edificio.center_y)
						}
					}
					//Extender
					if mouse_check_button(mb_left) and construible{
						pre_build_list = [[mx_clic, my_clic]]
						temp_complex_2 = abtoxy(mx_clic, my_clic)
						aa = temp_complex_2[0]
						bb = temp_complex_2[1]
						var mxc = mx_clic, myc = my_clic
						draw_edificio(aa, bb, build_index, build_dir, 0.5)
						if mx_clic != temp_mx or my_clic != temp_my{
							var temp_complex_3 = abtoxy(temp_mx, temp_my), aaaa = temp_complex_3[0], bbbb = temp_complex_3[1]
							var dir = (360 + point_direction(aa, bb, aaaa, bbbb)) mod 360, dis = point_distance(aa, bb, aaaa, bbbb), flag_2 = false
							for(var a = 0; a < floor(dis / 70); a++){
								repeat(3){
									var temp_complex_4 = next_to(mxc, myc, floor(dir / 60))
									var temp_complex_6 = abtoxy(temp_complex_4[0], temp_complex_4[1])
									var temp_dis = point_distance(temp_complex_6[0], temp_complex_6[1], aaaa, bbbb)
									var temp_complex_5 = next_to(mxc, myc, ceil(dir / 60))
									var temp_complex_7 = abtoxy(temp_complex_5[0], temp_complex_5[1])
									var temp_dis_2 = point_distance(temp_complex_7[0], temp_complex_7[1], aaaa, bbbb)
									if temp_dis > temp_dis_2{
										temp_complex_4 = temp_complex_5
										temp_dis = temp_dis_2
									}
									mxc = temp_complex_4[0]
									myc = temp_complex_4[1]
									if mxc < 0 or myc < 0 or mxc >= xsize or myc >= ysize
										break
									temp_complex_4 = abtoxy(mxc, myc)
									dir = point_direction(temp_complex_4[0], temp_complex_4[1], aaaa, bbbb)
									if temp_dis = 0{
										flag_2 = true
										break
									}
								}
								if mxc < 0 or myc < 0 or mxc >= xsize or myc >= ysize
									break
								array_push(pre_build_list, [mxc, myc])
								temp_complex_3 = abtoxy(mxc, myc)
								draw_edificio(temp_complex_3[0], temp_complex_3[1], build_index, 0, 0.5)
								if edificio_bool[# mxc, myc] or not terreno_caminable[terreno[# mxc, myc]]
									draw_sprite_off(spr_rojo, 0, temp_complex_3[0], temp_complex_3[1],,,,, 0.5)
								if flag_2
									break
							}
							if not (mxc = temp_mx and myc = temp_my)
								array_push(pre_build_list, [temp_mx, temp_my])
							draw_text(mouse_x, mouse_y + 20, temp_text)
						}
					}
					//Construir
					if mouse_check_button_released(mb_left) and clicked and construible{
						flag_camino = false
						clicked = false
						for(var a = 0; a < array_length(pre_build_list); a++){
							comprable = true
							if not cheat
								comprable = is_comprable(edificio_precio_id[build_index], edificio_precio_num[build_index])
							if comprable{
								temp_complex_2 = pre_build_list[a]
								construir(build_index, build_dir, temp_complex_2[0], temp_complex_2[1], build_enemigo)
							}
						}
					}
				}
				//Vista previa no caminos
				else{
					if in(build_index, id_tunel, id_tunel_salida){
						var temp_complex_2 = abtoxy(temp_mx, temp_my), flag_2 = false
						var a = temp_mx, b = temp_my, c = 0
						//Evaluar si es construible
						build_able = false
						repeat(10){
							c++
							a = a + DESFACE[b & 1][build_dir, 0]
							b = b + DESFACE[b & 1][build_dir, 1]
							if a < 0 or b < 0 or a >= xsize or b >= ysize
								break
							if edificio_bool[# a, b]{
								var edificio_2 = edificio_id[# a, b]
								if edificio_2.enemigo = build_enemigo and in(edificio_2.index, id_tunel, id_tunel_salida) and edificio_2.dir = (build_dir + 3) mod 6{
									build_target = edificio_2
									build_able = true
									break
								}
							}
						}
						//Dibujar vista previa
						if build_able{
							a = temp_mx
							b = temp_my
							repeat(c - 1){
								a = a + DESFACE[b & 1][build_dir, 0]
								b = b + DESFACE[b & 1][build_dir, 1]
								temp_complex_2 = abtoxy(a, b)
								draw_sprite_off(spr_tunel_view, 0, temp_complex_2[0], temp_complex_2[1],,, (build_dir - 1) * 60,, 0.5)
							}
						}
					}
					else{
						draw_edificio(temp_complex[0], temp_complex[1], build_index, build_dir, 0.5)
						//Torres de alta tensión
						if build_index = id_torre_de_alta_tension{
							draw_circle_off(temp_complex[0], temp_complex[1], 1_000, true)
							for(var c = array_length(torres_de_tension) - 1; c >= 0; c--){
								var temp_edificio = torres_de_tension[c]
								if distance_sqr(temp_edificio.center_x, temp_edificio.center_y, temp_complex[0], temp_complex[1]) < 1_000_000//1000^2
									draw_line_off(temp_edificio.center_x, temp_edificio.center_y, temp_complex[0],temp_complex[1])
							}
						}
						//Vista previa Alcance de torres
						else if edificio_armas[build_index]{
							draw_circle_off(temp_complex[0], temp_complex[1], edificio_alcance[build_index], true)
							if build_index = id_mortero
								draw_circle_off(temp_complex[0], temp_complex[1], 100, true)
						}
						//Taberías subterraneas
						else if build_index = id_tuberia_subterranea{
							var temp_list = get_size(temp_mx, temp_my, 0, 7), flag = false, temp_edificio = null_edificio
							for(var c = array_length(temp_list) - 1; c >= 0; c--){
								var temp_complex_2 = temp_list[c], aa = temp_complex_2[0], bb = temp_complex_2[1]
								if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
									continue
								if edificio_bool[# aa, bb] and not (aa = temp_mx and bb = temp_my){
									temp_edificio = edificio_id[# aa, bb]
									if temp_edificio.index = build_index and temp_edificio.link = null_edificio and temp_edificio.enemigo = build_enemigo{
										flag = true
										break
									}
								}
							}
							if flag{
								draw_set_color(c_blue)
								draw_line_off(temp_complex[0], temp_complex[1], temp_edificio.center_x, temp_edificio.center_y)
							}
						}
						//Ensambladora
						else if build_index = id_ensambladora{
							if edificio_tecnologia[id_modulo] or not tecnologia{
								for(var a = array_length(build_list_arround) - 1; a >= 0; a--){
									var temp_complex_2 = build_list_arround[a]
									var aa = temp_complex_2[0], bb = temp_complex_2[1]
									if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
										continue
									if edificio_bool[# aa, bb]{
										var temp_edificio = edificio_id[# aa, bb]
										if temp_edificio.index = id_ensambladora and not temp_edificio.mode and temp_edificio.enemigo = build_enemigo{
											draw_set_color(c_blue)
											draw_line_off(temp_complex[0], temp_complex[1], temp_edificio.center_x, temp_edificio.center_y)
											temp_text += "Conectando\n"
											break
										}
									}
								}
							}
						}
						//Drones encima
						else if tag_dron_encima[build_index]{
							if last_mx != temp_mx or last_my != temp_my or prev_change{
								var temp_complex_array = cinta_grande_check(temp_mx, temp_my, build_dir, build_index)
								build_array_edificios_input = temp_complex_array.inputs
								build_array_edificios_output = temp_complex_array.outputs
							}
							draw_set_color(c_red)
							for(var a = array_length(build_array_edificios_input) - 1; a >= 0; a--){
								var temp_edificio = build_array_edificios_input[a]
								draw_arrow_off(temp_edificio.center_x, temp_edificio.center_y, temp_complex[0], temp_complex[1], 10)
							}
							draw_set_color(c_blue)
							for(var a = array_length(build_array_edificios_output) - 1; a >= 0; a--){
								var temp_edificio = build_array_edificios_output[a]
								draw_arrow_off(temp_complex[0], temp_complex[1], temp_edificio.center_x, temp_edificio.center_y, 10)
							}
							if build_index = id_planta_de_reciclaje{
								draw_set_color(c_lime)
								draw_circle_off(temp_complex[0], temp_complex[1], 250, true)
							}
						}
					}
					//Construir
					if ((devise and mouse_check_button_pressed(mb_left)) or (not devise and mouse_check_button_released(mb_left) and android_building and construible and distance(mouse_x, mouse_y, android_mouse_x, android_mouse_y) < 10)) and flag_camino and comprable and (not edificio_bool[# temp_mx, temp_my] or (build_index = id_cruce and edificio_camino[edificio_id[# temp_mx, temp_my].index])){
						android_building = false
						var temp_edificio = construir(build_index, build_dir, temp_mx, temp_my, build_enemigo)
						if temp_edificio != null_edificio and tag_dron_encima[temp_edificio.index]{
							array_copy(temp_edificio.inputs_carga, 0, build_array_edificios_input, 0, array_length(build_array_edificios_input))
							for(var a = array_length(temp_edificio.inputs_carga) - 1; a >= 0; a--){
								var temp_edificio_2 = temp_edificio.inputs_carga[a]
								array_push(temp_edificio_2.outputs_carga, temp_edificio)
								if array_contains(edificios_salida_drones, temp_edificio_2)
									array_remove(edificios_salida_drones, temp_edificio_2)
							}
							array_copy(temp_edificio.outputs_carga, 0, build_array_edificios_output, 0, array_length(build_array_edificios_output))
							for(var a = array_length(temp_edificio.outputs_carga) - 1; a >= 0; a--){
								var temp_edificio_2 = temp_edificio.outputs_carga[a]
								array_push(temp_edificio_2.inputs_carga, temp_edificio)
							}
							if array_length(temp_edificio.outputs_carga) = 0
								array_push(edificios_salida_drones, temp_edificio)
						}
					}
				}
				//Arcos eléctricos
				if edificio_energia[build_index] and build_index != id_cable{
					var temp_complex_2 = abtoxy(temp_mx, temp_my), temp_list_complex = get_size(temp_mx, temp_my, build_dir, 7)
					for(var a = array_length(temp_list_complex) - 1; a >= 0; a--){
						var temp_complex_3 = temp_list_complex[a], aa = temp_complex_3[0], bb = temp_complex_3[1]
						if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
							continue
						if (aa != temp_mx or bb != temp_my) and edificio_draw[# aa, bb]{
							var temp_edificio = edificio_id[# aa, bb]
							if temp_edificio.enemigo = build_enemigo and temp_edificio.index = id_cable
								draw_line_off(temp_complex_2[0], temp_complex_2[1], temp_edificio.center_x, temp_edificio.center_y)
						}
					}
				}
				draw_text_background(min(room_width - string_width(temp_text), mouse_x + 20), min(room_height - string_height(temp_text), mouse_y), temp_text)
			}
		}
	}
	last_mx = mx
	last_my = my
	if not devise and mouse_check_button_released(mb_left)
		android_clic = true
}
else if build_index = -1 and win = 0 and array_length(blueprint) > 0{
	var len = array_length(blueprint), flip = (((blueprint_mod2 + my) mod 2) = 1), _rotar = false
	//Guardar
	if not blueprint_safe{
		draw_set_halign(fa_center)
		if draw_boton(room_width / 2, 40, L.guardar_plano){
			blueprint_safe = true
			var buffer = buffer_create(2 + 4 * len, buffer_grow, 1)
			buffer_write(buffer, buffer_u8, len)
			buffer_write(buffer, buffer_bool, blueprint_mod2)
			for(var a = 0; a < len; a++){
				var temp_blueprint = blueprint[a]
				buffer_write(buffer, buffer_u8, temp_blueprint.a)
				buffer_write(buffer, buffer_u8, temp_blueprint.b)
				buffer_write(buffer, buffer_u8, temp_blueprint.index)
				buffer_write(buffer, buffer_u8, temp_blueprint.dir)
				buffer_write(buffer, buffer_u8, temp_blueprint.rot0)
				buffer_write(buffer, buffer_u8, temp_blueprint.rot4)
				buffer_write(buffer, buffer_u8, temp_blueprint.rot5)
			}
			buffer_save(buffer, $"Blueprints/{day_format()}.txt")
			buffer_delete(buffer)
			var surf = surface_create(room_width, room_height)
			surface_set_target(surf)
			var color = draw_get_color()
			draw_set_color(make_color_rgb(255, 0, 255))
			draw_rectangle(0, 0, room_width, room_height, false)
			draw_set_color(color)
			var max_width = 0, max_height = 0, min_width = infinity, min_height = infinity
			for(var a = 0; a < len; a++){
				var temp_blueprint = blueprint[a], aaa = temp_blueprint.a + mx
				if flip and (temp_blueprint.b & 1){
					if blueprint_mod2
						aaa--
					else
						aaa++
				}
				var temp_complex = abtoxy(aaa, temp_blueprint.b + my), aa = temp_complex[0], bb = temp_complex[1], index = temp_blueprint.index, dir = temp_blueprint.dir
				draw_edificio(aa, bb, index, dir)
				var size = edificio_size[index] + 1
				min_width = min(min_width, aa - camx - 48 * floor(size / 2))
				min_height = min(min_height, bb - camy - 14 * size)
				max_width = max(max_width, aa - camx + 48 * ceil(size / 2))
				max_height = max(max_height, bb - camy + 14 * size)
			}
			var sprite = sprite_create_from_surface(surf, min_width, min_height, max_width - min_width, max_height - min_height, true, false, 0, 0)
			sprite_save(sprite, 0, $"Blueprints/{day_format()}.png")
			surface_reset_target()
			surface_free(surf)
		}
		draw_set_halign(fa_left)
	}
	//Cancelar
	if mouse_check_button_pressed(mb_right){
		mouse_clear(mb_right)
		build_index = 0
	}
	//Rotar
	if keyboard_check_pressed(CONTROL_ROTAR) or mouse_wheel_up() or mouse_wheel_down(){
		keyboard_clear(CONTROL_ROTAR)
		_rotar = true
		var temp_dir = true
		if mouse_wheel_down()
			temp_dir = true
		else if mouse_wheel_up()
			temp_dir = false
		if keyboard_check(vk_lshift)
			temp_dir = not temp_dir
		blueprint_mina = infinity
		blueprint_minb = infinity
		for(var a = 0; a < len; a++){
			if (my % 1) and false
				blueprint[a].b--
			var temp_blueprint = blueprint[a], size = edificio_size[temp_blueprint.index]
			if (size & 1) = 0
				blueprint[a].dir = 5 - temp_blueprint.dir
			else if temp_dir
				blueprint[a].dir = (temp_blueprint.dir + 5) mod 6
			else
				blueprint[a].dir = (temp_blueprint.dir + 1) mod 6
			var b = temp_blueprint.rot0
			if temp_dir{
				blueprint[a].rot0 = -temp_blueprint.rot4
				blueprint[a].rot4 = temp_blueprint.rot5
				blueprint[a].rot5 = b
			}
			else{
				blueprint[a].rot0 = temp_blueprint.rot5
				blueprint[a].rot5 = temp_blueprint.rot4
				blueprint[a].rot4 = -b
			}
			if (size & 1) = 0{
				if temp_blueprint.dir = 0 and temp_dir
					blueprint[a].rot5--
				if temp_blueprint.dir = 5 and not temp_dir
					blueprint[a].rot0++
			}
			temp_blueprint = blueprint[a]
			var tempa = mx, tempb = my, temp_array_real = [temp_blueprint.rot0, temp_blueprint.rot4, temp_blueprint.rot5], temp_array_real_2 = [0, 4, 5]
			for(var i = 0; i < 3; i++){
				if temp_array_real[i] < 0
					temp_array_real_2[i] = (temp_array_real_2[i] + 3) mod 6
				repeat(abs(temp_array_real[i])){
					tempa = tempa + DESFACE[tempb & 1][temp_array_real_2[i], 0]
					tempb = tempb + DESFACE[tempb & 1][temp_array_real_2[i], 1]
				}
			}
			blueprint[a].a = tempa - mx
			blueprint[a].b = tempb - my
			blueprint_mina = min(blueprint_mina, blueprint[a].a)
			blueprint_minb = min(blueprint_minb, blueprint[a].b)
		}
		for(var a = 0; a < len; a++){
			blueprint[a].a -= blueprint_mina
			blueprint[a].b -= blueprint_minb
		}
		blueprint_mod2 = (blueprint_minb & 1)
	}
	//Detectar colisiones
	if not (last_mx = mx and last_my = my) or _rotar{
		for(var a = 0; a < len; a++){
			var temp_blueprint = blueprint[a], aaa = temp_blueprint.a + mx
			if flip and (temp_blueprint.b mod 2) = 1{
				if blueprint_mod2
					aaa--
				else
					aaa++
			}
			blueprint[a].construible = check_colision(aaa, temp_blueprint.b + my, temp_blueprint.index, temp_blueprint.dir)
		}
	}
	//Dibujar Blueprint
	for(var a = 0; a < len; a++){
		var temp_blueprint = blueprint[a], aaa = temp_blueprint.a + mx
		if flip and (temp_blueprint.b & 1){
			if blueprint_mod2
				aaa--
			else
				aaa++
		}
		var temp_complex = abtoxy(aaa, temp_blueprint.b + my), aa = temp_complex[0], bb = temp_complex[1], index = temp_blueprint.index, dir = temp_blueprint.dir
		draw_edificio(aa, bb, index, dir, 0.5)
		if not temp_blueprint.construible{
			var size = get_size(aaa, temp_blueprint.b + my, dir, edificio_size[index])
			for(var b = 0; b < array_length(size); b++){
				temp_complex = abtoxy(size[b, 0], size[b, 1])
				draw_sprite_off(spr_rojo, 0, temp_complex[0], temp_complex[1],,,,, 0.5)
			}
		}
	}
	//Construir
	if mouse_check_button_pressed(mb_left){
		mouse_clear(mb_left)
		if not keyboard_check(vk_lshift)
			build_index = 0
		for(var a = 0; a < len; a++){
			var temp_blueprint = blueprint[a], aaa = temp_blueprint.a + mx
			if flip and (temp_blueprint.b mod 2) = 1{
				if blueprint_mod2
					aaa--
				else
					aaa++
			}
			if temp_blueprint.construible and is_comprable(edificio_precio_id[temp_blueprint.index], edificio_precio_num[temp_blueprint.index])
				construir(temp_blueprint.index, temp_blueprint.dir, aaa, temp_blueprint.b + my)
		}
	}
	last_mx = mx
	last_my = my
}
//Destruir edificio
else{
	if ((mouse_check_button(mb_right) and prev_change) or mouse_check_button_pressed(mb_right)) and not outside and edificio_bool[# mx, my] and edificio.index != id_nucleo and edificio.enemigo = build_enemigo{
		prev_change = true
		delete_edificio(edificio)
	}
}
var temp_text_right = ""
//Juego
if menu = 1{
	//Ciclo principal
	if pausa = 0 or online{
		var frame_time = min(delta_time / 1_000_000, 0.25)
		acumulator += frame_time
		if online and not servidor{
			if timer + LAG < server_timer
				acumulator++
			if ++server_jugadores_timeout[0] = 599
				server_jugador_irse()
			else if server_jugadores_timeout[0] = 600
				handle_server_break()
		}
		for(ticks = 0; (acumulator >= LOGIC_DT and ticks < 5) or ticks = 0; ticks++)
			step()
	}
	if info
		temp_text_right += $"FPS: {fps}\n"
	if oleadas{
		if oleadas_timer < 60 * oleadas_tiempo_primera{
			var temp_time = oleadas_timer / 60
			var seg = floor(oleadas_tiempo_primera - temp_time)
			temp_text_right += $"{seg > 60 ? string(floor(seg / 60)) + "m " : ""}{seg mod 60}s {L.game_first_wave}\n"
		}
		else{
			var temp_time = (oleadas_timer / 60) - oleadas_tiempo_primera
			var seg = floor(oleadas_tiempo - (temp_time mod oleadas_tiempo))
			temp_text_right += $"{seg > 60 ? string(floor(seg / 60)) + "m " : ""}{seg mod 60}s {L.game_next_wave}\n"
		}
	}
	if mision_actual >= 0 and win = 0{
		var a = mision_actual
		if not in(mision.objetivo, 5, 6)
			temp_text_right += $"\n\n{mision.nombre}\n{objetivos_nombre[mision.objetivo]} {mision.target_num} "
		if mision.objetivo < 2
			temp_text_right += recurso_nombre[mision.target_id]
		else if in(mision.objetivo, 2, 3, 7, 8)
			temp_text_right += edificio_nombre[mision.target_id]
		else if mision.objetivo = 4
			temp_text_right += L.mision_enemigos
		if not in(mision.objetivo, 5, 7)
			temp_text_right += $"\n{mision_counter} / {mision.target_num}"
		if mision.tiempo > 0 and mision.tiempo_show{
			var seg = floor(mision_current_tiempo / 60)
			temp_text_right += $"\n{L.mision_tiempo}: {seg > 60 ? string(floor(seg / 60)) + "m " + string(seg mod 60) : seg}s"
		}
	}
	if temp_text_right != ""{
		temp_text_right = string_trim(temp_text_right)
		draw_set_halign(fa_right)
		draw_text_background(room_width, 0, temp_text_right)
		draw_set_halign(fa_left)
	}
	if draw_sprite_boton(spr_manual,, room_width - 64, string_height(temp_text_right), 64, 64,, hover_sprite_boton_text, {a : $"{L.game_enciclopedia} (Y)"})
		enciclopedia = true
	//Input
	if win = 0 and not show_menu and not chat_input{
		if keyboard_check_pressed(vk_anykey){
			if keyboard_check_pressed(CONTROL_PAUSE){
				keyboard_clear(CONTROL_PAUSE)
				if pausa = 0
					pausa = 2
				else if pausa = 2
					pausa = 0
			}
			if string_ends_with(keyboard_string, "cheat"){
				keyboard_string = ""
				cheat = not cheat
			}
			if cheat and keyboard_check_pressed(CONTROL_WAVES)
				oleadas = not oleadas
			if keyboard_check_pressed(CONTROL_ENCICLOPEDIA){
				if enciclopedia = 0
					enciclopedia = 1
				else
					enciclopedia = 0
			}
			if cheat and mision_actual >= 0 and string_ends_with(keyboard_string, "uwu")
				pasar_mision()
		}
		//Mostrar redes electricas
		if keyboard_check(CONTROL_REDES){
			var temp_text = ""
			for(var a = array_length(redes) - 1; a >= 0; a--){
				var red = redes[a]
				if array_length(red.edificios) > 1{
					temp_text += $"{L.red_red} {a}:\n"
					temp_text += $"  {L.red_consumo}: {red.consumo}\n"
					temp_text += $"  {L.red_generacion}: {red.generacion}\n"
					temp_text += $"  {L.red_bateria}: {floor(red.bateria)}/{red.bateria_max}\n"
					temp_text += red_text(red)
					draw_set_color(make_color_hsv(255 * a / array_length(redes), 255, 255))
					for(var b = array_length(red.edificios) - 1; b >= 0; b--){
						edificio = red.edificios[b]
						var center_x = edificio.center_x, center_y = edificio.center_y
						for(var c = array_length(edificio.energia_link) - 1; c >= 0; c--){
							var edificio_2 = edificio.energia_link[c]
							draw_arrow_off(center_x, center_y, edificio_2.center_x, edificio_2.center_y, 8)
						}
					}
				}
			}
			draw_text_background(0, 0, temp_text)
		}
		//Mostrar redes hidraulicas
		if keyboard_check(CONTROL_FLUJO){
			var temp_text = ""
			for(var a = array_length(flujos) - 1; a >= 0; a--){
				var flujo = flujos[a]
				if array_length(flujo.edificios) > 1{
					temp_text += $"{L.flujo_flujo} {a}:\n"
					if flujo.liquido = -1
						temp_text += $"{L.flujo_sin_liquido}\n"
					else
						temp_text += $"{liquido_nombre[flujo.liquido]}\n"
					temp_text += $"  {L.flujo_generacion}: {flujo.generacion}\n"
					temp_text += $"  {L.flujo_consumo}: {flujo.consumo}\n"
					temp_text += $"  {L.flujo_almacenado}: {floor(flujo.almacen)}/{flujo.almacen_max}\n"
					temp_text += flujo_text(flujo)
					draw_set_color(make_color_hsv(255 * a / array_length(flujos), 255, 255))
					for(var b = array_length(flujo.edificios) - 1; b >= 0; b--){
						edificio = flujo.edificios[b]
						var center_x = edificio.center_x, center_y = edificio.center_y
						for(var c = array_length(edificio.flujo_link) - 1; c >= 0; c--){
							var edificio_2 = edificio.flujo_link[c]
							draw_arrow_off(center_x, center_y, edificio_2.center_x, edificio_2.center_y, 8)
						}
					}
				}
			}
			draw_text_background(0, 0, temp_text)
		}
	}
	//Control de cámara
	if mision_actual = 0 and mision_camara_step > 0{
		mision_camara_step--
		zoom = 1
		camx = clamp(((mision.camera_x - room_width / 2) * (60 - mision_camara_step) + mision_camera_x_start * mision_camara_step) / 60, 0, xsize * 48 * zoom - room_width)
		camy = clamp(((mision.camera_y - room_height / 2) * (60 - mision_camara_step) + mision_camera_y_start * mision_camara_step) / 60, 0, ysize * 14 * zoom - room_height)
	}
	else if not chat_input
		control_camara()
	if win > 0{
		draw_set_color(c_black)
		draw_set_alpha(min(++win_step / 100, 0.5))
		draw_rectangle(0, 0, room_width, room_height, false)
		draw_set_color(c_white)
		if win_step > 25{
			draw_set_alpha(min((win_step - 25) / 100, 1))
			draw_set_font(font_titulo)
			draw_set_halign(fa_center)
			draw_text(room_width / 2, 100, (win mod 10) = 1 ? L.win_victoria : L.win_derrota)
			draw_set_font(font_normal)
			var xpos = room_width / 2, ypos = 200, sec = floor(timer / 60)
			//Info general
			if win < 10{
				ypos = draw_text_ypos(xpos, ypos, $"{L.win_tiempo}: {sec >= 60 ? string(floor(sec / 60)) + "m " : ""}{sec mod 60}s")
				if tecnologia
					ypos = draw_text_ypos(xpos, ypos, $"{L.win_tecnologias}: {tecnologias_estudiadas}")
				if modo_misiones
					ypos = draw_text_ypos(xpos, ypos, $"{L.win_misiones}: {misiones_pasadas}")
				var b = 0
				for(var a = 0; a < rss_max; a++)
					b += recursos_obtenidos[a]
				if b > 0{
					if draw_boton(xpos, ypos + 10, $"{L.recursos_obtenidos}: {num_format(b)}", ui_azul){
						usable_rss_bool = array_create(rss_max, true)
						win += 10
					}
					ypos += text_y + 10
				}
				b = 0
				for(var a = array_length(energia_producida) - 1; a >= 0; a--)
					b += energia_producida[a]
				if b > 0{
					if draw_boton(xpos, ypos + 10, $"{L.energia_producida}: {num_format(b)}", ui_azul)
						win += 20
					ypos += text_y + 10
				}
				if draw_boton(xpos, ypos + 10, L.win_militar, ui_azul)
					win += 30
				ypos += text_y + 10
			}
			//Info recursos
			else if win < 20{
				ypos = draw_text_ypos(xpos, ypos + 10, L.recursos_obtenidos)
				if draw_boton(xpos, ypos + 10, L.volver, ui_azul)
					win -= 10
				ypos += text_y + 20
				var show_array = array_create(array_length(recursos_obtenidos_time))
				for(var a = 0; a < array_length(recursos_obtenidos_time); a++){
					show_array[a] = array_create(rss_max, 0)
					for(var b = 0; b < rss_max; b++)
						array_set(show_array[a], b, recursos_obtenidos_time[a, b])
				}
				for(var a = 0; a < rss_max; a++)
					if recursos_obtenidos[a] > 0{
						if usable_rss_bool[a]
							draw_set_color(recurso_color[a])
						else{
							draw_set_color(make_color_hsv(color_get_hue(recurso_color[a]), color_get_saturation(recurso_color[a]), color_get_value(recurso_color[a]) / 2))
							for(var b = 0; b < array_length(recursos_obtenidos_time); b++)
								array_set(show_array[b], a, 0)
						}
						if draw_boton(xpos, ypos, $"{recurso_nombre[a]}: {num_format(recursos_obtenidos[a])}",, draw_get_color(),, false)
							usable_rss_bool[a] = not usable_rss_bool[a]
						ypos += text_y
					}
				draw_graph(xpos - 200, ypos, 400, 100, show_array, recurso_color)
			}
			//Info energía
			else if win < 30{
				ypos = draw_text_ypos(xpos, ypos + 10, L.red_energia)
				if draw_boton(xpos, ypos + 10, L.volver, ui_azul)
					win -= 20
				ypos += text_y + 20
				var temp_prod = 0, temp_cons = 0, temp_perd = 0
				for(var a = array_length(energia_producida) - 1; a >= 0; a--){
					temp_prod += energia_producida[a]
					temp_cons += energia_consumida[a]
					temp_perd += energia_perdida[a]
				}
				draw_set_color(#FFF899)
				ypos = draw_text_ypos(xpos, ypos, $"{L.energia_producida}: {num_format(temp_prod)}")
				draw_set_color(c_black)
				ypos = draw_text_ypos(xpos, ypos, $"{L.energia_consumida}: {num_format(temp_cons)}")
				draw_set_color(c_red)
				ypos = draw_text_ypos(xpos, ypos, $"{L.energia_perdida}: {num_format(temp_perd)} ({100 - floor(100 * temp_prod / (temp_prod + temp_perd))}%)")
				draw_set_color(c_white)
				draw_graph(xpos - 200, ypos, 400, 100, [energia_producida, energia_consumida, energia_perdida], [ #FFF899, c_black, c_red], true)
			}
			//Info militar
			else if win < 40{
				ypos = draw_text_ypos(xpos, ypos + 10, L.win_militar)
				if draw_boton(xpos, ypos + 10, L.volver, ui_azul)
					win -= 30
				ypos += text_y + 20
				if edificios_construidos > 0
					ypos = draw_text_ypos(xpos, ypos, $"{L.win_edificios}: {edificios_construidos}")
				if edificios_destruidos > 0
					ypos = draw_text_ypos(xpos, ypos, $"{L.win_edificios_destruidos}: {edificios_destruidos}")
				if edificios_perdidos > 0
					ypos = draw_text_ypos(xpos, ypos, $"{L.win_edificios_perdidos}: {edificios_perdidos}")
				if drones_construidos > 0
					ypos = draw_text_ypos(xpos, ypos, $"{L.win_drones}: {drones_construidos}")
				if drones_perdidos > 0
					ypos = draw_text_ypos(xpos, ypos, $"{L.win_drones_perdidos}: {drones_perdidos}")
				if enemigos_eliminados > 0
					ypos = draw_text_ypos(xpos, ypos, $"{L.win_enemigos}: {enemigos_eliminados}")
				if dmg_causado > 0
					ypos = draw_text_ypos(xpos, ypos, $"{L.win_dmg_causado}: {num_format(dmg_causado)}")
				if dmg_recibido > 0
					ypos = draw_text_ypos(xpos, ypos, $"{L.win_dmg_recibido}: {num_format(dmg_recibido)}")
				if dmg_curado > 0
					ypos = draw_text_ypos(xpos, ypos, $"{L.win_dmg_curado}: {num_format(dmg_curado)}")
			}
			//Victoria
			if (win mod 10) = 1{
				if tutorial = 1
					descubrir_zona(4, 8, tutorial)
				else if tutorial = 2
					descubrir_zona(4, 3, tutorial)
				else if tutorial = 3
					descubrir_zona(3, 7, tutorial)
				else if tutorial = 4
					descubrir_zona(4, 2, tutorial)
				if in(tutorial, 1, 2, 3, 4) and draw_boton(room_width / 2, room_height - 250, L.win_siguiente_mision, ui_verde){
					var file = load_escenario_buffer($"mision_{tutorial + 1}.txt")
					if file != ""
						game_start()
					tutorial++
				}
				if draw_boton(room_width / 2, room_height - 200, L.win_seguir_jugando){
					mision_actual = -1
					win_step = 0
					win = 0
				}
			}
			//Derrota
			if (win mod 10) = 2 and tutorial > 0 and draw_boton(room_width / 2, room_height - 250, L.win_reintentar, ui_azul){
				load_escenario_buffer($"mision_{tutorial}.txt")
				game_start()
			}
			if draw_boton(room_width / 2, room_height - 150, L.win_salir, ui_rojo) or keyboard_check_pressed(vk_escape){
				keyboard_clear(vk_escape)
				game_restart()
			}
		}
		draw_set_alpha(1)
	}
}
else if not chat_input
	control_camara()
if menu = 1 or menu = 3{
	if win = 0 and not show_menu and (not chat_input and keyboard_check_pressed(vk_anykey)){
		if (keyboard_check_pressed(CONTROL_MENU) or (not devise and keyboard_check_pressed(vk_backspace))) and pausa != 1{
			if not devise
				keyboard_clear(vk_backspace)
			pausa = 1
			clear_edit()
			mouse_clear(mb_any)
			keyboard_clear(vk_anykey)
		}
		if keyboard_check_pressed(CONTROL_HIDEUI)
			grafic_hideui = not grafic_hideui
		if keyboard_check_pressed(CONTROL_MUSIC)
			sound_change()
		if keyboard_check_pressed(CONTROL_INFO){
			info = not info
			save_setting("", "info", info)
		}
		if keyboard_check_pressed(CONTROL_FLOW){
			keyboard_clear(CONTROL_FLOW)
			flow = (flow + 1) mod flow_max
		}
	}
	if flow > 0
		draw_flow()
}
update_cursor()
if sprite_boton_text != ""
	draw_text_background(mouse_x, mouse_y + 20, sprite_boton_text)
if sonido{
	for(var a = 0; a < SONIDOS_MAX; a++){
		if not audio_is_paused(sonido_id[a]) and volumen[a] = 0
			audio_pause_sound(sonido_id[a])
		if audio_is_paused(sonido_id[a]) and volumen[a] > 0
			audio_resume_sound(sonido_id[a])
		audio_sound_gain(sonido_id[a], volumen[a], 0)
	}
	if random(3600) < 1{
		var flag = true
		for(var a = array_length(MUSICA) - 1; a >= 0; a--)
			if audio_is_playing(MUSICA[a]){
				flag = false
				break
			}
		if flag
			audio_play_sound(MUSICA[irandom(array_length(MUSICA) - 1)], 1, false)
	}
	if clic_sound
		audio_play_sound(snd_click, 1, false, 0.3)
}
if array_length(chat) >= 0{
	var max_width = 0, pos
	if get_keyboard_string != 0
		for(pos = 0; pos < array_length(chat); pos++)
			if chat_time[pos] > image_index - 600
				break
	pos = max(0, array_length(chat) - 10)
	for(var a = pos; a < array_length(chat); a++)
		max_width = max(max_width, string_width(string(chat[a])))
	if get_keyboard_string = 0{
		chat_input = true
		max_width = max(max_width, string_width($"'{chat_text}'"))
		if keyboard_check_pressed(vk_enter){
			keyboard_clear(vk_enter)
			chat_input = false
			get_keyboard_string = -1
			array_push(chat, chat_text)
			array_push(chat_time, image_index)
			if online
				server_mensaje($"{online_nombre}: {chat_text}")
			chat_text = ""
		}
		if keyboard_check_pressed(vk_escape)
			chat_input = false
	}
	draw_set_color(c_black)
	draw_set_alpha(0.5)
	draw_rectangle(0, room_height, max_width, room_height - 20 * (array_length(chat) - pos) - 20, false)
	draw_set_color(c_white)
	draw_set_alpha(1)
	for(var a = pos; a < array_length(chat); a++)
		draw_text(0, room_height + 20 * (a - array_length(chat)) - 20, string(chat[a]))
	draw_boton_text_counter = 0
	chat_text = draw_boton_text(0, room_height - 20, chat_text, false,, false)
}
if keyboard_check(CONTROL_TAB) and online{
	draw_set_color(c_black)
	draw_set_halign(fa_center)
	draw_set_alpha(0.5)
	var max_width = 0
	for(var a = 0; a < array_length(server_jugadores_nombre); a++)
		max_width = max(max_width, string_width(server_jugadores_nombre[a]))
	max_width += 30
	draw_rectangle((room_width - max_width) / 2, 150, (room_width + max_width) / 2, 170 + 40 * array_length(server_jugadores_nombre), false)
	draw_set_color(c_white)
	draw_set_alpha(1)
	if servidor{
		for(var a = 0; a < array_length(server_jugadores_nombre); a++)
			if draw_boton(room_width / 2, 160 + 40 * a, server_jugadores_nombre[a],,,, true) and a != 0
				server_jugador_expulsar(a)
	}
	else
		for(var a = 0; a < array_length(server_jugadores_nombre); a++)
			draw_boton(room_width / 2, 160 + 40 * a, server_jugadores_nombre[a],,,, true)
	draw_set_halign(fa_left)
}
draw_sprite(spr_vineta, 0, 0, 0)
if keyboard_check(ord("V")){
	draw_set_valign(fa_bottom)
	draw_text(0, room_height, $"{jugador}\n{server_jugadores_nombre}\n{misiones}")
	if keyboard_check_pressed(ord("V")){
		_time = current_time
		var temp_array = array_create(0, 0), visitado = ds_grid_create(xsize, ysize), _continue = array_create(20)
		ds_grid_clear(visitado, false)
		for(var i = 0; i < 20; i++){
			_continue[i] = array_create(20, false)
			var a = random(xsize - 1), b = random(ysize - 1)
			array_push(temp_array, a, b)
			visitado[# a, b] = true
			abba[# a, b] = i
		}
		for(var _counter = 0; _counter < array_length(temp_array); _counter++){
			var a = temp_array[_counter++], b = temp_array[_counter], bmod = b & 1, c = abba[# a, b]
			for(var i = 0; i < 6; i++){
				var aa = a + DESFACE[bmod][i, 0], bb = b + DESFACE[bmod][i, 1]
				if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
					continue
				if not visitado[# aa, bb]{
					visitado[# aa, bb] = true
					array_push(temp_array, aa, bb)
					abba[# aa, bb] = c
				}
				else{
					var d = abba[# aa, bb]
					if c != d{
						_continue[c, d] = true
						_continue[d, c] = true
					}
				}
			}
		}
		for(var a = 0; a < 20; a++)
			show_debug_message(_continue[a])
		show_debug_message($"{current_time - _time}ms")
		for(var a = 0; a < array_length(misiones); a++)
			show_debug_message(misiones[a])
	}
	draw_set_valign(fa_top)
}
