#region Pre-event
	mina = max(0, floor(camx / zoom / 48))
	minb = max(0, floor(camy / zoom / 14) - 1)
	maxa = min(xsize, ceil(1 + (camx + room_width) / zoom / 48))
	maxb = min(ysize, ceil(1 + (camy + room_height) / zoom / 14))
	min_chunka = max(0, floor(mina / chunk_width))
	min_chunkb = max(0, floor(minb / chunk_height))
	max_chunka = min(ceil(maxa / chunk_width), chunk_xsize)
	max_chunkb = min(ceil(maxb / chunk_height), chunk_ysize)
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
		if array_length(mision_nombre) = 0{
			tecnologia = false
			oleadas_tiempo_primera = 240
			oleadas_tiempo = 90
			multiplicador_vida_enemigos = 50
			cheat = false
			mision_objetivo = [4]
			mision_nombre = [""]
			mision_target_num = [15]
			mision_target_id = [0]
			mision_tiempo = [0]
			mision_switch_oleadas = [false]
			mision_camara_move = [false]
			mision_texto = [[]]
			mision_tiempo_edit = [0]
			flow = 0
			dificultad = 0
		}
		else{
			flow = 4
			dificultad = -1
		}
	}
	ypos += text_y * 2
	if draw_boton(room_width / 2, ypos, L.menu_tutorial, ui_verde)
		menu = 4
	ypos += text_y * 2
	if draw_boton(room_width / 2, ypos, L.menu_editor, ui_azul)
		menu = 2
	ypos += text_y * 2
	if draw_boton(room_width / 2, ypos, "Buscar servidores en LAN"){
		var buffer = buffer_create(256, buffer_grow, 1)
		buffer_write(buffer, buffer_u8, 5) //Buscar servidor
		network_send_broadcast(udp_socket, 6501, buffer, buffer_tell(buffer))
		buffer_delete(buffer)
	}
	ypos += text_y * 2
	if server_ip = ""{
		if draw_boton(room_width / 2, ypos, "Conexión Directa"){
			window_set_fullscreen(false)
			var temp_server_ip = get_string("Dirección IP", "192.168.1.x")
			network_connect(socket, temp_server_ip, 6500)
			if server = -1
				show_debug_message("Error de conexión")
			else{
				server_ip = temp_server_ip
				server_hello()
			}
		}
	}
	else{
		if draw_boton(room_width / 2, ypos, $"Conectarse a {server_ip}"){
			server = network_connect(socket, server_ip, 6500)
			if server = -1
				show_debug_message("Error de conexión")
			else
				server_hello()
		}
	}
	ypos += text_y * 2
	draw_set_halign(fa_left)
	if get_file > 0{
		draw_set_color(c_dkgray)
		draw_rectangle(100, 100, room_width - 100, room_height - 100, false)
		draw_set_color(c_white)
		draw_rectangle(100, 100, room_width - 100, room_height - 100, true)
		draw_set_halign(fa_center)
		draw_text(room_width / 2, 110, get_file = 1 ? L.menu_cargar_escenario : L.menu_juego_rapido)
		draw_set_halign(fa_left)
		//Cargar Archivo
		if get_file = 1{
			draw_set_valign(fa_bottom)
			for(var a = 0; a < array_length(save_files); a++){
				var xpos = 120 + 120 * (a mod 9)
				ypos = 200 + 120 * floor(a / 9)
				var temp_text = string_delete(save_files[a], string_pos(".", save_files[a]), 4)
				if draw_sprite_boton(save_files_png[a],, xpos, ypos, 96, 96, 1){
					tecnologia = true
					cargar_escenario(save_files[a])
					game_start()
				}
				if draw_sprite_boton(spr_basura,, xpos - 10, ypos - 30,,, 1){
					file_delete(temp_text + ".txt")
					file_delete(temp_text + ".png")
					array_delete(save_files, a, 1)
					array_delete(save_files_png, a, 1)
					continue
				}
				draw_text(xpos + 20, ypos, text_wrap(temp_text, 100))
			}
			draw_set_valign(fa_top)
			if array_length(save_files) = 0{
				draw_set_halign(fa_center)
				draw_text(room_width / 2, 200, L.menu_sin_archivos)
				draw_set_halign(fa_left)
			}
			if draw_boton(120, 120, L.cancelar, ui_rojo,,,, 1) or keyboard_check_pressed(vk_escape){
				keyboard_clear(vk_escape)
				get_file = 2
			}
		}
		//Partida Nueva
		else if get_file = 2{
			ypos = 110
			if draw_boton(120, ypos, L.cancelar, ui_rojo,,,, 1) or keyboard_check_pressed(vk_escape){
				keyboard_clear(vk_escape)
				get_file = 0
				input_layer = 0
			}
			ypos += text_y * 1.2
			draw_panel(110, ypos, room_width - 220, room_height - 200 - ypos, 0, 1, 1, function(xpos, ypos){
				var des_count = 0
				draw_boton_text_counter = 0
				ypos = draw_text_ypos(xpos, ypos, L.dificultad)
				if draw_boton(xpos, ypos, L.facil, flow = 0 ? ui_azul : ui_gris,,,, 1){
					tecnologia = false
					oleadas_tiempo_primera = 240
					oleadas_tiempo = 90
					multiplicador_vida_enemigos = 50
					cheat = false
					mision_objetivo = [4]
					mision_nombre = [""]
					mision_target_num = [15]
					mision_target_id = [0]
					mision_tiempo = [0]
					mision_switch_oleadas = [false]
					mision_camara_move = [false]
					mision_texto = [[]]
					mision_tiempo_edit = [0]
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
					mision_objetivo = [4]
					mision_nombre = [""]
					mision_target_num = [22]
					mision_target_id = [0]
					mision_tiempo = [0]
					mision_switch_oleadas = [false]
					mision_camara_move = [false]
					mision_texto = [[]]
					mision_tiempo_edit = [0]
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
					mision_objetivo = [4]
					mision_nombre = [""]
					mision_target_num = [35]
					mision_target_id = [0]
					mision_tiempo = [0]
					mision_switch_oleadas = [false]
					mision_camara_move = [false]
					mision_texto = [[]]
					mision_tiempo_edit = [0]
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
						mision_objetivo = array_create(0, 0)
						mision_nombre = array_create(0, "")
						mision_target_num = array_create(0, 0)
						mision_target_id = array_create(0, 0)
						mision_tiempo = array_create(0, 0)
						mision_switch_oleadas = array_create(0, false)
						mision_camara_move = array_create(0, false)
						mision_texto = [[]]
						mision_tiempo_edit = array_create(0, 0)
						flow = 3
					}
					xpos += text_x + 20
					if draw_boton(xpos, ypos, L.menu_modo_oleadas, flow = 4 ? ui_azul : ui_gris,,,, 1){
						mision_objetivo = [4]
						mision_nombre = [""]
						mision_target_num = [20]
						mision_target_id = [0]
						mision_tiempo = [0]
						mision_switch_oleadas = [false]
						mision_camara_move = [false]
						mision_texto = [[]]
						mision_tiempo_edit = [0]
						flow = 4
					}
					xpos += text_x + 20
					if draw_boton(xpos, ypos, L.menu_modo_misiones, flow = 5 ? ui_azul : ui_gris,,,, 1){
						modo_misiones = true
						add_mision()
						flow = 5
					}
					if flow = 4{
						ypos += text_y + 10
						xpos = draw_text_xpos(160, ypos, L.menu_numero_oleadas)
						mision_target_num[0] = round(draw_deslizante(xpos + 10, xpos + 135, ypos + 10, mision_target_num[0], 10, 50, des_count++, 1))
						draw_text_ypos(xpos + 145, ypos, mision_target_num[0])
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
					mapa = -1
				}
				xpos += 120
				for(var a = 0; a < array_length(default_maps); a++){
					if mapa = a{
						draw_set_color(c_blue)
						draw_rectangle(xpos - 2, ypos - 2, xpos + 97, ypos + 97, false)
					}
					if draw_sprite_boton(default_maps_image[a],, xpos, ypos, 96, 96, 1, function(data){
						sprite_boton_text = data.a}, {a : a}) and mapa != a{
						var file = cargar_escenario($"{default_maps[a]}.txt", false)
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
				return {a : xpos, b : ypos}
			})
			ypos = room_height - 180
			draw_set_halign(fa_right)
			if browser and draw_boton(room_width / 2 - 200, ypos, L.menu_cargar_escenario, ui_azul,,,, 1){
				if not nucleo.vivo
					game_restart()
				get_file = 1
				input_layer = 1
				scan_files_save()
			}
			draw_set_halign(fa_left)
			if draw_boton(room_width / 2 + 200, ypos, L.menu_juego_rapido, ui_verde,,,, 1)
				game_start()
		}
	}
	draw_set_valign(fa_bottom)
	draw_text(10, room_height - 10, "Tomás Ramdohr")
	draw_set_valign(fa_top)
	update_cursor()
	if keyboard_check_pressed(vk_escape)
		game_end()
	if os_type == os_windows
		for(var a = 0; a < idiomas; a++)
			if draw_sprite_boton(spr_bandera, a, 20 + 80 * a, 20, 64, 48,, function(data){draw_text_background(0, 80, idioma_name[data.a])}, {a : a}){
				idioma = a
				set_idioma()
			}
	if keyboard_check_pressed(vk_f4){
		keyboard_clear(vk_f4)
		window_set_fullscreen(not window_get_fullscreen())
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
				var edificio = chunk[c], index = edificio.index, aa = edificio.x, bb = edificio.y, aaa = aa * zoom - camx, bbb = bb * zoom - camy, center_x = edificio.center_x, center_y = edificio.center_y, alert_count = 0
				//Recursos sobre caminos
				if grafic_array_camino_o_tunel[index] and edificio.carga_total > 0{
					var proceso = edificio_proceso[index]
					var d = 1.2 * (max(edificio.proceso, edificio.waiting * proceso) - proceso / 2) * 20 / proceso
					draw_sprite_off(recurso_sprite[edificio.carga_id], 0, aa + d * edificio.array_real[0], bb + d * edificio.array_real[1])
				}
				//Munición armas
				else if grafic_array_municion_armas[index] and edificio.carga_total = 0{
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
				if show_humo and grafic_array_generadores_de_humo[index]{
					if ((in(index, id_generador, id_turbina, id_planta_nuclear, id_horno) and edificio.fuel > 0) or (index = id_generador_geotermico and in(edificio.flujo.liquido, 0, 4)) or (index = id_refineria_de_petroleo and edificio.flujo.liquido = 2 and edificio.red.eficiencia > 0)){
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
				else if grafic_array_dron_encima[index] and edificio.select >= 0
					draw_sprite_off(dron_sprite[edificio.select], 0, center_x, center_y,,,,, 0.5)
				//Dibujo falta líquido
				if grafic_array_liquido_obligatorio[index]{
					if edificio.flujo.liquido != edificio_flujo_liquido[index] and edificio.flujo_consumo_max > 0{
						draw_sprite_off(liquido_sprite[edificio_flujo_liquido[index]], 0, aa, bb - 28 * ++alert_count)
						draw_sprite_off(spr_falta, 0, aa, bb - 28 * alert_count)
					}
				}
				draw_vida(aaa, bbb, edificio.vida, edificio_vida[index])
				//Dibujo estados
				if edificio.enemigo{
					draw_set_color(c_red)
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
	if keyboard_check(ord("Q"))
		for(var a = mina; a < maxa; a++)
			for(var b = minb; b < maxb; b++)
				if repair_id[# a, b] >= 0{
					var temp_complex = abtoxy(a, b)
					draw_edificio(temp_complex.a, temp_complex.b, repair_id[# a, b], repair_dir[# a, b], 0.5)
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
		for(var b = 0; b < array_length(mision_texto[mision_actual]); b++){
			var texto = mision_texto[mision_actual, b]
			draw_text_background(texto.x * zoom - camx, texto.y * zoom - camy, text_wrap(texto.texto, 250),, false)
		}
	var temp_text = ""
	for(var a = 0; a < rss_max; a++)
		if nucleo.carga[rss_sort[a]] > 0
			temp_text += $"{recurso_nombre[rss_sort[a]]} {nucleo.carga[rss_sort[a]]}\n"
	if temp_text != ""
		draw_text_background(room_width / 2, 0, temp_text)
	draw_set_halign(fa_left)
	if enciclopedia > 0{
		image_index--
		draw_set_color(c_gray)
		draw_rectangle(100, 100, room_width - 100, room_height - 100, false)
		draw_set_color(c_black)
		draw_rectangle(100, 100, room_width - 100, room_height - 100, true)
		var width = 100
		if draw_boton(width, 100, L.enciclopedia_recursos){
			deslizante[0] = 0
			enciclopedia = 1
		}
		width += text_x + 20
		if draw_boton(width, 100, L.enciclopedia_edificios){
			deslizante[0] = 0
			enciclopedia = 2
		}
		width += text_x + 20
		if draw_boton(width, 100, L.enciclopedia_unidades){
			deslizante[0] = 0
			enciclopedia = 5
		}
		width += text_x + 20
		if tecnologia and draw_boton(width, 100, L.enciclopedia_tecnologia){
			deslizante[0] = 0
			enciclopedia = 7
		}
		//Menú Recursos
		if enciclopedia = 1{
			var pos = 140
			if rss_max > 25
				deslizante[0] = floor(draw_deslizante_vertical(110, pos, pos + 25 * 20, deslizante[0], 0, rss_max - 25, 0))
			for(var a = deslizante[0]; a < min(deslizante[0] + 25, rss_max); a++){
				draw_sprite(recurso_sprite[rss_sort[a]], 0, 120, pos + 10)
				if draw_boton(140, pos, recurso_nombre[rss_sort[a]],,,, false){
					enciclopedia_item = rss_sort[a]
					enciclopedia = 3
				}
				pos += 20
			}
			if deslizante[0] + 25 < rss_max and mouse_wheel_down()
				deslizante[0]++
			if deslizante[0] > 0 and mouse_wheel_up()
				deslizante[0]--
		}
		//Menú Edificios
		else if enciclopedia = 2{
			var pos = 140
			if edificio_max > 25
				deslizante[0] = floor(draw_deslizante_vertical(110, pos, pos + 25 * 20, deslizante[0], 0, edificio_max - 25, 0))
			for(var a = deslizante[0]; a < min(deslizante[0] + 25, edificio_max); a++){
				draw_sprite_stretched(edificio_sprite[edi_sort[a]], 0, 120, pos, 18, 18)
				if draw_boton(150, pos, edificio_nombre[edi_sort[a]],,,, false){
					enciclopedia_item = edi_sort[a]
					enciclopedia = 4
				}
				pos += 20
			}
			if deslizante[0] + 25 < edificio_max and mouse_wheel_down()
				deslizante[0]++
			if deslizante[0] > 0 and mouse_wheel_up()
				deslizante[0]--
		}
		//Detalles Recurso
		else if enciclopedia = 3{
			var pos = 140
			draw_set_font(devise ? font_titulo : ft_titulo_android)
			pos = draw_text_ypos(120, pos, recurso_nombre[enciclopedia_item])
			draw_set_font(font_normal)
			pos = draw_text_ypos(120, pos, recurso_descripcion[enciclopedia_item])
			if recurso_combustion[enciclopedia_item]
				pos = draw_text_ypos(120, pos, $"{L.enciclopedia_combustible} {recurso_combustion_time[enciclopedia_item] / 60}[s]")
			pos = draw_text_ypos(120, pos, L.enciclopedia_usado_en)
			for(var a = 0; a < edificio_max; a++){
				var aa = edi_sort[a]
				for(var b = 0; b < array_length(edificio_input_id[aa]); b++)
					if edificio_input_id[aa, b] = enciclopedia_item{
						if draw_boton(140, pos, edificio_nombre[aa],,,, false){
							enciclopedia_item = aa
							enciclopedia = 4
							exit
						}
						pos += 20
						break
					}
			}
			pos = draw_text_ypos(120, pos, $"{L.enciclopedia_producido_en}:")
			for(var a = 0; a < edificio_max; a++){
				var aa = edi_sort[a]
				for(var b = 0; b < array_length(edificio_output_id[aa]); b++)
					if edificio_output_id[aa, b] = enciclopedia_item{
						if draw_boton(140, pos, edificio_nombre[aa],,,, false){
							enciclopedia_item = aa
							enciclopedia = 4
							exit
						}
						pos += 20
						break
					}
			}
			var flag = false
			for(var a = 0; a < edificio_max; a++){
				for(var b = 0; b < array_length(edificio_precio_id[a]); b++)
					if edificio_precio_id[a, b] = enciclopedia_item{
						flag = true
						break
					}
				if flag
					break
			}
			if flag{
				pos = draw_text_ypos(120, pos, $"{L.enciclopedia_necesario_para_construir}:")
				for(var a = 0; a < edificio_max; a++){
					var aa = edi_sort[a]
					for(var b = 0; b < array_length(edificio_precio_id[aa]); b++)
						if edificio_precio_id[aa, b] = enciclopedia_item{
							if draw_boton(140, pos, edificio_nombre[aa],,,, false){
								enciclopedia_item = aa
								enciclopedia = 4
								exit
							}
							pos += 20
							break
						}
				}
			}
			else
				pos = draw_text_ypos(120, pos, L.enciclopedia_inutil)
			flag = false
			for(var a = 0; a < dron_max; a++){
				for(var b = 0; b < array_length(dron_precio_id[a]); b++)
					if dron_precio_id[a, b] = enciclopedia_item{
						flag = true
						break
					}
				if flag
					break
			}
			if flag{
				pos = draw_text_ypos(120, pos, $"{L.enciclopedia_necesario_para_producir}:")
				for(var a = 0; a < dron_max; a++)
					for(var b = 0; b < array_length(dron_precio_id[a]); b++)
						if dron_precio_id[a, b] = enciclopedia_item{
							if draw_boton(140, pos, dron_nombre[a],,,, false){
								enciclopedia_item = a
								enciclopedia = 6
								exit
							}
							pos += 20
							break
						}
			}
			draw_sprite_ext(recurso_sprite[enciclopedia_item], 0, room_width - 200, 200, 4, 4, 0, c_white, 1)
		}
		//Detalles Edificio
		else if enciclopedia = 4{
			var pos = 140, ei = enciclopedia_item
			draw_set_font(font_titulo)
			pos = draw_text_ypos(120, pos, edificio_nombre[ei])
			draw_set_font(font_normal)
			pos = draw_text_ypos(120, pos, edificio_descripcion[ei]) + 10
			pos = draw_text_ypos(120, pos, $"{L.enciclopedia_vida}: {edificio_vida[ei]}")
			pos = draw_text_ypos(120, pos, $"{L.enciclopedia_size}: {edificio_size[ei]}")
			if array_length(edificio_precio_id[ei]) > 0{
				pos += 10
				pos = draw_text_ypos(120, pos, $"{L.enciclopedia_coste_construccion}:")
				for(var a = 0; a < array_length(edificio_precio_id[ei]); a++){
					if draw_boton(140, pos, $"{edificio_precio_num[ei, a]} {recurso_nombre[edificio_precio_id[ei, a]]}",,,, false){
						enciclopedia_item = edificio_precio_id[ei, a]
						enciclopedia = 3
						exit
					}
					pos += 20
				}
			}
			if array_length(edificio_input_id[ei]) > 0{
				pos += 10
				pos = draw_text_ypos(120, pos, $"{L.enciclopedia_consume}:")
				for(var a = 0; a < array_length(edificio_input_id[ei]); a++){
					if draw_boton(140, pos, recurso_nombre[edificio_input_id[ei, a]],,,, false){
						enciclopedia_item = edificio_input_id[ei, a]
						enciclopedia = 3
						exit
					}
					pos += 20
				}
			}
			if array_length(edificio_output_id[ei]) > 0{
				pos += 10
				pos = draw_text_ypos(120, pos, $"{L.enciclopedia_produce}:")
				for(var a = 0; a < array_length(edificio_output_id[ei]); a++){
					if draw_boton(140, pos, recurso_nombre[edificio_output_id[ei, a]],,,, false){
						enciclopedia_item = edificio_output_id[ei, a]
						enciclopedia = 3
						exit
					}
					pos += 20
				}
			}
			if edificio_energia[ei]{
				pos += 10
				if edificio_energia_consumo[ei] > 0
					pos = draw_text_ypos(120, pos, $"{L.enciclopedia_consume} {edificio_energia_consumo[ei]} {L.red_energia}/s")
				else if edificio_energia_consumo[ei] < 0
					pos = draw_text_ypos(120, pos, $"{L.enciclopedia_produce} {abs(edificio_energia_consumo[ei])} {L.red_energia}/s")
			}
			if edificio_flujo[ei]{
				pos += 10
				if edificio_flujo_liquido[ei] = -1
					temp_text = L.flujo_liquido
				else
					temp_text = liquido_nombre[edificio_flujo_liquido[ei]]
				if edificio_flujo_consumo[ei] > 0
					pos = draw_text_ypos(120, pos, $"{L.enciclopedia_consume} {edificio_flujo_consumo[ei]} {temp_text}/s")
				else if edificio_flujo_consumo[ei] < 0
					pos = draw_text_ypos(120, pos, $"{L.enciclopedia_produce} {abs(edificio_flujo_consumo[ei])} {temp_text}/s")
			}
			if (edificio_tecnologia[ei] or cheat) and draw_boton(120, pos + 40, L.enciclopedia_construir, ui_verde){
				enciclopedia = 0
				build_index = ei
				build_dir = 0
			}
			draw_sprite_ext(edificio_sprite[ei], 0, room_width - 200, 200, 2, 2, 0, c_white, 1)
			if edificio_armas[ei] and ei != id_onda_de_choque
				if edificio_size[ei] mod 2 = 0
					draw_sprite_ext(edificio_sprite_2[ei], 0, room_width - 200 + 16, 200 + 24, 2, 2, 0, c_white, 1)
				else if edificio_size[ei] = 2.5
					draw_sprite_ext(edificio_sprite_2[ei], 0, room_width - 200 + 24, 200 + 14, 2, 2, 0, c_white, 1)
				else
					draw_sprite_ext(edificio_sprite_2[ei], 0, room_width - 200, 200, 2, 2, 0, c_white, 1)
			if tecnologia{
				sprite_boton_text = ""
				var size = array_length(edificio_tecnologia_prev[ei]), xpos = 800, ypos = 200
				for(var a = 0; a < size; a++){
					var b = edificio_tecnologia_prev[ei, a]
					if edificio_tecnologia[b]
						draw_set_color(c_green)
					else if edificio_tecnologia_desbloqueable[b]
						draw_set_color(c_yellow)
					else
						draw_set_color(c_red)
					draw_line(xpos + 50 * a - 25 * (size - 1), ypos, xpos, ypos + 100)
					draw_circle(xpos + 50 * a - 25 * (size - 1), ypos, 25, false)
					draw_set_color(c_black)
					draw_circle(xpos + 50 * a - 25 * (size - 1), ypos, 25, true)
					if draw_sprite_boton(edificio_sprite[b],, xpos - 20 + 50 * a - 25 * (size - 1), ypos - 20, 40, 40,, function(data){
						sprite_boton_text = edificio_nombre[data.b]}, {b : b}){
						enciclopedia_item = b
						enciclopedia = 4
						exit
					}
					draw_text_background(mouse_x + 20, mouse_y, sprite_boton_text)
				}
				size = array_length(edificio_tecnologia_next[ei])
				for(var a = 0; a < size; a++){
					var b = edificio_tecnologia_next[ei, a]
					if edificio_tecnologia[b]
						draw_set_color(c_green)
					else if edificio_tecnologia_desbloqueable[b]
						draw_set_color(c_yellow)
					else
						draw_set_color(c_red)
					draw_line(xpos + 50 * a - 25 * (size - 1), ypos + 200, xpos, ypos + 100)
					draw_circle(xpos + 50 * a - 25 * (size - 1), ypos + 200, 25, false)
					draw_set_color(c_black)
					draw_circle(xpos + 50 * a - 25 * (size - 1), ypos + 200, 25, true)
					if draw_sprite_boton(edificio_sprite[b],, xpos - 20 + 50 * a - 25 * (size - 1), ypos + 180, 40, 40,, function(data){
						sprite_boton_text = edificio_nombre[data.b]}, {b : b}){
						enciclopedia_item = b
						enciclopedia = 4
						exit
					}
					draw_text_background(mouse_x + 20, mouse_y, sprite_boton_text)
				}
				if edificio_tecnologia[ei]
					draw_set_color(c_green)
				else if edificio_tecnologia_desbloqueable[ei]{
					var flag = true
					temp_text = ""
					if not cheat
						for(var a = 0; a < array_length(edificio_tecnologia_precio[ei]); a++){
							var temp_precio = edificio_tecnologia_precio[ei, a]
							temp_text += $"\n{recurso_nombre[temp_precio.id]}: {temp_precio.num}"
							if nucleo.carga[temp_precio.id] < temp_precio.num{
								flag = false
								temp_text += " !!"
							}
						}
					draw_set_valign(fa_middle)
					if draw_boton(xpos + 100, ypos + 100, (flag ? L.enciclopedia_investigar : L.almacen_sin_recursos) + temp_text, flag ? ui_verde : ui_rojo) and flag{
						if not cheat
							for(var a = 0; a < array_length(edificio_tecnologia_precio[ei]); a++){
								var temp_precio = edificio_tecnologia_precio[ei, a]
								nucleo.carga[temp_precio.id] -= temp_precio.num
							}
						edificio_tecnologia_desbloqueable[ei] = false
						edificio_tecnologia[ei] = true
						tecnologias_estudiadas++
						for(var a = 0; a < array_length(edificio_tecnologia_next[ei]); a++){
							var b = edificio_tecnologia_next[ei, a]
							if not edificio_tecnologia[b]{
								flag = true
								for(var c = 0; c < array_length(edificio_tecnologia_prev[b]); c++){
									var d = edificio_tecnologia_prev[b, c]
									if not edificio_tecnologia[d]{
										flag = false
										break
									}
								}
								if flag
									edificio_tecnologia_desbloqueable[b] = true
							}
						}
					}
					draw_set_valign(fa_top)
					draw_set_color(c_yellow)
				}
				else
					draw_set_color(c_red)
				draw_circle(xpos, ypos + 100, 25, false)
				draw_set_color(c_black)
				draw_circle(xpos, ypos + 100, 25, true)
				draw_sprite_stretched(edificio_sprite[ei], 0, xpos - 20, ypos + 80, 40, 40)
			}
		}
		//Menú Unidades
		else if enciclopedia = 5{
			var pos = 140
			if dron_max > 25
				deslizante[0] = floor(draw_deslizante_vertical(110, pos, pos + 25 * 20, deslizante[0], 0, dron_max - 25, 0))
			for(var a = deslizante[0]; a < min(deslizante[0] + 25, dron_max); a++){
				if draw_boton(120, pos, dron_nombre[a],,,, false){
					enciclopedia_item = a
					enciclopedia = 6
				}
				pos += 20
			}
			if deslizante[0] + 25 < dron_max and mouse_wheel_down()
				deslizante[0]++
			if deslizante[0] > 0 and mouse_wheel_up()
				deslizante[0]--
		}
		//Detalles Dron
		else if enciclopedia = 6{
			var pos = 140
			draw_set_font(font_titulo)
			pos = draw_text_ypos(120, pos, dron_nombre[enciclopedia_item])
			draw_set_font(font_normal)
			pos = draw_text_ypos(120, pos, dron_descripcion[enciclopedia_item])
			pos = draw_text_ypos(120, pos, $"{L.enciclopedia_vida}: {dron_vida_max[enciclopedia_item]}")
			if dron_aereo[enciclopedia_item]
				pos = draw_text_ypos(140, pos, L.enciclopedia_aerea)
			if array_length(dron_precio_id[enciclopedia_item]) > 0{
				pos += 10
				pos = draw_text_ypos(120, pos, $"{L.enciclopedia_coste_construccion}:")
				for(var a = 0; a < array_length(dron_precio_id[enciclopedia_item]); a++){
					if draw_boton(140, pos, $"{dron_precio_num[enciclopedia_item, a]} {recurso_nombre[dron_precio_id[enciclopedia_item, a]]}",,,, false){
						enciclopedia_item = dron_precio_id[enciclopedia_item, a]
						enciclopedia = 3
						exit
					}
					pos += 20
				}
			}
			draw_sprite_ext(dron_sprite[enciclopedia_item], image_index / 2, room_width - 200, 200, 2, 2, 0, c_white, 1)
			draw_sprite_ext(dron_sprite_color[enciclopedia_item], image_index / 2, room_width - 200, 200, 2, 2, 0, c_white, 1)
		}
		//Tecnología
		else if enciclopedia = 7{
			sprite_boton_text = ""
			var pos = 140, xpos = room_width / 2
			draw_set_font(font_titulo)
			pos = draw_text_ypos(120, pos, L.enciclopedia_tecnologia)
			draw_set_font(font_normal)
			pos = 140
			for(var a = 0; a < array_length(tecnologia_nivel_edificios); a++){
				pos += 60
				width = array_length(tecnologia_nivel_edificios[a])
				for(var b = 0; b < width; b++){
					var c = tecnologia_nivel_edificios[a, b]
					if edificio_tecnologia[c]
						draw_set_color(c_green)
					else if edificio_tecnologia_desbloqueable[c]
						draw_set_color(c_yellow)
					else
						draw_set_color(c_red)
					draw_circle(xpos + 60 * b - 30 * (width - 1), pos, 25, false)
					draw_set_color(c_black)
					draw_circle(xpos + 60 * b - 30 * (width - 1), pos, 25, true)
					if draw_sprite_boton(edificio_sprite[c],, xpos - 20 + 60 * b - 30 * (width - 1), pos - 20, 40, 40,, function(data){
						sprite_boton_text = edificio_nombre[data.c]}, {c : c}){
						enciclopedia_item = c
						enciclopedia = 4
						exit
					}
				}
			}
			draw_text_background(mouse_x + 20, mouse_y, sprite_boton_text)
		}
		if keyboard_check_pressed(vk_escape) or keyboard_check_pressed(ord("Y")) or mouse_check_button_pressed(mb_right) or (mouse_check_button_pressed(mb_left) and (mouse_x < 100 or mouse_y < 100 or mouse_x > room_width - 100 or mouse_y > room_height - 100)){
			mouse_clear(mouse_lastbutton)
			keyboard_clear(vk_escape)
			keyboard_clear(ord("K"))
			enciclopedia = false
		}
		update_cursor()
		exit
	}
	if sonido and random(1) < 0.1{
		var a = irandom_range(mina, maxa - 1), b = irandom_range(minb, maxb - 1)
		if terreno[# a, b] = idt_lava{
			var temp_complex = abtoxy(a, b), aa = temp_complex.a, bb = temp_complex.b
			sound_play(snd_lava, aa, bb, 0.5)
		}
	}
	sprite_boton_text = ""
	clic_sound = false
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
	draw_text(room_width / 2, 150,	$"{L.pausa_continuar}\n{L.pausa_red}\n{L.pausa_liquido}\n{L.pausa_enciclopedia}\n{L.pausa_reparar}")
	draw_set_halign(fa_left)
	var a = room_width / 2
	draw_set_halign(fa_center)
	if draw_boton(a, 300, (info ? L.pausa_desactivar : L.pausa_activar) + $" {L.pausa_info}", info ? ui_verde : ui_rojo){
		info = not info
		ini_open("settings.ini")
			ini_write_real("", "info", info)
		ini_close()
	}
	if draw_boton(a, 340, (grafic_tile_animation ? L.pausa_desactivar : L.pausa_activar) + $" {L.pausa_animacion}", grafic_tile_animation ? ui_verde : ui_rojo){
		grafic_tile_animation = not grafic_tile_animation
		ini_open("settings.ini")
			ini_write_real("", "grafic_tile_animation", grafic_tile_animation)
		ini_close()
	}
	if draw_boton(a, 380, (grafic_luz ? L.pausa_desactivar : L.pausa_activar) + $" {L.pausa_iluminacion}", grafic_luz ? ui_verde : ui_rojo){
		grafic_luz = not grafic_luz
		ini_open("settings.ini")
			ini_write_real("", "grafic_luz", grafic_luz)
		ini_close()
	}
	if draw_boton(a, 420, (grafic_humo ? L.pausa_desactivar : L.pausa_activar) + $" {L.pausa_humo}", grafic_humo ? ui_verde : ui_rojo){
		grafic_humo = not grafic_humo
		ini_open("settings.ini")
			ini_write_real("", "grafic_humo", grafic_humo)
		ini_close()
	}
	if draw_boton(a, 460, (grafic_hideui ? L.pausa_desactivar : L.pausa_activar) + $" {L.pausa_UI}", grafic_hideui ? ui_rojo : ui_verde)
		grafic_hideui = not grafic_hideui
	if draw_boton(a, 500, (sonido ? L.pausa_desactivar : L.pausa_activar) + $" {L.pausa_sonido}", sonido ? ui_verde : ui_rojo)
		sound_change()
	if draw_boton(a, 540, (grafic_energia ? L.pausa_desactivar : L.pausa_activar) + $" {L.red_energia}", grafic_energia ? ui_verde : ui_rojo)
		grafic_energia = not grafic_energia
	if server = -1 and menu = 1{
		if draw_boton(a, 580, "Abrir en LAN")
			open_server()
	}
	else
		draw_text(a, 580, $"IP: {server}")
	if draw_boton(a, 620, L.salir, ui_rojo)
		if menu = 1{
			clear_edit()
			menu = 0
			pausa = 0
			cheat = false
			if server != -1{
				network_destroy(server)
				server = -1
				servidor = false
			}
			exit
		}
		else if menu = 3{
			clear_edit()
			menu = 2
			build_index = -1
			build_enemigo = false
			cheat = false
			pausa = 0
			draw_set_halign(fa_left)
			draw_set_color(color)
			exit
		}
	draw_set_halign(fa_left)
	if os_type == os_windows
		for(a = 0; a < idiomas; a++)
			if draw_sprite_boton(spr_bandera, a, 20 + 80 * a, 20, 64, 48,, function(data){draw_text_background(0, 80, idioma_name[data.a])}, {a : a}){
				idioma = a
				set_idioma()
			}
	draw_set_color(color)
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
		if size > 25
			deslizante[0] = floor(draw_deslizante_vertical(110, ypos, ypos + 25 * 20, deslizante[0], 0, size - 25, 0))
		for(var a = deslizante[0]; a < min(deslizante[0] + 25, size); a++){
			var pc = edificio.instruccion[a], pc0 = pc[0]
			xpos = 150
			draw_set_halign(fa_right)
			draw_text_xpos(xpos, ypos, ((edificio.select + 1) mod size = a ? ">" : "") + $"{a}|")
			draw_set_halign(fa_left)
			if draw_sprite_boton(spr_basura,, xpos, ypos, 20, 20,, function(){
				sprite_boton_text = L.procesador_borrar}){
				array_delete(edificio.instruccion, a, 1)
				size--
			}
			xpos += 20
			if draw_sprite_boton(spr_clonar,, xpos, ypos, 20, 20,, function(){
				sprite_boton_text = L.procesador_clonar}){
				var temp_array = []
				for(var c = 0; c < array_length(pc); c++)
					array_push(temp_array, pc[c])
				array_insert(edificio.instruccion, a + 1, temp_array)
			}
			xpos += 20
			if draw_sprite_boton(spr_flecha,, xpos, ypos, 20, 20,, function(){
				sprite_boton_text = L.procesador_subir})
				procesador_move = a
			xpos += 20
			if procesador_move >= 0 and mouse_y > ypos and mouse_y < ypos + text_y{
				draw_set_alpha(0.3)
				draw_rectangle(150, ypos, xpos, ypos + text_y, false)
				draw_set_alpha(1)
				if mouse_check_button_released(mb_left) and a != procesador_move{
					array_insert(edificio.instruccion, a, edificio.instruccion[procesador_move])
					array_delete(edificio.instruccion, procesador_move + 1, 1)
					procesador_move = -1
				}
			}
			//Continue
			if pc0 = 0
				draw_text(xpos, ypos, L.procesador_continue)
			//Set {A} to [VAR]{B}
			else if pc0 = 1{
				xpos = draw_text_xpos(xpos, ypos, $"{L.procesador_set} VAR_")
				pc[1] = procesador_var(xpos, ypos, pc, 1)
				xpos = draw_text_xpos(xpos + text_x, ypos, " to ")
				procesador_valor(xpos, ypos, pc, 2, 3, false)
			}
			//Set {A} to [sin, cos, tan, random, floor, round, ceil, sqr, sqrt, pi] [VAR]{B}
			else if pc0 = 2{
				var signs = ["sin", "cos", "tan", "random", "floor", "round", "ceil", "sqr", "sqrt", "pi"]
				xpos = draw_text_xpos(xpos, ypos, $"{L.procesador_set} VAR_")
				pc[1] = procesador_var(xpos, ypos, pc, 1)
				xpos = draw_text_xpos(xpos + text_x, ypos, $" {L.procesador_to} ")
				if draw_boton(xpos, ypos, $"{signs[pc[2]]}",,,, false)
					pc[2] = (pc[2] + 1) mod array_length(signs)
				if not in(signs[pc[2]], "pi"){
					xpos = draw_text_xpos(xpos + text_x, ypos, $" ")
					procesador_valor(xpos, ypos, pc, 3, 4)
				}
			}
			//Set {A} to [VAR]{B} [+, -, *, /, div, mod, or, and, xor, <<, >>, power] [VAR]{C}
			else if pc0 = 3{
				var signs = ["+", "-", "*", "/", "div", "mod", "or", "and", "xor", "<<", ">>", "power"]
				xpos = draw_text_xpos(xpos, ypos, $"{L.procesador_set} VAR_")
				pc[1] = procesador_var(xpos, ypos, pc, 1)
				xpos = draw_text_xpos(xpos + text_x, ypos, $" {L.procesador_to} ")
				procesador_valor(xpos, ypos, pc, 2, 3)
				xpos += text_x
				if draw_boton(xpos, ypos, $" {signs[pc[4]]} ",,,, false)
					pc[4] = (pc[4] + 1) mod array_length(signs)
				procesador_valor(xpos + text_x, ypos, pc, 5, 6)
			}
			//If [VAR]{A} [yes, no][<, >, =] [VAR]{B}, jump to [VAR]{C}
			else if pc0 = 4{
				var signs = ["<", ">", "="]
				xpos = draw_text_xpos(xpos, ypos, $"{L.procesador_if} ")
				procesador_valor(xpos, ypos, pc, 1, 2, false)
				xpos += text_x
				if draw_boton(xpos, ypos, pc[3] ? $" {L.procesador_is}" : $" {L.procesador_is_not}",,,, false)
					pc[3] = 1 - pc[3]
				xpos += text_x
				if draw_boton(xpos, ypos, $" {signs[pc[4]]} ",,,, false)
					pc[4] = (pc[4] + 1) mod 3
				xpos += text_x
				procesador_valor(xpos, ypos, pc, 5, 6, false)
				xpos = draw_text_xpos(xpos + text_x, ypos, $", {L.procesador_jump} ")
				procesador_valor(xpos, ypos, pc, 7, 8, true)
				if not pc[7]
					pc[8] = clamp(pc[8], 0, size)
				xpos += text_x
				var val = 0, flag = true
				if pc[7] = 0{
					if is_real(edificio.variables[pc[8]])
						val = real(edificio.variables[pc[8]])
					else
						flag = false
				}
				else
					val = real(pc[8])
				if flag and a != val{
					draw_set_color(make_color_hsv((49 * b) mod 255, 127, 127))
					draw_rectangle(xpos, ypos + 8, xpos + 10 + 10 * ++b, ypos + 12, false)
					draw_rectangle(xpos + 8 + 10 * b, ypos + 12, xpos + 10 + 10 * b, 150 + val * 20, false)
					draw_rectangle(xpos, 148 + val * 20, xpos + 10 + 10 * b, 152 + val * 20, false)
					draw_set_color(c_white)
				}
			}
			//Set VAR_{A} to [eneabled, carga, etc...][VAR]{B} from LINK[VAR]{C}
			else if pc0 = 5{
				var signs = ["eneabled", "carga", "líquido tipo", "líquido almacen", "líquido capacidad", "líquido produccion", "líquido consumo", "energía almacenada", "energía capacidad", "energía producida", "energía consumida"]
				var signs_subindex = [false, true, false, false, false, false, false, false, false, false, false]
				xpos = draw_text_xpos(xpos, ypos, $"{L.procesador_set} VAR_")
				pc[1] = procesador_var(xpos, ypos, pc, 1)
				xpos = draw_text_xpos(xpos + text_x, ypos, $" {L.procesador_to} ")
				if draw_boton(xpos, ypos, signs[pc[2]],,,, false)
					pc[2] = (pc[2] + 1) mod array_length(signs)
				xpos += text_x
				if signs_subindex[pc[2]]{
					xpos = draw_text_xpos(xpos, ypos, "[")
					procesador_valor(xpos, ypos, pc, 3, 4, true)
					xpos = draw_text_xpos(xpos + text_x, ypos, "]")
				}
				xpos = draw_text_xpos(xpos, ypos, $" {L.procesador_from} LINK_")
				procesador_valor(xpos, ypos, pc, 5, 6, true)
			}
			//Control LINK[VAR]{A} to set [Eneable] to [VAR]{B}
			else if pc0 = 6{
				var signs = ["Eneabled"]
				xpos = draw_text_xpos(xpos, ypos, $"{L.procesador_control} LINK_")
				procesador_valor(xpos, ypos, pc, 1, 2, true)
				xpos = draw_text_xpos(xpos + text_x, ypos, $" {L.procesador_to_set} ")
				if draw_boton(xpos, ypos, signs[pc[3]],,,, false)
					pc[3] = (pc[3] + 1) mod array_length(signs)
				xpos = draw_text_xpos(xpos + text_x, ypos, $" {L.procesador_to} ")
				procesador_valor(xpos, ypos, pc, 4, 5, false)
			}
			//Set VAR_{A} to value of cell [VAR]{B} of LINK[VAR]{C}
			else if pc0 = 7{
				xpos = draw_text_xpos(xpos, ypos, $"{L.procesador_set} VAR_")
				pc[1] = procesador_var(xpos, ypos, pc, 1)
				xpos = draw_text_xpos(xpos + text_x, ypos, $" {L.procesador_to_value_of_cell} ")
				procesador_valor(xpos, ypos, pc, 2, 3, true)
				xpos = draw_text_xpos(xpos + text_x, ypos, $" {L.procesador_from} LINK_")
				procesador_valor(xpos, ypos, pc, 4, 5, true)
			}
			//Write [VAR]{A} into value of cell [VAR]{B} of LINK[VAR]{c}
			else if pc0 = 8{
				xpos = draw_text_xpos(xpos, ypos, $"{L.procesador_write} ")
				procesador_valor(xpos, ypos, pc, 1, 2, false)
				xpos = draw_text_xpos(xpos + text_x, ypos, $" {L.procesador_into_value_of_cell} ")
				procesador_valor(xpos, ypos, pc, 3, 4, true)
				xpos = draw_text_xpos(xpos + text_x, ypos, $" {L.procesador_of} LINK_")
				procesador_valor(xpos, ypos, pc, 5, 6, true)
			}
			//Draw to LINK[VAR]{B} [clear(), color(r, g, b), color(h, s, v), rectangle(x, y, w, h), line(x1, y1, x2, y2), triangle(x1, y1, x2, y2, x3, y3), circle(x, y, radio), draw_flush()]
			else if pc0 = 9{
				var signs = ["Clear", "Color grb", "Color hsv", "Rectangle", "Line", "Triangle", "Circle", "Texto", "Draw_flush"]
				xpos = draw_text_xpos(xpos, ypos, $"{L.procesador_write} {L.procesador_to} LINK_")
				procesador_valor(xpos, ypos, pc, 1, 2, true)
				xpos += text_x
				if draw_boton(xpos, ypos, $" {signs[pc[3]]}",,,, false){
					if pc[3] = 7{
						pc[8] = 0
						pc[9] = 0
					}
					pc[3] = (pc[3] + 1) mod array_length(signs)
				}
				if pc[3] = 0
					xpos = draw_text_xpos(xpos + text_x, ypos, "()")
				else if pc[3] = 1{
					xpos = draw_text_xpos(xpos + text_x, ypos, "(R:")
					procesador_valor(xpos, ypos, pc, 4, 5, true)
					xpos = draw_text_xpos(xpos + text_x, ypos, ", G:")
					procesador_valor(xpos, ypos, pc, 6, 7, true)
					xpos = draw_text_xpos(xpos + text_x, ypos, ", B:")
					procesador_valor(xpos, ypos, pc, 8, 9, true)
					xpos = draw_text_xpos(xpos + text_x, ypos, ")")
				}
				else if pc[3] = 2{
					xpos = draw_text_xpos(xpos + text_x, ypos, "(H:")
					procesador_valor(xpos, ypos, pc, 4, 5, true)
					xpos = draw_text_xpos(xpos + text_x, ypos, ", S:")
					procesador_valor(xpos, ypos, pc, 6, 7, true)
					xpos = draw_text_xpos(xpos + text_x, ypos, ", V:")
					procesador_valor(xpos, ypos, pc, 8, 9, true)
					xpos = draw_text_xpos(xpos + text_x, ypos, ")")
				}
				else if pc[3] = 3{
					xpos = draw_text_xpos(xpos + text_x, ypos, "(X:")
					procesador_valor(xpos, ypos, pc, 4, 5, true)
					xpos = draw_text_xpos(xpos + text_x, ypos, ", Y:")
					procesador_valor(xpos, ypos, pc, 6, 7, true)
					xpos = draw_text_xpos(xpos + text_x, ypos, ", width:")
					procesador_valor(xpos, ypos, pc, 8, 9, true)
					xpos = draw_text_xpos(xpos + text_x, ypos, ", height:")
					procesador_valor(xpos, ypos, pc, 10, 11, true)
					xpos = draw_text_xpos(xpos + text_x, ypos, ")")
				}
				else if pc[3] = 4{
					xpos = draw_text_xpos(xpos + text_x, ypos, "(X1:")
					procesador_valor(xpos, ypos, pc, 4, 5, true)
					xpos = draw_text_xpos(xpos + text_x, ypos, ", Y1:")
					procesador_valor(xpos, ypos, pc, 6, 7, true)
					xpos = draw_text_xpos(xpos + text_x, ypos, ", X2:")
					procesador_valor(xpos, ypos, pc, 8, 9, true)
					xpos = draw_text_xpos(xpos + text_x, ypos, ", Y2:")
					procesador_valor(xpos, ypos, pc, 10, 11, true)
					xpos = draw_text_xpos(xpos + text_x, ypos, ")")
				}
				else if pc[3] = 5{
					xpos = draw_text_xpos(xpos + text_x, ypos, "(X1:")
					procesador_valor(xpos, ypos, pc, 4, 5, true)
					xpos = draw_text_xpos(xpos + text_x, ypos, ", Y1:")
					procesador_valor(xpos, ypos, pc, 6, 7, true)
					xpos = draw_text_xpos(xpos + text_x, ypos, ", X2:")
					procesador_valor(xpos, ypos, pc, 8, 9, true)
					xpos = draw_text_xpos(xpos + text_x, ypos, ", Y2:")
					procesador_valor(xpos, ypos, pc, 10, 11, true)
					xpos = draw_text_xpos(xpos + text_x, ypos, ", X3:")
					procesador_valor(xpos, ypos, pc, 12, 13, true)
					xpos = draw_text_xpos(xpos + text_x, ypos, ", Y3:")
					procesador_valor(xpos, ypos, pc, 14, 15, true)
					xpos = draw_text_xpos(xpos + text_x, ypos, ")")
				}
				else if pc[3] = 6{
					xpos = draw_text_xpos(xpos + text_x, ypos, "(X:")
					procesador_valor(xpos, ypos, pc, 4, 5, true)
					xpos = draw_text_xpos(xpos + text_x, ypos, ", Y:")
					procesador_valor(xpos, ypos, pc, 6, 7, true)
					xpos = draw_text_xpos(xpos + text_x, ypos, ", radio:")
					procesador_valor(xpos, ypos, pc, 8, 9, true)
					xpos = draw_text_xpos(xpos + text_x, ypos, ")")
				}
				else if pc[3] = 7{
					xpos = draw_text_xpos(xpos + text_x, ypos, "(X:")
					procesador_valor(xpos, ypos, pc, 4, 5, true)
					xpos = draw_text_xpos(xpos + text_x, ypos, ", Y:")
					procesador_valor(xpos, ypos, pc, 6, 7, true)
					xpos = draw_text_xpos(xpos + text_x, ypos, ", text:")
					procesador_valor(xpos, ypos, pc, 8, 9, false)
					xpos = draw_text_xpos(xpos + text_x, ypos, ")")
				}
				else if pc[3] = 8
					xpos = draw_text_xpos(xpos + text_x, ypos, "()")
			}
			ypos += 20
		}
		if deslizante[0] + 25 < size and mouse_wheel_down()
			deslizante[0]++
		if deslizante[0] > 0 and mouse_wheel_up()
			deslizante[0]--
		xpos = 150
		if draw_boton(xpos, ypos, L.procesador_add, ui_azul,,, false) or keyboard_check_pressed(vk_enter){
			keyboard_clear(vk_enter)
			procesador_add = true
			input_layer = 1
		}
		if procesador_add{
			var width = 0
			for(var a = 0; a < array_length(procesador_instrucciones_length); a++)
				width = max(width, string_width($"{procesador_instrucciones_nombre[a]} ({a})"))
			draw_set_color(c_gray)
			draw_rectangle((room_width - width) / 2, 200, (room_width + width) / 2, 200 + 20 * array_length(procesador_instrucciones_length), false)
			draw_set_color(c_white)
			draw_rectangle((room_width - width) / 2, 200, (room_width + width) / 2, 200 + 20 * array_length(procesador_instrucciones_length), true)
			draw_set_halign(fa_center)
			for(var a = 0; a < array_length(procesador_instrucciones_length); a++)
				if draw_boton(room_width / 2, 200 + 20 * a, $"{procesador_instrucciones_nombre[a]} ({a})",,,, false, 1) or keyboard_check_pressed(ord(string(a))){
					var new_instruccion = array_create(procesador_instrucciones_length[a], 0)
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
			save_codes = scan_files("*.code", fa_none)
			get_file = 1
			input_layer = 1
			keyboard_clear(ord("S"))
		}
		if browser and draw_boton(room_width - 120, 560, L.procesador_cargar, ui_azul,,, false) or (keyboard_check(vk_control) and keyboard_check_pressed(ord("A"))){
			save_codes = scan_files("*.code", fa_none)
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
						ini_open(save_codes[a])
						size = ini_read_real("Largo", "", 0)
						edificio.instruccion = array_create(size, [])
						for(b = 0; b < size; b++){
							var size_2 = ini_read_real("Largo", b, 0)
							edificio.instruccion[b] = array_create(size_2)
							for(var c = 0; c < size_2; c++){
								var val = ini_read_string(string(b), string(c), "0")
								if string_digits(val) = val and val != ""
									array_set(edificio.instruccion[b], c, real(val))
								else
									array_set(edificio.instruccion[b], c, string(val))
							}
						}
						ini_close()
						edificio.select = 0
					}
			}
			//Guardar
			else{
				var flag = false
				for(var a = 0; a < array_length(save_codes); a++)
					if draw_boton(140, 160 + 30 * a, save_codes[a],,,,, 1){
						save_file = save_codes[a]
						if string_count(".code", save_file)
							save_file = string_delete(save_file, string_pos(".code", save_file), string_length(save_file))
						flag = true
					}
				save_file = string(draw_boton_text(140, 160 + 30 * (array_length(save_codes) + 1), save_file, false,,, 1))
				draw_text(140 + text_x, 160 + 30 * (array_length(save_codes) + 1), ".code")
				input_layer = 1
				if save_file != "" and (draw_boton(120, 160 + 30 * array_length(save_codes), L.nuevo_archivo,,,,, 1) or keyboard_check_pressed(vk_enter)){
					keyboard_clear(vk_enter)
					save_file += ".code"
					flag = true
					input_layer = 0
					get_file = 0
				}
				if flag{
					ini_open(save_file)
					ini_write_real("Largo", "", size)
					for(var a = 0; a < size; a++){
						var size_2 = array_length(edificio.instruccion[a])
						ini_write_real("Largo", a, size_2)
						for(b = 0; b < size_2; b++)
							ini_write_string(string(a), string(b), string(edificio.instruccion[a, b]))
					}
					ini_close()
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
		var aa = abtoxy(edificio.a, edificio.b).a * zoom - camx
		var bb = abtoxy(edificio.a, edificio.b).b * zoom - camy
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
			var temp_array = index = id_fabrica_de_drones ? [idd_mula, idd_kamikaze] : [idd_reparador, idd_helicoptero, idd_bombardero], len = array_length(temp_array)
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
			var temp_array = index = id_fabrica_de_drones ? [idd_mula, idd_kamikaze] : [idd_reparador, idd_helicoptero, idd_bombardero], len = array_length(temp_array)
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
			if mouse_check_button_pressed(mb_right)
				if edificio.array_real[0] = -1{
					edificio.array_real[0] = xmouse
					edificio.array_real[1] = ymouse
				}
				else{
					edificio.array_real[0] = -1
					edificio.array_real[1] = -1
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
				var temp_array = index = id_fabrica_de_drones ? [idd_mula, idd_kamikaze] : [idd_reparador, idd_helicoptero, idd_bombardero], len = array_length(temp_array)
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
var temp_complex_mouse = xytoab(xmouse, ymouse), mx = temp_complex_mouse.a, my = temp_complex_mouse.b, outside = false
if mx < 0 or my < 0 or mx >= xsize or my >= ysize{
	outside = true
	mx = clamp(mx, 0, xsize - 1)
	my = clamp(my, 0, ysize - 1)
}
var prev_change = false
if mx != prev_x or my != prev_y{
	prev_x = mx
	prev_y = my
	prev_change = true
}
var edificio = edificio_id[# mx, my], temp_coordenada = edificio.coordenadas
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
		if edificio.enemigo and menu = 1 and not cheat
			temp_text += "ENEMIGO\n"
		else{
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
					}
					procesador_select = null_edificio
				}
				else if edificio_seteable[index] or in(index, id_procesador, id_memoria, id_deposito){
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
						if puerto_carga_link.link != null_edificio{
							if puerto_carga_link.receptor
								array_disorder_remove(puerto_carga_array, puerto_carga_link, 2)
							else
								array_disorder_remove(puerto_carga_array, puerto_carga_link.link, 2)
							if puerto_carga_atended >= array_length(puerto_carga_array)
								puerto_carga_atended = 0
							puerto_carga_link.link.receptor = false
							puerto_carga_link.link.emisor = false
							calculate_in_out_2(puerto_carga_link.link)
							puerto_carga_link.link.link = null_edificio
						}
						puerto_carga_link.receptor = true
						puerto_carga_link.emisor = false
						puerto_carga_link.link = edificio
						calculate_in_out(puerto_carga_link)
						calculate_in_out_2(puerto_carga_link, false)
						if edificio.link != null_edificio{
							if edificio.receptor
								array_disorder_remove(puerto_carga_array, edificio, 2)
							else
								array_disorder_remove(puerto_carga_array, edificio.link, 2)
							if puerto_carga_atended >= array_length(puerto_carga_array)
								puerto_carga_atended = 0
							edificio.link.receptor = false
							edificio.link.emisor = false
							calculate_in_out_2(edificio.link)
							edificio.link.link = null_edificio
						}
						edificio.receptor = false
						edificio.emisor = true
						edificio.link = puerto_carga_link
						calculate_in_out(edificio)
						calculate_in_out_2(edificio, false)
						array_disorder_push(puerto_carga_array, puerto_carga_link, 2)
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
					for(var a = ds_list_size(edificio.coordenadas) - 1; a >= 0; a--){
						var temp_complex = edificio.coordenadas[|a], aa = temp_complex.a, bb = temp_complex.b
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
					for(var a = ds_list_size(temp_array_coord) - 1; a >= 0; a--){
						var temp_complex = temp_array_coord[|a], aa = temp_complex.a, bb = temp_complex.b
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
			if grafic_array_mostrar_combustion[index]
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
						var temp_coord_2 = abtoxy(chunk_width * (temp_coord.a + 1), chunk_height * (temp_coord.b + 1))
						temp_coord = abtoxy(chunk_width * temp_coord.a, chunk_height * temp_coord.b)
						draw_rectangle_off(temp_coord.a, temp_coord.b, temp_coord_2.a, temp_coord_2.b, false)
					}
					draw_set_color(c_red)
					var temp_coord = abtoxy(chunk_width * edificio.chunk_x, chunk_height * edificio.chunk_y)
					draw_rectangle_off(temp_coord.a, temp_coord.b, temp_coord.a + chunk_width * 48, temp_coord.b + chunk_height * 14, false)
					draw_set_alpha(1)
				}
			}
			//Mostrar rutas de tuneles
			if in(index, id_tunel, id_tunel_salida){
				if keyboard_check_pressed(ord("R")) and edificio.link != null_edificio{
					keyboard_clear(ord("R"))
					if edificio.index = 16{
						edificio.index = 6
						edificio.link.index = 16
						calculate_in_out(edificio)
						calculate_in_out(edificio.link)
						calculate_in_out_2(edificio)
						calculate_in_out_2(edificio.link)
						array_push(edificio.outputs, edificio.link)
						array_push(edificio.link.inputs, edificio)
					}
					else{
						edificio.index = 16
						edificio.link.index = 6
						calculate_in_out(edificio)
						calculate_in_out(edificio.link)
						calculate_in_out_2(edificio)
						calculate_in_out_2(edificio.link)
						array_push(edificio.inputs, edificio.link)
						array_push(edificio.link.outputs, edificio)
					}
					set_camino_dir(edificio)
					set_camino_dir(edificio.link)
				}
			}
			else if grafic_array_dron_encima[index]{
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
					if edificio.select >= 0
						temp_text += $"{L.almacen_consumiendo} {dron_nombre[edificio.select]}: {floor(100 * edificio.proceso / dron_time[edificio.select])}%\n"
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
				if edificio_proceso[index] > 1
					temp_text += $"{L.almacen_proceso}: {floor(edificio.proceso)}/{edificio_proceso[index]}\n"
				temp_text += $"select: {edificio.select}, mode: {edificio.mode}, fuel: {edificio.fuel}\n"
			}
		}
	}
	//Reconstruir edificios
	else if keyboard_check(ord("Q")){
		var b = repair_id[# mx, my], temp_text_2 = ""
		if b > 0{
			var comprable = true
			if not cheat{
				for(var a = 0; a < array_length(edificio_precio_id[b]); a++)
					if nucleo.carga[edificio_precio_id[b, a]] < edificio_precio_num[b, a]{
						comprable = false
						temp_text_2 += $"  {recurso_nombre[edificio_precio_id[b, a]]} {nucleo.carga[edificio_precio_id[b, a]]}/{edificio_precio_num[b, a]}\n"
					}
				if not comprable
					temp_text_2 = $"{L.construir_recursos_insuficientes}\n" + temp_text_2
				draw_set_color(c_red)
				var flag_3 = false, size_2 = array_length(enemigos)
				for(var a = 0; a < size_2; a++){
					var enemigo = enemigos[a]
					draw_circle_off(enemigo.x, enemigo.y, 100, true)
					if not flag_3 and (sqr(mouse_x - enemigo.x + camx) + sqr(mouse_y - enemigo.y + camy)) < 10000{//100^2
						temp_text_2 += $"{L.construir_enemigos_cerca}\n"
						comprable = false
						flag_3 = true
					}
				}
				draw_set_color(c_white)
			}
			if not comprable{
				var temp_complex = abtoxy(mx, my)
				draw_sprite_off(spr_rojo, 0, temp_complex.a, temp_complex.b,,,,, 0.5)
				draw_text_background_off(temp_complex.a + 20, temp_complex.b, temp_text_2)
			}
			else if mouse_check_button(mb_left){
				var temp_edificio = construir(b, repair_dir[# mx, my], mx, my)
				if edificio_seteable[b]
					set_edificio(repair_mode[# mx, my], repair_select[# mx, my], temp_edificio)
			}
			if mouse_check_button(mb_right)
				ds_grid_set(repair_id, mx, my, -1)
		}
	}
	//Seleccionar drones
	else if mouse_check_button_pressed(mb_left) and build_index = 0{
		mx_clic = xmouse
		my_clic = ymouse
		clicked = true
	}
	if mouse_check_button(mb_left) and clicked and build_index = 0 and not keyboard_check(ord("Q")){
		draw_set_alpha(0.5)
		draw_set_color(c_black)
		draw_rectangle_off(mx_clic, my_clic, xmouse, ymouse, false)
		draw_set_color(c_white)
		var minx = min(mx_clic, xmouse), miny = min(my_clic, ymouse), maxx = max(mx_clic, xmouse), maxy = max(my_clic, ymouse)
		for(var a = array_length(drones_aliados) - 1; a >= 0; a--){
			var dron = drones_aliados[a]
			if in(dron.index, idd_kamikaze, idd_helicoptero, idd_bombardero){
				var xx = dron.x, yy = dron.y
				if xx > minx and yy > miny and xx < maxx and yy < maxy
					draw_circle_off(xx, yy, 30, true)
			}
		}
		draw_set_alpha(1)
	}
	if mouse_check_button_released(mb_left) and clicked and build_index = 0{
		deselect_drones()
		var minx = min(mx_clic, xmouse), miny = min(my_clic, ymouse), maxx = max(mx_clic, xmouse), maxy = max(my_clic, ymouse)
		for(var a = array_length(drones_aliados) - 1; a >= 0; a--){
			var dron = drones_aliados[a]
			if in(dron.index, idd_kamikaze, idd_helicoptero, idd_bombardero){
				var xx = dron.x, yy = dron.y
				if xx > minx and yy > miny and xx < maxx and yy < maxy{
					array_push(selected_drones, dron)
					dron.selected = true
				}
			}
		}
		clicked = false
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
		if dron.modo = 1
			draw_sprite_off(spr_target, 0, dron.array_real[3], dron.array_real[4])
		if right_clicked and in(dron.index, 3, 5, 7){
			mouse_clear(mb_right)
			mover_dron(dron, xmouse, ymouse)
		}
	}
}
//Seleccionar target edificio
if puerto_carga_bool or (procesador_select != null_edificio) or (misil_set_target != null_edificio){
	draw_set_halign(fa_center)
	if puerto_carga_bool
		var temp_text = L.game_puerto_carga
	else if procesador_select != null_edificio
		temp_text = L.game_vincular_procesador
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
	for(var a = 0; a < sonidos_max; a++)
		volumen[a] = 0
#region Menú de edificios
	var just_pressed = false
	if mouse_check_button_pressed(mb_right) and build_index = 0 and not edificio_bool[# mx, my] and not keyboard_check(ord("Q")){
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
		var b = 2 * pi / array_length(categoria_nombre_disponible)
		draw_set_color(c_white)
		draw_circle(menu_x, menu_y, 100, true)
		draw_circle(menu_x, menu_y, 10, false)
		for(var a = 0; a < array_length(categoria_nombre_disponible); a++){
			var angle = a * b
			draw_sprite(spr_items, categoria_index_disponible[a], menu_x - 15 + 100 * cos(angle + b / 2), menu_y - 15 - 100 * sin(angle + b / 2))
			draw_line(menu_x, menu_y, menu_x + 100 * cos(angle), menu_y - 100 * sin(angle))
		}
		if distance_sqr(mouse_x, mouse_y, menu_x, menu_y) < 10000{//100^2
			var temp_text = ""
			var a = floor((array_length(categoria_nombre_disponible) - arctan2(mouse_y - menu_y, mouse_x - menu_x) / b) mod array_length(categoria_nombre_disponible))
			draw_set_alpha(0.5)
			draw_arco(menu_x, menu_y, 100, a * b, (a + 1) * b)
			draw_set_alpha(1)
			draw_sprite(spr_items, categoria_index_disponible[a], menu_x - 15 + 100 * cos((a + 0.5) * b), menu_y - 15 - 100 * sin((a + 0.5) * b))
			temp_text = categoria_nombre[categoria_index_disponible[a]]
			draw_text_background(min(room_width - string_width(temp_text), mouse_x + 20), min(room_height - string_height(temp_text), mouse_y), temp_text)
			if mouse_check_button_pressed(mb_left){
				mouse_clear(mb_left)
				build_menu = 2
				menu_array = categoria_edificios_disponible[a]
			}
		}
		else if mouse_check_button_pressed(mb_left){
			mouse_clear(mb_left)
			build_menu = 0
		}
	}
	else if build_menu = 2{
		var b = 2 * pi / array_length(menu_array)
		draw_set_color(c_white)
		draw_circle(menu_x, menu_y, 100, true)
		for(var a = 0; a < array_length(menu_array); a++){
			var angle = a * b, comprable = true, index = menu_array[a]
			draw_line(menu_x, menu_y, menu_x + 100 * cos(angle), menu_y - 100 * sin(angle))
			if not cheat{
				comprable = edificio_tecnologia[index] or not tecnologia
				if comprable
					for(var c = 0; c < array_length(edificio_precio_id[index]); c++)
						if nucleo.carga[edificio_precio_id[index, c]] < edificio_precio_num[index, c]{
							comprable = false
							break
						}
				if not comprable{
					draw_set_alpha(0.5)
					draw_set_color(c_red)
					draw_arco(menu_x, menu_y, 100, angle, angle + b)
					draw_set_alpha(1)
					draw_set_color(c_white)
				}
			}
			draw_sprite_stretched(edificio_sprite[index], 0, menu_x - 15 + 100 * cos(angle + b / 2), menu_y - 15 - 100 * sin(angle + b / 2), 30, 30)
		}
		draw_circle(menu_x, menu_y, 10, false)
		if distance_sqr(mouse_x, mouse_y, menu_x, menu_y) < 10000{//100^2
			var a = floor((array_length(menu_array) - arctan2(mouse_y - menu_y, mouse_x - menu_x) / b) mod array_length(menu_array))
			draw_set_alpha(0.5)
			draw_arco(menu_x, menu_y, 100, a * b, (a + 1) * b)
			draw_set_alpha(1)
			draw_sprite_stretched(edificio_sprite[menu_array[a]], 0, menu_x - 15 + 100 * cos((a + 0.5) * b), menu_y - 15 - 100 * sin((a + 0.5) * b), 30, 30)
			a = menu_array[a]
			var temp_text = $"{edificio_nombre[a]} (hotkey: {edificio_key[a]})\n"
			if not cheat{
				if tecnologia and not edificio_tecnologia[a]
					temp_text += "  Falta Tecnología\n"
				for(var c = 0; c < array_length(edificio_precio_id[a]); c++)
					temp_text += $"  {recurso_nombre[edificio_precio_id[a, c]]}: {edificio_precio_num[a, c]}\n"
			}
			temp_text += $"{edificio_descripcion[a]}\n"
			draw_text_background(min(room_width - string_width(temp_text), mouse_x + 20), min(room_height - string_height(temp_text), mouse_y), temp_text)
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
				}
			}
		}
		else if mouse_check_button_pressed(mb_left){
			mouse_clear(mb_left)
			build_menu = 1
		}
	}
#endregion
//Acceso directo
if keyboard_check_pressed(vk_anykey) and (not in(keyboard_lastchar, "A", "D", "W", "S", " ") or cheat) and win = 0 and not show_menu{
	for(var a = 1; a < edificio_max; a++)
		if edificio_key[a] != "" and string_ends_with(keyboard_string, edificio_key[a]) and (cheat or edificio_tecnologia[a] or not tecnologia){
			selected_dron = null_dron
			keyboard_string = ""
			build_index = a
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
if (mouse_check_button_pressed(mb_right) or keyboard_check_pressed(vk_escape)) and (build_index > 0 or show_menu) and selected_dron = null_dron{
	mouse_clear(mb_right)
	keyboard_clear(vk_escape)
	clear_edit()
}
//CONSTRUCCIÓN
if build_index > 0 and win = 0 and not just_pressed{
	if not edificio_rotable[build_index]
		build_dir = 0
	if edificio_size[build_index] mod 2 = 0
		build_dir = 5 * (build_dir mod 2)
	//Rotar
	if (edificio_rotable[build_index] or edificio_size[build_index] mod 2 = 0) and not keyboard_check(vk_lcontrol){
		if mouse_wheel_up() or keyboard_check_pressed(ord("R")){
			keyboard_clear(ord("R"))
			if not edificio_rotable[build_index] and edificio_size[build_index] mod 2 = 0
				build_dir = 5 - build_dir
			else
				build_dir = (build_dir + 1) mod 6
			prev_change = true
		}
		if mouse_wheel_down(){
			if not edificio_rotable[build_index] and edificio_size[build_index] mod 2 = 0
				build_dir = 5 - build_dir
			else
				build_dir = (build_dir + 5) mod 6
			prev_change = true
		}
	}
	if last_mx != mx or last_my != my or prev_change{
		build_list = get_size(mx, my, build_dir, edificio_size[build_index])
		if build_index = id_taladro_de_explosion
			build_list_arround = get_size(mx, my, build_dir, edificio_size[build_index] + 2)
		else if in(build_index, id_fabrica_de_drones, id_ensambladora, id_planta_de_reciclaje, id_fabrica_de_drones_grande, id_cinta_grande)
			build_list_arround = get_arround(mx, my, build_dir, edificio_size[build_index])
		else if build_index = id_cable
			build_list_arround = get_size(mx, my, 0, 7)
		show_menu = false
		build_array_edificios_input = array_create(0, null_edificio)
		build_array_edificios_output = array_create(0, null_edificio)
	}
	var comprable = true, temp_text = ""
	//Detectar si el terreno existe
	for(var a = ds_list_size(build_list) - 1; a >= 0; a--){
		var temp_complex_2 = build_list[|a], aa = temp_complex_2.a, bb = temp_complex_2.b
		if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize{
			comprable = false
			break
		}
	}
	if comprable and not outside{
		//Módulos
		if build_index = id_modulo{
			var temp_complex = abtoxy(mx, my)
			draw_sprite_off(spr_item_modulo, 0, temp_complex.a, temp_complex.b,,,,, 0.5)
			if edificio_bool[# mx, my]{
				var temp_edificio = edificio_id[# mx, my]
				if temp_edificio.enemigo = build_enemigo{
					var index = edificio.index, temp_precio_id = array_create(0, 0), temp_precio_num = array_create(0, 0), flag_2 = true
					#region Precios
						if in(index, id_taladro, id_torre_basica, id_bomba_hidraulica){
							temp_precio_id = [idr_modulos]
							temp_precio_num = [1]
						}
						else if in(index, id_rifle, id_lanzallamas, id_ensambladora, id_generador_geotermico, id_planta_desalinizadora, id_torre_reparadora, id_triturador, id_turbina){
							temp_precio_id = [idr_modulos, idr_silicio]
							temp_precio_num = [2, 2]
						}
						else if in(index, id_taladro_electrico, id_laser, id_mortero, id_fabrica_de_concreto, id_perforadora_de_petroleo, id_planta_de_reciclaje, , id_planta_quimica, id_refineria_de_metales){
							temp_precio_id = [idr_modulos, idr_electronicos]
							temp_precio_num = [3, 5]
						}
						else if in(index, id_onda_de_choque, id_fabrica_de_drones, id_fabrica_de_drones_grande, id_planta_de_enriquecimiento, id_planta_nuclear, id_refineria_de_petroleo, id_taladro_de_explosion){
							temp_precio_id = [idr_modulos, idr_electronicos, idr_uranio_bruto]
							temp_precio_num = [5, 5, 10]
						}
						else if index = id_nucleo{
							temp_precio_id = [idr_modulos, idr_electronicos, idr_plastico, idr_uranio_bruto]
							temp_precio_num = [20, 25, 40, 100]
						}
					#endregion
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
					if array_length(temp_precio_id) = 0{
						temp_text = L.modulo_edificio_sin_modulo
						flag_2 = false
					}
					else if temp_edificio.modulo{
						temp_text = L.modulo_edificio_con_modulo
						flag_2 = false
					}
					if flag_2{
						if not cheat 
							for(var a = array_length(temp_precio_id) - 1; a >= 0; a--){
								temp_text += $"  {recurso_nombre[temp_precio_id[a]]}: {temp_precio_num[a]}\n"
								if flag_2 and nucleo.carga[temp_precio_id[a]] < temp_precio_num[a]
									flag_2 = false
							}
						if not flag_2
							temp_text += $"{L.construir_recursos_insuficientes}\n"
						else if mouse_check_button_pressed(mb_left){
							if not cheat and not build_enemigo
								for(var a = array_length(temp_precio_id) - 1; a >= 0; a--)
									nucleo.carga[temp_precio_id[a]] -= temp_precio_num[a]
							temp_edificio.modulo = true
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
					if nucleo.carga[edificio_precio_id[build_index, a]] < edificio_precio_num[build_index, a]{
						comprable = false
						temp_text += $"  {recurso_nombre[edificio_precio_id[build_index, a]]} {nucleo.carga[edificio_precio_id[build_index, a]]}/{edificio_precio_num[build_index, a]}\n"
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
			var temp_complex = abtoxy(spawn_x, spawn_y), aaa = temp_complex.a, bbb = temp_complex.b
			draw_circle_off(aaa, bbb, 250, true)
			if distance_sqr(mouse_x, mouse_y, aaa * zoom - camx, bbb * zoom - camy) < 62500 * sqr(zoom){//(250 * zoom)^2
				temp_text += $"{L.construir_zona_enemigos}\n"
				comprable = false
			}
			for(var a = ds_list_size(build_list) - 1; a >= 0; a--){
				var temp_complex_2 = build_list[|a], aa = temp_complex_2.a, bb =  temp_complex_2.b
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
				for(var a = ds_list_size(build_list) - 1; a >= 0; a--){
					var temp_complex_2 = build_list[|a], aa = temp_complex_2.a, bb = temp_complex_2.b
					if terreno_liquido[terreno[# aa, bb]]{
						temp_text += $"{L.construir_terreno_invalido}\n"
						comprable = false
						break
					}
				}
			if build_index = id_bomba_de_evaporacion
				for(var a = ds_list_size(build_list) - 1; a >= 0; a--){
					var temp_complex_2 = build_list[|a], aa = temp_complex_2.a, bb = temp_complex_2.b
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
				for(var a = ds_list_size(build_list) - 1; a >= 0; a--){
					var temp_complex_2 = build_list[|a], aa = temp_complex_2.a, bb = temp_complex_2.b
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
						else if grafic_array_agua_salada[terreno[# aa, bb]]{
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
				for(var a = ds_list_size(build_list) - 1; a >= 0; a--){
					var temp_complex_2 = build_list[|a], aa = temp_complex_2.a, bb = temp_complex_2.b
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
				for(var a = ds_list_size(build_list) - 1; a >= 0; a--){
					var temp_complex_2 = build_list[|a], aa = temp_complex_2.a, bb = temp_complex_2.b
					if grafic_array_agua[terreno[# aa, bb]]{
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
				for(var a = ds_list_size(build_list) - 1; a >= 0; a--){
					var temp_complex_2 = build_list[|a], aa = temp_complex_2.a, bb = temp_complex_2.b, b = terreno[# aa, bb]
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
				for(var a = ds_list_size(build_list) - 1; a >= 0; a--){
					var temp_complex_2 = build_list[|a], aa = temp_complex_2.a, bb = temp_complex_2.b
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
					for(var a = ds_list_size(build_list) - 1; a >= 0; a--){
						var temp_complex_2 = build_list[|a], aa = temp_complex_2.a, bb = temp_complex_2.b
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
				for(var a = ds_list_size(build_list_arround) - 1; a >= 0; a--){
					var temp_complex_2 = build_list_arround[|a], aa = temp_complex_2.a, bb = temp_complex_2.b
					if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
						continue
					var temp_complex_3 = abtoxy(aa, bb)
					draw_sprite_off(spr_blanco, 0, temp_complex_3.a, temp_complex_3.b,,,,, 0.5)
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
				for(var a = ds_list_size(build_list) - 1; a >= 0; a--){
					var temp_complex_2 = build_list[|a], aa = temp_complex_2.a, bb = temp_complex_2.b
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
			else for(var a = ds_list_size(build_list) - 1; a >= 0; a--){
				var temp_complex_2 = build_list[|a], aa  = temp_complex_2.a, bb = temp_complex_2.b
				if edificio_bool[# aa, bb]{
					temp_text += $"{L.construir_ocupado}\n"
					comprable = false
					break
				}
			}
			//No se puede construir
			if not comprable{
				var temp_complex_2 = abtoxy(mx, my)
				draw_edificio(temp_complex_2.a, temp_complex_2.b, build_index, build_dir, 0.5, build_enemigo)
				for(var a = ds_list_size(build_list) - 1; a >= 0; a--){
					temp_complex_2 = build_list[|a]
					var temp_complex_3 = abtoxy(temp_complex_2.a, temp_complex_2.b)
					draw_sprite_off(spr_rojo, 0, temp_complex_3.a, temp_complex_3.b,,,,, 0.5)
				}
				draw_text_background(min(room_width - string_width(temp_text), mouse_x + 20), min(room_height - string_height(temp_text), mouse_y), temp_text)
			}
			//Sí se puede construir
			else{
				temp_complex = abtoxy(mx, my)
				if not (mouse_check_button(mb_left) and (edificio_camino[build_index] or build_index = id_tuberia))
					draw_edificio(temp_complex.a, temp_complex.b, build_index, build_dir, 0.5, build_enemigo)
				var temp_array, temp_array_2, flag_camino = true
				//Vista previa caminos
				if edificio_camino[build_index] or in(build_index, id_tuberia, id_muro){
					//Iniciar arrastre
					if mouse_check_button_pressed(mb_left){
						mx_clic = mx
						my_clic = my
						clicked = true
					}
					//Arrastre
					if mouse_check_button(mb_left){
						pre_build_list = [{a : mx_clic, b : my_clic}]
						pre_build_list_cruce = [false]
						var temp_complex_2 = abtoxy(mx_clic, my_clic), aa = temp_complex_2.a, bb = temp_complex_2.b
						draw_edificio(aa, bb, build_index, build_dir, 0.5, build_enemigo)
						if mx_clic != mx or my_clic != my{
							var angle = radtodeg((arctan2(bb * zoom - camy - mouse_y, mouse_x - aa * zoom + camx) + 2 * pi) mod (2 * pi))
							if (last_mx != mx or last_my != my) and edificio_camino[build_index]
								build_dir = floor(angle / 60)
							build_dir_camino = floor(angle / 60)
							var a = mx_clic, b = my_clic, temp_complex_3
							do{
								temp_complex_3 = next_to(a, b, build_dir_camino)
								array_push(pre_build_list, temp_complex_3)
								a = temp_complex_3.a
								b = temp_complex_3.b
								temp_complex_3 = abtoxy(a, b)
								aaa = temp_complex_3.a
								bbb = temp_complex_3.b
								if in(build_index, id_cinta_transportadora, id_cinta_magnetica) and (a != mx or b != my) and (a != mx_clic or b != my_clic) and edificio_bool[# a, b] and not in(edificio_id[# a, b].dir, build_dir, (build_dir + 3) mod 6) and in(edificio_id[# a, b].index, id_cinta_transportadora, id_cinta_magnetica){
									draw_edificio(aaa, bbb, id_cruce, 0, 0.5, build_enemigo)
									array_push(pre_build_list_cruce, true)
								}
								else{
									draw_edificio(aaa, bbb, build_index, build_dir, 0.5, build_enemigo)
									array_push(pre_build_list_cruce, false)
								}
							}
							until(temp_complex_3.a < min(xmouse, aa) or temp_complex_3.a > max(xmouse, aa) or temp_complex_3.b < min(ymouse, bb) or temp_complex_3.b > max(ymouse, bb))
						}
					}
					//Mostrar caminos solos
					else{
						temp_complex = next_to(mx, my, build_dir)
						var temp_complex_2 = abtoxy(mx, my), aa = temp_complex_2.a, bb = temp_complex_2.b
						var temp_complex_3 = abtoxy(temp_complex.a, temp_complex.b)
						if not in(build_index, id_tuberia, id_muro){
							draw_set_color(c_black)
							draw_arrow_off(aa, bb, temp_complex_3.a, temp_complex_3.b, 8)
						}
						if in(build_index, id_enrutador, id_selector, id_overflow){
							temp_complex = next_to(mx, my, (build_dir + 1) mod 6)
							temp_complex_3 = abtoxy(temp_complex.a, temp_complex.b)
							draw_arrow_off(aa, bb, temp_complex_3.a, temp_complex_3.b, 8)
							temp_complex = next_to(mx, my, (build_dir + 5) mod 6)
							temp_complex_3 = abtoxy(temp_complex.a, temp_complex.b)
							draw_arrow_off(aa, bb, temp_complex_3.a, temp_complex_3.b, 8)
						}
					}
					//Construir en cadena
					if mouse_check_button_released(mb_left) and clicked{
						flag_camino = false
						clicked = false
						for(var a = 0; a < array_length(pre_build_list); a++){
							comprable = true
							if not cheat
								for(var b = array_length(edificio_precio_id[build_index]) - 1; b >= 0; b--)
									if nucleo.carga[edificio_precio_id[build_index, b]] < edificio_precio_num[build_index, b]{
										comprable = false
										break
									}
							if in(build_index, id_tuberia, id_muro)
								build_dir = 0
							if comprable{
								var temp_complex_2 = pre_build_list[a]
								if edificio_camino[build_index] and pre_build_list_cruce[a]
									construir(id_cruce, 0, temp_complex_2.a, temp_complex_2.b, build_enemigo)
								else
									construir(build_index, build_dir, temp_complex_2.a, temp_complex_2.b, build_enemigo)
							}
						}
					}
				}
				//Cables
				else if build_index = id_cable{
					//Empezar a construir
					if mouse_check_button_pressed(mb_left){
						mx_clic = mx
						my_clic = my
						clicked = true
					}
					//Dibujar nodos cercanos
					var temp_complex_2 = abtoxy(mx, my), aa = temp_complex_2.a, bb = temp_complex_2.b
					draw_circle_off(aa, bb, 90, true)
					for(var a = ds_list_size(build_list_arround) - 1; a >= 0; a--){
						var temp_complex_3 = build_list_arround[|a], aaaa = temp_complex_3.a, bbbb = temp_complex_3.b
						if aaaa < 0 or bbbb < 0 or aaaa >= xsize or bbbb >= ysize
							continue
						if (aaaa != mx or bbbb != my) and edificio_bool[# aaaa, bbbb]{
							var temp_edificio = edificio_id[# aaaa, bbbb]
							if temp_edificio.enemigo = build_enemigo and edificio_energia[temp_edificio.index] and distance_sqr(aa, bb, temp_edificio.center_x, temp_edificio.center_y) <= 8100//90^2
								draw_line_off(aa, bb, temp_edificio.center_x, temp_edificio.center_y)
						}
					}
					//Extender
					if mouse_check_button(mb_left){
						pre_build_list = [{a : mx_clic, b : my_clic}]
						temp_complex_2 = abtoxy(mx_clic, my_clic)
						aa = temp_complex_2.a
						bb = temp_complex_2.b
						var mxc = mx_clic, myc = my_clic
						draw_edificio(aa, bb, build_index, build_dir, 0.5, build_enemigo)
						if mx_clic != mx or my_clic != my{
							var temp_complex_3 = abtoxy(mx, my), aaaa = temp_complex_3.a, bbbb = temp_complex_3.b
							var dir = (360 + point_direction(aa, bb, aaaa, bbbb)) mod 360, dis = point_distance(aa, bb, aaaa, bbbb), flag_2 = false
							for(var a = 0; a < floor(dis / 70); a++){
								repeat(3){
									var temp_complex_4 = next_to(mxc, myc, floor(dir / 60))
									var temp_complex_6 = abtoxy(temp_complex_4.a, temp_complex_4.b)
									var temp_dis = point_distance(temp_complex_6.a, temp_complex_6.b, aaaa, bbbb)
									var temp_complex_5 = next_to(mxc, myc, ceil(dir / 60))
									var temp_complex_7 = abtoxy(temp_complex_5.a, temp_complex_5.b)
									var temp_dis_2 = point_distance(temp_complex_7.a, temp_complex_7.b, aaaa, bbbb)
									if temp_dis > temp_dis_2{
										temp_complex_4 = temp_complex_5
										temp_dis = temp_dis_2
									}
									mxc = temp_complex_4.a
									myc = temp_complex_4.b
									if mxc < 0 or myc < 0 or mxc >= xsize or myc >= ysize
										break
									temp_complex_4 = abtoxy(mxc, myc)
									dir = point_direction(temp_complex_4.a, temp_complex_4.b, aaaa, bbbb)
									if temp_dis = 0{
										flag_2 = true
										break
									}
								}
								if mxc < 0 or myc < 0 or mxc >= xsize or myc >= ysize
									break
								array_push(pre_build_list, {a : mxc, b : myc})
								temp_complex_3 = abtoxy(mxc, myc)
								draw_edificio(temp_complex_3.a, temp_complex_3.b, build_index, 0, 0.5, build_enemigo)
								if edificio_bool[# mxc, myc] or not terreno_caminable[terreno[# mxc, myc]]
									draw_sprite_off(spr_rojo, 0, temp_complex_3.a, temp_complex_3.b,,,,, 0.5)
								if flag_2
									break
							}
							if not (mxc = mx and myc = my)
								array_push(pre_build_list, {a : mx, b : my})
							draw_text(mouse_x, mouse_y + 20, temp_text)
						}
					}
					//Construir
					if mouse_check_button_released(mb_left) and clicked{
						flag_camino = false
						clicked = false
						for(var a = 0; a < array_length(pre_build_list); a++){
							comprable = true
							if not cheat
								for(var b = array_length(edificio_precio_id[build_index]) - 1; b >= 0; b--)
									if nucleo.carga[edificio_precio_id[build_index, b]] < edificio_precio_num[build_index, b]{
										comprable = false
										break
									}
							if comprable{
								temp_complex_2 = pre_build_list[a]
								construir(build_index, build_dir, temp_complex_2.a, temp_complex_2.b, build_enemigo)
							}
						}
					}
				}
				//Vista previa no caminos
				else{
					if in(build_index, id_tunel, id_tunel_salida){
						var temp_complex_2 = abtoxy(mx, my), flag_2 = false
						var a = mx, b = my, c = 0
						//Evaluar si es construible
						build_able = false
						repeat(10){
							c++
							temp_complex_2 = next_to(a, b, build_dir)
							a = temp_complex_2.a
							b = temp_complex_2.b
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
							a = mx
							b = my
							repeat(c - 1){
								temp_complex_2 = next_to(a, b, build_dir)
								a = temp_complex_2.a
								b = temp_complex_2.b
								temp_complex_2 = abtoxy(a, b)
								draw_sprite_off(spr_tunel_view, 0, temp_complex_2.a, temp_complex_2.b,,, (build_dir - 1) * 60,, 0.5)
							}
						}
					}
					else{
						draw_edificio(temp_complex.a, temp_complex.b, build_index, build_dir, 0.5, build_enemigo)
						//Torres de alta tensión
						if build_index = id_torre_de_alta_tension{
							draw_circle_off(temp_complex.a, temp_complex.b, 1_000, true)
							for(var c = array_length(torres_de_tension) - 1; c >= 0; c--){
								var temp_edificio = torres_de_tension[c]
								if distance_sqr(temp_edificio.center_x, temp_edificio.center_y, temp_complex.a, temp_complex.b) < 1_000_000//1000^2
									draw_line_off(temp_edificio.center_x, temp_edificio.center_y, temp_complex.a,temp_complex.b)
							}
						}
						//Vista previa Alcance de torres
						else if edificio_armas[build_index]{
							draw_circle_off(temp_complex.a, temp_complex.b, edificio_alcance[build_index], true)
							if build_index = id_mortero
								draw_circle_off(temp_complex.a, temp_complex.b, 100, true)
						}
						//Taberías subterraneas
						else if build_index = id_tuberia_subterranea{
							var temp_list = get_size(mx, my, 0, 7), flag = false, temp_edificio = null_edificio
							for(var c = ds_list_size(temp_list) - 1; c >= 0; c--){
								var temp_complex_2 = temp_list[|c], aa = temp_complex_2.a, bb = temp_complex_2.b
								if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
									continue
								if edificio_bool[# aa, bb] and not (aa = mx and bb = my){
									temp_edificio = edificio_id[# aa, bb]
									if temp_edificio.index = build_index and temp_edificio.link = null_edificio and temp_edificio.enemigo = build_enemigo{
										flag = true
										break
									}
								}
							}
							if flag{
								draw_set_color(c_blue)
								draw_line_off(temp_complex.a, temp_complex.b, temp_edificio.center_x, temp_edificio.center_y)
							}
						}
						//Ensambladora
						else if build_index = id_ensambladora{
							if edificio_tecnologia[id_modulo] or not tecnologia{
								for(var a = ds_list_size(build_list_arround) - 1; a >= 0; a--){
									var temp_complex_2 = build_list_arround[|a]
									var aa = temp_complex_2.a, bb = temp_complex_2.b
									if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
										continue
									if edificio_bool[# aa, bb]{
										var temp_edificio = edificio_id[# aa, bb]
										if temp_edificio.index = id_ensambladora and not temp_edificio.mode and temp_edificio.enemigo = build_enemigo{
											draw_set_color(c_blue)
											draw_line_off(temp_complex.a, temp_complex.b, temp_edificio.center_x, temp_edificio.center_y)
											temp_text += "Conectando\n"
											break
										}
									}
								}
							}
						}
						//Drones encima
						else if grafic_array_dron_encima[build_index]{
							if last_mx != mx or last_my != my or prev_change{
								var temp_complex_array = cinta_grande_check(mx, my, build_dir, build_index)
								build_array_edificios_input = temp_complex_array.inputs
								build_array_edificios_output = temp_complex_array.outputs
							}
							draw_set_color(c_red)
							for(var a = array_length(build_array_edificios_input) - 1; a >= 0; a--){
								var temp_edificio = build_array_edificios_input[a]
								draw_arrow_off(temp_edificio.center_x, temp_edificio.center_y, temp_complex.a, temp_complex.b, 10)
							}
							draw_set_color(c_blue)
							for(var a = array_length(build_array_edificios_output) - 1; a >= 0; a--){
								var temp_edificio = build_array_edificios_output[a]
								draw_arrow_off(temp_complex.a, temp_complex.b, temp_edificio.center_x, temp_edificio.center_y, 10)
							}
							if build_index = id_planta_de_reciclaje{
								draw_set_color(c_lime)
								draw_circle_off(temp_complex.a, temp_complex.b, 250, true)
							}
						}
					}
					if mouse_check_button_pressed(mb_left) and flag_camino and comprable and (not edificio_bool[# mx, my] or (build_index = id_cruce and edificio_camino[edificio_id[# mx, my].index])){
						var temp_edificio = construir(build_index, build_dir, mx, my, build_enemigo)
						if grafic_array_dron_encima[temp_edificio.index]{
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
				if edificio_energia[build_index] and build_index != id_cable{
					var temp_complex_2 = abtoxy(mx, my), temp_list_complex = get_size(mx, my, build_dir, 7)
					for(var a = ds_list_size(temp_list_complex) - 1; a >= 0; a--){
						var temp_complex_3= temp_list_complex[|a], aa = temp_complex_3.a, bb = temp_complex_3.b
						if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
							continue
						if (aa != mx or bb != my) and edificio_draw[# aa, bb]{
							var temp_edificio = edificio_id[# aa, bb]
							if temp_edificio.enemigo = build_enemigo and temp_edificio.index = id_cable
								draw_line_off(temp_complex_2.a, temp_complex_2.b, temp_edificio.center_x, temp_edificio.center_y)
						}
					}
				}
				draw_text_background(min(room_width - string_width(temp_text), mouse_x + 20), min(room_height - string_height(temp_text), mouse_y), temp_text)
			}
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
		for(ticks = 0; (acumulator >= LOGIC_DT and ticks < 5) or ticks = 0; ticks++){
			acumulator -= LOGIC_DT
			timer++
			if win = 0 and (timer mod 3600) = 0{
				var temp_array_real = array_create(rss_max, 0)
				array_copy(temp_array_real, 0, recursos_obtenidos_time_temp, 0, rss_max)
				for(var a = 0; a < rss_max; a++)
					recursos_obtenidos[a] += recursos_obtenidos_time_temp[a]
				array_push(recursos_obtenidos_time, temp_array_real)
				recursos_obtenidos_time_temp = array_create(rss_max, 0)
				array_push(energia_producida, energia_producida_time)
				energia_producida_time = 0
				array_push(energia_consumida, energia_consumida_time)
				energia_consumida_time = 0
				array_push(energia_perdida, energia_perdida_time)
				energia_perdida_time = 0
			}
			//Ciclo edificios
			for(var a = array_length(edificios_activos) - 1; a >= 0; a--){
				edificio = edificios_activos[a]
				if edificio.idle or edificio.vida <= 0
					continue
				edificio_script[edificio.index](edificio)
			}
			for(var a = array_length(edificios_pendientes) - 1; a >= 0; a--){
				edificio = array_pop(edificios_pendientes)
				if edificio.eliminar and edificio.punteros[4] >= 0{
					edificio.eliminar = false
					array_disorder_remove(edificios_activos, edificio, 4)
					edificio.punteros[4] = -1
				}
				if edificio.agregar and edificio.punteros[4] = -1{
					edificio.agregar = false
					array_disorder_push(edificios_activos, edificio, 4)
				}
			}
			//Ciclo de los enemigos
			var cam_center_x = (camx + room_width * zoom / 2), cam_center_y = (camy + room_height * zoom / 2)
			for(var a = array_length(enemigos) - 1; a >= 0; a--){
				var dron = enemigos[a], aa = dron.x, bb = dron.y, index = dron.index, vel = dron_vel[index]
				draw_dron(dron, true)
				if distance_sqr(cam_center_x, cam_center_y, aa, bb) > 250_000{
					draw_set_color(c_red)
					var angle = arctan2(cam_center_y - bb, cam_center_x - aa), cosa = cos(angle), sina = sin(angle)
					draw_line(room_width / 2 - 60 * cosa, room_height / 2 - 60 * sina, room_width / 2 - 90 * cosa, room_height / 2 - 90 * sina)
				}
				for(var b = 0; b < efectos_max; b++)
					if dron.efecto[b] > 0{
						dron.efecto[b]--
						//Shock
						if b = 0
							vel /= 2
						//Fuego
						else if b = 1{
							herir_dron(dron_vida_max[index] / 3000, dron)
							if grafic_humo and (image_index mod 10) = (a mod 10){
								var dir = direccion_viento + random_range(-pi / 4, pi / 4)
								array_push(humos, add_humo(aa, bb, dron.a, dron.b, cos(dir) / 2, sin(dir) / 2, irandom_range(40, 70)))
							}
						}
					}
				if dron.vida <= 0{
					delete_dron(dron)
					continue
				}
				if aa < 0
					dron.x++
				else if aa > xsize * 48
					dron.x--
				if bb < 0
					dron.y++
				else if bb > ysize * 14
					dron.y--
				if dron.target != null_edificio and dron.target.vida <= 0
					dron.target = null_edificio
				if grafic_array_drones_terrestres[index]{
					if array_length(edificios) > 0 and dron.target = null_edificio{
						var temp_complex = xytoab(aa, bb)
						dron.target = edificio_cercano[# temp_complex.a, temp_complex.b]
					}
				}
				if not dron_aereo[index] and terreno[# dron.a, dron.b] = idt_hielo
					vel *= 1.2
				if dron.step != dron_step[index]
					dron.step++
				//Target edificios y drones
				if dron.target != null_edificio{
					var minu = max(0, dron.chunk_x - dron_alcance_chunk_x[index]), maxu = min(chunk_xsize - 1, dron.chunk_x + dron_alcance_chunk_x[index])
					var minv = max(0, dron.chunk_y - dron_alcance_chunk_y[index]), maxv = min(chunk_ysize - 1, dron.chunk_y + dron_alcance_chunk_y[index])
					edificio = dron.target
					if index != idd_bombardero
						dron.dir = (9 * dron.dir + radtodeg(arctan2(edificio.center_y - bb, aa - edificio.center_x))) / 10
					var temp_complex = xytoab(aa, bb), aaa = temp_complex.a, bbb = temp_complex.b, dir = -1, ataque = false
					var dis = distance_sqr(aa, bb, edificio.center_x, edificio.center_y)
					//Moverse
					if grafic_array_drones_terrestres[index]{
						if edificio_cercano_dis[# aaa, bbb] > 1 and dis > 2500{//50^2
							if edificio_cercano_dir[# aaa, bbb] = -1{
								var min_dis = edificio_cercano_dis[# aaa, bbb], min_dis_eu =  infinity
								for(var i = 0; i < 6; i++){
									temp_complex = next_to(aaa, bbb, i)
									var aaaa = temp_complex.a, bbbb = temp_complex.b
									if aaaa < 0 or bbbb < 0 or aaaa >= xsize or bbbb >= ysize
										continue
									if not terreno_caminable[terreno[# aaaa, bbbb]]
										continue
									var disi = edificio_cercano_dis[# aaaa, bbbb]
									if disi < min_dis{
										min_dis = disi
										dir = i
										ds_grid_set(edificio_cercano_dir, aaa, bbb, i)
										temp_complex = abtoxy(aaaa, bbbb)
										min_dis_eu = distance_sqr(temp_complex.a, temp_complex.b, edificio.center_x, edificio.center_y)
									}
									else if disi = min_dis{
										temp_complex = abtoxy(aaaa, bbbb)
										var c = distance_sqr(temp_complex.a, temp_complex.b, edificio.center_x, edificio.center_y)
										if c < min_dis_eu{
											min_dis = disi
											dir = i
											ds_grid_set(edificio_cercano_dir, aaa, bbb, i)
											min_dis_eu = c
										}
									}
								}
							}
							else
								dir = edificio_cercano_dir[# aaa, bbb]
							if dir = -1
								dir = 0
							dron.x += vel * cos_angle_dir[dir]
							dron.y -= vel * sin_angle_dir[dir]
							if index = idd_tanque
								dron.dir_move += angle_difference(dron.dir_move, radtodeg(arctan2(sin_angle_dir[dir], cos_angle_dir[dir]))) / 100
						}
					}
					else if dron_aereo[index]{
						if index = idd_bombardero{
							if dron.step <= dron_step[index]{
								dir = point_direction(dron.x, dron.y, edificio.center_x, edificio.center_y)
								var diff = angle_difference(dir, dron.dir)
								diff += random_range(-0.01, 0.01)
								dron.dir += 0.02 * diff
							}
							else
								vel *= 1.2
							dron.x += lengthdir_x(vel, dron.dir)
							dron.y += lengthdir_y(vel, dron.dir)
						}
						else if index = 3 or dis > 10_000{//100^2
							var dis_2 = sqrt(dis)
							dron.x += vel * (edificio.center_x - dron.x) / dis_2
							dron.y += vel * (edificio.center_y - dron.y) / dis_2
						}
					}
					if dis < dron_alcance[index]{
						ataque = true
						if atacar_dron(dron, edificio)
							continue
					}
					//Targetear unidades
					else if array_length(drones_aliados) > 0{
						if dron = null_dron{
							if (image_index mod 10) = (a mod 10){
								var closest_dis = dron_alcance[dron.index]
								for(var u = minu; u <= maxu; u++)
									for(var v = minv; v <= maxv; v++){
										var temp_array_dron = chunk_dron_aliado[# u, v]
										for(var i = array_length(temp_array_dron) - 1; i >= 0; i--){
											var temp_dron = temp_array_dron[i], temp_dis = distance_sqr(aa, bb, temp_dron.x, temp_dron.y)
											if temp_dis < closest_dis{
												closest_dis = temp_dis
												dron = temp_dron
											}
										}
									}
							}
						}
						else if dron.vida > 0{
							ataque = true
							if atacar_dron(dron,, dron)
								continue
						}
					}
					//Targetear edificios
					if ataque = false{
						if dron.temp_target = null_edificio{
							if (image_index mod 10) = (a + 5 mod 10){
								var closest_dis = dron_alcance[index], max_prioridad = -1
								for(var u = minu; u <= maxu; u++)
									for(var v = minv; v <= maxv; v++){
										var chunk = chunk_edificios[# u, v]
										for(var i = array_length(chunk) - 1; i >= 0; i--){
											edificio = chunk[i]
											if edificio.prioridad >= max_prioridad{
												max_prioridad = edificio.prioridad
												dis = distance_sqr(aa, bb, edificio.center_x, edificio.center_y)
												if dis < closest_dis{
													dron.temp_target = edificio
													closest_dis = dis
												}
											}
										}
									}
							}
						}
						else{
							edificio = dron.temp_target
							if edificio.vida <= 0
								dron.temp_target = null_edificio
							else{
								dis = distance_sqr(aa, bb, edificio.center_x, edificio.center_y)
								if index != idd_bombardero
									dron.dir = (9 * dron.dir + radtodeg(arctan2(edificio.center_y - bb, aa - edificio.center_x))) / 10
								if dis > dron_alcance[index]
									dron.temp_target = null_edificio
								else{
									ataque = true
									if atacar_dron(dron, edificio)
										continue
								}
							}
						}
					}
				}
				//Alejarse de los enemigos cercanos
				var temp_dron_size = dron_size[index], temp_array = chunk_dron_enemigo[# dron.chunk_x, dron.chunk_y]
				for(var b = array_length(temp_array) - 1; b >= 0; b--){
					var temp_enemigo = temp_array[b], dis = max(0.01, distance_sqr(aa, bb, temp_enemigo.x, temp_enemigo.y))
					if dis < temp_dron_size{
						var aaa = sign(aa - temp_enemigo.x), bbb = sign(bb - temp_enemigo.y)
						dron.x += aaa
						dron.y += bbb
						temp_enemigo.x -= aaa
						temp_enemigo.y -= bbb
					}
				}
				//Cambiar de chunk
				var temp_complex = xytoab(aa, bb)
				aa = temp_complex.a
				bb = temp_complex.b
				if aa != dron.a or bb != dron.b{
					dron.a = aa
					dron.b = bb
					if not dron_aereo[index] and array_length(edificios) > 0 and terreno_caminable[terreno[# aa, bb]]
						dron.target = edificio_cercano[# aa, bb]
					var chunk_x = clamp(round(aa / chunk_width), 0, chunk_xsize - 1), chunk_y = clamp(round(bb / chunk_height), 0, chunk_ysize - 1)
					if chunk_x != dron.chunk_x or chunk_y != dron.chunk_y{
						dron_chunk_remove(dron)
						dron.chunk_x = chunk_x
						dron.chunk_y = chunk_y
						dron_chunk_push(dron)
					}
				}
			}
			for(var a = array_length(enemigos) - 1; a >= 0; a--){
				var dron = enemigos[a]
				draw_vida(dron.x * zoom - camx, dron.y * zoom - camy, dron.vida, dron.vida_max)
			}
			//Ciclo drones aliados
			for(var a = array_length(drones_aliados) - 1; a >= 0; a--){
				var dron = drones_aliados[a], aa = dron.x, bb = dron.y, index = dron.index, vel = dron_vel[index]
				draw_dron(dron, false)
				//Efectos
				for(var b = 0; b < efectos_max; b++)
					if dron.efecto[b] > 0{
						dron.efecto[b]--
						//Shock
						if b = 0
							vel /= 2
						//Fuego
						else if b = 1{
							herir_dron(dron_vida_max[index] / 3000, dron)
							if grafic_humo and (image_index mod 10) = (a mod 10){
								var dir = direccion_viento + random_range(-pi / 4, pi / 4)
								array_push(humos, add_humo(aa, bb, dron.a, dron.b, cos(dir) / 2, sin(dir) / 2, irandom_range(40, 70)))
							}
						}
					}
				if dron.vida <= 0{
					array_disorder_remove(drones_aliados, dron, 0)
					continue
				}
				if not dron_aereo[index] and terreno[# dron.a, dron.b] = idt_hielo
					vel *= 1.2
				//Dron de Transporte
				if index = idd_mula{
					if array_length(puerto_carga_array) > 0{
						if dron.modo = 0{
							puerto_carga_atended = (++puerto_carga_atended) mod array_length(puerto_carga_array)
							dron.target = puerto_carga_array[puerto_carga_atended]
							dron.modo = 1
						}
						else{
							edificio = dron.target
							var dis = distance_sqr(aa, bb, edificio.center_x, edificio.center_y)
							if dis > dron_alcance[dron.index]{
								dis = sqrt(dis)
								dron.dir = (9 * dron.dir + radtodeg(arctan2(edificio.center_y - bb, aa - edificio.center_x))) / 10
								dron.x += vel * (edificio.center_x - aa) / dis
								dron.y += vel * (edificio.center_y - bb) / dis
							}
							else{
								if dron.modo = 1{
									for(var b = 0; b < rss_max; b++){
										dron.carga[b] += edificio.carga[b]
										edificio.carga[b] = 0
									}
									edificio.carga_total = 0
									mover_in(edificio)
									dron.target = edificio.link
									dron.modo = 2
								}
								else if dron.modo = 2{
									for(var b = 0; b < rss_max; b++){
										var c = dron.carga[b], d = edificio_carga_max[edificio.index] - edificio.carga_total
										if d > c{
											edificio.carga[b] += c
											edificio.carga_total += c
											dron.carga[b] = 0
										}
										else{
											edificio.carga[b] += d
											edificio.carga_total += d
											dron.carga[b] -= d
											break
										}
									}
									mover(edificio)
									puerto_carga_atended = (++puerto_carga_atended) mod array_length(puerto_carga_array)
									dron.target = puerto_carga_array[puerto_carga_atended]
									dron.modo = 1
								}
							}
						}
					}
				}
				//Dron Reparador
				else if index = idd_reparador{
					if dron.modo = 0{
						edificio = array_choose(edificios)
						if edificio.vida < edificio_vida[edificio.index]{
							dron.modo = 1
							dron.target = edificio
						}
					}
					else{
						edificio = dron.target
						if edificio.vida <= 0{
							dron.modo = 0
							continue
						}
						var dis = distance_sqr(aa, bb, edificio.center_x, edificio.center_y)
						if dis > dron_alcance[dron.index]{
							dron.dir = (9 * dron.dir + radtodeg(arctan2(edificio.center_y - bb, aa - edificio.center_x))) / 10
							dis = sqrt(dis)
							dron.x += vel * (edificio.center_x - aa) / dis
							dron.y += vel * (edificio.center_y - bb) / dis
						}
						else if ++dron.step >= 30{
							dron.step = 0
							draw_set_color(c_green)
							draw_line_off(aa, bb, edificio.center_x, edificio.center_y)
							if edificio_curar(edificio, 30)
								dron.modo = 0
						}
					}
				}
				//Drones aereos
				else if dron_aereo[index]{
					var minu = max(0, dron.chunk_x - dron_alcance_chunk_x[index]), maxu = min(chunk_xsize - 1, dron.chunk_x + dron_alcance_chunk_x[index])
					var minv = max(0, dron.chunk_y - dron_alcance_chunk_y[index]), maxv = min(chunk_ysize - 1, dron.chunk_y + dron_alcance_chunk_y[index])
					var ataque = false
					if dron.step != dron_step[index]
						dron.step++
					//Seguir instrucciones
					if dron.modo = 1{
						if index = idd_bombardero{
							if dron.step <= dron_step[index]{
								var dir = point_direction(dron.x, dron.y, dron.array_real[0], dron.array_real[1])
								var diff = angle_difference(dir, dron.dir)
								diff += random_range(-0.01, 0.01)
								dron.dir += 0.02 * diff
							}
							else
								vel *= 1.2
							dron.x += lengthdir_x(vel, dron.dir)
							dron.y += lengthdir_y(vel, dron.dir)
						}
						else{
							dron.dir = (9 * dron.dir + radtodeg(arctan2(dron.array_real[1], -dron.array_real[0]))) / 10
							dron.x += vel * dron.array_real[0]
							dron.y += vel * dron.array_real[1]
							if --dron.array_real[2] <= 0
								dron.modo = 0
						}
					}
					//Atacar unidades
					if array_length(enemigos) > 0{
						if dron = null_dron{
							if (image_index mod 10) = (a mod 10){
								var closest_dis = dron_alcance[dron.index]
								for(var u = minu; u <= maxu; u++)
									for(var v = minv; v <= maxv; v++){
										var chunk = chunk_dron_enemigo[# u, v]
										for(var i = array_length(chunk) - 1; i >= 0; i--){
											var temp_dron = chunk[i], temp_dis = distance_sqr(aa, bb, temp_dron.x, temp_dron.y)
											if temp_dis < closest_dis{
												closest_dis = temp_dis
												dron = temp_dron
											}
										}
									}
							}
						}
						else{
							ataque = true
							if atacar_dron(dron,, dron)
								continue
						}
					}
					//Atacar edificios
					if ataque = false and array_length(edificios_enemigos) > 0{
						if dron.temp_target = null_edificio{
							if (image_index mod 10) = ((a + 5) mod 10){
								var closest_dis = dron_alcance[index], max_prioridad = -1
								for(var u = minu; u <= maxu; u++)
									for(var v = minv; v <= maxv; v++){
										var chunk = chunk_edificios_enemigo[# u, v]
										for(var i = array_length(chunk) - 1; i >= 0; i--){
											edificio = chunk[i]
											if edificio.prioridad >= max_prioridad{
												max_prioridad = edificio.prioridad
												var dis = distance_sqr(aa, bb, edificio.center_x, edificio.center_y)
												if dis < closest_dis{
													dron.temp_target = edificio
													closest_dis = dis
												}
											}
										}
									}
							}
						}
						else{
							edificio = dron.temp_target
							if edificio.vida <= 0
								dron.temp_target = null_edificio
							else{
								var dis = distance_sqr(aa, bb, edificio.center_x, edificio.center_y)
								if index != idd_bombardero
									dron.dir = (9 * dron.dir + radtodeg(arctan2(edificio.center_y - bb, aa - edificio.center_x))) / 10
								if dis > dron_alcance[index]
									dron.temp_target = null_edificio
								else{
									ataque = true
									if atacar_dron(dron, edificio)
										continue
								}
							}
						}
					}
				}
				//Evitar colisiones
				var temp_dron_size = dron_size[index], temp_array_dron = chunk_dron_aliado[# dron.chunk_x, dron.chunk_y]
				for(var b = array_length(temp_array_dron) - 1; b >= 0; b--){
					var temp_dron = temp_array_dron[b], dis = max(0.01, distance_sqr(aa, bb, temp_dron.x, temp_dron.y))
					if dis < temp_dron_size{
						var aaa = (aa - temp_dron.x) / dis, bbb = (bb - temp_dron.y) / dis
						dron.x += aaa
						dron.y += bbb
						temp_dron.x -= aaa
						temp_dron.y -= bbb
					}
				}
				//Cambiar de chunk
				var temp_complex = xytoab(aa, bb)
				aa = temp_complex.a
				bb = temp_complex.b
				if aa != dron.a or bb != dron.b{
					dron.a = aa
					dron.b = bb
					var chunk_x = clamp(round(aa / chunk_width), 0, chunk_xsize - 1), chunk_y = clamp(round(bb / chunk_height), 0, chunk_ysize - 1)
					if chunk_x != dron.chunk_x or chunk_y != dron.chunk_y{
						dron_chunk_remove(dron)
						dron.chunk_x = chunk_x
						dron.chunk_y = chunk_y
						dron_chunk_push(dron)
					}
				}
			}
			for(var a = array_length(drones_aliados) - 1; a >= 0; a--){
				var dron = drones_aliados[a]
				draw_vida(dron.x * zoom - camx, dron.y * zoom - camy, dron.vida, dron.vida_max)
			}
			//Ciclo de disparos
			draw_set_alpha(0.5)
			for(var a = array_length(municiones) - 1; a >= 0; a--){
				var municion = municiones[a], target = municion.target, enemigo = municion.enemigo
				if municion.tipo != 2{
					draw_set_color(c_black)
					draw_circle_off(municion.x, municion.y, 2, false)
					draw_set_color(c_yellow)
					draw_line_off(municion.origen_x, municion.origen_y, municion.x, municion.y)
					municion.origen_x = municion.x
					municion.origen_y = municion.y
				}
				municion.x += municion.hmove
				municion.y += municion.vmove
				var temp_complex = xytoab(municion.x, municion.y), muna = temp_complex.a, munb = temp_complex.b
				if grafic_humo and municion.humo
					array_push(humos, add_humo(municion.x, municion.y, muna, munb, random_range(-1, 1), random_range(-1, 1), irandom_range(20, 30)))
				//Colisión
				if edificio_bool[# muna, munb]{
					edificio = edificio_id[# muna, munb]
					if edificio.enemigo != enemigo
						municion.dis = 0
				}
				//Munición perforadora
				if municion.tipo = 4
					herir_hexagono(muna, munb, floor(municion.dmg / 2), false, enemigo)
				if --municion.dis <= 0{
					municiones[a] = municiones[array_length(municiones) - 1]
					array_pop(municiones)
					//Daño unidad
					if target != null_dron and target.vida > 0{
						//Daño fuego
						if municion.tipo = 2
							aplicar_efecto(1, 120, target)
						//Daño área
						else
							herir_hexagono(muna, munb, municion.dmg)
						if target.vida > 0
							herir_dron(municion.dmg, target)
					}
					//Daño edificio
					if municion.target_build != null_edificio and municion.target_build.vida > 0
						herir_edificio(municion.dmg, municion.target_build)
					//Misil
					if municion.tipo = 1
						explosion(municion.x, municion.y, municion.target_build, enemigo, municion.radio)
					//Misil incendiario
					else if municion.tipo = 3
						explosion(municion.x, municion.y, municion.target_build, enemigo, municion.radio,, true)
				}
			}
			draw_set_alpha(1)
			//Efectos estáticos
			for(var a = 0; a < array_length(efectos); a++){
				var efecto = efectos[a]
				if show_smoke
					draw_sprite_off(efecto.sprite, efecto.subsprite, efecto.x, efecto.y)
				efecto.subsprite += efecto.frame_speed
				if --efecto.tiempo <= 0{
					efectos[a--] = efectos[array_length(efectos) - 1]
					array_pop(efectos)
				}
			}
			//Humo
			for(var a = 0; a < array_length(humos); a++){
				var humo = humos[a]
				if show_smoke and humo.a >= mina and humo.b >= minb and humo.a < maxa and humo.b < maxb{
					draw_sprite_off(spr_blur_32, 0, humo.x, humo.y)
					humo.x += humo.hmove
					humo.y += humo.vmove
				}
				humo.hmove *= 0.99
				humo.vmove *= 0.99
				if --humo.time <= 0{
					humos[a--] = humos[array_length(humos) - 1]
					array_pop(humos)
				}
			}
			//Fuego
			draw_set_alpha(0.4)
			for(var a = 0; a < array_length(fuegos); a++){
				var fuego = fuegos[a]
				if show_smoke and fuego.a >= mina and fuego.b >= minb and fuego.a < maxa and fuego.b < maxb{
					draw_set_color(make_color_hsv(fuego.intensidad, 127, 255))
					draw_circle_off(fuego.x, fuego.y, 10, false)
					fuego.x += fuego.hmove
					fuego.y += fuego.vmove
					fuego.hmove *= 0.9
					fuego.vmove *= 0.9
					if grafic_humo and random(1) < 0.05
						array_push(humos, add_humo(fuego.x, fuego.y, fuego.a, fuego.b, random_range(-1, 1), random_range(-1, 1), 15))
				}
				if --fuego.intensidad <= 0{
					fuegos[a--] = fuegos[array_length(fuegos) - 1]
					array_pop(fuegos)
					if grafic_humo and fuego.a >= mina and fuego.b >= minb and fuego.a < maxa and fuego.b < maxb
						array_push(humos, add_humo(fuego.x, fuego.y, fuego.a, fuego.b, random_range(-1, 1), random_range(-1, 1), 15))
				}
			}
			draw_set_alpha(1)
			if oleadas and (++oleadas_timer >= 60 * oleadas_tiempo_primera or keyboard_check_pressed(vk_enter)){
				var temp_time = oleadas_timer / 60 - oleadas_tiempo_primera
				if (temp_time mod oleadas_tiempo) = 0 or keyboard_check_pressed(vk_enter){
					var d = oleada_count++ + 3, e = 1, flag_2 = false
					if mision_actual >= 0 and mision_objetivo[mision_actual] = 4 and ++mision_counter >= mision_target_num[mision_actual]
						oleadas = false
					for(var i = 0; i < array_length(size_size); i++)
						if d <= size_size[i]{
							e = i + 1
							flag_2 = true
							break
						}
					if not flag_2
						e = array_length(size_size)
					var temp_complex_list = get_size(spawn_x, spawn_y, 0, e)
					for(var i = 0; i < min(ds_list_size(temp_complex_list), d); i++){
						var temp_complex = temp_complex_list[|i], aa = clamp(temp_complex.a, 0, xsize - 1), bb = clamp(temp_complex.b, 0, ysize - 1), enemigo
						if not terreno_caminable[terreno[# aa, bb]] or edificio_cercano[# aa, bb] = null_edificio or (tutorial = 0 and random(1) < 0.15){
							if irandom(min(ds_list_size(temp_complex_list), d)) > i + 11{
								enemigo = add_dron(aa, bb, idd_bombardero)
								i += 10
							}
							else if irandom(min(ds_list_size(temp_complex_list), d)) > i + 5{
								enemigo = add_dron(aa, bb, idd_helicoptero)
								i += 4
							}
							else
								enemigo = add_dron(aa, bb, idd_kamikaze)
						}
						else{
							if irandom(min(ds_list_size(temp_complex_list), d)) > i + 15{
								enemigo = add_dron(aa, bb, idd_titan)
								i += 14
							}
							else if irandom(min(ds_list_size(temp_complex_list), d)) > i + 6{
								enemigo = add_dron(aa, bb, idd_tanque)
								i += 5
							}
							else
								enemigo = add_dron(aa, bb, idd_arana)
						}
					}
				}
			}
			if mision_actual >= 0 and win = 0{
				var a = mision_actual
				if in(mision_objetivo[a], 5, 7) and not oleadas and keyboard_check_pressed(vk_enter){
					keyboard_clear(vk_enter)
					pasar_mision()
				}
				if mision_tiempo[a] > 0{
					if mision_camara_step <= 0 and --mision_current_tiempo <= 0{
						if mision_tiempo_victoria[a]
							pasar_mision()
						else
							win = 2
					}
				}
				else if mision_objetivo[a] = 1{
					mision_counter = nucleo.carga[mision_target_id[a]]
					if mision_counter >= mision_target_num[a]{
						pasar_mision()
						a++
					}
				}
				else if mision_objetivo[a] = 3{
					mision_counter = edificios_counter[mision_target_id[a]]
					if mision_counter >= mision_target_num[a]{
						pasar_mision()
						a++
					}
				}
				else if mision_objetivo[a] = 6{
					mision_counter += (keyboard_check(ord("A")) or keyboard_check(ord("D")) or keyboard_check(ord("W")) or keyboard_check(ord("S")))
					if mision_counter >= mision_target_num[a]{
						pasar_mision()
						a++
					}
				}
			}
			if mision_actual = -1 and in(tutorial, 1, 2, 3) and win = 0{
				draw_set_halign(fa_right)
				if draw_boton(room_width - 20, string_height(temp_text_right) + 64, L.win_siguiente_mision, ui_verde){
					if tutorial = 1
						var file = cargar_escenario("mision_2.txt")
					else if tutorial = 2
						file = cargar_escenario("mision_3.txt")
					else if tutorial = 3
						file = cargar_escenario("mision_4.txt")
					if file != ""
						game_start()
					tutorial++
				}
				draw_set_halign(fa_left)
			}
			energia_solar = clamp(2 * sin((image_index + 900) / 1800), 0, 1)
			//Ciclo de redes
			for(var a = array_length(redes) - 1; a >= 0; a--){
				var red = redes[a]
				red.bateria = clamp(red.bateria + (red.generacion - red.consumo) / 30, 0, red.bateria_max)
				red.eficiencia = clamp((red.generacion + red.bateria) / max(1, red.consumo), 0, 1)
				red.promedio = (19 * red.promedio + red.generacion - red.consumo) / 20
				if not red.edificios[0].enemigo{
					energia_producida_time += red.generacion / 60
					energia_consumida_time += red.consumo / 60
					if red.eficiencia = 1 and red.bateria = red.bateria_max
						energia_perdida_time += (abs(red.generacion) - abs(red.consumo)) / 60
				}
			}
			//Ciclo flujos
			for(var a = array_length(flujos) - 1; a >= 0; a--){
				var flujo = flujos[a]
				flujo.almacen = clamp(flujo.almacen + (flujo.generacion - flujo.consumo) / 30, 0, flujo.almacen_max)
				flujo.promedio = (19 * flujo.promedio + flujo.generacion - flujo.consumo) / 20
				if flujo.almacen = 0
					flujo.eficiencia = clamp(flujo.generacion / max(1, flujo.consumo), 0, 1)
				else
					flujo.eficiencia = 1
				if flujo.almacen < 1 and flujo.generacion = 0{
					if grafic_luz and flujo.liquido = 3
						for(var b = array_length(flujo.edificios) - 1; b >= 0; b--){
							edificio = flujo.edificios[b]
							encender_luz(false, edificio)
						}
					flujo.liquido = -1
				}
			}
			if array_length(explosion_queue) > 0{
				for(var a = array_length(explosion_queue) - 1; a >= 0; a--){
					var temp_explosion = explosion_queue[a]
					explosion(temp_explosion.x, temp_explosion.y, temp_explosion.edificio, temp_explosion.enemigo, temp_explosion.radio, temp_explosion.dmg, temp_explosion.incendiario)
				}
				explosion_queue = []
			}
			if array_length(explosion_fx_queue) > 0{
				var len = array_length(explosion_fx_queue)
				for(var a = len - 1; a >= 0; a--){
					var current_explosion = explosion_fx_queue[a]
					if --current_explosion.step = 0{
						explosion_fx_queue[a] = explosion_fx_queue[array_length(explosion_fx_queue) - 1]
						array_pop(explosion_fx_queue)
					}
					draw_circle(current_explosion.x, current_explosion.y, 32, false)
				}
			}
			if nuclear_step > 0{
				if --nuclear_step > 150{
					draw_set_color(c_white)
					draw_set_alpha((nuclear_step - 150) / 150)
					draw_rectangle(0, 0, room_width, room_height, false)
				}
				if nuclear_x >= 0
					draw_sprite_off(spr_blur, 0, nuclear_x, nuclear_y,,,,, nuclear_step / 300)
				draw_set_color(c_black)
				draw_set_alpha(1)
			}
		}
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
		if not in(mision_objetivo[a], 5, 6)
			temp_text_right += $"\n\n{mision_nombre[a]}\n{objetivos_nombre[mision_objetivo[a]]} {mision_target_num[a]} "
		if mision_objetivo[a] < 2
			temp_text_right += recurso_nombre[mision_target_id[a]]
		else if in(mision_objetivo[a], 2, 3, 7, 8)
			temp_text_right += edificio_nombre[mision_target_id[a]]
		else if mision_objetivo[a] = 4
			temp_text_right += L.mision_enemigos
		if not in(mision_objetivo[a], 5, 7)
			temp_text_right += $"\n{mision_counter} / {mision_target_num[a]}"
		if mision_tiempo[a] > 0 and mision_tiempo_show[a]{
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
	if draw_sprite_boton(spr_manual,, room_width - 64, string_height(temp_text_right), 64, 64,, function(){
		sprite_boton_text = $"{L.game_enciclopedia} (Y)"})
		enciclopedia = true
	//Input
	if win = 0 and not show_menu{
		if keyboard_check_pressed(vk_anykey){
			if keyboard_check_pressed(vk_space){
				if pausa = 2
					pausa = 0
				else if pausa = 0
					pausa = 2
			}
			if keyboard_check_pressed(ord("U"))
				info = not info
			if keyboard_check_pressed(ord("L"))
				flow = (flow + 1) mod 7
			if string_ends_with(keyboard_string, "cheat"){
				keyboard_string = ""
				cheat = not cheat
				clear_edit()
			}
			if keyboard_check_pressed(vk_escape){
				if pausa > 0
					pausa = 0
				else{
					pausa = 1
					clear_edit()
					mouse_clear(mb_any)
					keyboard_clear(vk_anykey)
				}
			}
			if keyboard_check_pressed(vk_f1)
				grafic_hideui = not grafic_hideui
			if keyboard_check_pressed(ord("N"))
				oleadas = not oleadas
			if keyboard_check_pressed(ord("M"))
				sound_change()
			if keyboard_check_pressed(ord("Y")){
				if enciclopedia = 0
					enciclopedia = 1
				else
					enciclopedia = 0
			}
			if cheat and mision_actual >= 0 and string_ends_with(keyboard_string, "uwu")
				pasar_mision()
		}
		//Mostrar redes electricas
		if keyboard_check(ord("O")){
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
		if keyboard_check(ord("I")){
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
	if mision_actual >= 0 and --mision_camara_step > 0{
		zoom = 1
		camx = clamp(((mision_camara_x[mision_actual] - room_width / 2) * (60 - mision_camara_step) + mision_camara_x_start * mision_camara_step) / 60, 0, xsize * 48 * zoom - room_width)
		camy = clamp(((mision_camara_y[mision_actual] - room_height / 2) * (60 - mision_camara_step) + mision_camara_y_start * mision_camara_step) / 60, 0, ysize * 14 * zoom - room_height)
	}
	else
		control_camara()
	if flow > 0
		draw_path_find()
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
			var xpos = room_width / 2, ypos = 200, sec = floor(--timer / 60)
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
				show_debug_message(show_array)
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
					descubrir_zona(4, 8)
				else if tutorial = 2
					descubrir_zona(4, 3)
				else if tutorial = 3
					descubrir_zona(3, 7)
				else if tutorial = 4
					descubrir_zona(4, 2)
				if in(tutorial, 1, 2, 3, 4) and draw_boton(room_width / 2, room_height - 250, L.win_siguiente_mision, ui_verde){
					if tutorial = 1
						var file = cargar_escenario("mision_2.txt")
					else if tutorial = 2
						file = cargar_escenario("mision_3.txt")
					else if tutorial = 3
						file = cargar_escenario("mision_4.txt")
					else if tutorial = 4
						file = cargar_escenario("mision_5.txt")
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
				if tutorial = 1
					cargar_escenario("mision_1.txt")
				if tutorial = 2
					cargar_escenario("mision_2.txt")
				if tutorial = 3
					cargar_escenario("mision_3.txt")
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
else{
	if keyboard_check_pressed(vk_escape){
		if pausa > 0
			pausa = 0
		else{
			pausa = 1
			clear_edit()
			mouse_clear(mb_any)
			keyboard_clear(vk_anykey)
		}
	}
	control_camara()
}
update_cursor()
if sprite_boton_text != ""
	draw_text_background(mouse_x, mouse_y + 20, sprite_boton_text)
if sonido{
	for(var a = 0; a < sonidos_max; a++){
		if not audio_is_paused(sonido_id[a]) and volumen[a] = 0
			audio_pause_sound(sonido_id[a])
		if audio_is_paused(sonido_id[a]) and volumen[a] > 0
			audio_resume_sound(sonido_id[a])
		audio_sound_gain(sonido_id[a], volumen[a], 0)
	}
	if random(3600) < 1{
		var flag = true
		for(var a = array_length(musica) - 1; a >= 0; a--)
			if audio_is_playing(musica[a]){
				flag = false
				break
			}
		if flag
			audio_play_sound(musica[irandom(array_length(musica) - 1)], 1, false)
	}
	if clic_sound
		audio_play_sound(snd_click, 1, false, 0.3)
}
