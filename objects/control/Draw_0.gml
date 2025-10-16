//Menú principal
if menu = 0{
	dibujar_fondo(1)
	draw_set_alpha(0.5)
	draw_set_color(c_black)
	draw_rectangle(0, 0, room_width, room_height, false)
	draw_set_alpha(1)
	draw_set_halign(fa_center)
	draw_set_font(ft_titulo)
	draw_set_color(c_white)
	draw_text(room_width / 2, 100, "HEXDUSTRY")
	draw_set_font(ft_letra)
	if draw_boton(room_width / 2, 200, "Juego rápido"){
		if not nucleo.vivo
			game_restart()
		if array_length(mision_nombre) > 0
			mision_actual = 0
		menu = 1
		image_index = 0
		build_index = 0
		ds_grid_clear(luz, 0)
		for(var a = 0; a < xsize; a++)
			for(var b = 0; b < ysize; b++)
				if terreno[# a, b] = 14
					add_luz(a, b, 1)
		for(var a = 0; a < xsize / chunk_width; a++)
			for(var b = 0; b < ysize / chunk_height; b++)
				update_background(a * chunk_width, b * chunk_height)
	}
	if draw_boton(room_width / 2, 250, "Cargar escenario"){
		if not nucleo.vivo
			game_restart()
		var file = cargar_escenario()
		if file != ""{
			redo_pathfind()
			if array_length(mision_nombre) > 0
				mision_actual = 0
			menu = 1
			image_index = 0
			build_index = 0
			ds_grid_clear(luz, 0)
			for(var a = 0; a < xsize; a++)
				for(var b = 0; b < ysize; b++)
					if terreno[# a, b] = 14
						add_luz(a, b, 1)
		}
	}
	if draw_boton(room_width / 2, 300, "Editor")
		menu = 2
	draw_set_halign(fa_left)
	draw_set_valign(fa_bottom)
	draw_text(10, room_height - 10, "Tomás Ramdohr")
	draw_set_valign(fa_top)
	update_cursor()
	if keyboard_check_pressed(vk_escape)
		game_end()
	exit
}
//Editor
if menu = 2{
	dibujar_fondo(1)
	dibujar_edificios()
	var xmouse = (mouse_x + camx) / zoom, ymouse = (mouse_y + camy) / zoom
	var temp_hexagono = instance_position(xmouse, ymouse, obj_hexagono), mx = 0, my = 0
	//Editor de objetivos
	if editor_menu{
		draw_set_color(c_ltgray)
		draw_rectangle(100, 100, room_width - 100, room_height - 100, false)
		draw_set_color(c_black)
		draw_rectangle(100, 100, room_width - 100, room_height - 100, true)
		if draw_boton(110, 110, "Volver") or keyboard_check_pressed(vk_escape){
			keyboard_clear(vk_escape)
			mision_actual = -1
			get_keyboard_string = -1
			editor_menu = false
		}
		if draw_boton(250, 110, "Configuración"){
			mision_actual = -1
			get_keyboard_string = -1
		}
		var size = array_length(mision_nombre), pos = 150
		if size > 15
			deslizante = floor(draw_deslizante_vertical(120, pos, pos + 15 * 30, deslizante, 0, size - 15, 0))
		for(var i = deslizante; i < min(deslizante + 15, size); i++){
			if draw_boton(140, pos, mision_nombre[i])
				mision_actual = i
			pos += 30
		}
		if deslizante + 15 < size and mouse_wheel_down()
			deslizante++
		if deslizante > 0 and mouse_wheel_up()
			deslizante--
		if draw_boton(140, 600, "Nuevo Objetivo"){
			array_push(mision_nombre, $"objetivo {size}")
			array_push(mision_objetivo, 0)
			array_push(mision_target_id, 0)
			array_push(mision_target_num, 0)
			mision_actual = size
		}
		draw_set_color(c_ltgray)
		draw_rectangle(room_width / 2, 110, room_width - 110, room_height - 110, false)
		draw_set_color(c_black)
		draw_rectangle(room_width / 2, 110, room_width - 110, room_height - 110, true)
		if mision_actual >= 0{
			var i = mision_actual
			var a = room_width / 2 + 20
			draw_text(a, 120, "Nombre objetivo: ")
			a += string_width("Nombre objetivo: ")
			if draw_boton(a, 120, mision_nombre[i],,,, false){
				keyboard_string = mision_nombre[i]
				get_keyboard_string = 0
			}
			if get_keyboard_string = 0{
				draw_line(a, 141, a + string_width(keyboard_string), 140)
				mision_nombre[i] = keyboard_string
				if keyboard_check_pressed(vk_enter) or mouse_check_button_pressed(mb_right){
					mouse_clear(mb_right)
					get_keyboard_string = -1
				}
			}
			a = room_width / 2 + 40
			draw_text(a, 150, "Objetivo: ")
			a += string_width("Objetivo: ")
			//Objetivo
			if draw_boton(a, 150, $"{objetivos_nombre[mision_objetivo[i]]} ",,,, false)
				get_keyboard_string = 3
			if get_keyboard_string = 3{
				var max_width = 0
				for(var b = 0; b < array_length(objetivos_nombre); b++)
					max_width = max(max_width, string_width(objetivos_nombre[b]))
				draw_set_color(c_ltgray)
				draw_rectangle(a, 170, a + max_width, 170 + 20 * array_length(objetivos_nombre), false)
				draw_set_color(c_black)
				draw_rectangle(a, 170, a + max_width, 170 + 20 * array_length(objetivos_nombre), true)
				for(var b = 0; b < array_length(objetivos_nombre); b++)
					if draw_boton(a, 170 + 20 * b, objetivos_nombre[b],,,, false){
						mision_objetivo[i] = b
						get_keyboard_string = -1
						if in(b, 2, 3)
							mision_target_id[i] = categoria_edificios[0, 0]
					}
				exit_keyboard_input()
			}
			a += string_width($"{objetivos_nombre[mision_objetivo[i]]} ")
			//Cantidad
			if draw_boton(a, 150, mision_target_num[i],,,, false){
				keyboard_string = mision_target_num[i] = 0 ? "" : string(mision_target_num[i])
				get_keyboard_string = 1
			}
			if get_keyboard_string = 1{
				draw_line(a, 170, a + string_width(mision_target_num[i]), 170)
				mision_target_num[i] = keyboard_string = "" ? 0 : real(string_digits(keyboard_string))
				exit_keyboard_input()
			}
			a += string_width(mision_target_num[i])
			//Conseguir recurso / Tener almacenado
			if mision_objetivo[i] < 2{
				draw_text(a, 150, " de ")
				a += string_width(" de ")
				//Recurso
				if draw_boton(a, 150, recurso_nombre[mision_target_id[i]],,,, false)
					get_keyboard_string = 2
				if get_keyboard_string = 2{
					var max_width = 0
					for(var b = 0; b < rss_max; b++)
						max_width = max(max_width, string_width(recurso_nombre[rss_sort[b]]))
					draw_set_color(c_ltgray)
					draw_rectangle(a, 170, a + max_width, 170 + 20 * rss_max, false)
					draw_set_color(c_black)
					draw_rectangle(a, 170, a + max_width, 170 + 20 * rss_max, true)
					if rss_max > 25
						deslizante = floor(draw_deslizante_vertical(a, 170, 170 + 25 * 20, deslizante, 0, rss_max - 25, 0))
					if deslizante + 25 < rss_max and mouse_wheel_down()
						deslizante++
					if deslizante > 0 and mouse_wheel_up()
						deslizante--
					pos = 170
					for(var b = deslizante; b < min(deslizante + 25, rss_max); b++){
						if draw_boton(a, pos, recurso_nombre[rss_sort[b]],,,, false){
							mision_target_id[i] = rss_sort[b]
							get_keyboard_string = -1
						}
						pos += 20
					}
					exit_keyboard_input()
				}
			}
			//Construir / Tener construido
			else if mision_objetivo[i] < 4{
				if draw_boton(a, 150, $" {edificio_nombre[mision_target_id[i]]}",,,, false)
					get_keyboard_string = 2
				if get_keyboard_string = 2{
					var max_width = 0
					size = array_length(edificios_construibles)
					for(var b = 0; b < 25; b++)
						max_width = max(max_width, string_width(edificio_nombre[deslizante + b]))
					draw_set_color(c_ltgray)
					draw_rectangle(a, 170, a + max_width + 20, 170 + 20 * 25, false)
					draw_set_color(c_black)
					draw_rectangle(a, 170, a + max_width + 20, 170 + 20 * 25, true)
					if size > 25
						deslizante = floor(draw_deslizante_vertical(a + 10, 170, 170 + 25 * 20, deslizante, 0, size - 25, 0))
					if deslizante + 25 < size and mouse_wheel_down()
						deslizante++
					if deslizante > 0 and mouse_wheel_up()
						deslizante--
					pos = 170
					for(var b = deslizante; b < min(deslizante + 25, size); b++){
						var c = edificios_construibles[b]
						if draw_boton(a + 20, pos, edificio_nombre[c],,,, false){
							mision_target_id[i] = c
							get_keyboard_string = -1
						}
						pos += 20
					}
					exit_keyboard_input()
				}
			}
			//Matar enemigos
			else if mision_objetivo[i] = 4
				draw_text(a, 150, " enemigos")
			if draw_boton(room_width / 2 + 10, room_height - 140, "Eliminar objetivo"){
				array_delete(mision_nombre, i, 1)
				array_delete(mision_objetivo, i, 1)
				array_delete(mision_target_id, i, 1)
				array_delete(mision_target_num, i, 1)
				mision_actual = -1
				deslizante = 0
			}
		}
		//Opciones generales
		else{
			var ypos = 120
			if draw_boton(room_width / 2 + 20, 120, (oleadas ? "Des" : "A") + "ctivar oleadas")
				oleadas = not oleadas
			ypos += 40
			if oleadas{
				var a = room_width / 2 + 40
				draw_text(a, ypos, "Tiempo primera ronda: ")
				a += string_width("Tiempo primera ronda: ")
				if draw_boton(a, ypos, $"{oleadas_tiempo_primera} s",,,, false){
					keyboard_string = string(oleadas_tiempo_primera)
					get_keyboard_string = 0
				}
				ypos += 20
				if get_keyboard_string = 0{
					draw_line(a, ypos, a + string_width(oleadas_tiempo_primera), ypos)
					oleadas_tiempo_primera = keyboard_string = "" ? 0 :  real(string_digits(keyboard_string))
					exit_keyboard_input()
				}
				ypos += 10
				a = room_width / 2 + 40
				draw_text(a, ypos, "Tiempo entre rondas: ")
				a += string_width("Tiempo entre rondas: ")
				if draw_boton(a, ypos, $"{oleadas_tiempo} s",,,, false){
					keyboard_string = string(oleadas_tiempo)
					get_keyboard_string = 1
				}
				ypos += 20
				if get_keyboard_string = 1{
					draw_line(a, ypos, a + string_width(oleadas_tiempo), ypos)
					oleadas_tiempo = keyboard_string = "" ? 0 : real(string_digits(keyboard_string))
					exit_keyboard_input()
				}
			}
			if array_length(mision_nombre) > 0{
				var a = room_width / 2 + 40
				ypos += 20
				draw_text(a, ypos, "Texto de victoria: ")
				a += string_width("Texto de victoria: ")
				if draw_boton(a, ypos, mision_texto_victoria,,,, false){
					keyboard_string = mision_texto_victoria
					get_keyboard_string = 2
				}
				ypos += 20
				if get_keyboard_string = 2{
					draw_line(a, ypos, a + string_width(keyboard_string), ypos)
					mision_texto_victoria = keyboard_string
					exit_keyboard_input()
				}
			}
			ypos += 20
			ypos = draw_text_ypos(room_width / 2 + 20, ypos, "Carga inicial")
			var xpos = room_width / 2 + 40, width = 0, ypos_2 = ypos
			for(var a = 0; a < rss_max; a++){
				ypos_2 = draw_text_ypos(xpos, ypos_2, recurso_nombre[rss_sort[a]])
				width = max(width, string_width(recurso_nombre[rss_sort[a]]))
			}
			xpos = room_width / 2 + 60 + width
			ypos_2 = ypos
			for(var a = 0; a < rss_max; a++){
				if draw_boton(xpos, ypos_2, carga_inicial[rss_sort[a]],,,, false){
					keyboard_string = string(carga_inicial[rss_sort[a]])
					get_keyboard_string = 10 + a
				}
				ypos_2 += string_height(carga_inicial[rss_sort[a]])
				if get_keyboard_string = 10 + a{
					draw_line(xpos, ypos_2 - 4, xpos + string_width(carga_inicial[rss_sort[a]]), ypos_2 - 4)
					carga_inicial[rss_sort[a]] = keyboard_string = "" ? 0 : real(string_digits(keyboard_string))
					nucleo.carga[rss_sort[a]] = carga_inicial[rss_sort[a]]
					exit_keyboard_input()
				}
			}
		}
		update_cursor()
		exit
	}
	//click en mapa
	if mouse_x > 200 and temp_hexagono != noone{
		mx = temp_hexagono.a
		my = temp_hexagono.b
		//Barril de Pintura
		if keyboard_check(vk_lcontrol) and editor_herramienta = 0 and build_index < terreno_max{
			if mouse_check_button_pressed(mb_left)
				//Aplicar cambio
				if mx = last_mx and my = last_my{
					last_mx = -1
					last_my = -1
					for(var i = 0; i < ds_list_size(build_list); i++){
						var temp_complex = build_list[|i], aa = temp_complex.a, bb = temp_complex.b
						set_terreno(aa, bb, build_index)
					}
				}
				//Calcular tarro de pintura
				else{
					ds_list_clear(build_list)
					last_mx = mx
					last_my = my
					mouse_clear(mb_left)
					var temp_queue = ds_queue_create(), visitado = ds_grid_create(xsize, ysize)
					ds_grid_clear(visitado, false)
					ds_grid_set(visitado, mx, my, true)
					ds_queue_enqueue(temp_queue, {a : mx, b : my, dir : -1})
					var target_id = terreno[# mx, my]
					while not ds_queue_empty(temp_queue){
						var temp_trio = ds_queue_dequeue(temp_queue), a = temp_trio.a, b = temp_trio.b, dir = temp_trio.dir
						ds_list_add(build_list, {a : a, b : b})
						for(var i = 0; i < 6; i++){
							if i= temp_trio.dir
								continue
							var temp_complex_2 = next_to(a, b, i), aa = temp_complex_2.a, bb = temp_complex_2.b
							if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
								continue
							if not visitado[# aa, bb]{
								ds_grid_set(visitado, aa, bb, true)
								if terreno[# aa, bb] = target_id
									ds_queue_enqueue(temp_queue, {a : aa, b : bb, dir : (i + 3) mod 6})
							}
						}
					}
				}
			if mx = last_mx and my = last_my{
				var temp_sprite = terreno_sprite[build_index]
				for(var i = 0; i < ds_list_size(build_list); i++){
					var temp_complex = build_list[|i], a = temp_complex.a, b = temp_complex.b
					var temp_complex_2 = abtoxy(a, b), aa = temp_complex_2.a, bb = temp_complex_2.b
					draw_sprite_off(temp_sprite, 0, aa, bb,,,,, 0.5)
				}
				draw_text_background(mouse_x, mouse_y + 20, "Clic para aplicar")
			}
		}
		//Lapiz
		else{
			//Spawn point
			if editor_herramienta = 1 and terreno_caminable[terreno[# mx, my]]{
				draw_set_color(c_red)
				var temp_complex = abtoxy(mx, my)
				draw_circle_off(temp_complex.a, temp_complex.b, 200, true)
				if mouse_check_button_pressed(mb_left){
					mouse_clear(mb_left)
					spawn_x = mx
					spawn_y = my
					editor_herramienta = 0
				}
			}
			//Base
			else if editor_herramienta = 2{
				var temp_complex = abtoxy(mx, my)
				draw_sprite_off(spr_base, 0, temp_complex.a, temp_complex.b,,,,, 0.5)
				if mouse_check_button_pressed(mb_left){
					mouse_clear(mb_left)
					var temp_nucleo = add_edificio(0, 0, mx, my)
					delete_edificio(nucleo.a, nucleo.b, false)
					nucleo = temp_nucleo
					editor_herramienta = 0
				}
			}
			//Terreno
			else if build_index >= 0 or editor_herramienta = 3{
				if mouse_wheel_up() and build_size < 5
					build_size++
				if mouse_wheel_down() and build_size > 1
					build_size--
				var temp_list = get_size(mx, my, 0, build_size)
				for(var i = 0; i < ds_list_size(temp_list); i++){
					var temp_complex = temp_list[|i], a = temp_complex.a, b = temp_complex.b
					if a < 0 or b < 0 or a >= xsize or b >= ysize
						continue
					temp_complex = abtoxy(a, b)
					var aa = temp_complex.a, bb = temp_complex.b
					//Eliminar minerales
					if editor_herramienta = 3{
						draw_sprite_off(spr_rojo, 0, aa, bb,,,,, 0.5)
						if mouse_check_button(mb_left){
							ds_grid_set(ore, a, b, -1)
							ds_grid_set(ore_amount, a, b, 0)
							update_background(a, b)
						}
					}
					if build_index >= 0{
						var offset = 0
						//Terrenos
						if build_index < terreno_max{
							draw_sprite_off(terreno_sprite[build_index], 0, aa, bb,,,,, 0.5)
							if mouse_check_button(mb_left)
								set_terreno(a, b, build_index)
						}
						//Minerales
						else{
							offset += terreno_max
							draw_sprite_off(ore_sprite[build_index - offset], 0, aa, bb,,,,, 0.5)
							if mouse_check_button(mb_left){
								ds_grid_set(ore, a, b, build_index - offset)
								ds_grid_set(ore_amount, a, b, floor(random_range(0.3, 1) * ore_size[build_index - offset]))
								update_background(a, b)
							}
						}
					}
				}
			}
		}
		//Borrar edificio
		if mouse_check_button_pressed(mb_right) and edificio_bool[# mx, my]{
			mouse_clear(mb_right)
			delete_edificio(mx, my)
		}
	}
	if mouse_check_button_pressed(mb_right){
		if build_index >= 0
			build_index = -1
		else if editor_herramienta > 0
			editor_herramienta = 0
	}
	draw_set_color(c_red)
	var temp_complex = abtoxy(spawn_x, spawn_y)
	draw_circle_off(temp_complex.a, temp_complex.b, 200, true)
	draw_set_color(c_ltgray)
	draw_rectangle(0, 0, 200, room_height, false)
	draw_set_color(c_black)
	var b = 0
	sprite_boton_text = ""
	for(var a = 0; a < terreno_max; a++)
		if draw_sprite_boton(terreno_sprite[a], 10 + (a mod 5) * 36, 10 + floor(a / 5) * 36,,, terreno_nombre[a]){
			build_index = a
			editor_herramienta = 0
		}
	b += terreno_max
	for(var a = 0; a < ore_max; a++)
		if draw_sprite_boton(ore_sprite[a], 10 + ((a + b) mod 5) * 36, 10 + floor((a + b) / 5) * 36,,, recurso_nombre[ore_recurso[a]]){
			build_index = a + b
			editor_herramienta = 0
		}
	b += ore_max
	if draw_sprite_boton(spr_equis, 10 + (b mod 5) * 36, 10 + floor(b / 5) * 36,,, "Eliminar depósito de Recursos"){
		build_index = -1
		editor_herramienta = 3
	}
	b++
	if draw_sprite_boton(spr_base, 10 + (b mod 5) * 36, 10 + floor(b / 5) * 36,,, "Cambia posición de la Base"){
		build_index = -1
		editor_herramienta = 2
	}
	b++
	if draw_sprite_boton(spr_arana, 10 + (b mod 5) * 36, 10 + floor(b / 5) * 36,,, "Cambiar zona de enemigos"){
		build_index = -1
		editor_herramienta = 1
	}
	b++
	if sprite_boton_text != ""
		draw_text_background(mouse_x + 20, mouse_y, sprite_boton_text)
	if draw_boton(10, room_height - 250, "Objetivos"){
		editor_menu = true
		exit
	}
	var prev_xsize = xsize
	xsize = round(draw_deslizante(50, 150, room_height - 200, xsize, 28, 96, 0))
	draw_text(150, room_height - 200, $"{xsize}")
	if xsize > prev_xsize
		resize_grid(prev_xsize, 0)
	var prev_ysize = ysize
	ysize = round(draw_deslizante(50, 150, room_height - 180, ysize, 60, 192, 1))
	draw_text(150, room_height - 180, $"{ysize}")
	if ysize > prev_ysize
		resize_grid(0, prev_ysize)
	build_size = round(draw_deslizante(50, 150, room_height - 150, build_size, 1, 5, 2))
	if draw_boton(10, room_height - 100, "Volver") or keyboard_check_pressed(vk_escape){
		menu = 0
		redo_pathfind()
	}
	if draw_boton(10, room_height - 60, "Guardar") or (keyboard_check(vk_lcontrol) and keyboard_check_pressed(ord("S"))){
		var file = get_save_filename("*.txt", game_save_id + "save.txt")
		if file != ""{
			ini_open(file)
			ini_write_real("Global", "xsize", xsize)
			ini_write_real("Global", "ysize", ysize)
			ini_write_real("Global", "spawn_x", spawn_x)
			ini_write_real("Global", "spawn_y", spawn_y)
			ini_write_real("Global", "nucleo_x", nucleo.a)
			ini_write_real("Global", "nucleo_y", nucleo.b)
			for(var a = 0; a < rss_max; a++)
				ini_write_real("Carga inicial", a, carga_inicial[a])
			ini_write_real("Global", "oleadas", oleadas)
			ini_write_real("Global", "tiempo primera oleada", oleadas_tiempo_primera)
			ini_write_real("Global", "tiempo entre oleadas", oleadas_tiempo)
			ini_write_real("Global", "objetivos", array_length(mision_nombre))
			if array_length(mision_nombre) > 0
				ini_write_string("Global", "texto victoria", mision_texto_victoria)
			for(var a = 0; ini_section_exists($"Objetivo {a}"); a++)
				ini_section_delete($"Objetivo {a}")
			for(var a = 0; a < array_length(mision_nombre); a++){
				ini_write_string($"Objetivo {a}", "nombre", mision_nombre[a])
				ini_write_real($"Objetivo {a}", "objetivo", mision_objetivo[a])
				ini_write_real($"Objetivo {a}", "target_id", mision_target_id[a])
				ini_write_real($"Objetivo {a}", "target_num", mision_target_num[a])
			}
			for(var a = 0; a < xsize; a++)
				for(b = 0; b < ysize; b++){
					ini_write_real("Terreno", $"{a},{b}", terreno[# a, b])
					if terreno_pared[terreno[# a, b]]
						ini_write_real("Terreno pared index", $"{a},{b}", terreno_pared_index[# a, b])
					else
						ini_key_delete("Terreno pared index", $"{a},{b}")
					if ore[# a, b] = -1{
						ini_key_delete("Ore", $"{a},{b}")
						ini_key_delete("Ore amount", $"{a},{b}")
					}
					else{
						ini_write_real("Ore", $"{a},{b}", ore[# a, b])
						ini_write_real("Ore amount", $"{a},{b}", ore_amount[# a, b])
					}
				}
			ini_close()
			ini_open(game_save_id + "settings.ini")
			ini_write_real("Saves", file, current_day)
			ini_close()
		}
	}
	if draw_boton(10, room_height - 30, "Cargar") or (keyboard_check(vk_lcontrol) and keyboard_check_pressed(ord("A")))
		cargar_escenario()
	control_camara(-200)
	update_cursor()
	exit
}
#region Dibujo
	dibujar_fondo()
	if grafic_tile_animation
		dibujar_fondo(2)
	dibujar_edificios()
	//Dibujo items y links electricos
	mina = max(0, floor(camx / zoom / 48))
	minb = max(0, floor(camy / zoom / 14) - 1)
	maxa = min(xsize - 1, ceil((camx + room_width) / zoom / 48))
	maxb = min(ysize - 1, ceil((camy + room_height) / zoom / 14))
	for(var a = mina; a < maxa; a++)
		for(var b = minb; b < maxb; b++)
			if edificio_draw[# a, b]{
				var edificio = edificio_id[# a, b], index = edificio.index, temp_complex = abtoxy(a, b), aa = temp_complex.a, bb = temp_complex.b, var_edificio_nombre = edificio_nombre[index]
				if edificio.carga_total > 0{
					//Dibujo de items en los caminos
					if (edificio_camino[index] or index = 6){
						var proceso = edificio_proceso[index]
						var c = 1.2 * (max(edificio.proceso, edificio.waiting * proceso) - proceso / 2) * 20 / proceso
						var d = edificio.dir * pi / 3 + pi / 6
						draw_sprite_off(recurso_sprite[edificio.carga_id], 0, aa + c * cos(d), bb - c * sin(d))
					}
					//Dibujo de items saliendo del tunel
					else if index = 16{
						var proceso = edificio_proceso[index]
						var c = 1.2 * (max(edificio.proceso, edificio.waiting * proceso) - proceso / 2) * 20 / proceso
						var d = edificio.dir * pi / 3 + pi / 6
						draw_sprite_off(recurso_sprite[edificio.carga_id], 0, aa - c * cos(d), bb + c * sin(d))
					}
				}
				//Dibujo de los links eléctricos
				if edificio_energia[index]{
					draw_set_color(c_yellow)
					for(var c = 0; c < ds_list_size(edificio.energia_link); c++){
						var edificio_2 = edificio.energia_link[|c]
						draw_line_off(edificio.x, edificio.y, edificio_2.x, edificio_2.y)
					}
				}
				//Humo
				if grafic_humo and (image_index mod 5) = 0 and ((in(var_edificio_nombre, "Generador", "Turbina", "Planta Nuclear") and edificio.fuel > 0) or (var_edificio_nombre = "Generador Geotérmico" and edificio.flujo.liquido = 0)){
					var dir = direccion_viento + random_range(-pi / 4, pi / 4)
					array_push(humos, add_humo(edificio.x, edificio.y, a, b, cos(dir), sin(dir), irandom_range(70, 100), 191, 0.3))
				}
			}
	//Luz
	if energia_solar < 1{
		var luz_alpha = (1 - energia_solar) / 3
		if grafic_luz{
			for(var a = mina; a < maxa; a++)
				for(var b = minb; b < maxb; b++){
					var temp_complex = abtoxy(a, b)
					draw_sprite_off(spr_negro, 0, temp_complex.a, temp_complex.b,,,,, max(0, luz_alpha - luz[# a, b] / 18))
				}
		}
		else{
			draw_set_alpha(luz_alpha)
			draw_set_color(c_black)
			draw_rectangle(0, 0, room_width, room_height, false)
			draw_set_alpha(1)
		}
	}
	if enciclopedia > 0{
		image_index--
		draw_set_color(c_gray)
		draw_rectangle(100, 100, room_width - 100, room_height - 100, false)
		draw_set_color(c_black)
		draw_rectangle(100, 100, room_width - 100, room_height - 100, true)
		var width = 100
		if draw_boton(width, 100, "Recursos"){
			deslizante = 0
			enciclopedia = 1
		}
		width += string_width("Recursos") + 20
		if draw_boton(width, 100, "Edificios"){
			deslizante = 0
			enciclopedia = 2
		}
		width += string_width("Edificios") + 20
		if draw_boton(width, 100, "Unidades"){
			deslizante = 0
			enciclopedia = 5
		}
		width += string_width("Unidades") + 20
		//Menú Recursos
		if enciclopedia = 1{
			var pos = 140
			if rss_max > 25
				deslizante = floor(draw_deslizante_vertical(110, pos, pos + 25 * 20, deslizante, 0, rss_max - 25, 0))
			for(var a = deslizante; a < min(deslizante + 25, rss_max); a++){
				if draw_boton(120, pos, recurso_nombre[rss_sort[a]],,,, false){
					enciclopedia_item = rss_sort[a]
					enciclopedia = 3
				}
				pos += 20
			}
			if deslizante + 25 < rss_max and mouse_wheel_down()
				deslizante++
			if deslizante > 0 and mouse_wheel_up()
				deslizante--
		}
		//Menú Edificios
		else if enciclopedia = 2{
			var pos = 140
			if edificio_max > 25
				deslizante = floor(draw_deslizante_vertical(110, pos, pos + 25 * 20, deslizante, 0, edificio_max - 25, 0))
			for(var a = deslizante; a < min(deslizante + 25, edificio_max); a++){
				if draw_boton(120, pos, edificio_nombre[edi_sort[a]],,,, false){
					enciclopedia_item = edi_sort[a]
					enciclopedia = 4
				}
				pos += 20
			}
			if deslizante + 25 < edificio_max and mouse_wheel_down()
				deslizante++
			if deslizante > 0 and mouse_wheel_up()
				deslizante--
		}
		//Detalles Recurso
		else if enciclopedia = 3{
			var pos = 140
			draw_set_font(ft_titulo)
			pos = draw_text_ypos(120, pos, recurso_nombre[enciclopedia_item])
			draw_set_font(ft_letra)
			pos = draw_text_ypos(120, pos, recurso_descripcion[enciclopedia_item])
			if recurso_combustion[enciclopedia_item]
				pos = draw_text_ypos(120, pos, $"Combustible por {recurso_combustion_time[enciclopedia_item] / 60}[s]")
			pos = draw_text_ypos(120, pos, "Usado en:")
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
			pos = draw_text_ypos(120, pos, "Producido en:")
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
				pos = draw_text_ypos(120, pos, "Necesario para construir:")
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
				draw_text_ypos(120, pos, "No es útil en el núcleo")
			draw_sprite_ext(recurso_sprite[enciclopedia_item], 0, room_width - 200, 200, 4, 4, 0, c_white, 1)
		}
		//Detalles Edificio
		else if enciclopedia = 4{
			var pos = 140
			draw_set_font(ft_titulo)
			pos = draw_text_ypos(120, pos, edificio_nombre[enciclopedia_item])
			draw_set_font(ft_letra)
			pos = draw_text_ypos(120, pos, edificio_descripcion[enciclopedia_item])
			pos = draw_text_ypos(120, pos, $"Vida máxima: {edificio_vida[enciclopedia_item]}")
			if array_length(edificio_precio_id[enciclopedia_item]) > 0{
				pos += 10
				pos = draw_text_ypos(120, pos, "Coste de construcción:")
				for(var a = 0; a < array_length(edificio_precio_id[enciclopedia_item]); a++){
					if draw_boton(140, pos, $"{edificio_precio_num[enciclopedia_item, a]} {recurso_nombre[edificio_precio_id[enciclopedia_item, a]]}",,,, false){
						enciclopedia_item = edificio_precio_id[enciclopedia_item, a]
						enciclopedia = 3
						exit
					}
					pos += 20
				}
			}
			if array_length(edificio_input_id[enciclopedia_item]) > 0{
				pos += 10
				pos = draw_text_ypos(120, pos, "Consume:")
				for(var a = 0; a < array_length(edificio_input_id[enciclopedia_item]); a++){
					if draw_boton(140, pos, recurso_nombre[edificio_input_id[enciclopedia_item, a]],,,, false){
						enciclopedia_item = edificio_input_id[enciclopedia_item, a]
						enciclopedia = 3
						exit
					}
					pos += 20
				}
			}
			if array_length(edificio_output_id[enciclopedia_item]) > 0{
				pos += 10
				pos = draw_text_ypos(120, pos, "Produce:")
				for(var a = 0; a < array_length(edificio_output_id[enciclopedia_item]); a++){
					if draw_boton(140, pos, recurso_nombre[edificio_output_id[enciclopedia_item, a]],,,, false){
						enciclopedia_item = edificio_output_id[enciclopedia_item, a]
						enciclopedia = 3
						exit
					}
					pos += 20
				}
			}
			if edificio_energia[enciclopedia_item]{
				pos += 10
				if edificio_energia_consumo[enciclopedia_item] > 0
					pos = draw_text_ypos(120, pos, $"Consume {edificio_energia_consumo[enciclopedia_item]} energía/s")
				else if edificio_energia_consumo[enciclopedia_item] < 0
					pos = draw_text_ypos(120, pos, $"Produce {abs(edificio_energia_consumo[enciclopedia_item])} energía/s")
			}
			if edificio_flujo[enciclopedia_item]{
				pos += 10
				if edificio_flujo_consumo[enciclopedia_item] > 0
					pos = draw_text_ypos(120, pos, $"Consume {edificio_flujo_consumo[enciclopedia_item]} líquido/s")
				else if edificio_flujo_consumo[enciclopedia_item] < 0
					pos = draw_text_ypos(120, pos, $"Produce {abs(edificio_flujo_consumo[enciclopedia_item])} líquido/s")
			}
			draw_sprite_ext(edificio_sprite[enciclopedia_item], 0, room_width - 200, 200, 2, 2, 0, c_white, 1)
			if edificio_armas[enciclopedia_item] and edificio_nombre[enciclopedia_item] != "Láser"
				if edificio_size[enciclopedia_item] mod 2 = 0
					draw_sprite_ext(edificio_sprite_2[enciclopedia_item], 0, room_width - 184, 224, 2, 2, 0, c_white, 1)
				else
					draw_sprite_ext(edificio_sprite_2[enciclopedia_item], 0, room_width - 200, 200, 2, 2, 0, c_white, 1)
		}
		//Menú Unidades
		else if enciclopedia = 5{
			var pos = 140
			if dron_max > 25
				deslizante = floor(draw_deslizante_vertical(110, pos, pos + 25 * 20, deslizante, 0, dron_max - 25, 0))
			for(var a = deslizante; a < min(deslizante + 25, dron_max); a++){
				if draw_boton(120, pos, dron_nombre[a],,,, false){
					enciclopedia_item = a
					enciclopedia = 6
				}
				pos += 20
			}
			if deslizante + 25 < dron_max and mouse_wheel_down()
				deslizante++
			if deslizante > 0 and mouse_wheel_up()
				deslizante--
		}
		//Detalles Dron
		else if enciclopedia = 6{
			var pos = 140
			draw_set_font(ft_titulo)
			pos = draw_text_ypos(120, pos, dron_nombre[enciclopedia_item])
			draw_set_font(ft_letra)
			pos = draw_text_ypos(120, pos, dron_descripcion[enciclopedia_item])
			pos = draw_text_ypos(120, pos, $"Vida máxima: {dron_vida_max[enciclopedia_item]}")
			if array_length(dron_precio_id[enciclopedia_item]) > 0{
				pos += 10
				pos = draw_text_ypos(120, pos, "Coste de construcción:")
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
		}
		if keyboard_check_pressed(vk_escape) or keyboard_check_pressed(ord("Y")) or (mouse_check_button_pressed(mb_any) and (mouse_x < 100 or mouse_y < 100 or mouse_x > room_width - 100 or mouse_y > room_height - 100)){
			mouse_clear(mouse_lastbutton)
			keyboard_clear(vk_escape)
			keyboard_clear(ord("K"))
			enciclopedia = false
		}
		update_cursor()
		exit
	}
	if sonido and random(1) < 0.1{
		var a = irandom_range(mina, maxa), b = irandom_range(minb, maxb)
		if terreno_nombre[terreno[# a, b]] = "Lava"{
			var temp_complex = abtoxy(a, b), aa = temp_complex.a, bb = temp_complex.b
			sound_play(snd_lava, aa, bb, 0.5)
		}
	}
	draw_set_halign(fa_center)
	var temp_text = ""
	for(var a = 0; a < rss_max; a++)
		if nucleo.carga[rss_sort[a]] > 0
			temp_text += $"{recurso_nombre[rss_sort[a]]} {nucleo.carga[rss_sort[a]]}\n"
	if temp_text != ""
		draw_text_background(room_width / 2, 0, temp_text)
	draw_set_halign(fa_left)
	sprite_boton_text = ""
#endregion
if pausa{
	for(var a = 0; a < ds_list_size(enemigos); a++){
		var enemigo = enemigos[|a], aa = enemigo.a, bb = enemigo.b, index = enemigo.index
		draw_sprite_off(dron_sprite[index], image_index / 2, aa, bb)
		draw_sprite_off(dron_sprite_color[index], 0, aa, bb,,,, c_red)
	}
	for(var a = 0; a < ds_list_size(drones_aliados); a++){
		var dron = drones_aliados[|a], aa = dron.a, bb = dron.b, index = dron.index
		draw_sprite_off(dron_sprite[index], 0, aa, bb)
		draw_sprite_off(dron_sprite_color[index], 0, aa, bb,,,, c_blue)
	}
	image_index--
	var color = draw_get_color()
	draw_set_color(c_white)
	draw_set_halign(fa_center)
	draw_set_font(ft_titulo)
	draw_text(room_width / 2, 100, "P A U S A")
	draw_set_font(ft_letra)
	draw_text(room_width / 2, 150,	"Presiona P para continuar"
									+ "\n\"O\" para ver las redes eléctricas"
									+ "\n\"I\" para ver las redes de líquidos"
									+ "\n\"Y\" para abrir la enciclopedia")
	draw_set_halign(fa_left)
	draw_set_alpha(0.2)
	draw_rectangle(0, 0, room_width, room_height, false)
	draw_set_alpha(1)
	var a = room_width / 2
	draw_set_halign(fa_center)
	if draw_boton(a, 300, (info ? "des" : "") + "activar información adicional")
		info = not info
	if draw_boton(a, 340, (grafic_tile_animation ? "des" : "") + "activar animaciones del terreno")
		grafic_tile_animation = not grafic_tile_animation
	if draw_boton(a, 380, (grafic_luz ? "des" : "") + "activar la iluminación")
		grafic_luz = not grafic_luz
	if draw_boton(a, 420, (grafic_humo ? "des" : "") + "activar humo")
		grafic_humo = not grafic_humo
	if draw_boton(a, 460, (grafic_pared ? "des" : "") + "activar texturas de paredes")
		grafic_pared = not grafic_pared
	if draw_boton(a, 500, (grafic_hideui ? "" : "des") + "activar UI")
		grafic_hideui = not grafic_hideui
	if draw_boton(a, 540, (sonido ? "des" : "") + "activar sonido"){
		sonido = not sonido
		if not sonido for(var b = 0; b < sonidos_max; b++)
			audio_pause_sound(sonido_id[b])
		if sonido for(var b = 0; b < sonidos_max; b++)
			audio_resume_sound(sonido_id[b])
	}
	draw_set_halign(fa_left)
	draw_set_color(color)
}
var flag = true, xmouse = (mouse_x + camx) / zoom, ymouse = (mouse_y + camy) / zoom
//Seleccionar recurso
if show_menu{
	var edificio = show_menu_build
	var aa = abtoxy(edificio.a, edificio.b).a * zoom - camx
	var bb = abtoxy(edificio.a, edificio.b).b * zoom - camy
	var index = edificio.index, var_edificio_nombre = edificio_nombre[index]
	draw_set_color(c_gray)
	draw_triangle(aa - 10 * zoom, bb + 20 * zoom, aa + 10 * zoom, bb + 20 * zoom, aa, bb + 10 * zoom, false)
	draw_rectangle(aa - 80 * zoom, bb + 20 * zoom, aa + 80 * zoom, bb + 40 * zoom, false)
	if in(var_edificio_nombre, "Selector", "Recurso Infinito")
		draw_rectangle(aa - 80 * zoom, bb + 40 * zoom, aa + 80 * zoom, bb + (40 + 28 * ceil(rss_max / 5)) * zoom, false)
	else if in(var_edificio_nombre, "Líquido Infinito")
		draw_rectangle(aa - 80 * zoom, bb + 40 * zoom, aa + 80 * zoom, bb + (40 + 20 * lq_max) * zoom, false)
	else if var_edificio_nombre = "Planta Química"
		draw_rectangle(aa - 80 * zoom, bb + 40 * zoom, aa + 80 * zoom, bb + (40 + 20 * array_length(planta_quimica_receta)) * zoom, false)
	else if var_edificio_nombre = "Fábrica de Drones"
		draw_rectangle(aa - 80 * zoom, bb + 40 * zoom, aa + 80 * zoom, bb + (40 + 20 * dron_max) * zoom, false)
	else if var_edificio_nombre = "Procesador"
		draw_rectangle(aa - 80 * zoom, bb + 40 * zoom, aa + 80 * zoom, bb + (40 + 20 * array_length(edificio.instruccion)) * zoom, false)
	draw_set_color(c_dkgray)
	draw_triangle(aa - 10 * zoom, bb + 20 * zoom, aa + 10 * zoom, bb + 20 * zoom, aa, bb + 10 * zoom, true)
	draw_rectangle(aa - 80 * zoom, bb + 20 * zoom, aa + 80 * zoom, bb + 40 * zoom, true)
	if in(var_edificio_nombre, "Selector", "Overflow")
		draw_text(aa - 80 * zoom, bb + 20 * zoom, "INVERTIR")
	if in(var_edificio_nombre, "Selector", "Recurso Infinito"){
		draw_rectangle(aa - 80 * zoom, bb + 40 * zoom, aa + 80 * zoom, bb + (40 + 28 * ceil(rss_max / 5)) * zoom, true)
		for(var a = 0; a < rss_max; a++)
			draw_sprite_stretched(recurso_sprite[a], 0, aa + (-80 + 32 * (a mod 5)) * zoom, bb + (40 + 28 * floor(a / 5)) * zoom, 32 * zoom, 28 * zoom)
	}
	if in(var_edificio_nombre, "Líquido Infinito"){
		draw_rectangle(aa - 80 * zoom, bb + 40 * zoom, aa + 80 * zoom, bb + (40 + 20 * lq_max) * zoom, true)
		draw_text(aa - 80 * zoom, bb + 20 * zoom, "Ningún líquido")
		for(var a = 0; a < lq_max; a++)
			draw_text(aa - 80 * zoom, bb + (40 + 20 * a) * zoom, liquido_nombre[a])
	}
	if var_edificio_nombre = "Planta Química"{
		draw_rectangle(aa - 80 * zoom, bb + 40 * zoom, aa + 80 * zoom, bb + (40 + 20 * array_length(planta_quimica_receta)) * zoom, true)
		draw_text(aa - 80 * zoom, bb + 20 * zoom, "Receta")
		for(var a = 0; a < array_length(planta_quimica_receta); a++)
			draw_text(aa - 80 * zoom, bb + (40 + 20 * a) * zoom, planta_quimica_receta[a])
	}
	if var_edificio_nombre = "Fábrica de Drones"{
		draw_rectangle(aa - 80 * zoom, bb + 40 * zoom, aa + 80 * zoom, bb + (40 + 20 * dron_max) * zoom, true)
		draw_text(aa - 80 * zoom, bb + 20 * zoom, "Unidad")
		for(var a = 0; a < dron_max; a++)
			draw_text(aa - 80 * zoom, bb + (40 + 20 * a) * zoom, dron_nombre[a])
	}
	else if var_edificio_nombre = "Procesador"{
		var b = 0
		draw_rectangle(aa - 80 * zoom, bb + 40 * zoom, aa + 80 * zoom, bb + (40 + 20 * array_length(edificio.instruccion)) * zoom, true)
		if draw_boton(aa - 80 * zoom, bb + 20 * zoom, "Añadir",,,, false)
			array_push(edificio.instruccion, array_create(6, 0))
		for(var a = 0; a < array_length(edificio.instruccion); a++){
			var pc = edificio.instruccion[a], xpos = aa - 80 * zoom, ypos = bb + (40 + 20 * a) * zoom
			if draw_boton(xpos, ypos, ">",,, mb_any, false){
				if mouse_lastbutton = mb_left{
					pc[0] = ++pc[0] mod 5
					if pc[0] = 0
						array_resize(edificio.instruccion[a], 1)
					else if pc[0] = 1
						array_resize(edificio.instruccion[a], 3)
					else if pc[0] = 2
						array_resize(edificio.instruccion[a], 5)
					else if pc[0] = 3
						array_resize(edificio.instruccion[a], 6)
					else if pc[0] = 4
						array_resize(edificio.instruccion[a], 2)
				}
				else
					array_delete(edificio.instruccion, a, 1)
			}
			xpos += text_x
			if a > 0 and draw_sprite_boton(spr_flecha, xpos, ypos, 16, 16){
				edificio.instruccion[a] = edificio.instruccion[a - 1]
				edificio.instruccion[a - 1] = pc
			}
			xpos += 20
			if pc[0] = 0
				draw_text(xpos, ypos, "Continue")
			else if pc[0] = 1{
				xpos = draw_text_xpos(xpos, ypos, "Set ")
				if draw_boton(xpos, ypos, $"VAR_{pc[1]}",,,, false)
					pc[1] = clamp(floor(get_integer("", pc[1])), 0, 15)
				xpos += text_x
				xpos = draw_text_xpos(xpos, ypos, " to ")
				if draw_boton(xpos, ypos, pc[2],,,, false)
					pc[2] = get_integer("", pc[2])
			}
			else if pc[0] = 2{
				var signs = ["+", "-", "*", "/", "div", "mod", "or", "and", "xor", "<<", ">>"]
				xpos = draw_text_xpos(xpos, ypos, "Set ")
				if draw_boton(xpos, ypos, $"VAR_{pc[1]}",,,, false)
					pc[1] = clamp(floor(get_integer("", pc[1])), 0, 15)
				xpos += text_x
				xpos = draw_text_xpos(xpos, ypos, " to ")
				if draw_boton(xpos, ypos, $"VAR_{pc[2]}",,,, false)
					pc[2] = clamp(floor(get_integer("", pc[2])), 0, 15)
				xpos += text_x
				if draw_boton(xpos, ypos, $" {signs[pc[3]]} ",,,, false)
					pc[3] = clamp(floor(get_integer(string(signs), pc[3])), 0, array_length(signs) - 1)
				xpos += text_x
				if draw_boton(xpos, ypos, $"VAR_{pc[4]}",,,, false)
					pc[4] = clamp(floor(get_integer("", pc[4])), 0, 15)
			}
			else if pc[0] = 3{
				var signs = ["<", ">", "="]
				xpos = draw_text_xpos(xpos, ypos, "If ")
				if draw_boton(xpos, ypos, $"VAR_{pc[1]}",,,, false)
					pc[1] = clamp(floor(get_integer("", pc[1])), 0, 15)
				xpos += text_x
				if draw_boton(xpos, ypos, pc[2] ? " is" : " is not",,,, false)
					pc[2] = real(show_question("is / is not"))
				xpos += text_x
				if draw_boton(xpos, ypos, $" {signs[pc[3]]} ",,,, false)
					pc[3] = clamp(floor(get_integer(string(signs), pc[3])), 0, 2)
				xpos += text_x
				if draw_boton(xpos, ypos, $"VAR_{pc[4]}",,,, false)
					pc[4] = clamp(floor(get_integer("", pc[4])), 0, 15)
				xpos += text_x
				xpos = draw_text_xpos(xpos, ypos, ", jump to ")
				if draw_boton(xpos, ypos, pc[5],,,, false)
					pc[5] = clamp(floor(get_integer("", pc[5])), 0, array_length(edificio.instruccion) - 1)
				xpos += text_x
				draw_rectangle(xpos, ypos, xpos + 6 * ++b, ypos, false)
				draw_rectangle(xpos + 6 * b, ypos, xpos + 6 * b, bb + (40 + 20 * pc[5]) * zoom, false)
				draw_arrow(xpos + 6 * b, bb + (40 + 20 * pc[5]) * zoom, xpos, bb + (40 + 20 * pc[5]) * zoom, 8)
			}
			else if pc[0] = 4{
				xpos = draw_text_xpos(xpos, ypos, "Print ")
				if draw_boton(xpos, ypos, $"VAR_{pc[1]}",,,, false)
					pc[1] = clamp(floor(get_integer("", pc[1])), 0, 15)
			}

		}
	}
	if mouse_x > aa - 80 * zoom and mouse_y > bb + 20 * zoom and mouse_x < aa + 80 * zoom{
		if in(var_edificio_nombre, "Selector", "Overflow") and mouse_y < bb + 40 * zoom{
			if mouse_check_button_pressed(mb_left){
				mouse_clear(mb_left)
				show_menu = false
				edificio.mode = not edificio.mode
				mover(edificio.a, edificio.b)
			}
		}
		else if in(var_edificio_nombre, "Selector", "Recurso Infinito") and mouse_y < bb + (40 + 28 * ceil(rss_max / 5)) * zoom{
			var a = floor((mouse_x - (aa - 80 * zoom)) / (32 * zoom)) + 5 * floor((mouse_y - (bb + 40 * zoom)) / (28 * zoom))
			if a >= 0 and a < rss_max{
				draw_text_background(mouse_x + 20, mouse_y, recurso_nombre[a])
				cursor = cr_handpoint
				if mouse_check_button_pressed(mb_left){
					mouse_clear(mb_left)
					show_menu = false
					edificio.select = a
					mover(edificio.a, edificio.b)
				}
			}
		}
		else if in(var_edificio_nombre, "Líquido Infinito") and mouse_y < bb + (40 + 20 * lq_max) * zoom{
			if mouse_check_button_pressed(mb_left){
				mouse_clear(mb_left)
				show_menu = false
				var a = floor((mouse_y - (bb + 20 * (1 + zoom))) / (20 * zoom))
				if edificio.select >= 0 and a = -1{
					change_flujo(0, edificio)
					edificio.flujo.almacen = 0
				}
				edificio.select = a
				if edificio.select >= 0 and edificio.flujo.liquido = -1
					change_flujo(edificio_flujo_consumo[index], edificio)
				edificio.flujo.liquido = a
				if grafic_luz and a = 3 and not edificio.luz{
					for(var b = 0; b < ds_list_size(edificio.flujo.edificios); b++){
						var temp_edificio = edificio.flujo.edificios[|b]
						if not temp_edificio.luz{
							temp_edificio.luz = true
							add_luz(temp_edificio.a, temp_edificio.b, 1)
						}
					}
				}
			}
		}
		else if in(var_edificio_nombre, "Planta Química") and mouse_y > bb + 40 * zoom and mouse_y < bb + (40 + 20 * array_length(planta_quimica_receta)) * zoom{
			var a = floor((mouse_y - (bb + 20 * (1 + zoom))) / (20 * zoom))
			draw_text_background(mouse_x + 20, mouse_y, planta_quimica_descripcion[a])
			cursor = cr_handpoint
			if mouse_check_button_pressed(mb_left){
				mouse_clear(mb_left)
				show_menu = false
				change_flujo(0, edificio)
				if edificio.flujo.almacen = 0 and edificio.flujo.generacion = 0
					edificio.flujo.liquido = -1
				for(var i = 0; i < rss_max; i++){
					edificio.carga[i] = 0
					edificio.carga_max[i] = 0
					edificio.carga_output[i] = false
				}
				edificio.carga_total = 0
				edificio.select = a
				edificio.fuel = 0
				if a = 0{
					edificio.carga_max[5] = 5
					edificio.carga_max[11] = 5
					edificio.receptor = true
					edificio.emisor = false
					edificio.flujo_consumo_max = -2
				}
				else if a = 1{
					edificio.carga_max[5] = 5
					edificio.carga_max[6] = 5
					edificio.carga_max[9] = 5
					edificio.carga_max[10] = 5
					edificio.carga_max[11] = 5
					edificio.carga_output[8] = true
					edificio.receptor = true
					edificio.emisor = true
				}
				else if a = 2{
					edificio.carga_max[1] = 5
					edificio.carga_max[11] = 5
					edificio.carga_output[13] = true
					edificio.receptor = true
					edificio.emisor = true
				}
				else if a = 3{
					edificio.carga_output[12] = true
					edificio.receptor = false
					edificio.emisor = true
					edificio.flujo_consumo_max = 4
				}
				else if a = 4{
					edificio.carga_output[11] = true
					edificio.receptor = false
					edificio.emisor = true
					edificio.flujo_consumo_max = 6
				}
				else if a = 5{
					edificio.carga_max[0] = 5
					edificio.carga_max[3] = 5
					edificio.carga_output[14] = true
					edificio.receptor = true
					edificio.emisor = true
					edificio.flujo_consumo_max = 4
				}
				else if a = 6{
					edificio.carga_output[15] = true
					edificio.receptor = false
					edificio.emisor = true
					edificio.flujo_consumo_max = 8
				}
				calculate_in_out_2(edificio)
				mover_in(edificio)
			}
		}
		else if in(var_edificio_nombre, "Fábrica de Drones") and mouse_y > bb + 40 * zoom and mouse_y < bb + (40 + 20 * dron_max) * zoom{
			var a = floor((mouse_y - (bb + 20 * (1 + zoom))) / (20 * zoom))
			draw_text_background(mouse_x + 20, mouse_y, dron_descripcion[a] + (a = 0 ? "\nNo disponible de momento" : ""))
			cursor = cr_handpoint
			if mouse_check_button_pressed(mb_left) and a > 0{
				mouse_clear(mb_left)
				show_menu = false
				edificio.carga = array_create(rss_max, 0)
				edificio.carga_max = array_create(rss_max, 0)
				edificio.carga_total = 0
				edificio.select = a
				edificio.fuel = 0
				for(var b = 0; b < array_length(dron_precio_id[a]); b++)
					edificio.carga_max[dron_precio_id[a, b]] = 2 * dron_precio_num[a, b]
				calculate_in_out_2(edificio)
				mover_in(edificio)
			}
		}
	}
	else if mouse_check_button_pressed(mb_left)
		show_menu = false
	if mouse_check_button_pressed(mb_right){
		mouse_clear(mb_right)
		show_menu = false
	}
}
//Terreno bajo el mouse
var temp_hexagono = instance_position(xmouse, ymouse, obj_hexagono), mx = 0, my = 0
if temp_hexagono != noone{
	mx = temp_hexagono.a
	my = temp_hexagono.b
	prev_change = false
	if mx != prev_x or my != prev_y{
		prev_x = mx
		prev_y = my
		prev_change = true
	}
}
var edificio = edificio_id[# mx, my], temp_coordenada = edificio.coordenadas
//Mostrar detalles de edificios al pasar el mouse_por encima
if not pausa and temp_hexagono != noone and flag{
	//Mostrar terreno
	temp_text = $"{mx}, {my}\n"
	temp_text += $"{terreno_nombre[terreno[# mx, my]]}\n"
	if ore[# mx, my] >= 0
		temp_text += $"{recurso_nombre[ore_recurso[ore[# mx, my]]]}: {ore_amount[# mx, my]}\n"
	temp_text += "___________________\n"
	if edificio_bool[# mx, my]{
		var index = edificio.index, var_edificio_nombre = edificio_nombre[index]
		//Seleccionar edificios
		if mouse_check_button_pressed(mb_left) and build_index = 0 and build_menu = 0 and in(var_edificio_nombre, "Selector", "Overflow", "Líquido Infinito", "Recurso Infinito", "Planta Química", "Fábrica de Drones", "Procesador"){
			mouse_clear(mb_left)
			show_menu = true
			show_menu_build = edificio
			show_menu_x = edificio.x * zoom
			show_menu_y = edificio.y * zoom
		}
		//Modificar puertos de carga
		if var_edificio_nombre = "Puerto de Carga"{
			if edificio.link != null_edificio{
				draw_set_color(c_green)
				if edificio.receptor
					draw_arrow_off(edificio.x, edificio.y, edificio.link.x, edificio.link.y, 8)
				else
					draw_arrow_off(edificio.link.x, edificio.link.y, edificio.x, edificio.y, 8)
			}
			if mouse_check_button_pressed(mb_left){
				mouse_clear(mb_left)
				if puerto_carga_bool and edificio != puerto_carga_link{
					if puerto_carga_link.link != null_edificio{
						if puerto_carga_link.receptor
							array_remove(puerto_carga_array, puerto_carga_link)
						else
							array_remove(puerto_carga_array, puerto_carga_link.link)
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
					calculate_in_out_2(puerto_carga_link)
					if edificio.link != null_edificio{
						if edificio.receptor
							array_remove(puerto_carga_array, edificio)
						else
							array_remove(puerto_carga_array, edificio.link)
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
					calculate_in_out_2(edificio)
					array_push(puerto_carga_array, puerto_carga_link)
					puerto_carga_link = null_edificio
					puerto_carga_bool = false
				}
				else{
					puerto_carga_link = edificio
					puerto_carga_bool = true
				}
			}
		}
		temp_text += $"{var_edificio_nombre}\n"
		if info{
			//Mostrar inputs
			draw_set_color(c_blue)
			for(var a = 0; a < ds_list_size(edificio.inputs); a++){
				var edificio_2 = edificio.inputs[|a]
				draw_arrow_off(edificio_2.x, edificio_2.y, edificio.x, edificio.y, 12)
			}
			//Mostrar outputs
			draw_set_color(c_red)
			for(var a = 0; a < ds_list_size(edificio.outputs); a++){
				var edificio_2 = edificio.outputs[|a]
				draw_arrow_off(edificio.x, edificio.y, edificio_2.x, edificio_2.y, 12)
			}
		}
		//Mostrar carga
		if edificio.carga_total > 0{
			temp_text += "Almacen:\n"
			for(var a = 0; a < rss_max; a++)
				if edificio.carga[a] > 0
					temp_text += $"  {recurso_nombre[a]}: {floor(edificio.carga[a])}\n"
			if info and edificio.carga_total > 0
				temp_text += $"    Total: {floor(edificio.carga_total)}\n"
		}
		//Mostrar recursos subterraneos
		if in(var_edificio_nombre, "Taladro", "Taladro Eléctrico")
			if edificio.idle
				temp_text += "Sin recursos\n"
			else{
				var temp_array = [0], temp_text_2 = ""
				for(var a = 0; a < rss_max; a++)
					temp_array[a] = 0
				for(var a = 0; a < ds_list_size(edificio.coordenadas); a++){
					var temp_complex = edificio.coordenadas[|a], aa = temp_complex.a, bb = temp_complex.b
					if in(ore[# aa, bb], 0, 1, 2)
						temp_array[ore_recurso[ore[# aa, bb]]] += ore_amount[# aa, bb]
					else if terreno_recurso_bool[terreno[# aa, bb]] and in(var_edificio_nombre, "Taladro Eléctrico")
						temp_array[terreno_recurso_id[terreno[# aa, bb]]] = -1
				}
				for(var a = 0; a < rss_max; a++)
					if temp_array[a] > 0
						temp_text_2 += $"  {recurso_nombre[a]}: {temp_array[a]}\n"
					else if temp_array[a] = -1
						temp_text_2 += $"  {recurso_nombre[a]}\n"
				if temp_text_2 != ""
					temp_text += $"Recursos disponibles:\n{temp_text_2}"
			}
		//Mostrar combustión
		if in(var_edificio_nombre, "Horno", "Generador", "Turbina", "Planta Nuclear")
			temp_text += $"Combustion: {floor(edificio.fuel / 30)} s\n"
		//Mostrar rango de cables
		if in(var_edificio_nombre, "Cable"){
			draw_set_color(c_white)
			draw_circle_off(edificio.x, edificio.y, 90, true)
		}
		//Mostrar rango de torres
		if edificio_armas[index]{
			var alc = edificio_alcance[index]
			draw_set_color(c_white)
			draw_circle_off(edificio.x, edificio.y, alc, true)
			if var_edificio_nombre = "Mortero"
				draw_circle_off(edificio.x, edificio.y, 100, true)
			if not ds_list_empty(enemigos) and edificio.target != null_enemigo
				draw_sprite_off(spr_target, 0, edificio.target.a, edificio.target.b)
		}
		//Mostrar rutas de tuneles
		if in(var_edificio_nombre, "Túnel", "Túnel salida"){
			if keyboard_check_pressed(ord("R")) and edificio.link != null_edificio{
				keyboard_clear(ord("R"))
				if edificio.index = 16{
					edificio.index = 6
					edificio.link.index = 16
					calculate_in_out(edificio)
					calculate_in_out(edificio.link)
					calculate_in_out_2(edificio)
					calculate_in_out_2(edificio.link)
					ds_list_add(edificio.outputs, edificio.link)
					ds_list_add(edificio.link.inputs, edificio)
				}
				else{
					edificio.index = 16
					edificio.link.index = 6
					calculate_in_out(edificio)
					calculate_in_out(edificio.link)
					calculate_in_out_2(edificio)
					calculate_in_out_2(edificio.link)
					ds_list_add(edificio.inputs, edificio.link)
					ds_list_add(edificio.link.outputs, edificio)
				}
			}
		}
		if var_edificio_nombre = "Fábrica de Drones"{
			if edificio.proceso > 0
				temp_text += $"Creando Dron ({ds_list_size(drones_aliados)}/8)\n"
			else if ds_list_size(drones_aliados) = 8
				temp_text += "Límite de Drones alcanzado (8/8)\n"
		}
		//Mostrar inputs
		if info and edificio.receptor{
			if edificio_input_all[index]
				temp_text += "Acepta todo\n"
			else{
				var temp_text_2 = ""
				for(var a = 0; a < rss_max; a++)
					if edificio.carga_max[a] > 0
						temp_text_2 += $"  {recurso_nombre[a]}: {edificio.carga_max[a]}\n"
				if temp_text_2 != ""
					temp_text += "Acepta:\n" + temp_text_2
			}
		}
		//Mostrar outputs
		if info and edificio.emisor{
			if edificio_output_all[index]
				temp_text += "Entrega todo\n"
			else{
				var temp_text_2 = ""
				for(var a = 0; a < rss_max; a++)
					if edificio.carga_output[a]
						temp_text_2 += $"  {recurso_nombre[a]}\n"
				if temp_text_2 != ""
					temp_text += $"Entrega:\n{temp_text_2}"
			}
		}
		//Mostrar red electrica
		if edificio_energia[index]{
			var red = edificio.red
			if edificio_energia_consumo[index] > 0{
				temp_text += $"Consumiendo {edificio.energia_consumo} energía\n"
				if in(var_edificio_nombre, "Planta Química")
					temp_text += $"Funcionando al {floor(100 * clamp((red.generacion + red.bateria) / min(red.consumo, 1), 0, 1) * clamp((edificio.flujo.generacion + edificio.flujo.almacen) / min(edificio.flujo.consumo, 1), 0, 1))}% de su capacidad\n"
				else
					temp_text += $"Funcionando al {floor(100 * clamp((red.generacion + red.bateria) / min(red.consumo, 1), 0, 1))}% de su capacidad\n"
			}
			temp_text += $"Red {ds_list_find_index(redes, red)}\n"
			temp_text += $"  Consumo: {red.consumo}\n"
			temp_text += $"  Generacion: {red.generacion}\n"
			temp_text += $"  Batería: {floor(red.bateria)}/{red.bateria_max}\n"
			if info
				temp_text += red_text(red)
			for(var a = 0; a < ds_list_size(edificio.energia_link); a++){
				var edificio_2 = edificio.energia_link[|a]
				draw_set_color(c_red)
				var temp_complex_2 = abtoxy(edificio.a, edificio.b)
				var temp_complex_3 = abtoxy(edificio_2.a, edificio_2.b)
				draw_line_off(temp_complex_2.a, temp_complex_2.b, temp_complex_3.a, temp_complex_3.b)
			}
		}
		//Mostrar red de líquido
		if edificio_flujo[index]{
			var flujo = edificio.flujo
			temp_text += $"Tubería {ds_list_find_index(flujos, flujo)}:\n"
			if flujo.liquido = -1
				temp_text += "  Sin liquidos\n"
			else
				temp_text += $"  {liquido_nombre[flujo.liquido]}\n"
			if edificio_flujo_consumo[index] > 0
				temp_text += $"Consumiendo {edificio.flujo_consumo} líquido\n"
			temp_text += $"  Generacion: {flujo.generacion}\n"
			temp_text += $"  Consumo: {flujo.consumo}\n"
			temp_text += $"  Almacenado: {floor(flujo.almacen)}/{flujo.almacen_max}\n"
			if info
				temp_text += flujo_text(flujo)
		}
		if info and edificio_proceso[index] > 1
			temp_text += $"Proceso: {floor(edificio.proceso)}/{edificio_proceso[index]}\n"
		temp_text += "___________________\n"
	}
	draw_text_background(0, 0, temp_text)
}
if puerto_carga_bool{
	draw_set_halign(fa_center)
	draw_text_background(room_width / 2, 100, "Conecta con otro Puerto de Carga")
	draw_set_halign(fa_left)
	if mouse_check_button_pressed(mb_any){
		mouse_clear(mouse_lastbutton)
		puerto_carga_bool = false
	}
}
flag = false
if sonido
	for(var a = 0; a < sonidos_max; a++)
		volumen[a] = 0
#region Menú de edificios
	var just_pressed = false
	if mouse_check_button_pressed(mb_right) and build_index = 0 and not edificio_bool[# mx, my]{
		mouse_clear(mb_right)
		if build_menu = 0{
			build_menu = 1
			menu_x = mouse_x
			menu_y = mouse_y
		}
		else if build_menu = 1
			build_menu = 0
		else
			build_menu = 1
	}
	if build_menu = 1{
		var b = 2 * pi / array_length(categoria_nombre)
		draw_set_color(c_white)
		draw_circle(menu_x, menu_y, 100, true)
		draw_circle(menu_x, menu_y, 10, false)
		for(var a = 0; a < array_length(categoria_nombre); a++){
			var angle = a * b
			draw_sprite(spr_items, a, menu_x - 15 + 100 * cos(angle + b / 2), menu_y - 15 - 100 * sin(angle + b / 2))
			draw_line(menu_x, menu_y, menu_x + 100 * cos(angle), menu_y - 100 * sin(angle))
		}
		if distance_sqr(mouse_x, mouse_y, menu_x, menu_y) < 10000{//100^2
			temp_text = ""
			b = floor((array_length(categoria_nombre) - arctan2(mouse_y - menu_y, mouse_x - menu_x) / b) mod array_length(categoria_nombre))
			temp_text = categoria_nombre[b]
			draw_text_background(mouse_x + 20, mouse_y, temp_text)
			if mouse_check_button_pressed(mb_left){
				mouse_clear(mb_left)
				build_menu = 2
				menu_array = categoria_edificios[b]
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
				for(var c = 0; c < array_length(edificio_precio_id[index]); c++)
					if nucleo.carga[edificio_precio_id[index, c]] < edificio_precio_num[index, c]{
						comprable = false
						break
					}
				if not comprable{
					draw_set_alpha(0.5)
					draw_set_color(c_red)
					for(var angle_2 = angle; angle_2 < angle + b; angle_2 += pi / 64)
						draw_triangle(menu_x, menu_y, menu_x + 100 * cos(angle_2), menu_y - 100 * sin(angle_2), menu_x + 100 * cos(min(angle_2 + pi / 64, angle + b)), menu_y - 100 * sin(min(angle_2 + pi / 64, angle + b)), false)
					draw_set_alpha(1)
					draw_set_color(c_white)
				}
			}
			draw_sprite_stretched(edificio_sprite[index], 0, menu_x - 15 + 100 * cos(angle + b / 2), menu_y - 15 - 100 * sin(angle + b / 2), 30, 30)
		}
		draw_circle(menu_x, menu_y, 10, false)
		if distance_sqr(mouse_x, mouse_y, menu_x, menu_y) < 10000{//100^2
			b = menu_array[floor((array_length(menu_array) - arctan2(mouse_y - menu_y, mouse_x - menu_x) / b) mod array_length(menu_array))]
			temp_text = $"{edificio_nombre[b]} (hotkey: {edificio_key[b]})\n"
			if not cheat
				for(var c = 0; c < array_length(edificio_precio_id[b]); c++)
					temp_text += $"  {recurso_nombre[edificio_precio_id[b, c]]}: {edificio_precio_num[b, c]}\n"
			temp_text += $"{edificio_descripcion[b]}\n"
			draw_text_background(mouse_x, mouse_y + 20, temp_text)
			if mouse_check_button_pressed(mb_left){
				mouse_clear(mb_left)
				build_index = b
				build_menu = 0
				flag = true
				just_pressed = true
			}
		}
		else if mouse_check_button_pressed(mb_left){
			mouse_clear(mb_left)
			build_menu = 1
		}
	}
#endregion
//Acceso directo
if keyboard_check_pressed(vk_anykey) and (not in(keyboard_lastchar, "A", "D", "W", "S", " ") or cheat){
	for(var a = 1; a < edificio_max; a++)
		if edificio_key[a] != "" and string_ends_with(keyboard_string, edificio_key[a]){
			keyboard_string = ""
			build_index = a
			build_menu = 0
			flag = true
		}
	keyboard_step = 30
}
if keyboard_step-- = 0
	keyboard_string = ""
//Cancelar construcción o cerrar menú del selector
if (mouse_check_button_pressed(mb_right) or keyboard_check_pressed(vk_escape)) and (build_index > 0 or show_menu){
	mouse_clear(mb_right)
	build_index = 0
	show_menu = false
}
//Vista previa y construcción
if build_index > 0{
	var var_edificio_nombre = edificio_nombre[build_index]
	if flag and not edificio_rotable[build_index]
		build_dir = 0
	if flag and edificio_size[build_index] mod 2 = 0
		build_dir = 5 * (build_dir mod 2)
	//Rotar
	if edificio_rotable[build_index] and not keyboard_check(vk_lcontrol){
		if mouse_wheel_up(){
			if edificio_size[build_index] mod 2 = 0
				build_dir = 5 - build_dir
			else
				build_dir = (build_dir + 1) mod 6
			flag = true
		}
		if mouse_wheel_down(){
			if edificio_size[build_index] mod 2 = 0
				build_dir = 5 - build_dir
			else
				build_dir = build_dir - 1 + 6 * (build_dir = 0)
			flag = true
		}
	}
	if last_mx != mx or last_my != my or flag{
		build_list = get_size(mx, my, build_dir, edificio_size[build_index])
		if var_edificio_nombre = "Taladro de Explosión"
			build_list_arround = get_size(mx, my, build_dir, edificio_size[build_index] + 2)
		show_menu = false
	}
	last_mx = mx
	last_my = my
	var comprable = true
	temp_text = ""
	//Detectar si el terreno existe
	for(var a = 0; a < ds_list_size(build_list); a++){
		var temp_complex_2 = build_list[|a], aa = temp_complex_2.a, bb = temp_complex_2.b
		if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize{
			comprable = false
			break
		}
	}
	if comprable and temp_hexagono != noone{
		//Detectar recursos y enemigos cerca
		if not cheat{
			for(var a = 0; a < array_length(edificio_precio_id[build_index]); a++)
				if nucleo.carga[edificio_precio_id[build_index, a]] < edificio_precio_num[build_index, a]{
					comprable = false
					temp_text += $"  {recurso_nombre[edificio_precio_id[build_index, a]]} {nucleo.carga[edificio_precio_id[build_index, a]]}/{edificio_precio_num[build_index, a]}\n"
				}
			if not comprable
				temp_text = "Recursos insuficientes\n" + temp_text
			draw_set_color(c_red)
			var flag_3 = false
			for(var a = 0; a < ds_list_size(enemigos); a++){
				var enemigo = enemigos[|a]
				draw_circle_off(enemigo.a, enemigo.b, 100, true)
				if not flag_3 and (sqr(mouse_x - enemigo.a + camx) + sqr(mouse_y - enemigo.b + camy)) < 10000{//100^2
					temp_text += "¡Hay enemigos demasiado cerca!\n"
					comprable = false
					flag_3 = true
				}
			}
			draw_set_color(c_white)
		}
		draw_set_color(c_red)
		var temp_complex = abtoxy(spawn_x, spawn_y), aaa = temp_complex.a, bbb = temp_complex.b
		draw_circle_off(aaa, bbb, 250, true)
		if (sqr(mouse_x - aaa + camx) + sqr(mouse_y - bbb + camy)) < 62500{//250^2
			temp_text += "Zona de generación de enemigos\n"
			comprable = false
		}
		for(var a = 0; a < ds_list_size(build_list); a++){
			var temp_complex_2 = build_list[|a], aa = temp_complex_2.a, bb =  temp_complex_2.b
			if in(terreno_nombre[terreno[# aa, bb]], "Pared de Piedra"){
				temp_text += "Terreno inválido\n"
				comprable = false
				break
			}
		}
		//Detectar que no esté en terreno prohíbido
		if not in(var_edificio_nombre, "Tubería", "Bomba de Evaporación", "Bomba Hidráulica", "Generador Geotérmico")
			for(var a = 0; a < ds_list_size(build_list); a++){
				var temp_complex_2 = build_list[|a], aa = temp_complex_2.a, bb = temp_complex_2.b
				if terreno_liquido[terreno[# aa, bb]]{
					temp_text += "Terreno inválido\n"
					comprable = false
					break
				}
			}
		//Detectar que las bombas tengan líquidos
		if in(var_edificio_nombre, "Bomba Hidráulica"){
			flag = false
			var liquido = -1
			for(var a = 0; a < ds_list_size(build_list); a++){
				var temp_complex_2 = build_list[|a], aa = temp_complex_2.a, bb = temp_complex_2.b
				if terreno_liquido[terreno[# aa, bb]]{
					flag = true
					if in(terreno_nombre[terreno[# aa, bb]], "Agua", "Agua Profunda"){
						if not in(liquido, -1, 0){
							flag = false
							temp_text += "No se puede combinar líquidos\n"
							break
						}
						liquido = 0
					}
					else{
						if not in(liquido, -1, 1){
							flag = false
							temp_text += "No se puede combinar líquidos\n"
							break
						}
						liquido = 1
					}
				}
			}
			if not flag{
				comprable = false
				temp_text += "Necesita ser construido sobre agua, petróleo o lava\n"
			}
		}
		else if in(var_edificio_nombre, "Generador Geotérmico"){
			flag  = false
			for(var a = 0; a < ds_list_size(build_list); a++){
				var temp_complex_2 = build_list[|a], aa = temp_complex_2.a, bb = temp_complex_2.b
				if terreno_nombre[terreno[# aa, bb]] = "Lava"
					flag = true
			}
			if not flag{
				comprable = false
				temp_text += "Necesita ser construido sobre lava\n"
			}
		}
		else if in(var_edificio_nombre, "Bomba de Evaporación"){
			flag = false
			for(var a = 0; a < ds_list_size(build_list); a++){
				var temp_complex_2 = build_list[|a], aa = temp_complex_2.a, bb = temp_complex_2.b
				if in(terreno_nombre[terreno[# aa, bb]], "Agua", "Agua Profunda"){
					flag = true
					break
				}
			}
			if not flag{
				comprable = false
				temp_text += "Necesita ser construido sobre agua"
			}
		}
		//Detectar que los taladros tengan recursos
		if in(var_edificio_nombre, "Taladro", "Taladro Eléctrico"){
			var temp_array = array_create(rss_max, 0), temp_array_2 = array_create(rss_max, 0), b = 0
			flag = false
			//Buscar minerales superficiales
			for(var a = 0; a < ds_list_size(build_list); a++){
				var temp_complex_2 = build_list[|a], aa = temp_complex_2.a, bb = temp_complex_2.b
				if in(ore[# aa, bb], 0, 1, 2){
					temp_array[ore_recurso[ore[# aa, bb]]]++
					temp_array_2[ore_recurso[ore[# aa, bb]]] += ore_amount[# aa, bb]
					b++
					flag = true
				}
			}
			//Buscar piedra o arena
			if in(var_edificio_nombre, "Taladro Eléctrico"){
				for(var a = 0; a < ds_list_size(build_list); a++){
					var temp_complex_2 = build_list[|a], aa = temp_complex_2.a, bb = temp_complex_2.b
					if not in(ore[# aa, bb], 0, 1, 2) and in(terreno_nombre[terreno[# aa, bb]], "Piedra", "Arena", "Piedra Cúprica", "Piedra Férrica", "Basalto Sulfatado"){
						temp_array[terreno_recurso_id[terreno[# aa, bb]]]++
						temp_array_2[terreno_recurso_id[terreno[# aa, bb]]] = -1
						b++
						flag = true
					}
				}
			}
			if not flag{
				comprable = false
				if in(var_edificio_nombre, "Taladro")
					temp_text += "Necesita ser construido sobre minerales"
				else if in(var_edificio_nombre, "Taladro Eléctrico")
					temp_text += "Necesita ser construido sobre minerales, piedra o arena"
			}
			//Escribir porcentajes de recursos
			else for(var a = 0; a < rss_max; a++){
				if temp_array_2[a] > 0
					temp_text += $"{recurso_nombre[a]}: {temp_array_2[a]}({round(temp_array[a] * 100 / b)}%)\n"
				else if temp_array_2[a] = -1
					temp_text += $"{recurso_nombre[a]}({round(temp_array[a] * 100 / b)}%)\n"
			}
		}
		//Taladros de Explosión
		if var_edificio_nombre = "Taladro de Explosión"{
			var temp_array = array_create(rss_max, 0), temp_array_2 = array_create(rss_max, 0)
			for(var a = 0; a < ds_list_size(build_list_arround); a++){
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
				else if in(terreno_nombre[terreno[# aa, bb]], "Piedra", "Arena", "Piedra Cúprica", "Piedra Férrica", "Basalto Sulfatado"){
					temp_array[terreno_recurso_id[terreno[# aa, bb]]]++
					temp_array_2[terreno_recurso_id[terreno[# aa, bb]]] = -1
					flag = true
				}
			}
			if not flag{
				comprable = false
				temp_text += "Necesita ser construido sobre minerales, piedra o arena"
			}
			else for(var a = 0; a < rss_max; a++){
				if temp_array_2[a] > 0
					temp_text += $"{recurso_nombre[a]}: {temp_array_2[a]} ({temp_array[a] / 5}/s)\n"
				else if temp_array_2[a] = -1
					temp_text += $"{recurso_nombre[a]} ({temp_array[a] / 5}/s)\n"
			}
		}
		//Detectar que no haya otros edificios debajo
		if edificio_camino[build_index] or in(var_edificio_nombre, "Túnel", "Túnel salida"){
			for(var a = 0; a < ds_list_size(build_list); a++){
				var temp_complex_2 = build_list[|a], aa = temp_complex_2.a, bb = temp_complex_2.b
				if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
					continue
				if edificio_bool[# aa, bb]{
					var temp_edificio = edificio_id[# aa, bb]
					if not edificio_camino[temp_edificio.index]{
						temp_text += "Terreno ocupado\n"
						comprable = false
						break
					}
				}
			}
		}
		else for(var a = 0; a < ds_list_size(build_list); a++){
			var temp_complex_2 = build_list[|a], aa  = temp_complex_2.a, bb = temp_complex_2.b
			if edificio_bool[# aa, bb]{
				temp_text += "Terreno ocupado\n"
				comprable = false
				break
			}
		}
		//No se puede construir
		if not comprable{
			var temp_complex_2 = abtoxy(mx, my)
			draw_edificio(temp_complex_2.a, temp_complex_2.b, build_index, build_dir)
			for(var a = 0; a < ds_list_size(build_list); a++){
				temp_complex_2 = build_list[|a]
				var temp_complex_3 = abtoxy(temp_complex_2.a, temp_complex_2.b)
				draw_sprite_off(spr_rojo, 0, temp_complex_3.a, temp_complex_3.b,,,,, 0.5)
			}
			draw_text_background(mouse_x + 20, mouse_y, temp_text)
		}
		//Sí se puede construir
		else{
			temp_complex = abtoxy(mx, my)
			if not (mouse_check_button(mb_left) and (edificio_camino[build_index] or var_edificio_nombre = "Tubería"))
				draw_edificio(temp_complex.a, temp_complex.b, build_index, build_dir, 0.5)
			var temp_array, temp_array_2
			flag = true
			//Vista previa caminos
			if edificio_camino[build_index] or var_edificio_nombre = "Tubería"{
				//Iniciar arrastre
				if mouse_check_button_pressed(mb_left){
					mx_clic = mx
					my_clic = my
					clicked = true
				}
				//Arrastre
				if mouse_check_button(mb_left){
					ds_list_clear(pre_build_list)
					var temp_complex_2 = abtoxy(mx_clic, my_clic), aa = temp_complex_2.a, bb = temp_complex_2.b
					draw_edificio(aa, bb, build_index, build_dir, 0.5)
					ds_list_add(pre_build_list, {a : mx_clic, b : my_clic})
					if mx_clic != mx or my_clic != my{
						var angle = radtodeg((arctan2(bb * zoom - camy - mouse_y, mouse_x - aa * zoom + camx) + 2 * pi) mod (2 * pi))
						build_dir = floor(angle / 60)
						var a = mx_clic, b = my_clic, temp_complex_3
						do{
							temp_complex_3 = next_to(a, b, build_dir)
							ds_list_add(pre_build_list, temp_complex_3)
							a = temp_complex_3.a
							b = temp_complex_3.b
							temp_complex_3 = abtoxy(a, b)
							aaa = temp_complex_3.a
							bbb = temp_complex_3.b
							draw_edificio(aaa, bbb, build_index, build_dir, 0.5)
						}
						until(temp_complex_3.a < min(xmouse, aa) or temp_complex_3.a > max(xmouse, aa) or temp_complex_3.b < min(ymouse, bb) or temp_complex_3.b > max(ymouse, bb))
					}
				}
				//Mostrar caminos solos
				else{
					temp_complex = next_to(mx, my, build_dir)
					var temp_complex_2 = abtoxy(mx, my), aa = temp_complex_2.a, bb = temp_complex_2.b
					var temp_complex_3 = abtoxy(temp_complex.a, temp_complex.b)
					if not in(var_edificio_nombre, "Tubería"){
						draw_set_color(c_black)
						draw_arrow_off(aa, bb, temp_complex_3.a, temp_complex_3.b, 8)
					}
					if not in(var_edificio_nombre, "Cinta Transportadora", "Cinta Magnética", "Tubería"){
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
					flag = false
					clicked = false
					for(var a = 0; a < ds_list_size(pre_build_list); a++){
						comprable = true
						if not cheat
							for(var b = 0; b < array_length(edificio_precio_id[build_index]); b++)
								if nucleo.carga[edificio_precio_id[build_index, b]] < edificio_precio_num[build_index, b]{
									comprable = false
									break
								}
						if in(var_edificio_nombre, "Tubería")
							build_dir = 0
						if comprable{
							var temp_complex_2 = pre_build_list[|a]
							f1(build_index, build_dir, temp_complex_2.a, temp_complex_2.b)
						}
					}
				}
			}
			//Vista previa no caminos
			else{
				if in(var_edificio_nombre, "Túnel", "Túnel salida"){
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
							if in(edificio_nombre[edificio_2.index], "Túnel", "Túnel salida") and edificio_2.dir = (build_dir + 3) mod 6{
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
					var temp_complex_2 = abtoxy(mx, my)
					if edificio_size[build_index] mod 2 = 0
						draw_sprite_off(edificio_sprite[build_index], 0, temp_complex_2.a, temp_complex_2.b, power(-1, build_dir),,,, 0.5)
					else
						draw_sprite_off(edificio_sprite[build_index], 0, temp_complex_2.a, temp_complex_2.b,,, build_dir * 60,, 0.5)
					//Vista previa Cables
					if in(var_edificio_nombre, "Cable"){
						draw_circle_off(temp_complex_2.a, temp_complex_2.b, 90, true)
						var temp_list_complex = get_size(mx, my, build_dir, 7)
						for(var a = 0; a < ds_list_size(temp_list_complex); a++){
							var temp_complex_3 = temp_list_complex[|a], aa = temp_complex_3.a, bb = temp_complex_3.b
							if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
								continue
							if (aa != mx or bb != my) and edificio_draw[# aa, bb]{
								var temp_edificio = edificio_id[# aa, bb]
								if edificio_energia[temp_edificio.index]
									draw_line_off(temp_complex_2.a, temp_complex_2.b, temp_edificio.x, temp_edificio.y)
							}
						}
					}
					else if var_edificio_nombre = "Torre de Alta Tensión"{
						draw_circle_off(temp_complex_2.a, temp_complex_2.b, 1_000, true)
						var size = array_length(torres_de_tension)
						for(var c = 0; c < size; c++){
							var temp_edificio = torres_de_tension[c]
							if sqr(temp_edificio.x - temp_complex_2.a) + sqr(temp_edificio.y - temp_complex_2.b) < 1_000_000//1000^2
								draw_line_off(temp_edificio.x, temp_edificio.y, temp_complex_2.a,temp_complex_2.b)
						}
					}
					//Vista previa Alcance de torres
					if edificio_armas[build_index]{
						draw_circle_off(temp_complex_2.a, temp_complex_2.b, edificio_alcance[build_index], true)
						if var_edificio_nombre = "Mortero"
							draw_circle_off(temp_complex_2.a, temp_complex_2.b, 100, true)
					}
				}
				if mouse_check_button_pressed(mb_left) and flag and comprable and (not edificio_bool[# mx, my] or ((in(var_edificio_nombre, "Túnel", "Túnel salida")) and edificio_camino[edificio_id[# mx, my].index]))
					f1(build_index, build_dir, mx, my)
			}
			if edificio_energia[build_index] and var_edificio_nombre != "Cable"{
				var temp_complex_2 = abtoxy(mx, my), temp_list_complex = get_size(mx, my, build_dir, 7)
				for(var a = 0; a < ds_list_size(temp_list_complex); a++){
					var temp_complex_3= temp_list_complex[|a], aa = temp_complex_3.a, bb = temp_complex_3.b
					if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
						continue
					if (aa != mx or bb != my) and edificio_draw[# aa, bb]{
						var temp_edificio = edificio_id[# aa, bb]
						if edificio_nombre[temp_edificio.index] = "Cable"
							draw_line_off(temp_complex_2.a, temp_complex_2.b, temp_edificio.x, temp_edificio.y)
					}
				}
			}
			draw_text_background(mouse_x + 20, mouse_y, temp_text)
			//Construir
			function f1(index, dir, mx, my){
				var flag = true, flag_2 = false, build_list = get_size(mx, my, dir, edificio_size[index]), edificio, var_edificio_nombre = edificio_nombre[index], temp_complex = abtoxy(mx, my)
				for(var a = 0; a < ds_list_size(build_list); a++){
					var temp_complex_2 = build_list[|a], aa = temp_complex_2.a, bb = temp_complex_2.b
					//Asegurarse de que esté dentro del mundo
					if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize{
						flag = false
						break
					}
					var temp_terreno_terreno = terreno[# aa, bb]
					if in(terreno_nombre[temp_terreno_terreno], "Pared de Piedra", "Pared de Arena", "Pared de Nieve", "Pared de Pasto"){
						flag = false
						break
					}
					//Checkear coliciones
					if edificio_bool[# aa, bb] and not ((edificio_camino[index] or in(var_edificio_nombre, "Túnel", "Túnel salida")) and edificio_camino[edificio_id[# aa, bb].index]){
						flag = false
						break
					}
					//Checkear agua
					if not in(var_edificio_nombre, "Bomba de Evaporación", "Bomba Hidráulica", "Tubería", "Generador Geotérmico") and terreno_liquido[temp_terreno_terreno]{
						flag = false
						break
					}
					//Reemplazar caminos
					if edificio_bool[# aa, bb]{
						var temp_edificio = edificio_id[# aa, bb]
						if (edificio_camino[index] or (in(var_edificio_nombre, "Túnel", "Túnel salida"))) and edificio_camino[temp_edificio.index]{
							if index = temp_edificio.index{
								temp_edificio.dir = dir
								calculate_in_out_2(temp_edificio)
								
								flag = false
								break
							}
							else
								delete_edificio(aa, bb)
						}
					}
					//Checkear minerales
					if in(var_edificio_nombre, "Taladro", "Taladro Eléctrico") and ore[# aa, bb] >= 0
						flag_2 = true
					//Checkear minerales
					if in(var_edificio_nombre, "Taladro Eléctrico") and terreno_recurso_bool[temp_terreno_terreno]
						flag_2 = true
					//Checkear agua
					if in(var_edificio_nombre, "Bomba Hidráulica") and not terreno_liquido[temp_terreno_terreno]
						flag = false
					if in(var_edificio_nombre, "Bomba de Evaporación") and not in(terreno_nombre[temp_terreno_terreno], "Agua", "Agua Profunda")
						flag = false
				}
				//Detectar enemigos cerca
				if flag and not cheat
					for(var a = 0; a < ds_list_size(enemigos); a++){
						var enemigo = enemigos[|a]
						if (sqr(enemigo.a - temp_complex.a) + sqr(enemigo.b - temp_complex.b)) < 10_000{//100^2
							flag = false
							break
						}
					}
				if flag and in(var_edificio_nombre, "Taladro", "Taladro Eléctrico") and not flag_2
					flag = false
				if not flag
					return
				if in(var_edificio_nombre, "Túnel", "Túnel salida") and build_able and build_target.index = 6
					index = 16
				edificio = add_edificio(index, dir, mx, my)
				if in(edificio_nombre[index], "Túnel", "Túnel salida")
					build_dir = (dir + 3) mod 6
				//Algoritmo link de tuneles
				if in(var_edificio_nombre, "Túnel", "Túnel salida"){
					edificio.idle = not build_able
					if build_able{
						if not build_target.idle{
							build_target.link.idle = true
							ds_list_remove(build_target.outputs, build_target.link)
							ds_list_remove(build_target.link.inputs, build_target)
						}
						build_target.idle = false
						if index = 16{
							ds_list_add(edificio.inputs, build_target)
							ds_list_add(build_target.outputs, edificio)
						}
						else{
							ds_list_add(edificio.outputs, build_target)
							ds_list_add(build_target.inputs, edificio)
						}
						edificio.link = build_target
						build_target.link = edificio
						if build_target.waiting
							mover(build_target.a, build_target.b)
					}
				}
				//Actualizar recursos
				if not cheat
					for(var a = 0; a < array_length(edificio_precio_id[index]); a++){
						nucleo.carga[edificio_precio_id[index, a]] -= edificio_precio_num[index, a]
						nucleo.carga_total -= edificio_precio_num[index, a]
					}
				if in(var_edificio_nombre, "Planta Química", "Fábrica de Drones"){
					show_menu = true
					show_menu_build = edificio
					build_index = 0
				}
			}
		}
	}
}
//Destruir edificio
else if ((mouse_check_button(mb_right) and prev_change) or mouse_check_button_pressed(mb_right)) and temp_hexagono != noone and edificio_bool[# mx, my] and edificio.index != 0{
	mouse_clear(mb_right)
	delete_edificio(mx, my)
}
//Ciclos
if not pausa{
	//Ciclo edificios
	for(var a = 0; a < ds_list_size(edificios); a++){
		edificio = edificios[|a]
		if edificio.idle
			continue
		var index = edificio.index, var_edificio_nombre = edificio_nombre[index]
		if edificio_energia[index]
			var red = edificio.red, red_power = clamp((red.generacion + red.bateria) / max(1, red.consumo), 0, 1)
		if edificio_flujo[index]
			var flujo = edificio.flujo, flujo_power = clamp((flujo.generacion + flujo.almacen) / max(1, flujo.consumo), 0, 1)
		//Accion caminos
		if (edificio_camino[index] or in(var_edificio_nombre, "Túnel", "Túnel salida")){
			if edificio.carga_total > 0 and not edificio.waiting and ++edificio.proceso = edificio_proceso[index]{
				edificio.proceso = 0
				edificio.waiting = not mover(edificio.a, edificio.b)
			}
		}
		//Accion taladro
		else if in(var_edificio_nombre, "Taladro", "Taladro Eléctrico"){
			if edificio.carga_total < edificio_carga_max[index]{
				if in(var_edificio_nombre, "Taladro Eléctrico"){
					change_energia(edificio_energia_consumo[index], edificio)
					if red_power > 0 and edificio.flujo_consumo = 0 and flujo.liquido = 1
						change_flujo(edificio_flujo_consumo[index], edificio)
					edificio.proceso += red_power * (1 + 0.6 * (flujo.liquido = 1 ? flujo_power : 0))
				}
				else if in(var_edificio_nombre, "Taladro"){
					change_flujo(edificio_flujo_consumo[index], edificio)
					edificio.proceso += 1 + 0.6 * (flujo.liquido = 0 ? flujo_power : 0)
				}
				sound_play_edificio(0, edificio.x, edificio.y)
				if edificio.proceso >= edificio_proceso[index]{
					edificio.proceso = 0
					var temp_list = ds_list_create(), temp_complex_2 = {a : 0, b : 0}
					flag = false
					ds_list_copy(temp_list, edificio.coordenadas)
					ds_list_shuffle(temp_list)
					while not ds_list_empty(temp_list){
						temp_complex_2 = temp_list[|0]
						var aa = temp_complex_2.a, bb = temp_complex_2.b
						ds_list_delete(temp_list, 0)
						if in(ore[# aa, bb], 0, 1, 2){
							edificio.carga[ore_recurso[ore[# aa, bb]]]++
							edificio.carga_total++
							if edificio.carga_total = edificio_carga_max[index]
								change_energia(0, edificio)
							ds_grid_add(ore_amount, aa, bb, -1)
							if ore_amount[# aa, bb] = 50
								update_background(aa, bb)
							else if ore_amount[# aa, bb] = 0
								ds_grid_set(ore, aa, bb, -1)
								update_background(aa, bb)
							flag = true
							break
						}
						else if terreno_recurso_bool[terreno[# aa, bb]] and in(var_edificio_nombre, "Taladro Eléctrico"){
							edificio.carga[terreno_recurso_id[terreno[# aa, bb]]]++
							edificio.carga_total++
							if edificio.carga_total = edificio_carga_max[index]
								change_energia(0, edificio)
							flag = true
							break
						}
					}
					ds_list_destroy(temp_list)
					if flag
						edificio.waiting = not mover(edificio.a, edificio.b)
					else{
						edificio.idle = true
						change_energia(0, edificio)
					}
					if in(var_edificio_nombre, "Taladro Eléctrico") and flujo.liquido = 1
						change_flujo(0, edificio)
					if in(var_edificio_nombre, "Taladro") and flujo.liquido = 0
						change_flujo(0, edificio)
				}
			}
		}
		//Taladro explosivo
		else if var_edificio_nombre = "Taladro de Explosión"{
			if edificio.carga[13] > 0{
				if edificio.carga_total < edificio_carga_max[index] and ++edificio.proceso >= edificio_proceso[index]{
					sound_play(snd_explosion, edificio.x, edificio.y)
					edificio.carga[13]--
					edificio.carga_total--
					var temp_list = get_size(edificio.a, edificio.b, edificio.dir, edificio_size[index] + 2)
					flag = false
					for(var b = 0; b < ds_list_size(temp_list); b++){
						var temp_complex = temp_list[|b], aa = temp_complex.a, bb = temp_complex.b
						if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
							continue
						if ore[# aa, bb] >= 0{
							edificio.carga[ore_recurso[ore[# aa, bb]]]++
							edificio.carga_total++
							flag = true
						}
						else if in(terreno_nombre[terreno[# aa, bb]], "Piedra", "Arena", "Piedra Cúprica", "Piedra Férrica", "Basalto Sulfatado"){
							edificio.carga[terreno_recurso_id[terreno[# aa, bb]]]++
							edificio.carga_total++
							flag = true
						}
					}
					if flag
						edificio.waiting = not mover(edificio.a, edificio.b)
					else
						edificio.idle = true
					edificio.proceso -= edificio_proceso[index]
				}
			}
			if edificio.carga_total > edificio.carga[13]
				edificio.waiting = not mover(edificio.a, edificio.b)
		}
		//Acción horno
		else if var_edificio_nombre = "Horno"{
			if (edificio.carga[0] > 1 or edificio.carga[3] > 1 or edificio.carga[5] > 1) and (edificio.carga[1] > 0 or edificio.carga[12] > 0 or edificio.fuel > 0){
				if edificio.fuel > 0{
					edificio.fuel--
					sound_play_edificio(2, edificio.x, edificio.y)
				}
				if edificio.carga[2] < 2 and edificio.carga[4] < 2 and edificio.carga[7] < 2{
					if edificio.fuel = 0
						if (edificio.carga[1] > 0 or edificio.carga[12] > 0){
							if edificio.carga[12] > 0{
								edificio.fuel = recurso_combustion_time[12]
								edificio.carga[12]--
							}
							else if edificio.carga[1] > 0{
								edificio.fuel = recurso_combustion_time[1]
								edificio.carga[1]--
							}
							if grafic_luz and not edificio.luz{
								edificio.luz = true
								var temp_list = edificio.coordenadas, size = ds_list_size(temp_list)
								for(var b = 0; b < size; b++){
									var temp_complex = temp_list[|b]
									add_luz(temp_complex.a, temp_complex.b, 1)
								}
							}
							edificio.carga_total--
							mover_in(edificio)
						}
						else if grafic_luz and edificio.luz{
							edificio.luz = false
							var temp_list = edificio.coordenadas, size = ds_list_size(temp_list)
							for(var b = 0; b < size; b++){
								var temp_complex = temp_list[|b]
								add_luz(temp_complex.a, temp_complex.b, -1)
							}
						}
					edificio.proceso++
					if edificio.proceso >= edificio_proceso[index]{
						if edificio.carga[5] > 1{
							edificio.carga[5] -= 2
							edificio.carga[7]++
							edificio.carga_total--
							edificio.proceso = 0
						}
						else if edificio.carga[3] > 1{
							edificio.carga[3] -= 2
							edificio.carga[4]++
							edificio.carga_total--
							edificio.proceso = -edificio_proceso[index] / 2
						}
						else if edificio.carga[0] > 1{
							edificio.carga[0] -= 2
							edificio.carga[2]++
							edificio.carga_total--
							edificio.proceso = 0
						}
						edificio.waiting = not mover(edificio.a, edificio.b)
					}
				}
			}
		}
		//Acción generador
		else if in(var_edificio_nombre, "Generador"){
			if edificio.fuel > 0{
				edificio.fuel--
				sound_play_edificio(2, edificio.x, edificio.y)
			}
			if edificio.fuel <= 0{
				//Encender
				if edificio.carga[1] > 0 or edificio.carga[12] > 0{
					if edificio.carga[12] > 0{
						edificio.fuel = recurso_combustion_time[12]
						edificio.carga[12]--
					}
					if edificio.carga[1] > 0{
						edificio.fuel = recurso_combustion_time[1]
						edificio.carga[1]--
					}
					if grafic_luz and not edificio.luz{
						edificio.luz = true
						add_luz(edificio.a, edificio.b, 1)
					}
					change_energia(edificio_energia_consumo[index], edificio)
					edificio.carga_total--
					mover_in(edificio)
				}
				//Apagar
				else{
					if grafic_luz and edificio.luz{
						edificio.luz = false
						add_luz(edificio.a, edificio.b, -1)
					}
					change_energia(0, edificio)
				}
			}
		}
		//Turbina
		else if in(var_edificio_nombre, "Turbina"){
			//Ya está encendido
			if edificio.fuel > 0{
				edificio.fuel--
				if flujo.liquido = 0
					change_energia(edificio_energia_consumo[index] * flujo_power, edificio)
				sound_play_edificio(2, edificio.x, edificio.y)
			}
			if edificio.fuel = 0 and flujo.liquido = 0{
				//Encender
				if (edificio.carga[1] > 0 or edificio.carga[12] > 0) and flujo_power > 0{
					if edificio.carga[12] > 0{
						edificio.fuel = recurso_combustion_time[12]
						edificio.carga[12]--
					}
					else if edificio.carga[1] > 0{
						edificio.fuel = recurso_combustion_time[1]
						edificio.carga[1]--
					}
					if grafic_luz and not edificio.luz{
						edificio.luz = true
						var temp_list = edificio.coordenadas, size = ds_list_size(temp_list)
						for(var b = 0; b < size; b++){
							var temp_complex = temp_list[|b]
							add_luz(temp_complex.a, temp_complex.b, 1)
						}
					}
					change_energia(edificio_energia_consumo[index] * flujo_power, edificio)
					change_flujo(edificio_flujo_consumo[index], edificio)
					edificio.carga_total--
					mover_in(edificio)
				}
				//Apagar
				else{
					if grafic_luz and edificio.luz{
						edificio.luz = false
						var temp_list = edificio.coordenadas, size = ds_list_size(temp_list)
						for(var b = 0; b < size; b++){
							var temp_complex = temp_list[|b]
							add_luz(temp_complex.a, temp_complex.b, -1)
						}
					}
					change_energia(0, edificio)
					change_flujo(0, edificio)
				}
			}
		}
		//Planta Nuclear
		else if in(var_edificio_nombre, "Planta Nuclear"){
			//Está encendido
			if edificio.fuel > 0{
				edificio.fuel--
				if flujo.liquido != 0
					edificio.vida--
				else{
					if flujo_power < 1
						edificio.vida -= (1 - flujo_power)
					change_energia(edificio_energia_consumo[index] * flujo_power, edificio)
				}
			}
			if edificio.fuel = 0 and flujo.liquido = 0{
				//Encender
				if edificio.carga[18] > 0 and edificio.carga[19] > 0 and flujo_power > 0{
					edificio.fuel = 900
					edificio.carga[18] -= 0.05
					edificio.carga[19]--
					if grafic_luz and not edificio.luz{
						edificio.luz = true
						var temp_list = edificio.coordenadas, size = ds_list_size(temp_list)
						for(var b = 0; b < size; b++){
							var temp_complex = temp_list[|b]
							add_luz(temp_complex.a, temp_complex.b, 1)
						}
					}
					change_energia(edificio_energia_consumo[index] * flujo_power, edificio)
					change_flujo(edificio_flujo_consumo[index], edificio)
					edificio.carga_total -= 1.05
					mover_in(edificio)
				}
				//Apagar
				else{
					if grafic_luz and edificio.luz{
						edificio.luz = false
						var temp_list = edificio.coordenadas, size = ds_list_size(temp_list)
						for(var b = 0; b < size; b++){
							var temp_complex = temp_list[|b]
							add_luz(temp_complex.a, temp_complex.b, -1)
						}
					}
					change_energia(0, edificio)
					change_flujo(0, edificio)
				}
			}
		}
		//Acción de la bomba hidraulica
		else if in(var_edificio_nombre, "Bomba Hidráulica"){
			//Está encendido
			if in(flujo.liquido, -1, edificio.select) and red_power > 0{
				change_energia(edificio_energia_consumo[index], edificio)
				if edificio.select = 0
					change_flujo(red_power * edificio_flujo_consumo[index], edificio)
				else
					change_flujo(red_power * edificio_flujo_consumo[index] / 10, edificio)
				flujo.generacion -= edificio.proceso
				if flujo.almacen >= flujo.almacen_max and flujo.generacion >= flujo.consumo{
					change_energia(0, edificio)
					change_flujo(0, edificio)
				}
				if grafic_luz and flujo.liquido != 3 and edificio.select = 3 and not edificio.luz
					for(var b = 0; b < ds_list_size(flujo.edificios); b++){
						var temp_edificio = flujo.edificios[|b]
						if not temp_edificio.luz{
							temp_edificio.luz = true
							add_luz(temp_edificio.a, temp_edificio.b, 1)
						}
					}
				flujo.liquido = edificio.select
			}
			else{
				change_energia(0, edificio)
				change_flujo(0, edificio)
			}
		}
		//Acción de la perforadora de petróleo
		else if in(var_edificio_nombre, "Perforadora de Petróleo"){
			//Está encendido
			if in(flujo.liquido, -1, 2) and red_power > 0{
				change_energia(edificio_energia_consumo[index], edificio)
				change_flujo(red_power * edificio_flujo_consumo[index], edificio)
				flujo.generacion -= edificio.proceso
				if flujo.almacen >= flujo.almacen_max and flujo.generacion >= flujo.consumo{
					change_energia(0, edificio)
					change_flujo(0, edificio)
				}
				flujo.liquido = 2
			}
			//Está apagado
			else{
				change_energia(0, edificio)
				change_flujo(0, edificio)
			}
		}
		//Acción de triturador
		else if in(var_edificio_nombre, "Triturador"){
			if edificio.carga[6] > 0 or edificio.carga[9] > 0 or edificio.carga[10] > 0 or edificio.carga[11] > 0{
				//Encender
				if edificio.proceso < 0{
					change_energia(edificio_energia_consumo[index], edificio)
					edificio.proceso++
				}
				edificio.proceso += red_power
				sound_play_edificio(1, edificio.x, edificio.y)
				//Producir / apagar
				if edificio.proceso >= edificio_proceso[index]{
					edificio.proceso = -1
					if edificio.carga[6] > 0
						edificio.carga[6]--
					else if edificio.carga[9] > 0
						edificio.carga[9]--
					else if edificio.carga[10] > 0
						edificio.carga[10]--
					else if edificio.carga[11] > 0
						edificio.carga[11]--
					edificio.carga[5]++
					edificio.waiting = not mover(edificio.a, edificio.b)
					change_energia(0, edificio)
				}
			}
		}
		//Refinería de Minerales
		else if in(var_edificio_nombre, "Refinería de Metales"){
			if flujo.liquido = 1 and (edificio.carga[9] > 2 or edificio.carga[10] > 2 or edificio.carga[17] > 0){
				//Encender
				if edificio.proceso < 0{
					change_energia(edificio_energia_consumo[index], edificio)
					change_flujo(edificio_flujo_consumo[index], edificio)
					edificio.proceso++
				}
				edificio.proceso += red_power * flujo_power
				sound_play_edificio(2, edificio.x, edificio.y)
				//Producir / Apagar
				if edificio.proceso >= edificio_proceso[index]{
					edificio.proceso = -1
					if edificio.carga[17] > 0{
						repeat(edificio.carga[17]){
							if random(1) < 0.993
								edificio.carga[19]++
							else
								edificio.carga[18]++
						}
						edificio.carga[17] = 0
					}
					else if edificio.carga[10] > 2{
						edificio.carga[10] -= 3
						edificio.carga[3]++
					}
					else if edificio.carga[9] > 2{
						edificio.carga[9] -= 3
						edificio.carga[0]++
					}
					edificio.carga_total -= 2
					edificio.waiting = not mover(edificio.a, edificio.b)
					change_energia(0, edificio)
					change_flujo(0, edificio)
				}
			}
			//Vaciar interior
			if edificio.waiting and edificio.carga[18] > 0 or edificio.carga[19] > 0
				edificio.waiting = not mover(edificio.a, edificio.b)
		}
		//Acción de torres
		else if in(var_edificio_nombre, "Torre", "Rifle", "Mortero", "Lanzallamas"){
			//Buscar enemigos
			if (image_index mod 10 = 0 or edificio.target = null_enemigo) or edificio.target.vida <= 0{
				edificio.target = null_enemigo
				if not ds_list_empty(enemigos){
					if var_edificio_nombre = "Mortero"
						turret_target(edificio, 10000)//100^2
					else
						turret_target(edificio)
				}
			}
			var enemigo = edificio.target
			if enemigo != null_enemigo{
				var dmg_factor = 1
				edificio.select = radtodeg(-arctan2(edificio.x - enemigo.a, enemigo.b - edificio.y)) - 90
				if ((in(var_edificio_nombre, "Torre", "Rifle") and flujo.liquido = 0) or (var_edificio_nombre = "Lanzallamas" and flujo.liquido = 2)){
					change_flujo(edificio_flujo_consumo[index], edificio)
					if in(var_edificio_nombre, "Torre", "Rifle")
						edificio.proceso += 0.5
					else
						dmg_factor = 1.4
				}
				//Disparo
				if ++edificio.proceso >= edificio_proceso[index]{
					sound_play(snd_disparo, edificio.x, edificio.y)
					edificio.proceso = 0
					var tiro = -1, arma = edificio_arma[index]
					for(var b = 0; b < array_length(armas[arma]); b++){
						var tiro_struct = armas[arma, b]
						if edificio.carga[tiro_struct.recurso] >= tiro_struct.cantidad{
							tiro = b
							break
						}
					}
					if tiro >= 0{
						var tiro_struct = armas[arma, tiro], aa = edificio.x, bb = edificio.y
						edificio.carga[tiro_struct.recurso] -= tiro_struct.cantidad
						edificio.carga_total -= tiro_struct.cantidad
						if edificio_size[index] mod 2 = 0{
							bb = edificio.y + 14
							aa = edificio.x + power(-1, edificio.dir) * 8
						}
						var dis = distance(edificio.x, edificio.y, enemigo.a, enemigo.b)
						var municion = {
							x : aa,
							y : bb,
							hmove : 25 * (enemigo.a - aa) / dis,
							vmove : 25 * (enemigo.b - bb) / dis,
							tipo : var_edificio_nombre = "Mortero" ? 1 : (var_edificio_nombre = "Lanzallamas" ? 2 : 0),
							dis : dis / 25,
							dmg : tiro_struct.dmg * dmg_factor,
							target : enemigo
						}
						array_push(municiones, municion)
						if var_edificio_nombre = "Lanzallamas"{
							var angle = arctan2(bb - enemigo.b, aa - enemigo.a)
							var b = angle + random_range(-pi / 16, pi / 16)
							array_push(fuegos, add_fuego(aa - 20 * cos(angle), bb - 20 * sin(angle), edificio.a, edificio.b, 12 * -cos(b), 12 * -sin(b), 40))
						}
						mover_in(edificio)
					}
				}
			}
			else
				change_flujo(0, edificio)
		}
		else if in(var_edificio_nombre, "Láser"){
			if edificio.target.vida <= 0{
				edificio.target = null_enemigo
				if not ds_list_empty(enemigos)
					turret_target(edificio)
			}
			var enemigo = edificio.target
			if enemigo != null_enemigo and distance_sqr(edificio.x, edificio.y, enemigo.a, enemigo.b) < edificio_alcance_sqr[edificio.index]{
				change_energia(edificio_energia_consumo[index], edificio)
				edificio.mode = true
				enemigo.vida -= red_power
				draw_set_alpha(red_power)
				draw_set_color(c_red)
				draw_line_off(edificio.x + 12, edificio.y + 14, enemigo.a, enemigo.b)
				draw_set_alpha(1)
				if enemigo.vida <= 0{
					kill_enemigo(enemigo)
					change_energia(0, edificio)
					edificio.target = null_enemigo
					turret_target(edificio)
				}
			}
			else
				change_energia(0, edificio)
		}
		//Planta química
		else if in(var_edificio_nombre, "Planta Química"){
			//Está entregando fluído
			if edificio.fuel > 0{
				edificio.fuel--
				if edificio.fuel = 0
					change_flujo(0, edificio)
			}
			if (edificio.select = 0 and edificio.carga[5] > 1 and edificio.carga[11] > 0 and in(flujo.liquido, -1, 1) and flujo.almacen < flujo.almacen_max) or
				(edificio.select = 1 and edificio.carga[5] > 0 and (edificio.carga[6] > 0 or edificio.carga[9] > 0 or edificio.carga[10] > 0 or edificio.carga[11] > 0) and flujo.liquido = 0) or
				(edificio.select = 2 and edificio.carga[1] > 0 and edificio.carga[11] > 0) or
				(edificio.select = 3 and flujo.liquido = 2) or
				(edificio.select = 4 and flujo.liquido = 2) or
				(edificio.select = 5 and flujo.liquido = 1 and edificio.carga[0] > 0 and edificio.carga[3] > 0) or
				(edificio.select = 6 and flujo.liquido = 2){
				//Encender
				if edificio.proceso < 0{
					change_energia(edificio_energia_consumo[index], edificio)
					if in(edificio.select, 3, 4, 5, 6)
						change_flujo(edificio.flujo_consumo_max, edificio)
					edificio.proceso++
				}
				if in(edificio.select, 3, 4, 5, 6)
					edificio.proceso += red_power * flujo_power
				else
					edificio.proceso += red_power
				//Producir / Apagar
				if edificio.proceso >= edificio_proceso[index]{
					if edificio.select = 0{
						edificio.carga[5] -= 2
						edificio.carga[11]--
						edificio.carga_total -= 3
						flujo.liquido = 1
						edificio.fuel = 30
						change_flujo(-2, edificio)
					}
					else if edificio.select = 1{
						edificio.carga[5]--
						if edificio.carga[6] > 0
							edificio.carga[6]--
						else if edificio.carga[9] > 0
							edificio.carga[9]--
						else if edificio.carga[10] > 0
							edificio.carga[10]--
						else
							edificio.carga[11]--
						edificio.carga[8]++
						edificio.carga_total--
						change_flujo(0, edificio)
					}
					else if edificio.select = 2{
						edificio.carga[1]--
						edificio.carga[11]--
						edificio.carga[13]++
						edificio.carga_total--
					}
					else if edificio.select = 3{
						edificio.carga[12]++
						edificio.carga_total++
						change_flujo(0, edificio)
					}
					else if edificio.select = 4{
						edificio.carga[11]++
						edificio.carga_total++
						change_flujo(0, edificio)
					}
					else if edificio.select = 5{
						edificio.carga[0]--
						edificio.carga[3]--
						edificio.carga[14]++
						edificio.carga_total--
					}
					else if edificio.select = 6{
						edificio.carga[15]++
						edificio.carga_total++
						change_flujo(0, edificio)
					}
					edificio.proceso = -1
					change_energia(0, edificio)
					edificio.waiting = not mover(edificio.a, edificio.b)
				}
			}
		}
		else if in(var_edificio_nombre, "Ensambladora"){
			if edificio.carga[0] > 0 and edificio.carga[7] > 0{
				//Encender
				if edificio.proceso < 0{
					change_energia(edificio_energia_consumo[index], edificio)
					edificio.proceso++
				}
				edificio.proceso += red_power
				//Producir / Apagar
				if edificio.proceso >= edificio_proceso[index]{
					edificio.carga[0]--
					edificio.carga[7]--
					edificio.carga[16]++
					edificio.carga_total--
					edificio.proceso = -1
					change_energia(0, edificio)
					edificio.waiting = not mover(edificio.a, edificio.b)
				}
			}
		}
		//Fábrica de Drones
		else if in(var_edificio_nombre, "Fábrica de Drones"){
			if edificio.select >= 0 and ds_list_size(drones_aliados) < 8{
				flag = false
				var size = array_length(dron_precio_id[edificio.select])
				for(var b = 0; b < size; b++)
					if edificio.carga[dron_precio_id[edificio.select, b]] < dron_precio_num[edificio.select, b]{
						flag = true
						break
					}
				if flag
					continue
				//Encender
				if edificio.proceso < 0{
					change_energia(edificio_energia_consumo[index], edificio)
					edificio.proceso++
				}
				edificio.proceso += red_power
				//Producir / Apagar
				if edificio.proceso >= edificio_proceso[index]{
					edificio.proceso -= edificio_proceso[index] + 1
					for(var b = 0; b < size; b++){
						edificio.carga_total -= dron_precio_num[edificio.select, b]
						edificio.carga[dron_precio_id[edificio.select, b]] -= dron_precio_num[edificio.select, b]
					}
					var dron = add_dron(edificio.a, edificio.b, edificio.select)
					ds_list_add(drones_aliados, dron)
					edificio.waiting = not mover_in(edificio)
					change_energia(0, edificio)
				}
			}
		}
		else if in(var_edificio_nombre, "Puerto de Carga"){
			if edificio.link != null_edificio and edificio.emisor
				edificio.waiting = mover(edificio.a, edificio.b)
		}
		//Recursos Infinitos
		else if in(var_edificio_nombre, "Recurso Infinito"){
			if edificio.select != -1{
				edificio.carga[edificio.select] = 1
				edificio.waiting = not mover(edificio.a, edificio.b)
			}
		}
		else if in(var_edificio_nombre, "Panel Solar")
			change_energia(energia_solar * edificio_energia_consumo[index], edificio)
		else if in(var_edificio_nombre, "Bomba de Evaporación")
			change_flujo(energia_solar * edificio_flujo_consumo[index], edificio)
		//Horno de Lava
		else if in(var_edificio_nombre, "Horno de Lava"){
			if flujo.liquido = 3 and (edificio.carga[0] > 1 or edificio.carga[3] > 1 or edificio.carga[5] > 1){
				//Encender
				if edificio.proceso < 0{
					change_flujo(edificio_flujo_consumo[index], edificio)
					edificio.proceso++
				}
				edificio.proceso += flujo_power
				//Producir / Apagar
				if edificio.proceso >= edificio_proceso[index]{
					if edificio.carga[5] > 1{
						edificio.carga[5] -= 2
						edificio.carga[7]++
						edificio.carga_total--
						edificio.proceso = 0
					}
					else if edificio.carga[3] > 1{
						edificio.carga[3] -= 2
						edificio.carga[4]++
						edificio.carga_total--
						edificio.proceso = -edificio_proceso[index] / 2
					}
					else if edificio.carga[0] > 1{
						edificio.carga[0] -= 2
						edificio.carga[2]++
						edificio.carga_total--
						edificio.proceso = 0
					}
					edificio.waiting = not mover(edificio.a, edificio.b)
					change_flujo(0, edificio)
				}
			}
		}
		else if in(var_edificio_nombre, "Generador Geotérmico"){
			if edificio.flujo.liquido = 0{
				change_energia(flujo_power * edificio_energia_consumo[index], edificio)
				change_flujo(edificio_flujo_consumo[index], edificio)
			}
			else{
				change_energia(0, edificio)
				change_flujo(0, edificio)
			}
		}
		else if var_edificio_nombre = "Procesador"{
			edificio.proceso += red_power
			if edificio.proceso >= 1{
				edificio.proceso--
				edificio.select = ++edificio.select mod max(1, array_length(edificio.instruccion))
				var pc = edificio.instruccion[edificio.select]
				//Continue
				if pc[0] = 0
					continue
				//Set {A} to {int}
				else if pc[0] = 1
					edificio.variables[pc[1]] = pc[2]
				//Set {A} to {B} [+, -, *, /, div, mod, or, and, xor, <<, >>] {C}
				else if pc[0] = 2{
					if pc[3] = 0
						edificio.variables[pc[1]] = edificio.variables[pc[2]] + edificio.variables[pc[4]]
					else if pc[3] = 1
						edificio.variables[pc[1]] = edificio.variables[pc[2]] - edificio.variables[pc[4]]
					else if pc[3] = 2
						edificio.variables[pc[1]] = edificio.variables[pc[2]] * edificio.variables[pc[4]]
					else if pc[3] = 3
						edificio.variables[pc[1]] = edificio.variables[pc[2]] / edificio.variables[pc[4]]
					else if pc[3] = 4
						edificio.variables[pc[1]] = edificio.variables[pc[2]] div edificio.variables[pc[4]]
					else if pc[3] = 5
						edificio.variables[pc[1]] = edificio.variables[pc[2]] % edificio.variables[pc[4]]
					else if pc[3] = 6
						edificio.variables[pc[1]] = edificio.variables[pc[2]] | edificio.variables[pc[4]]
					else if pc[3] = 7
						edificio.variables[pc[1]] = edificio.variables[pc[2]] & edificio.variables[pc[4]]
					else if pc[3] = 8
						edificio.variables[pc[1]] = edificio.variables[pc[2]] ^ edificio.variables[pc[4]]
					else if pc[3] = 9
						edificio.variables[pc[1]] = edificio.variables[pc[2]] << edificio.variables[pc[4]]
					else if pc[3] = 10
						edificio.variables[pc[1]] = edificio.variables[pc[2]] >> edificio.variables[pc[4]]
				}
				//If {A} [yes, no][<, >, =] {B}, jump to {int}
				else if pc[0] = 3{
					if pc[3] = 0 and (pc[2] xor edificio.variables[pc[1]] < edificio.variables[pc[4]])
						edificio.select = pc[5]
					if pc[3] = 1 and (pc[2] xor edificio.variables[pc[1]] > edificio.variables[pc[4]])
						edificio.select = pc[5]
					if pc[3] = 2 and (pc[2] xor edificio.variables[pc[1]] = edificio.variables[pc[4]])
						edificio.select = pc[5]
				}
				//Print {A}
				else if pc[0] = 4
					show_debug_message(edificio.variables[pc[1]])
			}
		}
	}
	//Ciclo de los enemigos
	for(var a = 0; a < ds_list_size(enemigos); a++){
		var enemigo = enemigos[|a], aa = enemigo.a, bb = enemigo.b, index = enemigo.index
		draw_sprite_off(dron_sprite[index], image_index / 2, aa, bb)
		draw_sprite_off(dron_sprite_color[index], 0, aa, bb,,,, c_red)
		if enemigo.vida < dron_vida_max[index]{
			draw_set_color(make_color_hsv(120 * enemigo.vida / dron_vida_max[index], 255, 255))
			draw_circle_off(aa, bb - 20, 5, false)
			draw_set_color(c_white)
		}
		if enemigo.target != null_edificio and enemigo.target.vida <= 0
			enemigo.target = null_edificio
		if not ds_list_empty(edificios) and enemigo.target = null_edificio{
			var temp_complex = xytoab(aa, bb)
			enemigo.target = edificio_cercano[# temp_complex.a, temp_complex.b]
		}
		//Target edificios
		if enemigo.target != null_edificio{
			edificio = enemigo.target
			var temp_complex = xytoab(aa, bb), aaa = temp_complex.a, bbb = temp_complex.b, dir = -1
			var dis = sqr(aa - edificio.x) + sqr(bb - edificio.y)
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
							min_dis_eu = distance_sqr(temp_complex.a, temp_complex.b, edificio.x, edificio.y)
							
						}
						else if disi = min_dis{
							temp_complex = abtoxy(aaaa, bbbb)
							var c = distance_sqr(temp_complex.a, temp_complex.b, edificio.x, edificio.y)
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
				if dir = -1{
					dir = 0
					show_debug_message(1)
				}
				enemigo.a += cos_angle_dir[dir]
				enemigo.b -= sin_angle_dir[dir]
			}
			if dis < 6400{//80^2
				draw_set_color(c_red)
				draw_line_off(aa, bb, edificio.x, edificio.y)
				if --edificio.vida <= 0{
					delete_edificio(edificio.a, edificio.b, true)
					temp_complex = xytoab(aa, bb)
					enemigo.target = edificio_cercano[# temp_complex.a, temp_complex.b]
				}
			}
			else if not ds_list_empty(drones_aliados){
				var closest_dron = null_enemigo, size = ds_list_size(drones_aliados), closest_dis = infinity
				for(var b = 0; b < size; b++){
					var temp_dron = drones_aliados[|b], temp_dis = distance_sqr(aa, bb, temp_dron.a, temp_dron.b)
					if temp_dis < closest_dis and temp_dis < 2500{//50^2
						closest_dis = temp_dis
						closest_dron = temp_dron
					}
				}
				if closest_dron != null_enemigo{
					draw_set_color(c_red)
					draw_line_off(aa, bb, closest_dron.a, closest_dron.b)
					if --closest_dron.vida <= 0
						ds_list_remove(drones_aliados, closest_dron)
				}
			}
		}
		//Cambiar de chunk
		var temp_list = ds_grid_get(chunk_enemigos, enemigo.chunk_x, enemigo.chunk_y)
		var temp_complex = xytoab(aa, bb)
		aa = temp_complex.a
		bb = temp_complex.b
		if clamp(round(aa / 6), 0, ds_grid_width(chunk_enemigos) - 1) != enemigo.chunk_x or clamp(round(bb / 12), 0, ds_grid_height(chunk_enemigos) - 1) != enemigo.chunk_y{
			ds_list_remove(temp_list, enemigo)
			enemigo.chunk_x = clamp(round(aa / 6), 0, ds_grid_width(chunk_enemigos) - 1)
			enemigo.chunk_y = clamp(round(bb / 12), 0, ds_grid_height(chunk_enemigos) - 1)
			temp_list = ds_grid_get(chunk_enemigos, enemigo.chunk_x, enemigo.chunk_y)
			ds_list_add(temp_list, enemigo)
		}
		aa = enemigo.a
		bb = enemigo.b
		//Alejarse de los enemigos cercanos
		for(var b = 0; b < ds_list_size(temp_list); b++){
			var temp_enemigo = temp_list[|b]
			if temp_enemigo != enemigo{
				var dis = sqr(aa - temp_enemigo.a) + sqr(bb - temp_enemigo.b)
				if dis < 400{//20^2
					dis = sqrt(dis)
					var aaa = (aa - temp_enemigo.a) / dis, bbb = (bb - temp_enemigo.b) / dis
					enemigo.a += aaa
					enemigo.b += bbb
					temp_enemigo.a -= aaa
					temp_enemigo.b -= bbb
				}
			}
		}
	}
	//Ciclo drones aliados
	for(var a = 0; a < ds_list_size(drones_aliados); a++){
		var dron = drones_aliados[|a], aa = dron.a, bb = dron.b, index = dron.index
		draw_sprite_off(dron_sprite[index], 0, aa, bb)
		draw_sprite_off(dron_sprite_color[index], 0, aa, bb,,,, c_blue)
		//Indicador de Vida
		if dron.vida < dron_vida_max[index]{
			draw_set_color(make_color_hsv(120 * dron.vida / dron_vida_max[index], 255, 255))
			draw_circle_off(aa, bb - 20, 5, false)
			draw_set_color(c_white)
			if dron.vida <= 0{
				ds_list_remove(drones_aliados, dron)
				a--
				continue
			}
		}
		//Dron de Transporte
		if dron.index = 1{
			if array_length(puerto_carga_array) > 0{
				if dron.modo = 0{
					puerto_carga_atended = (++puerto_carga_atended) mod array_length(puerto_carga_array)
					dron.target = puerto_carga_array[puerto_carga_atended]
					dron.modo = 1
				}
				else{
					edificio = dron.target
					var dis = distance_sqr(aa, bb, edificio.x, edificio.y)
					if dis > 100{//10^2
						dron.a += (edificio.x - aa) / dis
						dron.b += (edificio.y - bb) / dis
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
							mover(edificio.a, edificio.b)
							puerto_carga_atended = (++puerto_carga_atended) mod array_length(puerto_carga_array)
							dron.target = puerto_carga_array[puerto_carga_atended]
							dron.modo = 1
						}
					}
				}
			}
		}
		//Dron Reparador
		else if dron.index = 2{
			if dron.modo = 0{
				var b = irandom(ds_list_size(edificios) - 1)
				edificio = edificios[|b]
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
				var dis = distance_sqr(aa, bb, edificio.x, edificio.y)
				if dis > 2500{//50^2
					dron.a += (edificio.x - aa) / dis
					dron.b += (edificio.y - bb) / dis
				}
				else{
					draw_set_color(c_green)
					draw_line_off(aa, bb, edificio.x, edificio.y)
					if ++edificio.vida >= edificio_vida[edificio.index]{
						edificio.vida = edificio_vida[edificio.index]
						dron.modo = 0
					}
				}
			}
		}
		//Evitar colisiones
		for(var b = a + 1; b < ds_list_size(drones_aliados); b++){
			var temp_dron = drones_aliados[|b], dis = sqr(aa - temp_dron.a) + sqr(bb - temp_dron.b)
			if dis < 400{//20^2
				var aaa = (aa - temp_dron.a) / dis, bbb = (bb - temp_dron.b) / dis
				dron.a += aaa
				dron.b += bbb
				temp_dron.a -= aaa
				temp_dron.b -= bbb
			}
		}
	}
	//Ciclo de disparos
	draw_set_color(c_black)
	for(var a = 0; a < array_length(municiones); a++){
		var municion = municiones[a]
		if municion.tipo != 2
			draw_circle_off(municion.x, municion.y, 2, false)
		municion.x += municion.hmove
		municion.y += municion.vmove
		if --municion.dis <= 0{
			municiones[a--] = municiones[array_length(municiones) - 1]
			array_pop(municiones)
			if municion.target.vida > 0{
				municion.target.vida -= municion.dmg
				if municion.target.vida <= 0
					kill_enemigo(municion.target)
			}
			if municion.tipo = 1{
				sound_play(snd_explosion, municion.x, municion.y)
				array_push(efectos, add_efecto(spr_explosion, 0, municion.x, municion.y, 24, 1 / 3))
				for(var b = 0; b < ds_list_size(enemigos); b++){
					var enemigo = enemigos[|b], dis = distance_sqr(enemigo.a, enemigo.b, municion.x, municion.y)
					if dis < 2500{//50^2
						enemigo.vida -= 1000 / (10 + sqrt(dis))
						if enemigo.vida <= 0{
							kill_enemigo(enemigo)
							b--
						}
					}
				}
			}
		}
	}
	//Efectos estáticos
	for(var a = 0; a < array_length(efectos); a++){
		var efecto = efectos[a]
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
		if humo.a >= mina and humo.b >= minb and humo.a <= maxa and humo.b <= maxb{
			draw_set_alpha(humo.alpha)
			draw_set_color(make_color_hsv(0, 0, humo.value))
			draw_circle_off(humo.x, humo.y, 10, false)
			humo.x += humo.hmove
			humo.y += humo.vmove
		}
		if --humo.time <= 0{
			humos[a--] = humos[array_length(humos) - 1]
			array_pop(humos)
		}
	}
	draw_set_alpha(1)
	//Fuego
	for(var a = 0; a < array_length(fuegos); a++){
		var fuego = fuegos[a]
		if fuego.a >= mina and fuego.b >= minb and fuego.a <= maxa and fuego.b <= maxb{
			draw_set_alpha(0.4)
			draw_set_color(make_color_hsv(fuego.intensidad, 127, 255))
			draw_circle_off(fuego.x, fuego.y, 10, false)
			fuego.x += fuego.hmove
			fuego.y += fuego.vmove
			fuego.hmove *= 0.9
			fuego.vmove *= 0.9
			if grafic_humo and random(1) < 0.05
				array_push(humos, add_humo(fuego.x, fuego.y, fuego.a, fuego.b, random_range(-1, 1), random_range(-1, 1), 15, random(255), 0.3))
		}
		if --fuego.intensidad <= 0{
			fuegos[a--] = fuegos[array_length(fuegos) - 1]
			array_pop(fuegos)
			if grafic_humo and fuego.a >= mina and fuego.b >= minb and fuego.a <= maxa and fuego.b <= maxb
				array_push(humos, add_humo(fuego.x, fuego.y, fuego.a, fuego.b, random_range(-1, 1), random_range(-1, 1), 15, random(255), 0.3))
		}
	}
	draw_set_alpha(1)
	var temp_text_right = ""
	if info
		temp_text_right += $"FPS: {fps}\n"
	if oleadas{
		if image_index >= (60 * oleadas_tiempo_primera) or keyboard_check_pressed(vk_enter){
			if (image_index - 60 * oleadas_tiempo_primera) mod (60 * oleadas_tiempo) = 0 or keyboard_check_pressed(vk_enter){
				var d = enemigos_spawned++, e = 1, flag_2 = false
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
					var temp_complex = temp_complex_list[|i], aa = clamp(temp_complex.a, 0, xsize - 1), bb = clamp(temp_complex.b, 0, ysize - 1)
					if not terreno_caminable[terreno[# aa, bb]]
						continue
					var enemigo = add_dron(aa, bb, 0)
					enemigo.vida += 5 * d
					var temp_list = ds_grid_get(chunk_enemigos, enemigo.chunk_x, enemigo.chunk_y)
					ds_list_add(temp_list, enemigo)
					enemigo.target = edificio_cercano[# aa, bb]
					ds_list_add(enemigos, enemigo)
				}
			}
		}
		if image_index < (60 * oleadas_tiempo_primera){
			var seg = floor(((60 * oleadas_tiempo_primera) - image_index) / 60)
			temp_text_right += $"{seg > 60 ? string(floor(seg / 60)) + "m " : ""}{seg mod 60}s para los enemigos\n"
		}
		else{
			var seg = floor((60 * (oleadas_tiempo_primera) - image_index) mod (60 * oleadas_tiempo) / 60) + oleadas_tiempo
			temp_text_right += $"{seg > 60 ? string(floor(seg / 60)) + "m " : ""}{seg mod 60}s para la siguiente oleada\n"
		}
	}
	if mision_actual >= 0{
		var a = mision_actual
		temp_text_right += $"\n\n{mision_nombre[a]}\n{objetivos_nombre[mision_objetivo[a]]} {mision_target_num[a]} "
		if mision_objetivo[a] < 2
			temp_text_right += recurso_nombre[mision_target_id[a]]
		else if mision_objetivo[a] < 4
			temp_text_right += edificio_nombre[mision_target_id[a]]
		else if mision_objetivo[a] = 4
			temp_text_right += "enemigos"
		temp_text_right += $"\n{mision_counter} / {mision_target_num[a]}"
		if mision_objetivo[a] = 1{
			mision_counter = nucleo.carga[mision_target_id[a]]
			if mision_counter >= mision_target_num[a]{
				pasar_mision()
				a++
			}
		}
		if mision_objetivo[a] = 3{
			mision_counter = edificios_counter[mision_target_id[a]]
			if mision_counter >= mision_target_num[a]{
				pasar_mision()
				a++
			}
		}
	}
	if temp_text_right != ""{
		temp_text_right = string_trim(temp_text_right)
		draw_set_halign(fa_right)
		draw_text_background(room_width, 0, temp_text_right)
		draw_set_halign(fa_left)
	}
	if draw_sprite_boton(spr_manual, room_width - 64, string_height(temp_text_right), 64, 64, "Enciclopedia (Y)")
		enciclopedia = true
	energia_solar = clamp(2 * sin((image_index + 900) / 1800), 0, 1)
	//Ciclo de redes
	for(var a = 0; a < ds_list_size(redes); a++){
		var red = redes[|a]
		red.bateria = clamp(red.bateria + (red.generacion - red.consumo) / 30, 0, red.bateria_max)
		red.eficiencia = clamp((red.generacion + red.bateria) / max(1, red.consumo), 0, 1)
	}
	//Ciclo flujos
	for(var a = 0; a < ds_list_size(flujos); a++){
		var flujo = flujos[|a]
		flujo.almacen = clamp(flujo.almacen + (flujo.generacion - flujo.consumo) / 30, 0, flujo.almacen_max)
		if flujo.almacen = 0 and flujo.generacion = 0{
			if grafic_luz and flujo.liquido = 3
				for(var b = 0; b < ds_list_size(flujo.edificios); b++){
					edificio = flujo.edificios[|b]
					if edificio.luz{
						edificio.luz = false
						add_luz(edificio.a, edificio.b, -1)
					}
				}
			flujo.liquido = -1
		}
	}
}
//Input
if keyboard_check_pressed(vk_anykey){
	if keyboard_check_pressed(ord("P")){
		pausa = not pausa
		if pausa{
			build_index = 0
			show_menu = false
			puerto_carga_bool = false
			build_menu = 0
			mouse_clear(mb_any)
			keyboard_clear(vk_anykey)
		}
	}
	if keyboard_check_pressed(ord("R"))
		game_restart()
	if keyboard_check_pressed(ord("U"))
		info = not info
	if keyboard_check_pressed(ord("L"))
		flow = (flow + 1) mod 6
	if cheat and keyboard_check(ord("T"))
		image_index += 20
	//Mostrar redes electricas
	if keyboard_check(ord("O")){
		temp_text = ""
		for(var a = 0; a < ds_list_size(redes); a++){
			var red = redes[|a]
			temp_text += $"Red {a}:\n"
			temp_text += $"  Consumo: {red.consumo}\n"
			temp_text += $"  Generacion: {red.generacion}\n"
			temp_text += $"  Batería: {floor(red.bateria)}/{red.bateria_max}\n"
			temp_text += red_text(red)
			draw_set_color(make_color_hsv(255 * a / ds_list_size(redes), 255, 255))
			for(var b = 0; b < ds_list_size(red.edificios); b++){
				edificio = red.edificios[|b]
				for(var c = 0; c < ds_list_size(edificio.energia_link); c++){
					var edificio_2 = edificio.energia_link[|c]
					draw_arrow_off(edificio.x, edificio.y, edificio_2.x, edificio_2.y, 8)
				}
			}
		}
		draw_text_background(0, 0, temp_text)
	}
	//Mostrar redes hidraulicas
	if keyboard_check(ord("I")){
		temp_text = ""
		for(var a = 0; a < ds_list_size(flujos); a++){
			var flujo = flujos[|a]
			temp_text += $"Tubería {a}:\n"
			if flujo.liquido = -1
				temp_text += "Sin liquidos\n"
			else
				temp_text += $"{liquido_nombre[flujo.liquido]}\n"
			temp_text += $"  Generacion: {flujo.generacion}\n"
			temp_text += $"  Consumo: {flujo.consumo}\n"
			temp_text += $"  Almacenado: {floor(flujo.almacen)}/{flujo.almacen_max}\n"
			temp_text += flujo_text(flujo)
			draw_set_color(make_color_hsv(255 * a / ds_list_size(flujos), 255, 255))
			for(var b = 0; b < ds_list_size(flujo.edificios); b++){
				edificio = flujo.edificios[|b]
				for(var c = 0; c < ds_list_size(edificio.flujo_link); c++){
					var edificio_2 = edificio.flujo_link[|c]
					draw_arrow_off(edificio.x, edificio.y, edificio_2.x, edificio_2.y, 8)
				}
			}
		}
		draw_text_background(0, 0, temp_text)
	}
	//Comandos
	if string_ends_with(keyboard_string, "cheat"){
		keyboard_string = ""
		cheat = not cheat
		build_index = 0
	}
	if keyboard_check_pressed(vk_escape){
		if pausa
			pausa = false
		else
			menu = 0
	}
	if keyboard_check_pressed(ord("G"))
		grafic_tile_animation = not grafic_tile_animation
	if keyboard_check_pressed(ord("H"))
		grafic_luz = not grafic_luz
	if keyboard_check_pressed(ord("J"))
		grafic_humo = not grafic_humo
	if keyboard_check_pressed(ord("K"))
		grafic_pared = not grafic_pared
	if keyboard_check_pressed(ord("F"))
		grafic_hideui = not grafic_hideui
	if keyboard_check_pressed(ord("N"))
		oleadas = not oleadas
	if keyboard_check_pressed(ord("M")){
		sonido = not sonido
		if not sonido for(var a = 0; a < sonidos_max; a++)
			audio_pause_sound(sonido_id[a])
		if sonido for(var a = 0; a < sonidos_max; a++)
			audio_resume_sound(sonido_id[a])
	}
	if keyboard_check_pressed(ord("Y")){
		if enciclopedia = 0
			enciclopedia = 1
		else
			enciclopedia = 0
	}
}
control_camara()
if flow > 0
	draw_path_find()
update_cursor()
if sprite_boton_text != ""{
	if mouse_x + string_width(sprite_boton_text) > room_width{
		draw_set_halign(fa_right)
		draw_text_background(room_width, mouse_y + 20, sprite_boton_text)
		draw_set_halign(fa_left)
	}
	else
		draw_text_background(mouse_x, mouse_y + 20, sprite_boton_text)
}
if sonido
	for(var a = 0; a < sonidos_max; a++){
		if not audio_is_paused(sonido_id[a]) and volumen[a] = 0
			audio_pause_sound(sonido_id[a])
		if audio_is_paused(sonido_id[a]) and volumen[a] > 0
			audio_resume_sound(sonido_id[a])
		audio_sound_gain(sonido_id[a], volumen[a], 0)
	}