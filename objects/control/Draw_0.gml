#region Pre-event
	if debug_frame_time
		var _frame_time = get_timer()
	mina = max(0, floor(camx / zoom / 48))
	minb = max(0, floor(camy / zoom / 14) - 1)
	maxa = min(xsize, ceil(1 + (camx + room_width) / zoom / 48))
	maxb = min(ysize, ceil(1 + (camy + room_height) / zoom / 14))
	min_chunka = max(0, floor(mina / CHUNK_WIDTH))
	min_chunkb = max(0, floor(minb / CHUNK_HEIGHT))
	max_chunka = min(ceil(maxa / CHUNK_WIDTH), chunk_xsize)
	max_chunkb = min(ceil(maxb / CHUNK_HEIGHT), chunk_ysize)
	world_minx = camx / zoom
	world_maxx = (camx + room_width) / zoom
	world_miny = camy / zoom
	world_maxy = (camy + room_height) / zoom
	if keyboard_check_pressed(vk_f4){
		keyboard_clear(vk_f4)
		window_set_fullscreen(not window_get_fullscreen())
		save_setting("", "fullscreen", window_get_fullscreen())
	}
	prev_get_keyboard_string = get_keyboard_string
#endregion
var a, b, c, temp_text, temp_complex, aa = 0, bb = 0, xpos, ypos, temp_array_real, flag, buffer, i, j, temp_complex_2 = array_create(0, 0)
var _parpadeo = abs(sin(image_index / 20)), len
if FIRST_TIME{
	menu_first_time()
	exit
}
if menu = MENU_PRINCIPAL{
	menu_principal()
	exit
}
if menu = MENU_EDITOR{
	menu_editor()
	exit
}
if menu = MENU_CAMPANNA{
	menu_campanna()
	exit
}
//Dibujo
if menu = MENU_JUEGO or menu = MENU_EDITOR_JUEGO{
	var t = get_timer()
	dibujar_fondo()
	if grafic_tile_animation and zoom >= 1
		dibujar_fondo(2)
	for(a = min_chunka; a < max_chunka; a++)
		for(b = min_chunkb; b < max_chunkb; b++)
			for(c = array_length(chunk_explosion[# a, b]) - 1; c >= 0; c--)
				draw_sprite_off(spr_explosion_mark, 0, chunk_explosion[# a, b][c].x, chunk_explosion[# a, b][c].y,,, chunk_explosion[# a, b][c].rot,, 0.3)
	dibujar_edificios()
	var show_humo = (grafic_humo and pausa = 0 and enciclopedia = 0 and ((image_index mod 5) = 0))
	var chunk, edificio, index, aaa, bbb, center_x, center_y, alert_count, _jugador, proceso, d, edificio_2, dir
	//DIBUJO SECUNDARIO
	for(a = min_chunka; a < max_chunka; a++)
		for(b = min_chunkb; b < max_chunkb; b++){
			chunk = chunk_edificios_draw[# a, b]
			for(c = array_length(chunk) - 1; c >= 0; c--){
				edificio = chunk[c]
				index = edificio.index
				aa = edificio.x
				bb = edificio.y
				aaa = aa * zoom - camx
				bbb = bb * zoom - camy
				center_x = edificio.center_x
				center_y = edificio.center_y
				alert_count = 0
				_jugador = edificio.jugador
				//Recursos sobre caminos
				if tag_camino_o_tunel[index] and edificio.carga_total > 0{
					proceso = edificio_proceso[index]
					d = 1.2 * (max(edificio.proceso, edificio.waiting * proceso) - proceso / 2) * 24 / proceso
					draw_sprite_off(recurso_sprite[edificio.carga_id], 0, aa + d * edificio.array_real[0], bb + d * edificio.array_real[1])
				}
				//Munición armas
				else if tag_municion_armas[index] and edificio.carga_total = 0{
					draw_sprite_off(spr_ammo, 0, aa, bb - TILE_WIDTH * ++alert_count)
					draw_sprite_off(spr_falta, 0, aa, bb - TILE_WIDTH * alert_count)
				}
				//Dibujo de los links eléctricos
				else if edificio_energia[index]{
					if grafic_energia{
						draw_set_color(ui_color_energia)
						for(d = array_length(edificio.energia_link) - 1; d >= 0; d--){
							edificio_2 = edificio.energia_link[d]
							draw_line_off(center_x, center_y, edificio_2.center_x, edificio_2.center_y)
						}
					}
					if edificio.red.generacion = 0 and edificio.red.bateria = 0 and edificio.energia_consumo_max > 0{
						draw_sprite_off(spr_energia, 1, aa, bb - TILE_WIDTH * ++alert_count)
						draw_sprite_off(spr_falta, 0, aa, bb - TILE_WIDTH * alert_count)
					}
				}
				//Receta planta química
				if index = id_planta_quimica and edificio.select >= 0
					draw_sprite_off(planta_quimica_sprite[edificio.select], 0, aa, bb)
				//Humo
				if show_humo and tag_generadores_de_humo[index]{
					if ((tag_generadores_de_humo_combustion[index] and edificio.fuel > 0) or (index = id_generador_geotermico and tag_liquido_agua[edificio.flujo.liquido]) or (index = id_refineria_de_petroleo and edificio.flujo.liquido = idl_petroleo and edificio.red.eficiencia > 0)) and image_index & 3{
						dir = viento_dir + random_range(-pi / 4, pi / 4)
						array_push(humos, add_humo(center_x, center_y, edificio.a, edificio.b, cos(dir) * viento_mag, sin(dir) * viento_mag, irandom_range(70, 100)))
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
						draw_sprite_off(liquido_sprite[edificio_flujo_liquido[index, (image_index / 300) mod array_length(edificio_flujo_liquido[index])]], 0, aa, bb - TILE_WIDTH * ++alert_count)
						draw_sprite_off(spr_falta, 0, aa, bb - TILE_WIDTH * alert_count)
					}
				}
				draw_vida(aaa, bbb, edificio.vida, edificio_vida[index])
				//Dibujo estados
				if _jugador != jugador
					draw_edificio_borde(edificio, EQUIPO_COLOR[_jugador])
				if info and edificio.waiting{
					draw_set_color(ui_color_lava)
					draw_circle_off(aa, bb + 16, 4, false)
				}
				if edificio.idle{
					draw_set_color(ui_boton_rojo)
					draw_circle_off(aa, bb + 8, 4, false)
				}
				if cheat and  index = id_nucleo and edificio.jugador = JUGADOR_IA{
					temp_text = $"{ia_queue_nombre[ia_queue[ia_queue_count]]}: {ia_queue_count}/{array_length(ia_queue)}\n"+
						$"construyendo: {edificio_nombre[ia_build_queue[ia_build_pos, 0]]}: {ia_build_pos}/{array_length(ia_build_queue)}\n"
					for(i = 0; i < rss_max; i++)
						if jugador_recursos[JUGADOR_IA, i] > 0
							temp_text += $"{recurso_nombre[i]}: {jugador_recursos[JUGADOR_IA, i]}, "
					draw_text_background(center_x, center_y, temp_text)
				}
			}
		}
	//Reconstruir
	if keyboard_check(CONTROL_REPARAR)
		for(a = mina; a < maxa; a++)
			for(b = minb; b < maxb; b++)
				if repair_id[# a, b][jugador] >= 0
					draw_edificio(pre_abtox[# a + 1, b + 1], pre_abtoy[# a + 1, b + 1], repair_id[# a, b][jugador], repair_dir[# a, b][jugador], 0.5)
	//Luz
	if energia_solar < 1{
		var luz_alpha = 0.6 * (1 - energia_solar)
		if grafic_luz{
			if not surface_exists(light_surface)
				light_surface = surface_create(room_width, room_height)
			surface_set_target(light_surface)
			draw_clear_alpha(c_black, 1)
			gpu_set_blendmode(bm_subtract)
			for(a = array_length(luces) - 1; a >= 0; a--){
				var temp_luz = luces[a]
				if temp_luz.a > mina and temp_luz.b > minb and temp_luz.a < maxa and temp_luz.b < maxb{
					draw_sprite_off(spr_blur_32, 0, temp_luz.x, temp_luz.y, temp_luz.r, temp_luz.r, 0, c_white, 1)
				}
			}
			gpu_set_blendmode(bm_normal)
			surface_reset_target()
			draw_set_alpha(luz_alpha)
			draw_surface(light_surface, 0, 0)
			draw_set_alpha(1)
		}
		else{
			draw_set_alpha(luz_alpha)
			draw_set_color(c_black)
			draw_rectangle(0, 0, room_width, room_height, false)
			draw_set_alpha(1)
		}
	}
	draw_set_halign(fa_left)
	draw_set_valign(fa_top)
	if mision_actual >= 0 and win = 0
		draw_mision_texto()
	draw_set_halign(fa_center)
	temp_text = ""
	b = 0
	for(a = 0; a < rss_max; a++)
		if jugador_recursos[jugador, rss_sort[a]] != 0{
			if ++b & 1
				temp_text += "\n"
			temp_text += $"/{recurso_keyword[rss_sort[a]]}{jugador_recursos[jugador, rss_sort[a]]} "
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
		a = irandom_range(mina, maxa - 1)
		b = irandom_range(minb, maxb - 1)
		if terreno[# a, b] = idt_lava
			sound_play(snd_lava, pre_abtox[# a + 1, b + 1], pre_abtoy[# a + 1, b + 1], 0.5)
	}
	sprite_boton_text = ""
	clic_sound = false
	if menu = MENU_EDITOR_JUEGO{
		draw_set_halign(fa_right)
		if jugador = JUGADOR_IA and draw_boton(room_width - 40, 20, L.enemigo, ui_rojo)
			jugador = 2
		else if jugador = 2 and draw_boton(room_width - 40, 20, L.aliado, ui_verde)
			jugador = JUGADOR_IA
		draw_set_halign(fa_left)
	}
}
//Pausa - Menú
if pausa = 1 and menu_pausa()
	exit
//Solo pausa
if pausa = 2{
	for(a = array_length(drones) - 1; a >= 0; a--)
		draw_dron(drones[a], true)
	image_index--
	draw_set_color(ui_texto)
	draw_set_halign(fa_center)
	draw_set_font(font_titulo)
	draw_text(room_width / 2, 100, L.pausa)
	draw_set_halign(fa_left)
	draw_set_font(font_normal)
}
var xmouse = (mouse_x + camx) / zoom, ymouse = (mouse_y + camy) / zoom
//Editar edificio
if show_menu
	menu_editar_edificio()
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
var edificio = edificio_id[# mx, my]
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
		for(a = 0; a < array_length(blueprints_image); a++)
			if blueprints_image[a] != spr_null_image
				sprite_delete(blueprints_image[a])
		for(a = 0; a < array_length(blueprints_files); a++){
			temp_text = "Blueprints/" + file_format(blueprints_files[a])
			if file_exists(temp_text + ".png")
				var temp_image = sprite_add(temp_text + ".png", 1, false, false, 0, 0)
			else
				temp_image = spr_null_image
			blueprints_image[a] = temp_image
		}
	}
	draw_set_halign(fa_left)
	var temp_mina = max(mina, blueprint_mina), temp_maxa = min(maxa, blueprint_maxa + 1), temp_minb = max(minb, blueprint_minb), temp_maxb = min(maxb, blueprint_maxb + 1)
	for(a = temp_mina; a < temp_maxa; a++)
		for(b = temp_minb; b < temp_maxb; b++)
			if blueprint_grid[# a, b]
				draw_sprite_off(spr_hexagono, 0, pre_abtox[# a + 1, b + 1], pre_abtoy[# a + 1, b + 1],,,, ui_boton_azul, 0.5)
	if mouse_check_button_released(mb_left){
		blueprint_safe = false
		blueprint_mod2 = (blueprint_minb & 1)
		blueprint = array_create(0, null_blueprint)
		var temp_array_bool = array_create(array_length(edificios_totales), true)
		var temp_blueprint_mina = infinity, temp_blueprint_maxa = 0, temp_blueprint_minb = infinity, temp_blueprint_maxb = 0
		for(a = blueprint_mina; a <= blueprint_maxa; a++)
			for(b = blueprint_minb; b <= blueprint_maxb; b++)
				if blueprint_grid[# a, b] and edificio_bool[# a, b]{
					var temp_edificio = edificio_id[# a, b]
					if temp_array_bool[temp_edificio.punteros[0]]{
						temp_array_bool[temp_edificio.punteros[0]] = false
						var temp_a = blueprint_mina, temp_b = blueprint_minb, rot4 = real(floor((temp_edificio.b - blueprint_minb) / 2)), rot0 = real(temp_edificio.a - blueprint_mina), rot5 = rot0
						temp_a += rot0
						temp_b += 2 * rot4
						if temp_a != temp_edificio.a or temp_b != temp_edificio.b
							for(i = 0; i < 6; i++){
								temp_complex = next_to(temp_a, temp_b, i)
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
		xpos = 120
		ypos = 200
		var _file_name
		for(i = 0; i < array_length(blueprints_files); i++){
			_file_name = file_format(blueprints_files[i])
			draw_set_color(ui_panel_secundario)
			draw_rectangle(xpos, ypos, xpos + 100, ypos + 100, false)
			if draw_sprite_boton(blueprints_image[i],, xpos, ypos, 100, 100, 1){
				get_file = 0
				input_layer = 0
				blueprint_safe = true
				build_index = -1
				buffer = buffer_load($"Blueprints\\{_file_name}.txt")
				len = real(buffer_read(buffer, buffer_u8))
				blueprint_mod2 = bool(buffer_read(buffer, buffer_bool))
				array_resize(blueprint, len)
				for(j = 0; j < len; j++){
					a = real(buffer_read(buffer, buffer_u8))
					b = real(buffer_read(buffer, buffer_u8))
					var index = real(buffer_read(buffer, buffer_u8))
					var dir = real(buffer_read(buffer, buffer_u8))
					var rot0 = real(buffer_read(buffer, buffer_s16))
					var rot4 = real(buffer_read(buffer, buffer_s16))
					var rot5 = real(buffer_read(buffer, buffer_s16))
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
				file_delete($"Blueprints\\{_file_name}.txt")
				file_delete($"Blueprints\\{_file_name}.png")
				if blueprints_image[i] != spr_null_image
					sprite_delete(blueprints_image[i])
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
	draw_set_halign(halign)
}
//Mostrar detalles de edificios al pasar el mouse_por encima
if pausa != 1 and not outside and not (show_menu and show_menu_build.index = id_procesador){
	//Mostrar terreno
	temp_text = $"{terreno_nombre[terreno[# mx, my]]}\n"
	if ore[# mx, my] >= 0
		temp_text += $"{recurso_nombre[ore_recurso[ore[# mx, my]]]}: {ore_amount[# mx, my]}\n"
	if edificio_bool[# mx, my]{
		var index = edificio.index
		temp_text += $"{edificio_nombre[index]}\n"
		if edificio.jugador != jugador and menu = MENU_JUEGO and not cheat{
			if online and edificio.jugador > JUGADOR_IA
				temp_text += server_jugadores_nombre[edificio.jugador - 2]
			else
				temp_text += (edificio.jugador = JUGADOR_SALVAJE) ? "SALVAJE\n" : $"{L.enemigo}\n"
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
					len = array_length(size)
					for(a = 0; a < len;){
						aa = size[a++]
						bb = size[a++]
						ds_grid_set(blueprint_grid, aa, bb, true)
						blueprint_mina = min(blueprint_mina, aa)
						blueprint_maxa = max(blueprint_maxa, aa)
						blueprint_minb = min(blueprint_minb, bb)
						blueprint_maxb = max(blueprint_maxb, bb)
					}
				}
				last_mx = mx
				last_my = my
			}
			if not edificio_inerte[index] and edificio.punteros[ptre_activo] = -1{
				draw_sprite_off(spr_diseneabled, 0, edificio.center_x, edificio.center_y)
				if draw_boton(edificio.center_x * zoom - camx, edificio.center_y * zoom - camy, L.game_activar)
					set_edificio_instruccion(edificio, cambio_activar,, true)
			}
			//Seleccionar edificios
			if mouse_check_button_pressed(mb_left) and build_index = -1 and build_menu = 0{
				if puerto_carga_select > 0{
					mouse_clear(mb_left)
					if edificio != puerto_carga_link and point_distance(edificio.x, edificio.y, puerto_carga_link.x, puerto_carga_link.y) < PUERTO_CARGA_RANGE{
						if puerto_carga_select = 1{
							if array_contains(edificio_output_id[index], puerto_carga_rss) or edificio_output_all[index]{
								set_edificio_instruccion(puerto_carga_link, cambio_instrucciones_cambio_input, {instruccion : puerto_carga_instruccion, a : edificio.a, b : edificio.b}, true)
								puerto_carga_select = 2
							}
						}
						else{
							if array_contains(edificio_input_id[index], puerto_carga_rss) or edificio_input_all[index]{
								set_edificio_instruccion(puerto_carga_link, cambio_instrucciones_cambio_output, {instruccion : puerto_carga_instruccion, a : edificio.a, b : edificio.b}, true)
								puerto_carga_select = 0
							}
						}
					}
				}
				if procesador_select != null_edificio{
					mouse_clear(mb_left)
					if procesador_select != edificio{
						set_edificio_instruccion(procesador_select, cambio_vincular, {desa : edificio.a, desb : edificio.b, instruccion : 0}, true)
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
			else if index = id_procesador{
				for(a = 1; a < array_length(edificio.procesador_link); a++){
					var temp_edificio = edificio.procesador_link[a]
					draw_set_color(ui_boton_verde)
					draw_arrow_off(edificio.center_x, edificio.center_y, temp_edificio.center_x, temp_edificio.center_y, 8)
					draw_set_color(ui_fondo)
					draw_text_off((edificio.center_x + temp_edificio.center_x) / 2, (edificio.center_y + temp_edificio.center_y) / 2, a)
				}
			}
			if info{
				var center_x = edificio.center_x, center_y = edificio.center_y
				//Mostrar inputs
				draw_set_color(ui_boton_azul)
				for(a = array_length(edificio.inputs) - 1; a >= 0; a--){
					var edificio_2 = edificio.inputs[a]
					draw_arrow_off(edificio_2.center_x, edificio_2.center_y, center_x, center_y, 12)
				}
				//Mostrar outputs
				draw_set_color(ui_boton_verde)
				for(a = array_length(edificio.outputs) - 1; a >= 0; a--){
					var edificio_2 = edificio.outputs[a]
					draw_arrow_off(center_x, center_y, edificio_2.center_x, edificio_2.center_y, 12)
				}
			}
			//Mostrar carga
			if edificio.index = id_ensambladora and edificio.mode{
				var temp_edificio = edificio.link
				flag = false
				draw_arrow_off(edificio.center_x, edificio.center_y, temp_edificio.center_x, temp_edificio.center_y, 4)
				for(a = 0; a < rss_max; a++)
					if (edificio.carga[a] + temp_edificio.carga[a]) > 0{
						if not flag{
							temp_text += $"{L.almacen_almacen}:\n"
							flag = true
						}
						temp_text += $"  {recurso_nombre[a]}: {floor(edificio.carga[a] + temp_edificio.carga[a])}\n"
					}
			}
			else if edificio.carga_total > 0 and index != id_silo_de_misiles{
				flag = false
				for(a = 0; a < rss_max; a++)
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
					temp_array_real = array_create(1, 0)
					var temp_text_2 = ""
					for(a = 0; a < rss_max; a++)
						temp_array_real[a] = 0
					len = array_length(edificio.coordenadas)
					for(a = 0; a < len;){
						aa = edificio.coordenadas[a++]
						bb = edificio.coordenadas[a++]
						if in(ore[# aa, bb], ido_cobre, ido_hierro, ido_carbon)
							temp_array_real[ore_recurso[ore[# aa, bb]]] += ore_amount[# aa, bb]
						else if terreno_recurso_bool[terreno[# aa, bb]] and index = id_taladro_electrico
							temp_array_real[terreno_recurso_id[terreno[# aa, bb]]] = -1
					}
					for(a = 0; a < rss_max; a++)
						if temp_array_real[a] > 0
							temp_text_2 += $"  {recurso_nombre[a]}: {temp_array_real[a]}\n"
						else if temp_array_real[a] = -1
							temp_text_2 += $"  {recurso_nombre[a]}\n"
					if temp_text_2 != ""
						temp_text += $"{L.almacen_recursos_disponibles}:\n{temp_text_2}"
				}
			}
			else if index = id_taladro_de_explosion{
				if edificio.idle
					temp_text += $"{L.almacen_sin_recursos}\n"
				else{
					temp_array_real = array_create(1, 0)
					var temp_text_2 = "", temp_array_coord = get_size(edificio.a, edificio.b, 0, 5)
					for(a = 0; a < rss_max; a++)
						temp_array_real[a] = 0
					len = array_length(temp_array_coord)
					for(a = 0; a < len;){
						aa = temp_array_coord[a++]
						bb = temp_array_coord[a++]
						if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
							continue
						if ore[# aa, bb] >= 0
							temp_array_real[ore_recurso[ore[# aa, bb]]] += ore_amount[# aa, bb]
						else if terreno_recurso_bool[terreno[# aa, bb]]
							temp_array_real[terreno_recurso_id[terreno[# aa, bb]]] = -1
					}
					for(a = 0; a < rss_max; a++)
						if temp_array_real[a] > 0
							temp_text_2 += $"  {recurso_nombre[a]}: {temp_array_real[a]}\n"
						else if temp_array_real[a] = -1
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
				draw_set_color(ui_color_energia)
				draw_circle_off(edificio.center_x, edificio.center_y, CABLE_RANGE, true)
			}
			//Mostrar rango de torres
			if edificio_armas[index]{
				var alc = edificio_alcance[index]
				draw_set_color(ui_texto)
				draw_circle_off(edificio.center_x, edificio.center_y, alc, true)
				if index = id_mortero
					draw_circle_off(edificio.center_x, edificio.center_y, 100, true)
				if edificio.target != null_dron
					draw_sprite_off(spr_target, 0, edificio.target.a, edificio.target.b)
				if info{
					draw_set_alpha(0.3)
					for(a = array_length(edificio.target_chunks) - 1; a >= 0; a--){
						var temp_coord = edificio.target_chunks[a]
						var temp_coord_2 = abtoxy(CHUNK_WIDTH * (temp_coord[0] + 1), CHUNK_HEIGHT * (temp_coord[1] + 1))
						temp_coord = abtoxy(CHUNK_WIDTH * temp_coord[0], CHUNK_HEIGHT * temp_coord[1])
						draw_rectangle_off(temp_coord[0], temp_coord[1], temp_coord_2[0], temp_coord_2[1], false)
					}
					draw_set_color(ui_fondo)
					var temp_coord = abtoxy(CHUNK_WIDTH * edificio.chunk_x, CHUNK_HEIGHT * edificio.chunk_y)
					draw_rectangle_off(temp_coord[0], temp_coord[1], temp_coord[0] + CHUNK_WIDTH * 48, temp_coord[1] + CHUNK_HEIGHT * 14, false)
					draw_set_alpha(1)
				}
			}
			//Mostrar rutas de tuneles
			if tag_edificio_tunel[index]{
				if keyboard_check_pressed(CONTROL_ROTAR) and edificio.link != null_edificio{
					keyboard_clear(CONTROL_ROTAR)
					set_edificio_instruccion(edificio, cambio_rotar_tunel,, true)
				}
			}
			else if tag_dron_encima[index]{
				if tag_edificio_fabrica_drones[index] and edificio.select >= 0{
					temp_text += $"{L.game_creando_dron} {dron_nombre[edificio.select]} ({array_length(drones_propios)}/{8 + 2 * edificios_jugador_index[edificio.jugador, id_nucleo][0].modulo})\n"
					for(a = 0; a < array_length(dron_precio_id[edificio.select]); a++)
						temp_text += $"  {recurso_nombre[dron_precio_id[edificio.select, a]]} {edificio.carga[dron_precio_id[edificio.select, a]]}/{dron_precio_num[edificio.select, a]}\n"
					if edificio.proceso > 0
						temp_text += $"  {L.game_creando_dron} {floor(100 * edificio.proceso / dron_time[edificio.select])}%\n"
					else if array_length(drones_propios) = 8 + 2 * edificios_jugador_index[edificio.jugador, id_nucleo][0].modulo
						temp_text += $"  {L.game_limite_dron} ({array_length(drones_propios)}/{8 + 2 * edificios_jugador_index[edificio.jugador, id_nucleo][0].modulo})\n"
				}
				else if index = id_planta_de_reciclaje{
					draw_set_color(ui_color_reciclaje)
					draw_circle_off(edificio.center_x, edificio.center_y, PLANTA_RECICLAJE_RANGE, true)
					if edificio.select >= 0{
						if edificio.mode
							temp_text += $"{L.almacen_consumiendo} {edificio_nombre[edificio.select]}: {floor(100 * edificio.proceso / max(5, 5 * edificio_precio[edificio.select]))}%\n"
						else
							temp_text += $"{L.almacen_consumiendo} {dron_nombre[edificio.select]}: {floor(100 * edificio.proceso / dron_time[edificio.select])}%\n"
					}
				}
				draw_set_color(ui_boton_azul)
				for(a = array_length(edificio.inputs_carga) - 1; a >= 0; a--){
					var temp_edificio = edificio.inputs_carga[a]
					draw_arrow_off(temp_edificio.center_x, temp_edificio.center_y, edificio.center_x, edificio.center_y, 10)
				}
				draw_set_color(ui_boton_verde)
				for(a = array_length(edificio.outputs_carga) - 1; a >= 0; a--){
					var temp_edificio = edificio.outputs_carga[a]
					draw_arrow_off(edificio.center_x, edificio.center_y, temp_edificio.center_x, temp_edificio.center_y, 10)
				}
			}
			else if index = id_mensaje
				temp_text += $"{edificio.variables[0]}\n"
			else if index = id_tuberia_subterranea and edificio.link != null_edificio{
				draw_set_color(ui_color_flujo)
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
						temp_text += $"{misiles_nombre[select]} {L.misil_listo}\n"
					else
						temp_text += $"{L.fabricando} {misiles_nombre[select]}\n"
					for(a = 0; a < array_length(misiles_precio_id[select]); a++)
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
					for(a = 0; a < rss_max; a++)
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
					for(a = 0; a < rss_max; a++)
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
					if flujo.liquido != -1 and edificio_flujo_consumo[index] > 0 and tag_liquido_obligatorio[index]
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
					draw_set_color(ui_color_energia)
					for(a = array_length(edificio.energia_link) - 1; a >= 0; a--){
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
					if array_length(edificio_flujo_liquido[index]) > 1{
						flujo = edificio.flujo_2
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
					}
				}
			}
			if info{
				var flag_rss = false
				for(a = 0; a < rss_max; a++)
					if edificio.carga[a] != 0{
						flag_rss = true
						break
					}
				if flag_rss{
					temp_text += L.almacen
					for(a = 0; a < rss_max; a++)
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
		b = repair_id[# mx, my][jugador]
		var temp_text_2 = ""
		if b > 0{
			var _comprable = true
			if not cheat
				_comprable = check_reconstruible(b,, jugador)._comprable
			if not _comprable{
				temp_complex = abtoxy(mx, my)
				draw_sprite_off(spr_rojo, 0, temp_complex[0], temp_complex[1],,,,, 0.5)
				draw_text_background_off(temp_complex[0] + 20, temp_complex[1], temp_text_2)
			}
			else if mouse_check_button(mb_left){
				var temp_edificio = construir(b, repair_dir[# mx, my][jugador], mx, my, true)
				if tag_edificio_seteable[b]
					set_edificio(repair_mode[# mx, my][jugador], repair_select[# mx, my][jugador], temp_edificio, true)
			}
			if mouse_check_button(mb_right)
				repair_id[# mx, my][jugador] = -1
		}
	}
	//Seleccionar drones
	else if DEVISE and mouse_check_button_pressed(mb_left) and build_index = -1{
		mx_clic = xmouse
		my_clic = ymouse
		clicked = true
	}
	if DEVISE and mouse_check_button(mb_left) and clicked and build_index = -1 and not keyboard_check(CONTROL_REPARAR){
		draw_set_alpha(0.5)
		draw_set_color(ui_fondo)
		draw_rectangle_off(mx_clic, my_clic, xmouse, ymouse, false)
		draw_set_color(EQUIPO_COLOR[jugador])
		var minx = min(mx_clic, xmouse), miny = min(my_clic, ymouse), maxx = max(mx_clic, xmouse), maxy = max(my_clic, ymouse)
		for(a = array_length(drones_propios) - 1; a >= 0; a--){
			var dron = drones_propios[a]
			if tag_dron_seleccionable[dron.index]{
				var xx = dron.x, yy = dron.y
				if xx > minx and yy > miny and xx < maxx and yy < maxy
					draw_circle_off(xx, yy, 30, true)
			}
		}
		draw_set_alpha(1)
	}
	if DEVISE and mouse_check_button_released(mb_left) and clicked and build_index = -1{
		deselect_drones()
		var minx = min(mx_clic, xmouse), miny = min(my_clic, ymouse), maxx = max(mx_clic, xmouse), maxy = max(my_clic, ymouse)
		for(a = array_length(drones_propios) - 1; a >= 0; a--){
			var dron = drones_propios[a]
			if tag_dron_seleccionable[dron.index]{
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
	var chunk_mx = floor(mx / CHUNK_WIDTH), chunk_my = floor(my / CHUNK_HEIGHT), min_dis = 900, min_dron = null_dron, temp_array_dron
	var next_chunk_x = ((mx mod CHUNK_WIDTH) > (CHUNK_WIDTH / 2)) ? [0, 1, 0, 1] : [0, -1, 0, -1]
	var next_chunk_y = ((my mod CHUNK_HEIGHT) > (CHUNK_HEIGHT / 2)) ? [0, 0, 1, 1] : [0, 0, -1, -1], dron, dis
	for(i = 0; i < 4; i++){
		aa = chunk_mx + next_chunk_x[i]
		bb = chunk_my + next_chunk_y[i]
		if aa < 0 or bb < 0 or aa >= chunk_xsize or bb >= chunk_ysize
			continue
		temp_array_dron = ds_grid_get(chunk_dron, aa, bb)
		for(a = 0; a < array_length(temp_array_dron); a++){
			dron = temp_array_dron[a]
			dis = point_distance(dron.x, dron.y, xmouse, ymouse)
			if dis < min_dis{
				min_dis = dis
				min_dron = dron
			}
		}
	}
	if min_dis < 30{
		dron = min_dron
		draw_set_color(EQUIPO_COLOR[jugador])
		draw_circle_off(dron.x, dron.y, 20, true)
		temp_text += $"{dron_nombre[dron.index]}\n"
		temp_text += $"{dron.jugador != jugador ? L.enemigo : L.aliado}\n"
		temp_text += $"vida: {dron.vida}/{dron.vida_max}\n"
		var flag_dron = false
		for(a = 0; a < rss_max; a++)
			if dron.carga[a] > 0{
				flag_dron = true
				break
			}
		if flag_dron{
			temp_text += $"{L.carga}:\n"
			for(a = 0; a < rss_max; a++)
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
	for(a = array_length(selected_drones) - 1; a >= 0; a--){
		var dron = selected_drones[a]
		draw_set_color(EQUIPO_COLOR[dron.jugador])
		draw_circle_off(dron.x, dron.y, 30, true)
		if dron.index = idd_mula and right_clicked{
			mouse_clear(mb_right)
			if edificio.index = id_puerto_de_carga
				mover_dron(dron, edificio.x, edificio.y, true)
			continue
		}
		if dron.modo = 1 and not dron.index = idd_minero
			draw_sprite_off(spr_target, 0, dron.move_x, dron.move_y)
		if right_clicked and tag_dron_seleccionable[dron.index]{
			mouse_clear(mb_right)
			mover_dron(dron, xmouse, ymouse, true)
		}
		if dron.index = idd_minero{
			if dron.modo = 1{
				temp_complex = xytoab(dron.move_x, dron.move_y)
				draw_sprite_off(spr_target, 0, temp_complex[0], temp_complex[1])
			}
			else if dron.target != null_edificio
				draw_sprite_off(spr_target, 0, dron.target.center_x, dron.target.center_y)
			if ore[# mx, my] >= 0
				draw_sprite(spr_minar, ore[# mx, my] = ido_uranio, mouse_x, mouse_y)
		}
		if dron.temp_target != null_edificio
			draw_sprite_off(spr_target, 0, dron.temp_target.center_x, dron.temp_target.center_y)
		if dron.target_dron != null_dron
			draw_sprite_off(spr_target, 0, dron.target_dron.x, dron.target_dron.y)
	}
}
//Seleccionar target edificio
if puerto_carga_select > 0 or (procesador_select != null_edificio) or (misil_set_target != null_edificio){
	draw_set_halign(fa_center)
	if puerto_carga_select > 0{
		temp_text = L.game_puerto_carga
		draw_circle_off(puerto_carga_link.center_x, puerto_carga_link.center_y, PUERTO_CARGA_RANGE, true)
		aa = puerto_carga_link.x
		bb = puerto_carga_link.y
		if puerto_carga_select = 1{
			for(a = 0; a < edificio_max; a++)
				if edificio_output_all[a] or array_contains(edificio_output_id[a], puerto_carga_rss)
					for(b = 0; b < array_length(edificios_jugador_index[jugador, a]); b++){
						var temp_edificio = edificios_jugador_index[jugador, a][b]
						if temp_edificio.a > mina and temp_edificio.b > minb and temp_edificio.a < maxa and temp_edificio.b < maxb and point_distance(temp_edificio.x, temp_edificio.y, aa, bb) < PUERTO_CARGA_RANGE
							draw_edificio_borde(temp_edificio, ui_boton_verde, _parpadeo)
					}
		}
		else if puerto_carga_select = 2{
			var temp_edificio_2 = edificio_id[# puerto_carga_link.instruccion[puerto_carga_instruccion, 1], puerto_carga_link.instruccion[puerto_carga_instruccion, 2]]
			draw_edificio_borde(temp_edificio_2, ui_boton_verde, 1)
			for(a = 0; a < edificio_max; a++)
				if edificio_input_all[a] or array_contains(edificio_input_id[a], puerto_carga_rss)
					for(b = 0; b < array_length(edificios_jugador_index[jugador, a]); b++){
						var temp_edificio = edificios_jugador_index[jugador, a][b]
						if temp_edificio.a > mina and temp_edificio.b > minb and temp_edificio.a < maxa and temp_edificio.b < maxb and point_distance(temp_edificio.x, temp_edificio.y, aa, bb) < PUERTO_CARGA_RANGE and temp_edificio != temp_edificio_2{
							draw_edificio_borde(temp_edificio, ui_boton_azul, _parpadeo)
							if temp_edificio = edificio
								draw_arrow_off(temp_edificio_2.center_x, temp_edificio_2.center_y, edificio.center_x, edificio.center_y, 8)
						}
					}
		}
	}
	else if procesador_select != null_edificio{
		temp_text = L.game_vincular_procesador
		for(a = 1; a < array_length(procesador_select.procesador_link); a++){
			var temp_edificio = procesador_select.procesador_link[a]
			draw_set_color(ui_boton_verde)
			draw_arrow_off(procesador_select.center_x, procesador_select.center_y, temp_edificio.center_x, temp_edificio.center_y, 8)
			draw_set_color(ui_fondo)
			draw_text_off((procesador_select.center_x + temp_edificio.center_x) / 2, (procesador_select.center_y + temp_edificio.center_y) / 2, a)
		}
	}
	else if misil_set_target != null_edificio
		temp_text = L.marcar_objetivo
	draw_text_background(room_width / 2, 100, temp_text)
	draw_set_halign(fa_left)
	if misil_set_target != null_edificio{
		if mouse_check_button_pressed(mb_left)
			set_edificio_instruccion(misil_set_target, cambio_silo_target, {_x : xmouse, _y : ymouse}, true)
		if mouse_check_button_pressed(mb_any){
			mouse_clear(mouse_lastbutton)
			misil_set_target = null_edificio
		}	
	}
	else if mouse_check_button_pressed(mb_any){
		mouse_clear(mouse_lastbutton)
		puerto_carga_select = 0
		procesador_select = null_edificio
	}
}
if sonido
	for(a = 0; a < SONIDOS_MAX; a++)
		volumen[a] = 0
#region Menú de edificios
	//ANDROID
	if not DEVISE and build_menu = 0 and build_index = -1 and draw_sprite_boton(spr_construir, 0, room_width - 80, room_height - 80, 68, 68){
		build_menu = 1
		menu_x = room_width / 2
		menu_y = room_height / 2
		android_building = false
	}
	var just_pressed = false, _size = DEVISE ? 100 : 200, _size_sqr = DEVISE ? 100 : 200, _size_sqrx = DEVISE ? 32 : 64, _size_sqry = DEVISE ? TILE_WIDTH : 56
	if DEVISE and mouse_check_button_pressed(mb_right) and build_index = -1 and not edificio_bool[# mx, my] and not keyboard_check(CONTROL_REPARAR) and pausa != 1{
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
		if not DEVISE and draw_sprite_boton(spr_construir, 1, room_width - 80, room_height - 80, 64, 56)
			build_menu = 0
		b = 2 * pi / array_length(categoria_nombre_disponible)
		draw_set_color(ui_texto)
		draw_circle(menu_x, menu_y, _size, true)
		if mision_actual >= 0 and in(mision.objetivo, idm_construir, idm_tener_construido){
			flag = false
			draw_set_color(ui_boton_azul)
			draw_set_alpha(0.5)
			for(a = 0; a < array_length(categoria_index_disponible); a++){
				for(i = 0; i < array_length(categoria_edificios[categoria_index_disponible[a]]); i++)
					if categoria_edificios[categoria_index_disponible[a], i] = mision.target_id{
						flag = true
						draw_arco(menu_x, menu_y, _size, a * b, (a + 1) * b)
						break
					}
				if flag
					break
			}
			draw_set_color(ui_texto)
			draw_set_alpha(1)
		}
		draw_circle(menu_x, menu_y, _size / 10, false)
		for(a = 0; a < array_length(categoria_nombre_disponible); a++){
			var angle = a * b
			draw_sprite_stretched(spr_items, categoria_index_disponible[a], menu_x - 15 + _size * cos(angle + b / 2), menu_y - 15 - _size * sin(angle + b / 2), _size_sqrx, _size_sqry)
			draw_line(menu_x, menu_y, menu_x + _size * cos(angle), menu_y - _size * sin(angle))
		}
		if point_distance(mouse_x, mouse_y, menu_x, menu_y) < _size_sqr{
			temp_text = ""
			a = floor((array_length(categoria_nombre_disponible) - arctan2(mouse_y - menu_y, mouse_x - menu_x) / b) mod array_length(categoria_nombre_disponible))
			draw_set_alpha(0.5)
			draw_arco(menu_x, menu_y, _size, a * b, (a + 1) * b)
			draw_set_alpha(1)
			draw_sprite_stretched(spr_items, categoria_index_disponible[a], menu_x - 15 + _size * cos((a + 0.5) * b), menu_y - 15 - _size * sin((a + 0.5) * b), _size_sqrx, _size_sqry)
			if DEVISE{
				temp_text = categoria_nombre[categoria_index_disponible[a]]
				draw_text_background(min(room_width - string_width(temp_text), mouse_x + 20), min(room_height - string_height(temp_text), mouse_y), temp_text)
			}
			if mouse_check_button_pressed(mb_left){
				mouse_clear(mb_left)
				build_menu = 2
				menu_array = categoria_edificios_disponible[categoria_index_disponible[a]]
			}
		}
		else if DEVISE and mouse_check_button_pressed(mb_left){
			mouse_clear(mb_left)
			build_menu = 0
		}
	}
	else if build_menu = 2{
		if not DEVISE and draw_sprite_boton(spr_construir, 1, room_width - 80, room_height - 80, 64, 56)
			build_menu = 1
		b = 2 * pi / array_length(menu_array)
		draw_set_color(ui_texto)
		draw_circle(menu_x, menu_y, _size, true)
		for(a = 0; a < array_length(menu_array); a++){
			var angle = a * b, _comprable = true, index = menu_array[a]
			draw_line(menu_x, menu_y, menu_x + _size * cos(angle), menu_y - _size * sin(angle))
			if not cheat{
				_comprable = edificio_tecnologia[jugador, index] or not tecnologia
				if _comprable
					_comprable = is_comprable(edificio_precio_id[index], edificio_precio_num[index])
				if not _comprable{
					draw_set_alpha(0.5)
					draw_set_color(ui_boton_rojo)
					draw_arco(menu_x, menu_y, _size, angle, angle + b)
					draw_set_alpha(1)
					draw_set_color(ui_texto)
				}
			}
			draw_sprite_stretched(edificio_sprite[index], 0, menu_x - 15 + _size * cos(angle + b / 2), menu_y - 15 - _size * sin(angle + b / 2), _size_sqrx, _size_sqry)
		}
		draw_circle(menu_x, menu_y, 10, false)
		if point_distance(mouse_x, mouse_y, menu_x, menu_y) < _size_sqr{
			a = floor((array_length(menu_array) - arctan2(mouse_y - menu_y, mouse_x - menu_x) / b) mod array_length(menu_array))
			draw_set_alpha(0.5)
			draw_arco(menu_x, menu_y, _size, a * b, (a + 1) * b)
			draw_set_alpha(1)
			draw_sprite_stretched(edificio_sprite[menu_array[a]], 0, menu_x - 15 + _size * cos((a + 0.5) * b), menu_y - 15 - _size * sin((a + 0.5) * b), _size_sqrx, _size_sqry)
			a = menu_array[a]
			if DEVISE{
				temp_text = $"{edificio_nombre[a]} ({L.hotkey}: {edificio_key[a]})\n"
				if not cheat{
					if tecnologia and not edificio_tecnologia[jugador, a]
						temp_text += $"  {L.falta_tecnologia}\n"
					for(c = 0; c < array_length(edificio_precio_id[a]); c++)
						temp_text += $"  {recurso_nombre[edificio_precio_id[a, c]]}: {edificio_precio_num[a, c]}\n"
				}
				temp_text += $"{edificio_descripcion[a]}\n"
				draw_text_background(min(room_width - string_width(temp_text), mouse_x + 20), min(room_height - string_height(temp_text), mouse_y), temp_text)
			}
			if mouse_check_button_pressed(mb_left){
				mouse_clear(mb_left)
				build_menu = 0
				if tecnologia and not cheat and not edificio_tecnologia[jugador, a]{
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
		else if DEVISE and mouse_check_button_pressed(mb_left){
			mouse_clear(mb_left)
			build_menu = 1
		}
	}
#endregion
//Acceso directo
if keyboard_check_pressed(vk_anykey) and (not in(ord(keyboard_lastchar), CONTROL_LEFT, CONTROL_RIGHT, CONTROL_UP, CONTROL_DOWN, ord(" ")) or cheat) and win = 0 and not show_menu and not chat_input{
	for(a = 1; a < edificio_max; a++)
		if edificio_key[a] != "" and string_ends_with(keyboard_string, edificio_key[a]){
			if tecnologia and not cheat and not edificio_tecnologia[jugador, a]{
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
if DEVISE and (mouse_check_button_pressed(mb_right) or keyboard_check_pressed(vk_escape)) and (build_index >= 0 or show_menu) and selected_dron = null_dron{
	mouse_clear(mb_right)
	keyboard_clear(vk_escape)
	clear_edit()
}
//CONSTRUCCIÓN
if build_index >= 0 and win = 0
	menu_construccion(mx, my, xmouse, ymouse, just_pressed, prev_change,outside)
else if build_index = -1 and win = 0 and array_length(blueprint) > 0{
	len = array_length(blueprint)
	var flip = (((blueprint_mod2 + my) mod 2) = 1), _rotar = false, len2
	//Guardar
	if not blueprint_safe{
		draw_set_halign(fa_center)
		if draw_boton(room_width / 2, 40, L.guardar_plano){
			blueprint_safe = true
			buffer = buffer_create(2 + 4 * len, buffer_grow, 1)
			buffer_write(buffer, buffer_u8, len)
			buffer_write(buffer, buffer_bool, blueprint_mod2)
			for(a = 0; a < len; a++){
				var temp_blueprint = blueprint[a]
				buffer_write(buffer, buffer_u8, temp_blueprint.a)
				buffer_write(buffer, buffer_u8, temp_blueprint.b)
				buffer_write(buffer, buffer_u8, temp_blueprint.index)
				buffer_write(buffer, buffer_u8, temp_blueprint.dir)
				buffer_write(buffer, buffer_s16, temp_blueprint.rot0)
				buffer_write(buffer, buffer_s16, temp_blueprint.rot4)
				buffer_write(buffer, buffer_s16, temp_blueprint.rot5)
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
			for(a = 0; a < len; a++){
				var temp_blueprint = blueprint[a], aaa = temp_blueprint.a + mx
				if flip and (temp_blueprint.b & 1){
					if blueprint_mod2
						aaa--
					else
						aaa++
				}
				temp_complex = abtoxy(aaa, temp_blueprint.b + my)
				aa = temp_complex[0]
				bb = temp_complex[1]
				var index = temp_blueprint.index, dir = temp_blueprint.dir
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
			sprite_delete(sprite)
		}
		draw_set_halign(fa_left)
	}
	//Cancelar
	if mouse_check_button_pressed(mb_right){
		mouse_clear(mb_right)
		array_resize(blueprint, 0)
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
		for(a = 0; a < len; a++){
			var temp_blueprint = blueprint[a], size = edificio_size[temp_blueprint.index]
			if (size & 1) = 0
				blueprint[a].dir = 5 - temp_blueprint.dir
			else if temp_dir
				blueprint[a].dir = (temp_blueprint.dir + 5) mod 6
			else
				blueprint[a].dir = (temp_blueprint.dir + 1) mod 6
			b = temp_blueprint.rot0
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
			var tempa = mx, tempb = my
			temp_array_real = [temp_blueprint.rot0, temp_blueprint.rot4, temp_blueprint.rot5]
			var temp_array_real_2 = [0, 4, 5]
			for(i = 0; i < 3; i++){
				if temp_array_real[i] < 0
					temp_array_real_2[i] = (temp_array_real_2[i] + 3) mod 6
				repeat(abs(temp_array_real[i])){
					tempa = tempa + DESFACE_A[tempb & 1, temp_array_real_2[i]]
					tempb = tempb + DESFACE_B[tempb & 1, temp_array_real_2[i]]
				}
			}
			blueprint[a].a = tempa - mx
			blueprint[a].b = tempb - my
			blueprint_mina = min(blueprint_mina, blueprint[a].a)
			blueprint_minb = min(blueprint_minb, blueprint[a].b)
		}
		for(a = 0; a < len; a++){
			blueprint[a].a -= blueprint_mina
			blueprint[a].b -= blueprint_minb
		}
		blueprint_mod2 = (blueprint_minb & 1)
	}
	//Detectar colisiones
	if not (last_mx = mx and last_my = my) or _rotar{
		for(a = 0; a < len; a++){
			var temp_blueprint = blueprint[a], aaa = temp_blueprint.a + mx
			if flip and (temp_blueprint.b & 1) = 1{
				if blueprint_mod2
					aaa--
				else
					aaa++
			}
			blueprint[a].construible = check_colision(aaa, temp_blueprint.b + my, temp_blueprint.index, temp_blueprint.dir)
		}
	}
	//Dibujar Blueprint
	for(a = 0; a < len; a++){
		var temp_blueprint = blueprint[a], aaa = temp_blueprint.a + mx
		if flip and (temp_blueprint.b & 1){
			if blueprint_mod2
				aaa--
			else
				aaa++
		}
		temp_complex = abtoxy(aaa, temp_blueprint.b + my)
		aa = temp_complex[0]
		bb = temp_complex[1]
		var index = temp_blueprint.index, dir = temp_blueprint.dir
		draw_edificio(aa, bb, index, dir, 0.5)
		if not temp_blueprint.construible{
			var size = get_size(aaa, temp_blueprint.b + my, dir, edificio_size[index])
			len2 = array_length(size)
			for(b = 0; b < len2;){
				var aaaa = size[b++], bbb = size[b++]
				temp_complex = abtoxy(aaaa, bbb)
				draw_sprite_off(spr_rojo, 0, temp_complex[0], temp_complex[1],,,,, 0.5)
			}
		}
	}
	//Construir
	if mouse_check_button_pressed(mb_left){
		mouse_clear(mb_left)
		if not keyboard_check(vk_lshift)
			array_resize(blueprint, 0)
		for(a = 0; a < len; a++){
			var temp_blueprint = blueprint[a], aaa = temp_blueprint.a + mx
			if flip and (temp_blueprint.b & 1) = 1{
				if blueprint_mod2
					aaa--
				else
					aaa++
			}
			if temp_blueprint.construible and is_comprable(edificio_precio_id[temp_blueprint.index], edificio_precio_num[temp_blueprint.index])
				construir(temp_blueprint.index, temp_blueprint.dir, aaa, temp_blueprint.b + my, true)
		}
	}
	last_mx = mx
	last_my = my
}
//Destruir edificio
else{
	if ((mouse_check_button(mb_right) and prev_change) or mouse_check_button_pressed(mb_right)) and not outside and edificio_bool[# mx, my] and edificio.index != id_nucleo and edificio.jugador = jugador{
		prev_change = true
		delete_edificio(edificio,, true)
	}
}
var temp_text_right = ""
//Juego
if menu = MENU_JUEGO{
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
		draw_once = true
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
		a = mision_actual
		if not in(mision.objetivo, idm_sin_objetivo, idm_apretar_ADWS)
			temp_text_right += $"\n\n{mision.nombre}\n{objetivos_nombre[mision.objetivo]} {mision.target_num} "
		if in(mision.objetivo, idm_conseguir, idm_tener_acumulado)
			temp_text_right += recurso_nombre[mision.target_id]
		else if in(mision.objetivo, idm_construir, idm_tener_construido, idm_cargar_edificio, idm_destruir_edificio)
			temp_text_right += edificio_nombre[mision.target_id]
		else if mision.objetivo = idm_sobrevivir_oleadas
			temp_text_right += L.mision_enemigos
		if not in(mision.objetivo, idm_sin_objetivo, idm_cargar_edificio)
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
	if not grafic_hideui and draw_sprite_boton(spr_manual,, room_width - 64, string_height(temp_text_right), 64, 64,, hover_sprite_boton_text, {a : $"{L.game_enciclopedia} (Y)"})
		enciclopedia = 1
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
			temp_text = ""
			for(a = array_length(redes) - 1; a >= 0; a--){
				var red = redes[a]
				if array_length(red.edificios) > 1{
					temp_text += $"{L.red_red} {a}:\n"
					temp_text += $"  {L.red_consumo}: {red.consumo}\n"
					temp_text += $"  {L.red_generacion}: {red.generacion}\n"
					temp_text += $"  {L.red_bateria}: {floor(red.bateria)}/{red.bateria_max}\n"
					temp_text += red_text(red)
					draw_set_color(make_color_hsv(255 * a / array_length(redes), 255, 255))
					for(b = array_length(red.edificios) - 1; b >= 0; b--){
						edificio = red.edificios[b]
						var center_x = edificio.center_x, center_y = edificio.center_y
						for(c = array_length(edificio.energia_link) - 1; c >= 0; c--){
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
			temp_text = ""
			for(a = array_length(flujos) - 1; a >= 0; a--){
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
					for(b = array_length(flujo.edificios) - 1; b >= 0; b--){
						edificio = flujo.edificios[b]
						var center_x = edificio.center_x, center_y = edificio.center_y
						for(c = array_length(edificio.flujo_link) - 1; c >= 0; c--){
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
	//Victoria / Derrota
	if win > 0{
		draw_set_color(ui_fondo)
		draw_set_alpha(min(++win_step / 100, 0.5))
		draw_rectangle(0, 0, room_width, room_height, false)
		draw_set_color(ui_texto)
		if win_step > 25{
			draw_set_alpha(min((win_step - 25) / 100, 1))
			draw_set_font(font_titulo)
			draw_set_halign(fa_center)
			draw_text(room_width / 2, 100, (win mod 10) = 1 ? L.win_victoria : L.win_derrota)
			draw_set_font(font_normal)
			xpos = room_width / 2
			ypos = 200
			var sec = floor(timer / 60)
			//Info general
			if win < 10{
				ypos = draw_text_ypos(xpos, ypos, $"{L.win_tiempo}: {sec >= 60 ? string(floor(sec / 60)) + "m " : ""}{sec mod 60}s")
				if tecnologia
					ypos = draw_text_ypos(xpos, ypos, $"{L.win_tecnologias}: {tecnologias_estudiadas}")
				if modo_misiones
					ypos = draw_text_ypos(xpos, ypos, $"{L.win_misiones}: {misiones_pasadas}")
				b = 0
				for(a = 0; a < rss_max; a++)
					b += recursos_obtenidos[a]
				if b > 0{
					if draw_boton(xpos, ypos + 10, $"{L.recursos_obtenidos}: {num_format(b)}", ui_azul){
						usable_rss_bool = array_create(rss_max, true)
						win += 10
					}
					ypos += text_y + 10
				}
				b = 0
				for(a = array_length(energia_producida) - 1; a >= 0; a--)
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
				for(a = 0; a < array_length(recursos_obtenidos_time); a++){
					show_array[a] = array_create(rss_max, 0)
					for(b = 0; b < rss_max; b++)
						array_set(show_array[a], b, recursos_obtenidos_time[a, b])
				}
				for(a = 0; a < rss_max; a++)
					if recursos_obtenidos[a] > 0{
						if usable_rss_bool[a]
							draw_set_color(recurso_color[a])
						else{
							draw_set_color(make_color_hsv(color_get_hue(recurso_color[a]), color_get_saturation(recurso_color[a]), color_get_value(recurso_color[a]) / 2))
							for(b = 0; b < array_length(recursos_obtenidos_time); b++)
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
				for(a = array_length(energia_producida) - 1; a >= 0; a--){
					temp_prod += energia_producida[a]
					temp_cons += energia_consumida[a]
					temp_perd += energia_perdida[a]
				}
				draw_set_color(ui_color_energia)
				ypos = draw_text_ypos(xpos, ypos, $"{L.energia_producida}: {num_format(temp_prod)}")
				draw_set_color(ui_fondo)
				ypos = draw_text_ypos(xpos, ypos, $"{L.energia_consumida}: {num_format(temp_cons)}")
				if (temp_prod + temp_perd) > 0{
					draw_set_color(ui_boton_rojo)
					ypos = draw_text_ypos(xpos, ypos, $"{L.energia_perdida}: {num_format(temp_perd)} ({100 - floor(100 * temp_prod / (temp_prod + temp_perd))}%)")
				}
				draw_set_color(ui_texto)
				draw_graph(xpos - 200, ypos, 400, 100, [energia_producida, energia_consumida, energia_perdida], [ ui_color_energia, ui_fondo, ui_boton_rojo], true)
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
				game_terminar(fin_salir, MENU_PRINCIPAL)
			}
		}
		draw_set_alpha(1)
	}
}
else if not chat_input
	control_camara()
if menu = MENU_JUEGO or menu = MENU_EDITOR_JUEGO{
	if win = 0 and not show_menu and (not chat_input and keyboard_check_pressed(vk_anykey)){
		if (keyboard_check_pressed(CONTROL_MENU) or (not DEVISE and keyboard_check_pressed(vk_backspace))) and pausa != 1{
			if not DEVISE
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
	for(a = 0; a < SONIDOS_MAX; a++){
		if not audio_is_paused(sonido_id[a]) and volumen[a] = 0
			audio_pause_sound(sonido_id[a])
		if audio_is_paused(sonido_id[a]) and volumen[a] > 0
			audio_resume_sound(sonido_id[a])
		audio_sound_gain(sonido_id[a], volumen[a], 0)
	}
	if clic_sound
		audio_play_sound(snd_click, 1, false, 0.3)
}
if musica and random(3600) < 1{
	flag = true
	for(a = array_length(MUSICA) - 1; a >= 0; a--)
		if audio_is_playing(MUSICA[a]){
			flag = false
			break
		}
	if flag
		audio_play_sound(MUSICA[irandom(array_length(MUSICA) - 1)], 1, false)
}
if array_length(chat) > 0{
	var max_width = 0, pos = 0
	if get_keyboard_string != 0
		for(pos = 0; pos < array_length(chat); pos++)
			if chat_time[pos] > image_index - 600
				break
	pos = max(pos, array_length(chat) - 10)
	for(a = pos; a < array_length(chat); a++)
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
	draw_set_color(ui_fondo)
	draw_set_alpha(0.5)
	draw_rectangle(0, room_height, max_width, room_height - ui_height * (array_length(chat) - pos) - ui_height, false)
	draw_set_color(ui_texto)
	draw_set_alpha(1)
	for(a = pos; a < array_length(chat); a++)
		draw_text(0, room_height + ui_height * (a - array_length(chat)) - ui_height, string(chat[a]))
	draw_boton_text_counter = 0
	chat_text = draw_boton_text(0, room_height - ui_height, chat_text, false,, false)
}
if keyboard_check(CONTROL_TAB) and online{
	draw_set_color(ui_fondo)
	draw_set_halign(fa_center)
	draw_set_alpha(0.5)
	var max_width = 0, max_height = ui_height
	for(a = 0; a < MAX_JUGADORES; a++)
		if server_jugadores[a] != -1{
			max_width = max(max_width, string_width(server_jugadores_nombre[a]))
			max_height += 2 * ui_height
		}
	max_width += 30
	draw_rectangle((room_width - max_width) / 2, 150, (room_width + max_width) / 2, 150 + max_height, false)
	draw_set_color(ui_texto)
	draw_set_alpha(1)
	ypos = 160
	for(a = 0; a < MAX_JUGADORES; a++)
		if server_jugadores[a] != -1{
			if draw_boton(room_width / 2, ypos, server_jugadores_nombre[a],,,, true) and a != 0 and servidor
				server_jugador_expulsar(a)
			ypos += text_y * 1.5
		}
	draw_set_halign(fa_left)
}
draw_sprite(spr_vineta, 0, 0, 0)
if debug_frame_time{
	draw_set_halign(fa_right)
	draw_set_valign(fa_bottom)
	draw_set_color(ui_texto)
	draw_text(room_width, room_height, $"frame_time: {debug_frame_time_value}µs")
	debug_frame_time_value_2 += get_timer() - _frame_time
	if (image_index mod 60) = 0{
		debug_frame_time_value = floor((debug_frame_time_value + debug_frame_time_value_2 / 60) / 2)
		debug_frame_time_value_2 = 0
	}
}
