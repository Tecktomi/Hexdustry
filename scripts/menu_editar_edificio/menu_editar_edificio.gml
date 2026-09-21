function menu_editar_edificio(){
	with control{
		var edificio = show_menu_build, index = edificio.index, a, xpos, ypos, b, size, buffer, flag, temp_text, temp_complex, aa, bb, c, len, temp_array_real
		if index = id_procesador{
			draw_boton_text_counter = 0
			show_smoke = false
			draw_set_color(ui_color_procesador)
			draw_roundrect(100, 100, room_width - 100, room_height - 100, false)
			draw_set_color(ui_texto)
			draw_roundrect(100, 100, room_width - 100, room_height - 100, true)
			b = 0
			draw_set_halign(fa_center)
			if draw_boton(room_width / 2, 110, L.procesador_vincular,,,, false){
				procesador_select = edificio
				show_menu = false
			}
			draw_set_halign(fa_left)
			ypos = 150
			size = array_length(edificio.instruccion)
			//SCROLL
			scroll(110, ypos, size, DEVISE ? 25 : 12, DEVISE ? 20 : 40, scroll_procesador, {xpos : 150, ypos : ypos, edificio : edificio, size : size, b : 0})
			draw_boton_text_list_end()
			xpos = 150
			ypos += min(size, 25) * 20
			if draw_boton(xpos, ypos, L.procesador_add, ui_azul,,, false) or keyboard_check_pressed(vk_enter){
				keyboard_clear(vk_enter)
				procesador_add = true
				input_layer = 1
			}
			if procesador_add{
				var width = 0, i, new_instruccion
				for(a = 0; a < array_length(PROCESADOR_INSTRUCCIONES_LENGTH); a++)
					width = max(width, string_width($"{procesador_instrucciones_nombre[a]} ({a})"))
				draw_set_color(ui_borde)
				draw_rectangle((room_width - width) / 2 - 4, 200 - 4, (room_width + width) / 2 + 4, 200 + 20 * array_length(PROCESADOR_INSTRUCCIONES_LENGTH) + 4, false)
				draw_set_color(ui_texto)
				draw_rectangle((room_width - width) / 2 - 4, 200 - 4, (room_width + width) / 2 + 4, 200 + 20 * array_length(PROCESADOR_INSTRUCCIONES_LENGTH) + 4, true)
				draw_set_halign(fa_center)
				for(a = 0; a < array_length(PROCESADOR_INSTRUCCIONES_LENGTH); a++)
					if draw_boton(room_width / 2, 200 + 20 * a, $"{procesador_instrucciones_nombre[a]} ({a})",,,, false, 1) or keyboard_check_pressed(ord(string(a))){
						new_instruccion = array_create(PROCESADOR_INSTRUCCIONES_LENGTH[a], 0)
						for(i = 0; i < array_length(procesador_default_instruccion[a]); i++)
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
			for(a = 0; a < array_length(edificio.variables); a++){
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
			if BROWSER and draw_boton(room_width - 120, 530, L.procesador_guardar, ui_azul,,, false) or (keyboard_check(vk_control) and keyboard_check_pressed(ord("S"))){
				save_codes = scan_files("Codes/*.txt", fa_none)
				get_file = 1
				input_layer = 1
				keyboard_clear(ord("S"))
			}
			if BROWSER and draw_boton(room_width - 120, 560, L.procesador_cargar, ui_azul,,, false) or (keyboard_check(vk_control) and keyboard_check_pressed(ord("A"))){
				save_codes = scan_files("Codes/*.txt", fa_none)
				get_file = 2
				input_layer = 1
				keyboard_clear(ord("A"))
			}
			draw_set_halign(fa_left)
			if get_file > 0{
				draw_set_color(ui_fondo)
				draw_rectangle(100, 100, room_width - 100, room_height - 100, false)
				draw_set_color(ui_texto)
				//Cargar
				if get_file = 2{
					for(a = 0; a < array_length(save_codes); a++)
						if draw_boton(140, 160 + 30 * a, save_codes[a],,,,, 1){
							input_layer = 0
							get_file = 0
							buffer = buffer_load("Codes/" + save_codes[a])
							load_procesador(buffer, edificio)
							buffer_delete(buffer)
							edificio.select = 0
						}
				}
				//Guardar
				else if get_file = 1{
					flag = false
					for(a = 0; a < array_length(save_codes); a++)
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
						buffer = buffer_create(6, buffer_grow, 1)
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
			draw_set_color(ui_color_procesador)
			draw_rectangle((room_width - 840) / 2, 100, (room_width + 840) / 2, 480, false)
			draw_set_color(ui_texto)
			draw_rectangle((room_width - 840) / 2, 100, (room_width + 840) / 2, 480, true)
			draw_set_halign(fa_center)
			draw_text(room_width / 2, 110, edificio_nombre[edificio.index])
			draw_set_halign(fa_left)
			for(a = 0; a < 128; a++){
				xpos = (a mod 8) * 100 + (room_width - 800) / 2
				ypos = (a div 8) * 20 + 140
				if is_real(edificio.variables[a]){
					draw_set_color(make_color_rgb(127, 127, 255))
					draw_set_halign(fa_right)
				}
				else{
					draw_set_color(make_color_rgb(255, 91, 91))
					draw_set_halign(fa_left)
				}
				draw_rectangle(xpos, ypos, xpos + 100, ypos + 20, false)
				draw_set_color(ui_texto)
				draw_rectangle(xpos, ypos, xpos + 100, ypos + 20, true)
				if string_length(edificio.variables[a]) > 9
					temp_text = string_copy(edificio.variables[a], 1, 6) + "..."
				else
					temp_text = edificio.variables[a]
				edificio.variables[a] = draw_boton_text(xpos + 100 * (is_real(edificio.variables[a])), ypos, temp_text,, true)
			}
			draw_set_halign(fa_left)
		}
		else{
			temp_complex = abtoxy(edificio.a, edificio.b)
			var width = 80 * zoom, height = 80 * zoom
			aa = clamp(temp_complex[0] * zoom - camx, width, room_width - width)
			bb = clamp(temp_complex[1] * zoom - camy, 0, room_height - height)
			draw_set_color(ui_borde)
			draw_triangle(aa - 10 * zoom, bb + 20 * zoom, aa + 10 * zoom, bb + 20 * zoom, aa, bb + 10 * zoom, false)
			draw_rectangle(aa - 80 * zoom, bb + 20 * zoom, aa + 80 * zoom, bb + 40 * zoom, false)
			if in(index, id_selector, id_recurso_infinito)
				draw_rectangle(aa - 80 * zoom, bb + 40 * zoom, aa + 80 * zoom, bb + (40 + TILE_WIDTH * ceil(rss_max / 5)) * zoom, false)
			else if index = id_liquido_infinito
				draw_rectangle(aa - 80 * zoom, bb + 40 * zoom, aa + 80 * zoom, bb + (40 + 20 * liquido_max) * zoom, false)
			else if index = id_planta_quimica
				draw_rectangle(aa - 90 * zoom, bb + 40 * zoom, aa + 90 * zoom, bb + (40 + 20 * array_length(planta_quimica_receta)) * zoom, false)
			else if tag_edificio_fabrica_drones[index]{
				temp_array_real = (index = id_fabrica_de_drones) ? fabrica_de_drones_array : fabrica_de_drones_grande_array
				draw_rectangle(aa - 80 * zoom, bb + 40 * zoom, aa + 80 * zoom, bb + (40 + 20 * array_length(temp_array_real)) * zoom, false)
			}
			else if index = id_refineria_de_petroleo{
				c = max(max(string_width(recurso_nombre[idr_compuesto_incendiario]), string_width(recurso_nombre[idr_plastico]), string_width(recurso_nombre[idr_piedra_sulfatada])) + string_width(": 100%"), 200)
				draw_rectangle(aa - c * zoom / 2, bb + 40 * zoom, aa + c * zoom / 2, bb + 120 * zoom, false)
			}
			else if index = id_silo_de_misiles
				draw_rectangle(aa - 80 * zoom, bb + 40 * zoom, aa + 80 * zoom, bb + (40 + 20 * (array_length(misiles_nombre) - not permitir_nuclear)) * zoom, false)
			draw_set_color(ui_fondo)
			draw_triangle(aa - 10 * zoom, bb + 20 * zoom, aa + 10 * zoom, bb + 20 * zoom, aa, bb + 10 * zoom, true)
			draw_rectangle(aa - 80 * zoom, bb + 20 * zoom, aa + 80 * zoom, bb + 40 * zoom, true)
			draw_set_color(ui_texto)
			if in(index, id_selector, id_overflow)
				draw_text(aa - 80 * zoom, bb + 20 * zoom, L.show_menu_invertir)
			if in(index, id_selector, id_recurso_infinito){
				draw_rectangle(aa - 80 * zoom, bb + 40 * zoom, aa + 80 * zoom, bb + (40 + TILE_WIDTH * ceil(rss_max / 5)) * zoom, true)
				for(a = 0; a < rss_max; a++)
					draw_sprite_stretched(recurso_sprite[a], 0, aa + (-80 + 32 * (a mod 5)) * zoom, bb + (40 + TILE_WIDTH * floor(a / 5)) * zoom, 32 * zoom, TILE_WIDTH * zoom)
			}
			if index = id_liquido_infinito{
				draw_rectangle(aa - 80 * zoom, bb + 40 * zoom, aa + 80 * zoom, bb + (40 + 20 * liquido_max) * zoom, true)
				draw_text(aa - 80 * zoom, bb + 20 * zoom, L.show_menu_ningun_liquido)
				for(a = 0; a < liquido_max; a++)
					draw_text(aa - 80 * zoom, bb + (40 + 20 * a) * zoom, liquido_nombre[a])
			}
			if index = id_planta_quimica{
				draw_rectangle(aa - 90 * zoom, bb + 40 * zoom, aa + 90 * zoom, bb + (40 + 20 * array_length(planta_quimica_receta)) * zoom, true)
				draw_text(aa - 80 * zoom, bb + 20 * zoom, L.show_menu_receta)
				for(a = 0; a < array_length(planta_quimica_receta); a++){
					draw_sprite(planta_quimica_sprite[a], 0, aa - 80 * zoom, bb + (50 + 20 * a) * zoom)
					draw_text(aa - 70 * zoom, bb + (40 + 20 * a) * zoom, planta_quimica_receta[a])
				}
			}
			if tag_edificio_fabrica_drones[index]{
				temp_array_real = (index = id_fabrica_de_drones) ? fabrica_de_drones_array : fabrica_de_drones_grande_array
				len = array_length(temp_array_real)
				draw_rectangle(aa - 80 * zoom, bb + 40 * zoom, aa + 80 * zoom, bb + (40 + 20 * len) * zoom, true)
				draw_text(aa - 80 * zoom, bb + 20 * zoom, L.show_menu_unidad)
				for(a = 0; a < len; a++)
					draw_text(aa - 80 * zoom, bb + (40 + 20 * a) * zoom, dron_nombre[temp_array_real[a]])
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
				draw_rectangle(aa - 80 * zoom, bb + 40 * zoom, aa + 80 * zoom, bb + (40 + 20 * (array_length(misiles_nombre) - not permitir_nuclear)) * zoom, true)
				draw_text(aa - 80 * zoom, bb + 20 * zoom, L.show_menu_receta)
				for(a = 0; a < array_length(misiles_nombre); a++)
					if permitir_nuclear or a != 2
						draw_text(aa - 70 * zoom, bb + (40 + 20 * a) * zoom, misiles_nombre[a])
			}
			if mouse_x > aa - 80 * zoom and mouse_y > bb + 20 * zoom and mouse_x < aa + 80 * zoom{
				if in(index, id_selector, id_overflow){
					if mouse_check_button_pressed(mb_left) and mouse_y < bb + 40 * zoom{
						mouse_clear(mb_left)
						show_menu = false
						set_edificio(not edificio.mode, edificio.select, edificio)
					}
				}
				if in(index, id_selector, id_recurso_infinito){
					if mouse_y < bb + (40 + TILE_WIDTH * ceil(rss_max / 5)) * zoom{
						a = floor((mouse_x - (aa - 80 * zoom)) / (32 * zoom)) + 5 * floor((mouse_y - (bb + 40 * zoom)) / (TILE_WIDTH * zoom))
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
					if mouse_check_button_pressed(mb_left) and mouse_y < bb + (40 + 20 * liquido_max) * zoom{
						mouse_clear(mb_left)
						show_menu = false
						a = floor((mouse_y - (bb + 20 * (1 + zoom))) / (20 * zoom))
						set_edificio(edificio.mode, a, edificio)
					}
				}
				else if index = id_planta_quimica{
					if mouse_y > bb + 40 * zoom and mouse_y < bb + (40 + 20 * array_length(planta_quimica_receta)) * zoom{
						a = clamp(floor((mouse_y - (bb + 20 * (1 + zoom))) / (20 * zoom)), 0, array_length(planta_quimica_receta) - 1)
						draw_text_background(mouse_x + 20, mouse_y, planta_quimica_descripcion[a])
						cursor = cr_handpoint
						if mouse_check_button_pressed(mb_left){
							mouse_clear(mb_left)
							show_menu = false
							set_edificio(edificio.mode, a, edificio)
						}
					}
				}
				else if tag_edificio_fabrica_drones[index]{
					temp_array_real = (index = id_fabrica_de_drones) ? fabrica_de_drones_array : fabrica_de_drones_grande_array
					len = array_length(temp_array_real)
					if mouse_y > bb + 40 * zoom and mouse_y < bb + (40 + 20 * len) * zoom{
						a = temp_array_real[floor((mouse_y - (bb + 20 * (1 + zoom))) / (20 * zoom))]
						temp_text = $"{dron_descripcion[a]}\n"
						for(b = array_length(dron_precio_id[a]) - 1; b >= 0; b--)
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
					if edificio.flujo.liquido >= 0{
						if edificio.flujo.liquido_forzado = 0{
							if mouse_check_button_pressed(mb_left){
								mouse_clear(mb_left)
								show_menu = false
								edificio.flujo.almacen = 0
								edificio.flujo.liquido = -1
							}
						}
						else{
							draw_set_halign(fa_center)
							draw_text_background(aa + 80 * zoom, bb + 80 * zoom, $"No se puede vaciar\nHay edificios que aún fuerzan {liquido_nombre[edificio.flujo.liquido]}")
							draw_set_halign(fa_left)
							for(a = array_length(edificio.flujo.edificios) - 1; a >= 0; a--){
								var temp_edificio = edificio.flujo.edificios[a]
								if not tag_edificio_tuberia[temp_edificio.index]
									draw_edificio_borde(temp_edificio, ui_boton_rojo, abs(sin(image_index / 20)))
							}
						}
					}
				}
				else if index = id_silo_de_misiles{
					if mouse_y > bb + 40 * zoom and mouse_y < bb + (40 + 20 * (array_length(misiles_nombre) - not permitir_nuclear)) * zoom{
						a = clamp(floor((mouse_y - (bb + 20 * (1 + zoom))) / (20 * zoom)), 0, array_length(misiles_nombre) - 1)
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
}