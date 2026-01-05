//Menú principal
if menu = 0{
	mina = max(0, floor(camx / zoom / 48))
	minb = max(0, floor(camy / zoom / 14) - 1)
	maxa = min(xsize - 1, ceil((camx + room_width) / zoom / 48))
	maxb = min(ysize - 1, ceil((camy + room_height) / zoom / 14))
	if keyboard_check_pressed(ord("G")){
		var surf = surface_create(32, 28)
		surface_set_target(surf)
		for(var a = 0; a < 64; a++){
			draw_sprite(spr_tuberia_color, 0, 16, 14)
			var sprite = sprite_create_from_surface(surf, 0, 0, 32, 28, true, false, 0, 0)
			sprite_save(sprite, 0, $"tuberia_color{a}.png")
		}
		surface_reset_target()
		surface_free(surf)
	}
	dibujar_fondo(1)
	draw_set_alpha(0.5)
	draw_set_color(c_black)
	draw_rectangle(0, 0, room_width, room_height, false)
	draw_set_alpha(1)
	draw_set_halign(fa_center)
	draw_set_font(ft_titulo)
	draw_set_color(c_white)
	draw_text(room_width / 2, 100, L.menu_hexdustry)
	draw_set_font(ft_letra)
	if os_browser != browser_not_a_browser
		draw_text(room_width / 2, 140, L.menu_html)
	if draw_boton(room_width / 2, 200, L.menu_juego_rapido, ui_boton_verde){
		input_layer = 1
		get_file = 2
	}
	if draw_boton(room_width / 2, 250, L.menu_tutorial, ui_boton_verde){
		var file = cargar_escenario("mision_1.txt")
		if file != ""
			game_start()
		tutorial = 1
		tecnologia = true
		cheat = false
	}
	if draw_boton(room_width / 2, 370, L.menu_editor, ui_boton_verde)
		menu = 2
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
				var xpos = 120 + 120 * (a mod 10), ypos = 200 + 120 * floor(a / 10)
				var temp_text = string_delete(save_files[a], string_pos(".", save_files[a]), 4)
				if draw_sprite_boton(save_files_png[a], xpos, ypos, 96, 96,, 1){
					tecnologia = true
					cargar_escenario(save_files[a])
					game_start()
				}
				if draw_sprite_boton(spr_basura, xpos - 10, ypos - 30,,,, 1){
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
			if draw_boton(120, 120, L.cancelar, ui_boton_rojo,,,, 1) or keyboard_check_pressed(vk_escape){
				keyboard_clear(vk_escape)
				get_file = 2
			}
		}
		//Partida Nueva
		else if get_file = 2{
			var xpos = 140, ypos = 160, des_count = 0
			draw_boton_text_counter = 0
			//Tecnología
			draw_text_xpos(xpos, ypos, $"{L.enciclopedia_tecnologia}: {tecnologia ? L.activado : L.desactivado}")
			xpos += max(string_width($"{L.enciclopedia_tecnologia}: {L.activado}"), string_width($"{L.enciclopedia_tecnologia}: {L.desactivado}"))
			tecnologia = draw_toggle(xpos + 10, ypos - 5, tecnologia, 1)
			ypos += text_y + 10
			if tecnologia{
				xpos = draw_text_xpos(160, ypos, $"{L.menu_precio_tecnologia}")
				tecnologia_precio_multiplicador = draw_deslizante(xpos + 10, xpos + 135, ypos + 10, tecnologia_precio_multiplicador, 0.5, 3, des_count++, 1)
				ypos = 10 + draw_text_ypos(xpos + 145, ypos, $"{floor(100 * tecnologia_precio_multiplicador)}%")
			}
			//Primera oleada
			xpos = draw_text_xpos(140, ypos, $"{L.editor_primera_ronda}")
			oleadas_tiempo_primera = round(draw_deslizante(xpos + 10, xpos + 135, ypos + 10, oleadas_tiempo_primera, 60, 300, des_count++, 1))
			ypos = 10 + draw_text_ypos(xpos + 145, ypos, $"{oleadas_tiempo_primera >= 60 ? string(floor(oleadas_tiempo_primera / 60)) + "m " : ""}{oleadas_tiempo_primera mod 60}s")
			//Siguientes oleadas
			xpos = draw_text_xpos(140, ypos, $"{L.editor_siguiente_ronda}")
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
			ypos += text_y + 10
			//Biomas
			xpos = 200
			if draw_boton(xpos, ypos, L.praderas,,,,, 1)
				generar_mapa(, 1, [[ 0,0,50,5 ],[ 0,4,5,2 ],[ 1,4,1,2 ],[ 1,4,0,2 ],[ 1,2,0,3 ],[ 1,2,1,3 ],[ 0,5,6,1 ],[ 1,5,0,16 ],[ 1,5,1,16 ],[ 0,14,6,1 ],[ 1,14,1,0 ],[ 2,0,6,3 ],[ 2,0,7,3 ],[ 2,16,8,15 ],[ 0,9,50,3 ],[ 1,9,1,0 ],[ 3,0,12,3 ],[ 3,2,10,3 ],[ 3,1,6,3 ],[ 3,3,4,2 ]])
			xpos += text_x + 20
			if draw_boton(xpos, ypos, L.cuevas,,,,, 1)
				generar_mapa(, 0, [ [ 0,17,50,5 ],[ 0,4,5,3 ],[ 1,4,0,2 ],[ 1,2,0,16 ],[ 0,5,5,2 ],[ 1,5,0,16 ],[ 0,14,5,2 ],[ 1,14,0,16 ],[ 2,16,8,15 ],[ 0,9,80,5 ],[ 2,17,16,100 ],[ 2,0,6,3 ],[ 2,0,7,3 ],[ 3,0,12,3 ],[ 3,2,10,3 ],[ 3,1,8,2 ],[ 3,3,5,2 ] ])
			xpos += text_x + 20
			if draw_boton(xpos, ypos, L.desierto,,,,, 1)
				generar_mapa(, 3, [ [ 0,0,50,5 ],[ 0,4,15,2 ],[ 1,4,0,2 ],[ 1,4,3,2 ],[ 1,2,3,1 ],[ 0,11,50,5 ],[ 0,5,10,2 ],[ 1,5,5,16 ],[ 0,14,15,1 ],[ 1,14,14,16 ],[ 2,0,7,3 ],[ 2,0,6,3 ],[ 2,16,8,15 ],[ 3,0,10,3 ],[ 3,2,8,3 ],[ 3,1,8,3 ],[ 3,3,6,2 ] ])
			xpos += text_x + 20
			if draw_boton(xpos, ypos, L.nieve,,,,, 1)
				generar_mapa(, 12, [ [ 0,13,50,5 ],[ 0,0,50,5 ],[ 0,15,10,4 ],[ 1,15,12,0 ],[ 0,9,50,2 ],[ 1,9,9,0 ],[ 0,5,6,1 ],[ 1,5,5,0 ],[ 0,14,6,1 ],[ 1,14,14,16 ],[ 2,0,6,3 ],[ 2,0,7,3 ],[ 2,16,8,15 ],[ 3,0,12,3 ],[ 3,2,10,3 ],[ 3,1,8,3 ],[ 3,3,6,2 ] ])
			xpos += text_x + 20
			if draw_boton(xpos, ypos, L.islas,,,,, 1){
				do{
					randomize()
					generar_mapa(, 19, [ [ 0,1,50,5 ],[ 1,1,19,3 ],[ 1,3,19,18 ],[ 0,0,3,8 ],[ 1,0,19,2 ],[ 2,0,6,8 ],[ 2,0,7,8 ],[ 3,0,10,3 ],[ 3,2,8,3 ],[ 3,1,6,3 ],[ 3,3,6,2 ] ])
				}
				until terreno_caminable[terreno[# nucleo.a, nucleo.b]]
			}
			ypos += text_y + 10
			//Modos de Juego
			xpos = 200
			if draw_boton(xpos, ypos, L.menu_modo_infinito, flow = 0 ? ui_boton_azul : ui_boton_gris,,,, 1){
				mision_objetivo = []
				flow = 0
			}
			xpos += text_x + 20
			if draw_boton(xpos, ypos, L.menu_modo_oleadas, flow = 1 ? ui_boton_azul : ui_boton_gris,,,, 1){
				mision_objetivo = [4]
				mision_nombre = [""]
				mision_target_num = [20]
				mision_tiempo = [0]
				mision_switch_oleadas = [false]
				mision_camara_move = [false]
				mision_texto = [[]]
				flow = 1
			}
			xpos += text_x + 20
			if draw_boton(xpos, ypos, L.menu_modo_misiones, flow = 2 ? ui_boton_azul : ui_boton_gris,,,, 1){
				modo_misiones = true
				add_mision()
				flow = 2
			}
			if flow = 1{
				ypos += text_y + 10
				xpos = draw_text_xpos(160, ypos, L.menu_numero_oleadas)
				mision_target_num[0] = round(draw_deslizante(xpos + 10, xpos + 135, ypos + 10, mision_target_num[0], 10, 50, des_count++, 1))
				ypos = 10 + draw_text_ypos(xpos + 145, ypos, mision_target_num[0])
			}
			draw_set_halign(fa_center)
			if draw_boton(room_width / 2, room_height - 200, L.menu_cargar_escenario, ui_boton_azul,,,, 1){
				if not nucleo.vivo
					game_restart()
				get_file = 1
				input_layer = 1
				scan_files_save()
			}
			if draw_boton(room_width / 2, room_height - 150, L.menu_juego_rapido, ui_boton_verde,,,, 1)
				game_start()
			draw_set_halign(fa_left)
			if draw_boton(120, 120, L.cancelar, ui_boton_rojo,,,, 1) or keyboard_check_pressed(vk_escape){
				keyboard_clear(vk_escape)
				get_file = 0
				input_layer = 0
			}
		}
	}
	draw_set_valign(fa_bottom)
	draw_text(10, room_height - 10, "Tomás Ramdohr")
	draw_set_valign(fa_top)
	update_cursor()
	if keyboard_check_pressed(vk_escape)
		game_end()
	if os_type == os_windows
		for(var a = 0; a < array_length(idiomas); a++)
			if draw_sprite_boton(spr_bandera, 20 + 80 * a, 20, 64, 48,,, a){
				idioma = a
				set_idioma(idiomas[a])
			}
	if keyboard_check_pressed(vk_f4){
		keyboard_clear(vk_f4)
		window_set_fullscreen(not window_get_fullscreen())
	}
	exit
}
//Editor
if menu = 2{
	mina = max(0, floor(camx / zoom / 48))
	minb = max(0, floor(camy / zoom / 14) - 1)
	maxa = min(xsize - 1, ceil(1 + (camx + room_width) / zoom / 48))
	maxb = min(ysize - 1, ceil(1 + (camy + room_height) / zoom / 14))
	dibujar_fondo(1)
	dibujar_edificios()
	var xmouse = (mouse_x + camx) / zoom, ymouse = (mouse_y + camy) / zoom
	var temp_hexagono = instance_position(xmouse, ymouse, obj_hexagono), mx = 0, my = 0
	//Editor de objetivos
	if editor_menu = 1 and not mision_choosing_coord{
		draw_boton_text_counter = 0
		draw_set_color(c_ltgray)
		draw_rectangle(100, 100, room_width - 100, room_height - 100, false)
		draw_set_color(c_black)
		draw_rectangle(100, 100, room_width - 100, room_height - 100, true)
		var xpos = 110
		if draw_boton(110, 110, L.volver, ui_boton_rojo) or keyboard_check_pressed(vk_escape){
			keyboard_clear(vk_escape)
			mision_actual = -1
			get_keyboard_string = -1
			editor_menu = 0
		}
		xpos += text_x + 20
		if draw_boton(xpos, 110, L.editor_configuracion){
			mision_actual = -1
			get_keyboard_string = -1
		}
		xpos += text_x + 20
		if draw_boton(xpos, 110, L.editor_edificios_disponibles){
			mision_actual = -2
			get_keyboard_string = -1
		}
		var size = array_length(mision_nombre), pos = 150
		if size > 15
			deslizante[0] = floor(draw_deslizante_vertical(120, pos, pos + 15 * 30, deslizante[0], 0, size - 15, 0))
		for(var i = deslizante[0]; i < min(deslizante[0] + 15, size); i++){
			if i > 0 and draw_sprite_boton(spr_flecha, 140, pos){
				var	temp_string = mision_nombre[i - 1]
				mision_nombre[i - 1] = mision_nombre[i]
				mision_nombre[i] = temp_string
				var	temp_real = mision_objetivo[i - 1]
				mision_objetivo[i - 1] = mision_objetivo[i]
				mision_objetivo[i] = temp_real
				temp_real = mision_target_id[i - 1]
				mision_target_id[i - 1] = mision_target_id[i]
				mision_target_id[i] = temp_real
				temp_real = mision_target_num[i - 1]
				mision_target_num[i - 1] = mision_target_num[i]
				mision_target_num[i] = temp_real
				temp_real = mision_tiempo[i - 1]
				mision_tiempo[i - 1] = mision_tiempo[i]
				mision_tiempo[i] = temp_real
				var temp_bool = mision_tiempo_edit[i - 1]
				mision_tiempo_edit[i - 1] = mision_tiempo_edit[i]
				mision_tiempo_edit[i] = temp_real
				temp_real = mision_tiempo_victoria[i - 1]
				mision_tiempo_victoria[i - 1] = mision_tiempo_victoria[i]
				mision_tiempo_victoria[i] = temp_real
				temp_real = mision_tiempo_show[i - 1]
				mision_tiempo_show[i - 1] = mision_tiempo_show[i]
				mision_tiempo_show[i] = temp_real
				temp_bool = mision_camara_move[i - 1]
				mision_camara_move[i - 1] = mision_camara_move[i]
				mision_camara_move[i] = temp_bool
				temp_real = mision_camara_x[i - 1]
				mision_camara_x[i - 1] = mision_camara_x[i]
				mision_camara_x[i] = temp_real
				temp_real = mision_camara_y[i - 1]
				mision_camara_y[i - 1] = mision_camara_y[i]
				mision_camara_y[i] = temp_real
				var temp_array = mision_texto[i - 1]
				mision_texto[i - 1] = mision_texto[i]
				mision_texto[i] = temp_array
				temp_bool = mision_switch_oleadas[i - 1]
				mision_switch_oleadas[i - 1] = mision_switch_oleadas[i]
				mision_switch_oleadas[i] = temp_bool
			}
			if draw_boton(160, pos, $"'{mision_nombre[i]}'")
				mision_actual = i
			pos += 30
		}
		if deslizante[0] + 15 < size and mouse_wheel_down()
			deslizante[0]++
		if deslizante[0] > 0 and mouse_wheel_up()
			deslizante[0]--
		if draw_boton(140, 600, L.editor_nuevo_objetivo, ui_boton_verde){
			array_push(mision_nombre, $"{L.editor_objetivo} {size}")
			array_push(mision_objetivo, 0)
			array_push(mision_target_id, 0)
			array_push(mision_target_num, 0)
			array_push(mision_tiempo, 0)
			array_push(mision_tiempo_edit, false)
			array_push(mision_tiempo_victoria, 0)
			array_push(mision_tiempo_show, 1)
			array_push(mision_camara_move, 0)
			array_push(mision_camara_x, 0)
			array_push(mision_camara_y, 0)
			array_push(mision_texto, array_create(0, {texto : "", x : 0, y : 0}))
			array_push(mision_switch_oleadas, false)
			mision_actual = size
			if save_file != ""
				save_escenario(save_file + ".txt")
		}
		draw_set_color(c_ltgray)
		draw_rectangle(room_width / 2, 110, room_width - 110, room_height - 110, false)
		draw_set_color(c_black)
		draw_rectangle(room_width / 2, 110, room_width - 110, room_height - 110, true)
		//Editar Objetivo
		if mision_actual >= 0{
			var i = mision_actual, ypos = 120, a
			xpos = draw_text_xpos(room_width / 2 + 20, ypos, L.editor_nuevo_objetivo + ": ")
			mision_nombre[i] = draw_boton_text(xpos, ypos, mision_nombre[i], false)
			xpos = room_width / 2 + 40
			ypos = 150
			xpos = draw_text_xpos(xpos, ypos, $"{L.editor_objetivo}: ")
			//Objetivo
			var prev_objetivo = mision_objetivo[i]
			mision_objetivo[i] = draw_boton_text_list(xpos, ypos, mision_objetivo[i], objetivos_nombre)
			if mision_objetivo[i] != prev_objetivo{
				mision_target_id[i] = 0
				mision_target_num[i] = 0
			}
			xpos += text_x
			//Cantidad
			if not in(mision_objetivo[i], 5, 7){
				xpos = draw_text_xpos(xpos, ypos, " ")
				mision_target_num[i] = draw_boton_text(xpos, ypos, mision_target_num[i], true)
				xpos += text_x
			}
			//Conseguir recurso / Tener almacenado
			if mision_objetivo[i] < 2{
				xpos = draw_text_xpos(xpos, ypos, $" {L.editor_de} ")
				mision_target_id[i] = draw_boton_text_list(xpos, ypos, mision_target_id[i], recurso_nombre,, 10)
			}
			//Construir / Tener construido
			else if in(mision_objetivo[i], 2, 3, 7){
				xpos = draw_text_xpos(xpos, ypos, " ")
				mision_target_id[i] = draw_boton_text_list(xpos, ypos, mision_target_id[i], edificio_nombre,, 10)
			}
			//Matar enemigos
			else if mision_objetivo[i] = 4
				draw_text(xpos, ypos, $" {L.editor_enemigos}")
			xpos = room_width / 2 + 40
			ypos = 180
			if draw_boton(xpos, ypos, mision_tiempo_edit[i] ? L.editor_deshabilitar : L.editor_habilitar){
				if mision_tiempo[i] > 0
					mision_tiempo[i] = 0
				else
					mision_tiempo[i] = 1
				mision_tiempo_edit[i] = not mision_tiempo_edit[i]
			}
			if mision_tiempo_edit[i]{
				xpos = room_width / 2 + 70
				ypos += 30
				xpos = draw_text_xpos(xpos, ypos, $"{L.editor_luego_de} ")
				mision_tiempo[i] = draw_boton_text(xpos, ypos, mision_tiempo[i])
				xpos = 20 + draw_text_xpos(xpos + text_x, ypos, "s")
				if draw_boton(xpos, ypos, mision_tiempo_victoria[i] ? L.win_victoria : L.win_derrota)
					mision_tiempo_victoria[i] = not mision_tiempo_victoria[i]
				if draw_boton(xpos + text_x + 20, ypos, mision_tiempo_show[i] ? L.editor_mostrar : L.editor_ocultar)
					mision_tiempo_show[i] = not mision_tiempo_show[i]
			}
			ypos += 40
			for(var b = 0; b < array_length(mision_texto[i]); b++){
				var texto = mision_texto[i, b]
				xpos = room_width / 2 + 80
				xpos = draw_text_xpos(xpos, ypos, $"{L.procesador_write} ")
				if draw_boton(xpos, ypos, $"'{text_wrap(texto.texto, 250)}'",,, mb_any, false){
					if mouse_lastbutton = mb_left{
						editor_list = false
						get_keyboard_string = 100 + b
						keyboard_string = texto.texto
					}
					else{
						array_delete(mision_texto[i], b--, 1)
						continue
					}
				}
				a = text_y
				if get_keyboard_string = 100 + b{
					draw_line(xpos, ypos + 20, xpos + text_x, ypos + 20)
					texto.texto = keyboard_string
					exit_keyboard_input()
				}
				xpos = draw_text_xpos(xpos + text_x, ypos, $" {L.editor_on} ")
				texto.x = draw_boton_text(xpos, ypos, texto.x)
				xpos = draw_text_xpos(xpos + text_x, ypos, ", ")
				texto.y = draw_boton_text(xpos, ypos, texto.y)
				ypos += a
			}
			ypos += 10
			if draw_boton(room_width / 2 + 40, ypos, L.editor_add_text, ui_boton_azul){
				mision_choosing_coord = true
				mision_choosing_coord_i = i
				mision_choosing_coord_tipo = 0
			}
			ypos += text_y + 10
			if draw_boton(room_width / 2 + 40, ypos, (mision_switch_oleadas[i] ? "" : L.editor_no + " ") + L.editor_cambiar_oleadas)
				mision_switch_oleadas[i] = not mision_switch_oleadas[i]
			ypos += text_y + 10
			if draw_boton(room_width / 2  + 40, ypos, (mision_camara_move[i] ? "" : L.editor_no + " ") + L.editor_mover_camara){
				mision_camara_move[i] = not mision_camara_move[i]
				if mision_camara_move[i]{
					mision_choosing_coord = true
					mision_choosing_coord_i = i
					mision_choosing_coord_tipo = 1
				}
			}
			ypos += text_y + 10
			if mision_camara_move[i]{
				xpos = room_width / 2 + 80
				xpos = draw_text_xpos(xpos, ypos, $"{L.editor_mover_a} ")
				mision_camara_x[i] = draw_boton_text(xpos, ypos, mision_camara_x[i])
				xpos = draw_text_xpos(xpos+ text_x, ypos, ", ")
				mision_camara_y[i] = draw_boton_text(xpos, ypos, mision_camara_y[i])
			}
			if draw_boton(room_width / 2 + 10, room_height - 140, L.editor_eliminar_objetivo, ui_boton_rojo){
				array_delete(mision_nombre, i, 1)
				array_delete(mision_objetivo, i, 1)
				array_delete(mision_target_id, i, 1)
				array_delete(mision_target_num, i, 1)
				array_delete(mision_tiempo, i, 1)
				array_delete(mision_tiempo_victoria, i, 1)
				array_delete(mision_tiempo_show, i, 1)
				array_delete(mision_texto, i, 1)
				mision_actual = -1
				deslizante[0] = 0
			}
		}
		//Opciones generales
		else if mision_actual = -1{
			var ypos = 120
			if draw_boton(room_width / 2 + 20, 120, oleadas ? L.editor_desactivar_oleadas : L.editor_activar_oleadas)
				oleadas = not oleadas
			ypos += 40
			if oleadas{
				xpos = room_width / 2 + 40
				xpos = draw_text_xpos(xpos, ypos, $"{L.editor_primera_ronda}: ")
				oleadas_tiempo_primera = draw_boton_text(xpos, ypos, oleadas_tiempo_primera)
				xpos = room_width / 2 + 40
				ypos += text_y
				xpos = draw_text_xpos(xpos, ypos, $"{L.editor_siguiente_ronda}: ")
				oleadas_tiempo = draw_boton_text(xpos, ypos, oleadas_tiempo)
			}
			if array_length(mision_nombre) > 0{
				xpos = room_width / 2 + 40
				ypos += 20
				xpos = draw_text_xpos(xpos, ypos, $"{L.editor_texto_victoria}: ")
				mision_texto_victoria = draw_boton_text(xpos, ypos, mision_texto_victoria, false)
			}
			xpos = room_width / 2 + 40
			ypos += 20
			xpos = draw_text_xpos(xpos, ypos, $"{L.editor_multiplicador_vida}: ")
			multiplicador_vida_enemigos = draw_boton_text(xpos, ypos, multiplicador_vida_enemigos)
			draw_text_xpos(xpos + text_x, ypos, "%")
			ypos += 20
			ypos = draw_text_ypos(room_width / 2 + 20, ypos, L.editor_carga_inicial)
			xpos = room_width / 2 + 40
			var width = 0, ypos_2 = ypos
			for(var a = 0; a < rss_max; a++){
				ypos_2 = draw_text_ypos(xpos, ypos_2, recurso_nombre_display[rss_sort[a]])
				width = max(width, string_width(recurso_nombre_display[rss_sort[a]]))
			}
			xpos = room_width / 2 + 60 + width
			ypos_2 = ypos
			for(var a = 0; a < rss_max; a++){
				carga_inicial[rss_sort[a]] = draw_boton_text(xpos, ypos_2, carga_inicial[rss_sort[a]])
				ypos_2 += text_y
			}
		}
		//Editar edificios iniciales
		else if mision_actual = -2{
			xpos = room_width / 2 + 40
			var ypos = 140
			var b = 0
			for(var a = 0; a < edificio_max; a++)
				if edificio_construible[a]{
					if mision_edificios[a]
						draw_set_color(c_green)
					else
						draw_set_color(c_red)
					draw_circle(xpos, ypos, 18, false)
					draw_set_color(c_black)
					draw_circle(xpos, ypos, 18, true)
					if draw_sprite_boton(edificio_sprite[a], xpos - 15, ypos - 15)
						mision_edificios[a] = not mision_edificios[a]
					ypos += 40
					if (++b mod 12) = 0{
						ypos = 140
						xpos += 60
					}
				}
		}
		draw_boton_text_list_end()
		update_cursor()
		exit
	}
	//Editar Mapa
	else if editor_menu = 2{
		draw_set_color(c_ltgray)
		draw_rectangle(100, 100, room_width - 100, room_height - 100, false)
		draw_set_color(c_black)
		draw_rectangle(100, 100, room_width - 100, room_height - 100, true)
		if draw_boton(110, 110, L.volver, ui_boton_rojo) or keyboard_check_pressed(vk_escape){
			keyboard_clear(vk_escape)
			mision_actual = -1
			get_keyboard_string = -1
			editor_menu = 0
		}
		if draw_boton(110, 180, L.editor_generar_terreno, ui_boton_azul){
			//show_debug_message(editor_instrucciones)
			generar_mapa(editor_seed, editor_fondo, editor_instrucciones)
		}
		draw_set_color(c_dkgray)
		var xpos = 120, ypos = 220
		draw_boton_text_counter = 0
		xpos = draw_text_xpos(xpos, ypos, $"{L.editor_seed}: ")
		editor_seed = draw_boton_text(xpos, ypos, editor_seed)
		xpos = 120
		ypos += text_y
		xpos = draw_text_xpos(xpos, ypos, $"{L.editor_terreno_base}: ")
		editor_fondo = draw_boton_text_list(xpos, ypos, editor_fondo, terreno_nombre,, 10)
		ypos += text_y
		var ore_names = [], size = array_length(editor_instrucciones)
		for(var j = 0; j < ore_max; j++)
			array_push(ore_names, recurso_nombre_display[ore_recurso[j]])
		if size > 18
			deslizante[0] = floor(draw_deslizante_vertical(110, ypos, ypos + 20 * 18, deslizante[0], 0, size - 18, 0))
		for(var i = deslizante[0]; i < min(deslizante[0] + 18, size); i++){
			var instruccion = editor_instrucciones[i], tipo = instruccion[0], dat1 = instruccion[1], dat2 = instruccion[2], dat3 = instruccion[3]
			xpos = 140
			if draw_sprite_boton(spr_basura, xpos, ypos, 20, 20){
				array_delete(editor_instrucciones, i, 1)
				size--
				i--
				continue
			}
			xpos += 20
			if draw_sprite_boton(spr_flecha, xpos, ypos, 20, 20)
				procesador_move = i
			if procesador_move >= 0 and mouse_y > ypos and mouse_y < ypos + text_y{
				draw_set_alpha(0.3)
				draw_rectangle(140, ypos, xpos + text_x, ypos + text_y, false)
				draw_set_alpha(1)
				if mouse_check_button_released(mb_left) and i != procesador_move{
					array_insert(editor_instrucciones, i, editor_instrucciones[procesador_move])
					array_delete(editor_instrucciones, procesador_move + 1, 1)
					procesador_move = -1
					continue
				}
			}
			xpos += 20
			//Bloques de Terreno
			if tipo = 0{
				xpos = draw_text_xpos(xpos, ypos, $"{L.editor_add} ")
				instruccion[1] = draw_boton_text_list(xpos, ypos, dat1, terreno_nombre,, 10)
				xpos += text_x
				xpos = draw_text_xpos(xpos, ypos, $" {L.editor_size} ")
				instruccion[2] = draw_boton_text(xpos, ypos, dat2)
				xpos += text_x
				xpos = draw_text_xpos(xpos, ypos, ", ")
				instruccion[3] = draw_boton_text(xpos, ypos, dat3)
				xpos += text_x
				xpos = draw_text_xpos(xpos, ypos, $" {L.editor_veces}")
			}
			//Bordes de Terreno
			else if tipo = 1{
				var temp_text
				xpos = draw_text_xpos(xpos, ypos, $"{L.editor_al_rededor} ")
				instruccion[1] = draw_boton_text_list(xpos, ypos, dat1, terreno_nombre_display,, 10)
				xpos += text_x
				xpos = draw_text_xpos(xpos, ypos, $" {L.editor_reemplazar} ")
				if dat1 = dat2{
					temp_text = terreno_nombre[dat1]
					terreno_nombre[dat1] = L.editor_cualquiera
				}
				instruccion[2] = draw_boton_text_list(xpos, ypos, dat2, terreno_nombre_display,, 10)
				if dat1 = dat2
					terreno_nombre[dat1] = temp_text
				xpos += text_x
				xpos = draw_text_xpos(xpos, ypos, $" {L.editor_con} ")
				instruccion[3] = draw_boton_text_list(xpos, ypos, dat3, terreno_nombre_display,, 10)
			}
			//Ruido Aleatorio
			else if tipo = 2{
				xpos = draw_text_xpos(xpos, ypos, $"{L.editor_Reemplazar} ")
				instruccion[1] = draw_boton_text_list(xpos, ypos, dat1, terreno_nombre,, 10)
				xpos += text_x
				xpos = draw_text_xpos(xpos, ypos, $" {L.editor_con} ")
				instruccion[2] = draw_boton_text_list(xpos, ypos, dat2, terreno_nombre,, 10)
				xpos += text_x
				xpos = draw_text_xpos(xpos, ypos, $" {L.editor_el} ")
				instruccion[3] = draw_boton_text(xpos, ypos, dat3)
				xpos += text_x
				xpos = draw_text_xpos(xpos, ypos, $"% {L.editor_del_tiempo}")
			}
			//Menas de Recursos
			else if tipo = 3{
				xpos = draw_text_xpos(xpos, ypos, $"{L.editor_add} ")
				instruccion[1] = draw_boton_text_list(xpos, ypos, dat1, ore_names,, 10)
				xpos += text_x
				xpos = draw_text_xpos(xpos, ypos, $" {L.editor_size} ")
				instruccion[2] = draw_boton_text(xpos, ypos, dat2)
				xpos += text_x
				xpos = draw_text_xpos(xpos, ypos, ", ")
				instruccion[3] = draw_boton_text(xpos, ypos, dat3)
				xpos += text_x
				xpos = draw_text_xpos(xpos, ypos, $" {L.editor_veces}")
			}
			ypos += text_y
		}
		if deslizante[0] + 18 < size and mouse_wheel_down()
			deslizante[0]++
		if deslizante[0] > 0 and mouse_wheel_up()
			deslizante[0]--
		xpos = 120
		ypos += text_y
		xpos = draw_text_xpos(xpos, ypos, $"{L.editor_add} ")
		var a = draw_boton_text_list(xpos, ypos, 0, ["...", L.editor_manchas, L.editor_borde, L.editor_ruido, L.editor_menas])
		if a > 0{
			var temp_array_array = [[a - 1, 0, 50, 5], [a - 1, 4, 0, 2], [a - 1, 0, 6, 3], [a - 1, 0, 10, 3]]
			array_push(editor_instrucciones, temp_array_array[a - 1])
			a = 0
		}
		draw_set_color(c_black)
		xpos = room_width / 2 + 20
		ypos = 120
		draw_text(xpos, ypos, L.editor_size_map)
		xpos += 20
		ypos += text_y
		var prev_xsize = xsize
		xsize = round(draw_deslizante(xpos, xpos + 100, ypos + 10, xsize, 28, 96, 0))
		chunk_xsize = ceil(xsize / chunk_width)
		draw_text(xpos + 100, ypos, $"{xsize}")
		if xsize > prev_xsize
			resize_grid(prev_xsize, 0)
		ypos += text_y
		var prev_ysize = ysize
		ysize = round(draw_deslizante(xpos, xpos + 100, ypos + 10, ysize, 60, 192, 1))
		chunk_ysize = ceil(ysize / chunk_height)
		draw_text(xpos + 100, ypos, $"{ysize}")
		if ysize > prev_ysize
			resize_grid(0, prev_ysize)
		draw_boton_text_list_end()
		update_cursor()
		if keyboard_check_pressed(ord("F"))
			editor_instrucciones = [ [ 0,0,50,5 ],[ 0,4,15,2 ],[ 1,4,0,2 ],[ 1,4,3,2 ],[ 1,2,3,1 ],[ 0,11,50,5 ],[ 0,5,10,3 ],[ 1,5,3,16 ],[ 1,5,1,16 ],[ 1,5,11,16 ],[ 1,5,2,16 ],[ 1,5,4,16 ],[ 1,5,0,16 ],[ 0,14,15,1 ],[ 1,14,2,16 ],[ 1,14,3,16 ],[ 2,0,7,3 ],[ 2,0,6,3 ],[ 2,16,8,15 ] ]
		exit
	}
	//click en mapa
	if mouse_x > 200 and temp_hexagono != noone{
		mx = temp_hexagono.a
		my = temp_hexagono.b
		if mision_choosing_coord{
			draw_set_halign(fa_center)
			draw_text((room_width + 200) / 2, 100, $"{L.editor_clic} {mision_choosing_coord_tipo = 0 ? L.editor_add_text : L.editor_mover_camara}")
			draw_set_halign(fa_left)
			if mouse_check_button_pressed(mb_left){
				var temp_complex = abtoxy(mx, my)
				if mision_choosing_coord_tipo = 0
					array_push(mision_texto[mision_choosing_coord_i], {x : temp_complex.a, y : temp_complex.b, texto : ""})
				else if mision_choosing_coord_tipo = 1{
					mision_camara_x[mision_choosing_coord_i] = temp_complex.a
					mision_camara_y[mision_choosing_coord_i] = temp_complex.b
				}
				mision_choosing_coord = false
			}
			if mouse_check_button_pressed(mb_right)
				mision_choosing_coord = false
		}
		//Barril de Pintura
		if keyboard_check(vk_lcontrol) and editor_herramienta = 0 and build_index < terreno_max{
			if mouse_check_button_pressed(mb_left)
				//Aplicar cambio
				if mx = last_mx and my = last_my{
					last_mx = -1
					last_my = -1
					for(var i = ds_list_size(build_list) - 1; i >= 0; i--){
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
				for(var i = ds_list_size(build_list) - 1; i >= 0; i--){
					var temp_complex = build_list[|i], a = temp_complex.a, b = temp_complex.b
					var temp_complex_2 = abtoxy(a, b), aa = temp_complex_2.a, bb = temp_complex_2.b
					draw_sprite_off(temp_sprite, 0, aa, bb,,,,, 0.5)
				}
				draw_text_background(mouse_x, mouse_y + 20, L.editor_clic_aplicar)
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
				for(var i = ds_list_size(temp_list) - 1; i >= 0; i--){
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
							if mouse_check_button_pressed(mb_left) and ore[# a, b] = build_index - offset{
								ds_grid_add(ore_amount, a, b, floor(random_range(0.3, 1) * ore_size[build_index - offset]))
								update_background(a, b)
							}
							else if mouse_check_button(mb_left) and ore[# a, b] != build_index - offset and terreno_caminable[terreno[# a, b]]{
								ds_grid_set(ore, a, b, build_index - offset)
								ds_grid_set(ore_amount, a, b, floor(random_range(0.3, 1) * ore_size[build_index - offset]))
								update_background(a, b)
							}
						}
					}
				}
			}
			//Ver información
			else if editor_herramienta = 4{
				var temp_text = terreno_nombre_display[terreno[# mx, my]]
				if ore[# mx, my] >= 0
					temp_text += $"\n{recurso_nombre_display[ore_recurso[ore[# mx, my]]]}: {ore_amount[# mx, my]}"
				if edificio_bool[# mx, my]
					temp_text += $"\n{edificio_nombre_display[edificio_id[# mx, my].index]}"
				draw_text_background(200, 0, temp_text)
			}
		}
		//Borrar edificio
		if mouse_check_button_pressed(mb_right) and edificio_bool[# mx, my] and not edificio_id[# mx, my].index = id_nucleo{
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
		if draw_sprite_boton(terreno_sprite[a], 10 + (a mod 5) * 36, 10 + floor(a / 5) * 36,,, terreno_nombre_display[a]){
			build_index = a
			editor_herramienta = 0
		}
	b += terreno_max
	for(var a = 0; a < ore_max; a++)
		if draw_sprite_boton(ore_sprite[a], 10 + ((a + b) mod 5) * 36, 10 + floor((a + b) / 5) * 36,,, recurso_nombre_display[ore_recurso[a]]){
			build_index = a + b
			editor_herramienta = 0
		}
	b += ore_max
	if draw_sprite_boton(spr_equis, 10 + (b mod 5) * 36, 10 + floor(b / 5) * 36,,, L.editor_eliminar_mena){
		build_index = -1
		editor_herramienta = 3
	}
	b++
	if draw_sprite_boton(spr_base, 10 + (b mod 5) * 36, 10 + floor(b / 5) * 36,,, L.editor_cambiar_base){
		build_index = -1
		editor_herramienta = 2
	}
	b++
	if draw_sprite_boton(spr_arana, 10 + (b mod 5) * 36, 10 + floor(b / 5) * 36,,, L.editor_cambiar_zona){
		build_index = -1
		editor_herramienta = 1
	}
	b++
	if draw_sprite_boton(spr_info, 10 + (b mod 5) * 36, 10 + floor(b / 5) * 36,,, L.editor_info){
		build_index = -1
		editor_herramienta = 4
	}
	b++
	if sprite_boton_text != ""
		draw_text_background(mouse_x + 20, mouse_y, sprite_boton_text)
	if draw_boton(10, room_height - 390, L.editor_objetivos, ui_boton_azul){
		editor_menu = 1
		exit
	}
	if draw_boton(10, room_height - 340, L.editor_editar_mapa, ui_boton_azul){
		editor_menu = 2
		exit
	}
	build_size = round(draw_deslizante(50, 150, room_height - 200, build_size, 1, 5, 2))
	if draw_boton(10, room_height - 100, L.editor_guardar, ui_boton_azul) or (keyboard_check(vk_lcontrol) and keyboard_check_pressed(ord("S"))){
		get_file = 2
		input_layer = 1
		scan_files_save()
		keyboard_clear(ord("S"))
	}
	if draw_boton(10, room_height - 60, L.editor_cargar, ui_boton_azul) or (keyboard_check(vk_lcontrol) and keyboard_check_pressed(ord("A"))){
		get_file = 1
		input_layer = 1
		scan_files_save()
		keyboard_clear(ord("A"))
	}
	if get_file > 0{
		draw_set_color(c_dkgray)
		draw_rectangle(100, 100, room_width - 100, room_height - 100, false)
		draw_set_color(c_white)
		//Cargar
		if get_file = 1{
			draw_set_valign(fa_bottom)
			for(var a = 0; a < array_length(save_files); a++){
				var xpos = 120 + 120 * (a mod 10), ypos = 200 + 120 * floor(a / 10)
				var temp_text = string_delete(save_files[a], string_pos(".", save_files[a]), 4)
				if draw_sprite_boton(save_files_png[a], xpos, ypos, 96, 96,, 1){
					input_layer = 0
					get_file = 0
					save_file = cargar_escenario(save_files[a])
					if string_pos(".", save_file) > 0
						save_file = string_delete(save_file, string_pos(".", save_file), 4)
				}
				if draw_sprite_boton(spr_basura, xpos - 10, ypos - 30,,,, 1){
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
		}
		//Guardar
		else if get_file = 2{
			draw_boton_text_counter = 0
			var flag = false
			for(var a = 0; a < array_length(save_files); a++)
				if draw_boton(140, 160 + 30 * a, save_files[a],,,,, 1){
					save_file = save_files[a]
					flag = true
				}
			if not flag{
				save_file = string(draw_boton_text(140, 160 + 30 * (array_length(save_files) + 1), save_file, false,,, 1))
				draw_text(140 + text_x, 160 + 30 * (array_length(save_files) + 1), ".txt")
				input_layer = 1
				if save_file != "" and (draw_boton(120, 160 + 30 * array_length(save_files), L.nuevo_archivo,,,,, 1) or keyboard_check_pressed(vk_enter)){
					keyboard_clear(vk_enter)
					save_file += ".txt"
					flag = true
				}
			}
			if flag
				save_escenario(save_file)
		}
		if draw_boton(120, 120, L.cancelar, ui_boton_rojo,,,, 1) or keyboard_check_pressed(vk_escape){
			keyboard_clear(vk_escape)
			input_layer = 0
			get_file = 0
		}
	}
	if draw_boton(10, room_height - 140, L.volver, ui_boton_rojo) or keyboard_check_pressed(vk_escape){
		menu = 0
		redo_pathfind()
	}
	control_camara(-200)
	update_cursor()
	exit
}
#region Dibujo
	mina = max(0, floor(camx / zoom / 48))
	minb = max(0, floor(camy / zoom / 14) - 1)
	maxa = min(xsize - 1, ceil(1 + (camx + room_width) / zoom / 48))
	maxb = min(ysize - 1, ceil(1 + (camy + room_height) / zoom / 14))
	dibujar_fondo()
	if grafic_tile_animation
		dibujar_fondo(2)
	dibujar_edificios()
	for(var a = mina; a < maxa; a++)
		for(var b = minb; b < maxb; b++)
			if edificio_draw[# a, b]{
				var edificio = edificio_id[# a, b], index = edificio.index, aa = edificio.x, bb = edificio.y, aaa = aa * zoom - camx, bbb = bb * zoom - camy
				//Recursos sobre caminos
				if (edificio_camino[index] or in(index, 6, 16)) and edificio.carga_total > 0{
					var proceso = edificio_proceso[index]
					var c = 1.2 * (max(edificio.proceso, edificio.waiting * proceso) - proceso / 2) * 20 / proceso
					draw_sprite_off(recurso_sprite[edificio.carga_id], 0, aa + c * edificio.array_real[0], bb + c * edificio.array_real[1])
				}
				//Munición armas
				else if edificio_armas[index] and not in(index, id_laser, id_torre_reparadora, id_onda_de_choque) and edificio.carga_total = 0
					draw_sprite_off(spr_no_ammo, 0, aa, bb - 28)
				//Dibujo de los links eléctricos
				else if edificio_energia[index]{
					draw_set_color(c_yellow)
					for(var c = array_length(edificio.energia_link) - 1; c >= 0; c--){
						var edificio_2 = edificio.energia_link[c]
						draw_line_off(aa, bb, edificio_2.x, edificio_2.y)
					}
					if edificio.red.generacion = 0 and edificio.red.bateria = 0 and edificio.energia_consumo_max > 0
						draw_sprite_off(spr_no_ammo, 1, aa, bb - 28)
				}
				//Receta planta química
				if index = id_planta_quimica and edificio.select >= 0
					draw_sprite_off(planta_quimica_sprite[edificio.select], 0, aa, bb)
				//Humo
				if grafic_humo and pausa = 0 and enciclopedia = 0 and ((image_index mod 5) = 0) and ((in(index, id_generador, id_turbina, id_planta_nuclear) and edificio.fuel > 0) or (index = id_generador_geotermico and edificio.flujo.liquido = 0) or (index = id_refineria_de_petroleo and edificio.flujo.liquido = 2)){
					var dir = direccion_viento + random_range(-pi / 4, pi / 4)
					array_push(humos, add_humo(aa, bb, a, b, cos(dir), sin(dir), irandom_range(70, 100)))
				}
				//Mensajes
				if index = id_mensaje{
					draw_set_halign(fa_center)
					draw_text_background(aaa, bbb + 20, edificio.variables[0])
					draw_set_halign(fa_left)
				}
				//Planta de Reciclaje
				else if index = id_planta_de_reciclaje and edificio.select >= 0
					draw_sprite_off(dron_sprite[edificio.select], 0, aa, bb,,,,, 0.5)
				draw_vida(aaa, bbb, edificio.vida, edificio_vida[index])
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
	if flow = 5
		for(var a = 0; a < ds_grid_width(chunk_enemigos); a++)
			for(var b = 0; b < ds_grid_height(chunk_enemigos); b++){
				var temp_complex = abtoxy(a * chunk_width, b * chunk_height)
				draw_text_off(temp_complex.a, temp_complex.b, array_length(chunk_enemigos[# a, b]))
			}
	if energia_solar < 1{
		var luz_alpha = (1 - energia_solar) / 3
		if grafic_luz{
			for(var a = mina; a <= maxa; a++)
				for(var b = minb; b <= maxb; b++){
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
	draw_set_halign(fa_center)
	var temp_text = ""
	for(var a = 0; a < rss_max; a++)
		if nucleo.carga[rss_sort[a]] > 0
			temp_text += $"{recurso_nombre_display[rss_sort[a]]} {nucleo.carga[rss_sort[a]]}\n"
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
				if draw_boton(140, pos, recurso_nombre_display[rss_sort[a]],,,, false){
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
				if draw_boton(150, pos, edificio_nombre_display[edi_sort[a]],,,, false){
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
			draw_set_font(ft_titulo)
			pos = draw_text_ypos(120, pos, recurso_nombre_display[enciclopedia_item])
			draw_set_font(ft_letra)
			pos = draw_text_ypos(120, pos, recurso_descripcion[enciclopedia_item])
			if recurso_combustion[enciclopedia_item]
				pos = draw_text_ypos(120, pos, $"{L.enciclopedia_combustible} {recurso_combustion_time[enciclopedia_item] / 60}[s]")
			pos = draw_text_ypos(120, pos, L.enciclopedia_usado_en)
			for(var a = 0; a < edificio_max; a++){
				var aa = edi_sort[a]
				for(var b = 0; b < array_length(edificio_input_id[aa]); b++)
					if edificio_input_id[aa, b] = enciclopedia_item{
						if draw_boton(140, pos, edificio_nombre_display[aa],,,, false){
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
						if draw_boton(140, pos, edificio_nombre_display[aa],,,, false){
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
							if draw_boton(140, pos, edificio_nombre_display[aa],,,, false){
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
							if draw_boton(140, pos, dron_nombre_display[a],,,, false){
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
			draw_set_font(ft_titulo)
			pos = draw_text_ypos(120, pos, edificio_nombre_display[ei])
			draw_set_font(ft_letra)
			pos = draw_text_ypos(120, pos, edificio_descripcion[ei]) + 10
			pos = draw_text_ypos(120, pos, $"{L.enciclopedia_vida}: {edificio_vida[ei]}")
			pos = draw_text_ypos(120, pos, $"{L.enciclopedia_size}: {edificio_size[ei]}")
			if array_length(edificio_precio_id[ei]) > 0{
				pos += 10
				pos = draw_text_ypos(120, pos, $"{L.enciclopedia_coste_construccion}:")
				for(var a = 0; a < array_length(edificio_precio_id[ei]); a++){
					if draw_boton(140, pos, $"{edificio_precio_num[ei, a]} {recurso_nombre_display[edificio_precio_id[ei, a]]}",,,, false){
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
					if draw_boton(140, pos, recurso_nombre_display[edificio_input_id[ei, a]],,,, false){
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
					if draw_boton(140, pos, recurso_nombre_display[edificio_output_id[ei, a]],,,, false){
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
					temp_text = liquido_nombre_display[edificio_flujo_liquido[ei]]
				if edificio_flujo_consumo[ei] > 0
					pos = draw_text_ypos(120, pos, $"{L.enciclopedia_consume} {edificio_flujo_consumo[ei]} {temp_text}/s")
				else if edificio_flujo_consumo[ei] < 0
					pos = draw_text_ypos(120, pos, $"{L.enciclopedia_produce} {abs(edificio_flujo_consumo[ei])} {temp_text}/s")
			}
			if (edificio_tecnologia[ei] or cheat) and draw_boton(120, pos + 40, L.enciclopedia_construir, ui_boton_verde){
				enciclopedia = 0
				build_index = ei
			}
			draw_sprite_ext(edificio_sprite[ei], 0, room_width - 200, 200, 2, 2, 0, c_white, 1)
			if edificio_armas[ei] and ei != id_onda_de_choque
				if edificio_size[ei] mod 2 = 0
					draw_sprite_ext(edificio_sprite_2[ei], 0, room_width - 184, 224, 2, 2, 0, c_white, 1)
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
					if draw_sprite_boton(edificio_sprite[b], xpos - 20 + 50 * a - 25 * (size - 1), ypos - 20, 40, 40, edificio_nombre_display[b]){
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
					if draw_sprite_boton(edificio_sprite[b], xpos - 20 + 50 * a - 25 * (size - 1), ypos + 180, 40, 40, edificio_nombre_display[b]){
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
							temp_text += $"\n{recurso_nombre_display[temp_precio.id]}: {temp_precio.num}"
							if nucleo.carga[temp_precio.id] < temp_precio.num{
								flag = false
								temp_text += " !!"
							}
						}
					draw_set_valign(fa_middle)
					if draw_boton(xpos + 100, ypos + 100, (flag ? L.enciclopedia_investigar : L.almacen_sin_recursos) + temp_text, flag ? ui_boton_verde : ui_boton_rojo) and flag{
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
				if draw_boton(120, pos, dron_nombre_display[a],,,, false){
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
			draw_set_font(ft_titulo)
			pos = draw_text_ypos(120, pos, dron_nombre_display[enciclopedia_item])
			draw_set_font(ft_letra)
			pos = draw_text_ypos(120, pos, dron_descripcion[enciclopedia_item])
			pos = draw_text_ypos(120, pos, $"{L.enciclopedia_vida}: {dron_vida_max[enciclopedia_item]}")
			if dron_aereo[enciclopedia_item]
				pos = draw_text_ypos(140, pos, L.enciclopedia_aerea)
			if array_length(dron_precio_id[enciclopedia_item]) > 0{
				pos += 10
				pos = draw_text_ypos(120, pos, $"{L.enciclopedia_coste_construccion}:")
				for(var a = 0; a < array_length(dron_precio_id[enciclopedia_item]); a++){
					if draw_boton(140, pos, $"{dron_precio_num[enciclopedia_item, a]} {recurso_nombre_display[dron_precio_id[enciclopedia_item, a]]}",,,, false){
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
			draw_set_font(ft_titulo)
			pos = draw_text_ypos(120, pos, L.enciclopedia_tecnologia)
			draw_set_font(ft_letra)
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
					if draw_sprite_boton(edificio_sprite[c], xpos - 20 + 60 * b - 30 * (width - 1), pos - 20, 40, 40, edificio_nombre_display[c]){
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
		var a = irandom_range(mina, maxa), b = irandom_range(minb, maxb)
		if terreno[# a, b] = idt_lava{
			var temp_complex = abtoxy(a, b), aa = temp_complex.a, bb = temp_complex.b
			sound_play(snd_lava, aa, bb, 0.5)
		}
	}
	sprite_boton_text = ""
#endregion
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
	draw_set_font(ft_titulo)
	draw_text(room_width / 2, 100, L.pausa)
	draw_set_font(ft_letra)
	draw_text(room_width / 2, 150,	L.pausa_continuar + L.pausa_red + L.pausa_liquido + L.pausa_enciclopedia + L.pausa_reparar)
	draw_set_halign(fa_left)
	var a = room_width / 2
	draw_set_halign(fa_center)
	if draw_boton(a, 300, (info ? L.pausa_desactivar : L.pausa_activar) + $" {L.pausa_info}", info ? ui_boton_verde : ui_boton_rojo){
		info = not info
		ini_open("settings.ini")
			ini_write_real("", "info", info)
		ini_close()
	}
	if draw_boton(a, 340, (grafic_tile_animation ? L.pausa_desactivar : L.pausa_activar) + $" {L.pausa_animacion}", grafic_tile_animation ? ui_boton_verde : ui_boton_rojo){
		grafic_tile_animation = not grafic_tile_animation
		ini_open("settings.ini")
			ini_write_real("", "grafic_tile_animation", grafic_tile_animation)
		ini_close()
	}
	if draw_boton(a, 380, (grafic_luz ? L.pausa_desactivar : L.pausa_activar) + $" {L.pausa_iluminacion}", grafic_luz ? ui_boton_verde : ui_boton_rojo){
		grafic_luz = not grafic_luz
		ini_open("settings.ini")
			ini_write_real("", "grafic_luz", grafic_luz)
		ini_close()
	}
	if draw_boton(a, 420, (grafic_humo ? L.pausa_desactivar : L.pausa_activar) + $" {L.pausa_humo}", grafic_humo ? ui_boton_verde : ui_boton_rojo){
		grafic_humo = not grafic_humo
		ini_open("settings.ini")
			ini_write_real("", "grafic_humo", grafic_humo)
		ini_close()
	}
	if draw_boton(a, 460, (grafic_pared ? L.pausa_desactivar : L.pausa_activar) + $" {L.pausa_paredes}", grafic_pared ? ui_boton_verde : ui_boton_rojo){
		grafic_pared = not grafic_pared
		ini_open("settings.ini")
			ini_write_real("", "grafic_pared", grafic_pared)
		ini_close()
	}
	if draw_boton(a, 500, (grafic_hideui ? L.pausa_desactivar : L.pausa_activar) + $" {L.pausa_UI}", grafic_hideui ? ui_boton_rojo : ui_boton_verde)
		grafic_hideui = not grafic_hideui
	if draw_boton(a, 540, (sonido ? L.pausa_desactivar : L.pausa_activar) + $" {L.pausa_sonido}", sonido ? ui_boton_verde : ui_boton_rojo){
		sonido = not sonido
		if not sonido for(var b = 0; b < sonidos_max; b++)
			audio_pause_sound(sonido_id[b])
		if sonido for(var b = 0; b < sonidos_max; b++)
			audio_resume_sound(sonido_id[b])
		ini_open("settings.ini")
			ini_write_real("", "sonido", sonido)
		ini_close()
	}
	if draw_boton(a, 620, L.salir, ui_boton_rojo)
		game_restart()
	draw_set_halign(fa_left)
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
	draw_set_font(ft_titulo)
	draw_text(room_width / 2, 100, L.pausa)
	draw_set_halign(fa_left)
	draw_set_font(ft_letra)
}
var flag = true, xmouse = (mouse_x + camx) / zoom, ymouse = (mouse_y + camy) / zoom
//Seleccionar recurso
if show_menu{
	var edificio = show_menu_build, index = edificio.index
	if index = id_procesador{
		draw_boton_text_counter = 0
		show_smoke = false
		draw_set_color(make_color_rgb(189, 140, 191))
		draw_rectangle(100, 100, room_width - 100, room_height - 100, false)
		draw_set_color(c_white)
		draw_rectangle(100, 100, room_width - 100, room_height - 100, true)
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
			if draw_sprite_boton(spr_basura, xpos, ypos, 20, 20, L.procesador_borrar){
				array_delete(edificio.instruccion, a, 1)
				size--
			}
			xpos += 20
			if draw_sprite_boton(spr_clonar, xpos, ypos, 20, 20, L.procesador_clonar){
				var temp_array = []
				for(var c = 0; c < array_length(pc); c++)
					array_push(temp_array, pc[c])
				array_insert(edificio.instruccion, a + 1, temp_array)
			}
			xpos += 20
			if draw_sprite_boton(spr_flecha, xpos, ypos, 20, 20, L.procesador_subir)
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
				var val = 0
				flag = true
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
		if draw_boton(xpos, ypos, L.procesador_add, ui_boton_azul,,, false) or keyboard_check_pressed(vk_enter){
			keyboard_clear(vk_enter)
			procesador_add = true
			input_layer = 1
		}
		if procesador_add{
			var width = 0
			for(var a = 0; a < array_length(procesador_instrucciones_length); a++)
				width = max(width, string_width($"{procesador_instrucciones_nombre_display[a]} ({a})"))
			draw_set_color(c_gray)
			draw_rectangle((room_width - width) / 2, 200, (room_width + width) / 2, 200 + 20 * array_length(procesador_instrucciones_length), false)
			draw_set_color(c_white)
			draw_rectangle((room_width - width) / 2, 200, (room_width + width) / 2, 200 + 20 * array_length(procesador_instrucciones_length), true)
			draw_set_halign(fa_center)
			for(var a = 0; a < array_length(procesador_instrucciones_length); a++)
				if draw_boton(room_width / 2, 200 + 20 * a, $"{procesador_instrucciones_nombre_display[a]} ({a})",,,, false, 1) or keyboard_check_pressed(ord(string(a))){
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
		if draw_boton(room_width - 120, 500, L.procesador_next_step, ui_boton_azul,,, false) or keyboard_check_pressed(vk_space){
			keyboard_clear(vk_space)
			edificio.proceso = 1
		}
		if draw_boton(room_width - 120, 530, L.procesador_guardar, ui_boton_azul,,, false) or (keyboard_check(vk_control) and keyboard_check_pressed(ord("S"))){
			save_codes = scan_files("*.code", fa_none)
			get_file = 1
			input_layer = 1
			keyboard_clear(ord("S"))
		}
		if draw_boton(room_width - 120, 560, L.procesador_cargar, ui_boton_azul,,, false) or (keyboard_check(vk_control) and keyboard_check_pressed(ord("A"))){
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
				flag = false
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
			if draw_boton(120, 120, L.cancelar, ui_boton_rojo,,,, 1) or keyboard_check_pressed(vk_escape){
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
		draw_text(room_width / 2, 110, edificio_nombre_display[edificio.index])
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
				temp_text = string_copy(edificio.variables[a], 1, 6) + "..."
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
		else if index = id_fabrica_de_drones
			draw_rectangle(aa - 80 * zoom, bb + 40 * zoom, aa + 80 * zoom, bb + (40 + 20 * dron_max) * zoom, false)
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
				draw_text(aa - 80 * zoom, bb + (40 + 20 * a) * zoom, liquido_nombre_display[a])
		}
		if index = id_planta_quimica{
			draw_rectangle(aa - 90 * zoom, bb + 40 * zoom, aa + 90 * zoom, bb + (40 + 20 * array_length(planta_quimica_receta)) * zoom, true)
			draw_text(aa - 80 * zoom, bb + 20 * zoom, L.show_menu_receta)
			for(var a = 0; a < array_length(planta_quimica_receta); a++){
				draw_sprite(planta_quimica_sprite[a], 0, aa - 80 * zoom, bb + (50 + 20 * a) * zoom)
				draw_text(aa - 70 * zoom, bb + (40 + 20 * a) * zoom, planta_quimica_receta[a])
			}
		}
		if index = id_fabrica_de_drones{
			draw_rectangle(aa - 80 * zoom, bb + 40 * zoom, aa + 80 * zoom, bb + (40 + 20 * dron_max) * zoom, true)
			draw_text(aa - 80 * zoom, bb + 20 * zoom, L.show_menu_unidad)
			for(var a = 0; a < dron_max; a++)
				draw_text(aa - 80 * zoom, bb + (40 + 20 * a) * zoom, dron_nombre_display[a])
		}
		else if index = id_deposito
			draw_text(aa - 80 * zoom, bb + 20 * zoom, "Vaciar")
		else if index = id_embotelladora
			draw_text(aa - 80 * zoom, bb + 20 * zoom, edificio.mode ? "Embotellar" : "Desembotellar")
		if mouse_x > aa - 80 * zoom and mouse_y > bb + 20 * zoom and mouse_x < aa + 80 * zoom{
			if in(index, id_selector, id_overflow, id_embotelladora) and mouse_y < bb + 40 * zoom{
				if mouse_check_button_pressed(mb_left){
					mouse_clear(mb_left)
					show_menu = false
					edificio.mode = not edificio.mode
					if index = id_embotelladora{
						if edificio.mode{
							edificio.carga_output[id_barril_agua] = false
							edificio.carga_output[id_barril_acido] = false
							edificio.carga_output[id_barril_petroleo] = false
							edificio.carga_output[id_barril_lava] = false
							edificio.carga_output[id_barril_agua_salada] = false
							edificio.carga_max[id_barril_agua] = 10
							edificio.carga_max[id_barril_acido] = 10
							edificio.carga_max[id_barril_petroleo] = 10
							edificio.carga_max[id_barril_lava] = 10
							edificio.carga_max[id_barril_agua_salada] = 10
							edificio.receptor = true
							edificio.emisor = false
						}
						else{
							edificio.carga_output[id_barril_agua] = true
							edificio.carga_output[id_barril_acido] = true
							edificio.carga_output[id_barril_petroleo] = true
							edificio.carga_output[id_barril_lava] = true
							edificio.carga_output[id_barril_agua_salada] = true
							edificio.carga_max[id_barril_agua] = 0
							edificio.carga_max[id_barril_acido] = 0
							edificio.carga_max[id_barril_petroleo] = 0
							edificio.carga_max[id_barril_lava] = 0
							edificio.carga_max[id_barril_agua_salada] = 0
							edificio.receptor = false
							edificio.emisor = true
						}
						edificio.fuel = 0
						edificio.proceso = -1
						calculate_in_out_2(edificio, false)
					}
					mover(edificio.a, edificio.b)
				}
			}
			else if in(index, id_selector, id_recurso_infinito) and mouse_y < bb + (40 + 28 * ceil(rss_max / 5)) * zoom{
				var a = floor((mouse_x - (aa - 80 * zoom)) / (32 * zoom)) + 5 * floor((mouse_y - (bb + 40 * zoom)) / (28 * zoom))
				if a >= 0 and a < rss_max{
					draw_text_background(mouse_x + 20, mouse_y, recurso_nombre_display[a])
					cursor = cr_handpoint
					if mouse_check_button_pressed(mb_left){
						mouse_clear(mb_left)
						show_menu = false
						edificio.select = a
						mover(edificio.a, edificio.b)
					}
				}
			}
			else if index = id_liquido_infinito and mouse_y < bb + (40 + 20 * lq_max) * zoom{
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
						for(var b = array_length(edificio.flujo.edificios) - 1; b >= 0; b--){
							var temp_edificio = edificio.flujo.edificios[b]
							if not temp_edificio.luz{
								temp_edificio.luz = true
								add_luz(temp_edificio.a, temp_edificio.b, 1)
							}
						}
					}
				}
			}
			else if index = id_planta_quimica and mouse_y > bb + 40 * zoom and mouse_y < bb + (40 + 20 * array_length(planta_quimica_receta)) * zoom{
				var a = clamp(floor((mouse_y - (bb + 20 * (1 + zoom))) / (20 * zoom)), 0, array_length(planta_quimica_receta) - 1)
				draw_text_background(mouse_x + 20, mouse_y, planta_quimica_descripcion[a])
				cursor = cr_handpoint
				if mouse_check_button_pressed(mb_left){
					mouse_clear(mb_left)
					show_menu = false
					if edificio.select != a{
						change_flujo(0, edificio)
						if edificio.flujo.almacen = 0 and edificio.flujo.generacion = 0
							edificio.flujo.liquido = -1
						for(var i = 0; i < rss_max; i++){
							if i = id_sal
								continue
							edificio.carga[i] = 0
							edificio.carga_max[i] = 0
							edificio.carga_output[i] = false
						}
						edificio.carga_total = 0
						edificio.select = a
						edificio.fuel = 0
						edificio.proceso = -1
						edificio.carga_max[id_sal] = 10
						//Ácido
						if a = 0{
							edificio.carga_max[id_piedra_sulfatada] = 10
							edificio.receptor = true
							edificio.emisor = false
							edificio.flujo_consumo_max = -50
							edificio.energia_consumo_max = 80
						}
						//Explosivos
						else if a = 1{
							edificio.carga_max[id_combustible] = 10
							edificio.carga_output[id_explosivo] = true
							edificio.receptor = true
							edificio.emisor = true
							edificio.flujo_consumo_max = 30
							edificio.energia_consumo_max = 0
						}
						//Baterías
						else if a = 2{
							edificio.carga_max[id_cobre] = 10
							edificio.carga_output[id_baterias] = true
							edificio.receptor = true
							edificio.emisor = true
							edificio.flujo_consumo_max = 40
							edificio.energia_consumo_max = 80
						}
						calculate_in_out_2(edificio)
						mover_in(edificio)
					}
				}
			}
			else if index = id_fabrica_de_drones and mouse_y > bb + 40 * zoom and mouse_y < bb + (40 + 20 * dron_max) * zoom{
				var a = floor((mouse_y - (bb + 20 * (1 + zoom))) / (20 * zoom))
				temp_text = $"{dron_descripcion[a]}\n"
				if in(a, 0, 4)
					temp_text += $"  {L.show_menu_no_disponible}\n"
				else for(var b = array_length(dron_precio_id[a]) - 1; b >= 0; b--)
					temp_text += $"  {recurso_nombre_display[dron_precio_id[a, b]]}: {dron_precio_num[a, b]}\n"
				draw_text_background(mouse_x + 20, mouse_y, temp_text)
				cursor = cr_handpoint
				if mouse_check_button_pressed(mb_left) and not in(a, 0, 4){
					mouse_clear(mb_left)
					show_menu = false
					edificio.carga = array_create(rss_max, 0)
					edificio.carga_max = array_create(rss_max, 0)
					edificio.carga_total = 0
					edificio.select = a
					edificio.fuel = 0
					for(var b = array_length(dron_precio_id[a]) - 1; b >= 0; b--)
						edificio.carga_max[dron_precio_id[a, b]] = 2 * dron_precio_num[a, b]
					calculate_in_out_2(edificio)
					mover_in(edificio)
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
if pausa != 1 and temp_hexagono != noone and flag and not (show_menu and show_menu_build.index = id_procesador){
	//Mostrar terreno
	temp_text = $"{terreno_nombre_display[terreno[# mx, my]]}\n"
	if mouse_check_button_pressed(mb_left){
		var flag_dron = true, min_dis = 900 * sqr(zoom) //(30 / zoom)^2
		for(var a = array_length(drones_aliados) - 1; a >= 0; a--){
			var temp_dron = drones_aliados[a], dis = distance_sqr(mouse_x, mouse_y, temp_dron.a * zoom - camx, temp_dron.b * zoom - camy)
			if dis < min_dis{
				mouse_clear(mb_left)
				min_dis = dis
				selected_dron = temp_dron
				flag_dron = false
			}
		}
		if flag_dron
			selected_dron = null_enemigo
	}
	if ore[# mx, my] >= 0
		temp_text += $"{recurso_nombre_display[ore_recurso[ore[# mx, my]]]}: {ore_amount[# mx, my]}\n"
	if edificio_bool[# mx, my]{
		var index = edificio.index
		if not edificio_inerte[index] and edificio.pointer = -1{
			draw_sprite_off(spr_diseneabled, 0, edificio.x, edificio.y)
			if draw_boton(edificio.x * zoom - camx, edificio.y * zoom - camy, L.game_activar)
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
			else if in(index, id_selector, id_overflow, id_liquido_infinito, id_recurso_infinito, id_planta_quimica, id_fabrica_de_drones, id_procesador, id_memoria, id_deposito, id_embotelladora){
				mouse_clear(mb_left)
				show_menu = true
				show_menu_build = edificio
				show_menu_x = edificio.x * zoom
				show_menu_y = edificio.y * zoom
			}
		}
		//Modificar puertos de carga
		if index = id_puerto_de_carga{
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
					calculate_in_out_2(puerto_carga_link, false)
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
					calculate_in_out_2(edificio, false)
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
		else if index = id_procesador{
			for(var a = 1; a < array_length(edificio.procesador_link); a++){
				var temp_edificio = edificio.procesador_link[a]
				draw_set_color(c_green)
				draw_arrow_off(edificio.x, edificio.y, temp_edificio.x, temp_edificio.y, 8)
				draw_set_color(c_black)
				draw_text_off((edificio.x + temp_edificio.x) / 2, (edificio.y + temp_edificio.y) / 2, a)
			}
		}
		temp_text += $"{edificio_nombre_display[index]}\n"
		if info{
			//Mostrar inputs
			draw_set_color(c_blue)
			for(var a = array_length(edificio.inputs) - 1; a >= 0; a--){
				var edificio_2 = edificio.inputs[a]
				draw_arrow_off(edificio_2.x, edificio_2.y, edificio.x, edificio.y, 12)
			}
			//Mostrar outputs
			draw_set_color(c_red)
			for(var a = array_length(edificio.outputs) - 1; a >= 0; a--){
				var edificio_2 = edificio.outputs[a]
				draw_arrow_off(edificio.x, edificio.y, edificio_2.x, edificio_2.y, 12)
			}
		}
		//Mostrar carga
		if edificio.carga_total > 0 and index != id_silo_de_misiles{
			temp_text += $"{L.almacen_almacen}:\n"
			for(var a = 0; a < rss_max; a++)
				if edificio.carga[a] > 0
					temp_text += $"  {recurso_nombre_display[a]}: {floor(edificio.carga[a])}\n"
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
						temp_text_2 += $"  {recurso_nombre_display[a]}: {temp_array[a]}\n"
					else if temp_array[a] = -1
						temp_text_2 += $"  {recurso_nombre_display[a]}\n"
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
						temp_text_2 += $"  {recurso_nombre_display[a]}: {temp_array[a]}\n"
					else if temp_array[a] = -1
						temp_text_2 += $"  {recurso_nombre_display[a]}\n"
				if temp_text_2 != ""
					temp_text += $"{L.almacen_recursos_disponibles}:\n{temp_text_2}"
			}
		}
		//Mostrar combustión
		if in(index, id_horno, id_generador, id_turbina, id_planta_nuclear)
			temp_text += $"{L.almacen_combustion}: {floor(edificio.fuel / 30)} s\n"
		//Mostrar rango de cables
		if index = id_cable{
			draw_set_color(c_white)
			draw_circle_off(edificio.x, edificio.y, 90, true)
		}
		//Mostrar rango de torres
		if edificio_armas[index]{
			var alc = edificio_alcance[index]
			draw_set_color(c_white)
			draw_circle_off(edificio.x, edificio.y, alc, true)
			if index = id_mortero
				draw_circle_off(edificio.x, edificio.y, 100, true)
			if edificio.target != null_enemigo
				draw_sprite_off(spr_target, 0, edificio.target.a, edificio.target.b)
			if info{
				draw_set_alpha(0.3)
				for(var a = array_length(edificio.target_chunks) - 1; a >= 0; a--){
					var temp_coord = edificio.target_chunks[a]
					var temp_coord_2 = abtoxy(chunk_width * (temp_coord.a + 1), chunk_height * (temp_coord.b + 1))
					temp_coord = abtoxy(chunk_width * temp_coord.a, chunk_height * temp_coord.b)
					draw_rectangle_off(temp_coord.a, temp_coord.b, temp_coord_2.a, temp_coord_2.b, false)
				}
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
		else if index = id_fabrica_de_drones{
			if edificio.proceso > 0
				temp_text += $"{L.game_creando_dron} {dron_nombre_display[edificio.select]} ({array_length(drones_aliados)}/8)\n  {floor(100 * edificio.proceso / dron_time[edificio.select])}%\n"
			else if array_length(drones_aliados) = 8
				temp_text += $"{L.game_limite_dron} (8/8)\n"
		}
		else if index = id_mensaje
			temp_text += $"{edificio.variables[0]}\n"
		else if index = id_tuberia_subterranea and edificio.link != null_edificio{
			draw_set_color(c_blue)
			draw_line_off(edificio.x, edificio.y, edificio.link.x, edificio.link.y)
		}
		else if index = id_planta_quimica{
			if edificio.select = -1
				temp_text += $"{L.almacen_sin_receta}\n"
			else
				temp_text += $"{L.almacen_produciendo} {planta_quimica_receta[edificio.select]}\n  {planta_quimica_descripcion[edificio.select]}\n"
		}
		else if index = id_silo_de_misiles{
			for(var a = 0; a < array_length(edificio_input_id[index]); a++)
				temp_text += $"  {recurso_nombre_display[edificio_input_id[index, a]]}: {edificio.carga[edificio_input_id[index, a]]}/{edificio_input_num[index, a]}\n"
			temp_text += $"  {terreno_nombre_display[5]}: {floor(edificio.select)}/4000\n"
			if edificio.proceso > 0
				temp_text += $"  {floor(100 * edificio.proceso / edificio_proceso[index])}%\n"
		}
		else if index = id_cinta_transportadora
			temp_text += $"{edificio.array_real[4]}\n"
		else if index = id_planta_de_reciclaje{
			draw_set_color(c_lime)
			draw_circle_off(edificio.x, edificio.y, 250, true)
			if edificio.select >= 0
				temp_text += $"{L.almacen_consumiendo} {dron_nombre_display[edificio.select]}: {floor(100 * edificio.proceso / dron_time[edificio.select])}%\n"
		}
		//Mostrar inputs
		if info and edificio.receptor{
			if edificio_input_all[index]
				temp_text += $"{L.almacen_acepta_todo}\n"
			else{
				var temp_text_2 = ""
				for(var a = 0; a < rss_max; a++)
					if edificio.carga_max[a] > 0
						temp_text_2 += $"  {recurso_nombre_display[a]}: {edificio.carga_max[a]}\n"
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
						temp_text_2 += $"  {recurso_nombre_display[a]}\n"
				if temp_text_2 != ""
					temp_text += $"{L.almacen_entrega}:\n{temp_text_2}"
			}
		}
		//Mostrar red electrica
		if edificio_energia[index]{
			var red = edificio.red
			if edificio_energia_consumo[index] != 0{
				if edificio_energia_consumo[index] > 0{
					temp_text += $"{L.almacen_consumiendo} {edificio.energia_consumo} {L.red_energia}\n"
					temp_text += $"{L.almacen_funcionando_al} {floor(100 * clamp((red.generacion + red.bateria) / max(red.consumo, 1), 0, 1))}% {L.almacen_de_su_capacidad}\n"
				}
				else
					temp_text += $"{L.almacen_produciendo} {abs(edificio.energia_consumo)} {L.red_energia}\n"
			}
			temp_text += $"  {red.generacion > red.consumo ? L.almacen_produciendo : L.almacen_consumiendo} {round(abs(red.generacion - red.consumo))} {L.red_energia}\n"
			if red.bateria_max > 0
				temp_text += $"  {L.red_bateria}: {round(red.bateria)}/{round(red.bateria_max)}\n"
			if info
				temp_text += red_text(red)
			for(var a = array_length(edificio.energia_link) - 1; a >= 0; a--){
				var edificio_2 = edificio.energia_link[a]
				draw_set_color(c_red)
				var temp_complex_2 = abtoxy(edificio.a, edificio.b)
				var temp_complex_3 = abtoxy(edificio_2.a, edificio_2.b)
				draw_line_off(temp_complex_2.a, temp_complex_2.b, temp_complex_3.a, temp_complex_3.b)
			}
		}
		//Mostrar red de líquido
		if edificio_flujo[index]{
			var flujo = edificio.flujo
			if flujo.liquido = -1
				temp_text += $"{L.flujo_sin_liquido}!\n"
			else{
				if edificio_flujo_consumo[index] > 0{
					temp_text += $"{L.almacen_consumiendo} {round(edificio.flujo_consumo)} {liquido_nombre_display[flujo.liquido]}\n"
					temp_text += $"{L.almacen_funcionando_al} {floor(100 * clamp((flujo.generacion + flujo.almacen) / max(flujo.consumo, 1), 0, 1))}% {L.almacen_de_su_capacidad}\n"
				}
				else
					temp_text += $"{L.almacen_produciendo} {abs(round(edificio.flujo_consumo))} {liquido_nombre_display[flujo.liquido]}\n"
				temp_text += $"  {flujo.generacion > flujo.consumo ? L.almacen_produciendo : L.almacen_consumiendo} {round(abs(flujo.generacion - flujo.consumo))} {liquido_nombre_display[flujo.liquido]}\n"
				if flujo.almacen_max > 0
					temp_text += $"  {L.flujo_almacenado}: {round(flujo.almacen)}/{round(flujo.almacen_max)}\n"
			}
			if info
				temp_text += flujo_text(flujo)
		}
		if info{
			if edificio_proceso[index] > 1
				temp_text += $"{L.almacen_proceso}: {floor(edificio.proceso)}/{edificio_proceso[index]}\n"
			temp_text += $"{edificio.select}\n"
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
						temp_text_2 += $"  {recurso_nombre_display[edificio_precio_id[b, a]]} {nucleo.carga[edificio_precio_id[b, a]]}/{edificio_precio_num[b, a]}\n"
					}
				if not comprable
					temp_text_2 = $"{L.construir_recursos_insuficientes}\n" + temp_text_2
				draw_set_color(c_red)
				var flag_3 = false, size_2 = array_length(enemigos)
				for(var a = 0; a < size_2; a++){
					var enemigo = enemigos[a]
					draw_circle_off(enemigo.a, enemigo.b, 100, true)
					if not flag_3 and (sqr(mouse_x - enemigo.a + camx) + sqr(mouse_y - enemigo.b + camy)) < 10000{//100^2
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
				draw_text_background(temp_complex.a + 20, temp_complex.b, temp_text_2)
			}
			else if mouse_check_button(mb_left)
				construir(b, repair_dir[# mx, my], mx, my)
			if mouse_check_button(mb_right)
				ds_grid_set(repair_id, mx, my, -1)
		}
	}
	draw_text_background(0, 0, temp_text)
}
if selected_dron != null_enemigo{
	draw_set_color(c_white)
	draw_circle_off(selected_dron.a, selected_dron.b, 30, true)
	if mouse_check_button_pressed(mb_right) and in(selected_dron.index, 3, 5){
		var dis = distance(selected_dron.a, selected_dron.b, xmouse, ymouse)
		mouse_clear(mb_right)
		selected_dron.modo = 1
		selected_dron.array_real[2] = dis
		selected_dron.array_real[0] = (xmouse - selected_dron.a) / dis
		selected_dron.array_real[1] = (ymouse - selected_dron.b) / dis
	}
}
if puerto_carga_bool or procesador_select != null_edificio{
	draw_set_halign(fa_center)
	if puerto_carga_bool
		draw_text_background(room_width / 2, 100, L.game_puerto_carga)
	else
		draw_text_background(room_width / 2, 100, L.game_vincular_procesador)
	draw_set_halign(fa_left)
	if mouse_check_button_pressed(mb_any){
		mouse_clear(mouse_lastbutton)
		puerto_carga_bool = false
		procesador_select = null_edificio
	}
}
flag = false
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
			var a = floor((array_length(categoria_nombre) - arctan2(mouse_y - menu_y, mouse_x - menu_x) / b) mod array_length(categoria_nombre))
			draw_set_alpha(0.5)
			draw_arco(menu_x, menu_y, 100, a * b, (a + 1) * b)
			draw_set_alpha(1)
			draw_sprite(spr_items, a, menu_x - 15 + 100 * cos((a + 0.5) * b), menu_y - 15 - 100 * sin((a + 0.5) * b))
			temp_text = categoria_nombre_display[a]
			draw_text_background(min(room_width - string_width(temp_text), mouse_x + 20), min(room_height - string_height(temp_text), mouse_y), temp_text)
			if mouse_check_button_pressed(mb_left){
				mouse_clear(mb_left)
				build_menu = 2
				menu_array = categoria_edificios[a]
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
			temp_text = $"{edificio_nombre_display[a]} (hotkey: {edificio_key[a]})\n"
			if not cheat{
				if tecnologia and not edificio_tecnologia[a]
					temp_text += "  Falta Tecnología\n"
				for(var c = 0; c < array_length(edificio_precio_id[a]); c++)
					temp_text += $"  {recurso_nombre_display[edificio_precio_id[a, c]]}: {edificio_precio_num[a, c]}\n"
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
					flag = true
					just_pressed = true
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
			selected_dron = null_enemigo
			keyboard_string = ""
			build_index = a
			build_menu = 0
			flag = true
		}
	keyboard_step = 30
}
if keyboard_step-- = 0 and not show_menu
	keyboard_string = ""
//Cancelar construcción o cerrar menú del selector
if (mouse_check_button_pressed(mb_right) or keyboard_check_pressed(vk_escape)) and (build_index > 0 or show_menu){
	mouse_clear(mb_right)
	build_index = 0
	show_menu = false
	procesador_select = null_edificio
}
//CONSTRUCCIÓN
if build_index > 0 and win = 0{
	if flag and not edificio_rotable[build_index]
		build_dir = 0
	if flag and edificio_size[build_index] mod 2 = 0
		build_dir = 5 * (build_dir mod 2)
	//Rotar
	if edificio_rotable[build_index] and not keyboard_check(vk_lcontrol){
		if mouse_wheel_up() or keyboard_check_pressed(ord("R")){
			keyboard_clear(ord("R"))
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
		if build_index = id_taladro_de_explosion
			build_list_arround = get_size(mx, my, build_dir, edificio_size[build_index] + 2)
		show_menu = false
	}
	var comprable = true
	temp_text = ""
	//Detectar si el terreno existe
	for(var a = ds_list_size(build_list) - 1; a >= 0; a--){
		var temp_complex_2 = build_list[|a], aa = temp_complex_2.a, bb = temp_complex_2.b
		if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize{
			comprable = false
			break
		}
	}
	if comprable and temp_hexagono != noone{
		//Detectar recursos y enemigos cerca
		if not cheat{
			for(var a = array_length(edificio_precio_id[build_index]) - 1; a >= 0; a--)
				if nucleo.carga[edificio_precio_id[build_index, a]] < edificio_precio_num[build_index, a]{
					comprable = false
					temp_text += $"  {recurso_nombre_display[edificio_precio_id[build_index, a]]} {nucleo.carga[edificio_precio_id[build_index, a]]}/{edificio_precio_num[build_index, a]}\n"
				}
			if not comprable
				temp_text = $"{L.construir_recursos_insuficientes}\n" + temp_text
			draw_set_color(c_red)
			var flag_3 = false
			for(var a = array_length(enemigos) - 1; a >= 0; a--){
				var enemigo = enemigos[a]
				draw_circle_off(enemigo.a, enemigo.b, 100, true)
				if not flag_3 and distance_sqr(mouse_x, mouse_y, enemigo.a * zoom - camx, enemigo.b * zoom - camy) < 10000 * sqr(zoom){//100^2
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
			if terreno_pared[terreno[# aa, bb]] or terreno[# aa, bb] = idt_hielo{
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
			flag = false
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
					else if in(terreno[# aa, bb], idt_agua_salada, idt_agua_salada_profunda){
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
				temp_text += $"{L.game_producira} {round(abs(edificio_flujo_consumo[build_index]) * count / 3)} {liquido_nombre_display[liquido]}/s"
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
				temp_text += $"Producirá {30 * i} energía/s"
		}
		else if build_index = id_bomba_de_evaporacion{
			flag = false
			for(var a = ds_list_size(build_list) - 1; a >= 0; a--){
				var temp_complex_2 = build_list[|a], aa = temp_complex_2.a, bb = temp_complex_2.b
				if in(terreno[# aa, bb], idt_agua, idt_agua_profunda, idt_agua_salada, idt_agua_salada_profunda){
					flag = true
					break
				}
			}
			if not flag{
				comprable = false
				temp_text += $"{L.construir_sobre_agua}\n"
			}
		}
		//Detectar que los taladros tengan recursos
		if in(build_index, id_taladro, id_taladro_electrico){
			var temp_array = array_create(rss_max, 0), temp_array_2 = array_create(rss_max, 0), b = 0
			flag = false
			//Buscar minerales superficiales
			for(var a = ds_list_size(build_list) - 1; a >= 0; a--){
				var temp_complex_2 = build_list[|a], aa = temp_complex_2.a, bb = temp_complex_2.b
				if in(ore[# aa, bb], 0, 1, 2){
					temp_array[ore_recurso[ore[# aa, bb]]]++
					temp_array_2[ore_recurso[ore[# aa, bb]]] += ore_amount[# aa, bb]
					b++
					flag = true
				}
			}
			//Buscar piedra o arena
			if build_index = id_taladro_electrico{
				for(var a = ds_list_size(build_list) - 1; a >= 0; a--){
					var temp_complex_2 = build_list[|a], aa = temp_complex_2.a, bb = temp_complex_2.b
					if not in(ore[# aa, bb], 0, 1, 2) and in(terreno[# aa, bb], idt_piedra, idt_arena, idt_piedra_cuprica, idt_piedra_ferrica, idt_basalto_sulfatado){
						temp_array[terreno_recurso_id[terreno[# aa, bb]]]++
						temp_array_2[terreno_recurso_id[terreno[# aa, bb]]] = -1
						b++
						flag = true
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
			else for(var a = 0; a < rss_max; a++){
				if temp_array_2[a] > 0
					temp_text += $"{recurso_nombre_display[a]}: {temp_array_2[a]}({round(temp_array[a] * 100 / b)}%)\n"
				else if temp_array_2[a] = -1
					temp_text += $"{recurso_nombre_display[a]}({round(temp_array[a] * 100 / b)}%)\n"
			}
		}
		//Taladros de Explosión
		if build_index = id_taladro_de_explosion{
			var temp_array = array_create(rss_max, 0), temp_array_2 = array_create(rss_max, 0)
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
				else if in(terreno[# aa, bb], idt_piedra, idt_arena, idt_piedra_cuprica, idt_piedra_ferrica, idt_basalto_sulfatado){
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
					temp_text += $"{recurso_nombre_display[a]}: {temp_array_2[a]} ({temp_array[a] / 5}/s)\n"
				else if temp_array_2[a] = -1
					temp_text += $"{recurso_nombre_display[a]} ({temp_array[a] / 5}/s)\n"
			}
		}
		//Detectar que no haya otros edificios debajo
		if edificio_camino[build_index] or in(build_index, id_tunel, id_tunel_salida){
			for(var a = ds_list_size(build_list) - 1; a >= 0; a--){
				var temp_complex_2 = build_list[|a], aa = temp_complex_2.a, bb = temp_complex_2.b
				if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
					continue
				if edificio_bool[# aa, bb]{
					var temp_edificio = edificio_id[# aa, bb]
					if not edificio_camino[temp_edificio.index]{
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
			draw_edificio(temp_complex_2.a, temp_complex_2.b, build_index, build_dir)
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
				draw_edificio(temp_complex.a, temp_complex.b, build_index, build_dir, 0.5)
			var temp_array, temp_array_2
			flag = true
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
					pre_build_list = []
					var temp_complex_2 = abtoxy(mx_clic, my_clic), aa = temp_complex_2.a, bb = temp_complex_2.b
					draw_edificio(aa, bb, build_index, build_dir, 0.5)
					array_push(pre_build_list, {a : mx_clic, b : my_clic})
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
					if not in(build_index, id_tuberia, id_muro){
						draw_set_color(c_black)
						draw_arrow_off(aa, bb, temp_complex_3.a, temp_complex_3.b, 8)
					}
					if not in(build_index, id_cinta_transportadora, id_cinta_magnetica, id_tuberia, id_muro){
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
							construir(build_index, build_dir, temp_complex_2.a, temp_complex_2.b)
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
				var temp_list_complex = get_size(mx, my, build_dir, 7)
				for(var a = ds_list_size(temp_list_complex) - 1; a >= 0; a--){
					var temp_complex_3 = temp_list_complex[|a], aaaa = temp_complex_3.a, bbbb = temp_complex_3.b
					if aaaa < 0 or bbbb < 0 or aaaa >= xsize or bbbb >= ysize
						continue
					if (aaaa != mx or bbbb != my) and edificio_draw[# aaaa, bbbb]{
						var temp_edificio = edificio_id[# aaaa, bbbb]
						if edificio_energia[temp_edificio.index]
							draw_line_off(aa, bb, temp_edificio.x, temp_edificio.y)
					}
				}
				//Extender
				if mouse_check_button(mb_left){
					pre_build_list = []
					temp_complex_2 = abtoxy(mx_clic, my_clic)
					aa = temp_complex_2.a
					bb = temp_complex_2.b
					var mxc = mx_clic, myc = my_clic
					draw_edificio(aa, bb, build_index, build_dir, 0.5)
					array_push(pre_build_list, {a : mx_clic, b : my_clic})
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
							draw_edificio(temp_complex_3.a, temp_complex_3.b, build_index, 0, 0.5)
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
					flag = false
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
							construir(build_index, build_dir, temp_complex_2.a, temp_complex_2.b)
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
							if in(edificio_2.index, id_tunel, id_tunel_salida) and edificio_2.dir = (build_dir + 3) mod 6{
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
					if build_index = id_cable{
						draw_circle_off(temp_complex_2.a, temp_complex_2.b, 90, true)
						var temp_list_complex = get_size(mx, my, build_dir, 7)
						for(var a = ds_list_size(temp_list_complex) - 1; a >= 0; a--){
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
					else if build_index = id_torre_de_alta_tension{
						draw_circle_off(temp_complex_2.a, temp_complex_2.b, 1_000, true)
						for(var c = array_length(torres_de_tension) - 1; c >= 0; c--){
							var temp_edificio = torres_de_tension[c]
							if sqr(temp_edificio.x - temp_complex_2.a) + sqr(temp_edificio.y - temp_complex_2.b) < 1_000_000//1000^2
								draw_line_off(temp_edificio.x, temp_edificio.y, temp_complex_2.a,temp_complex_2.b)
						}
					}
					//Vista previa Alcance de torres
					if edificio_armas[build_index]{
						draw_circle_off(temp_complex_2.a, temp_complex_2.b, edificio_alcance[build_index], true)
						if build_index = id_mortero
							draw_circle_off(temp_complex_2.a, temp_complex_2.b, 100, true)
					}
					//Taberías subterraneas
					else if build_index = id_tuberia_subterranea{
						var temp_list = get_size(mx, my, 0, 7), flag_2 = false, temp_edificio = null_edificio
						for(var c = ds_list_size(temp_list) - 1; c >= 0; c--){
							temp_complex = temp_list[|c]
							if edificio_bool[# temp_complex.a, temp_complex.b] and not (temp_complex.a = mx and temp_complex.b = my){
								temp_edificio = edificio_id[# temp_complex.a, temp_complex.b]
								if temp_edificio.index = build_index and temp_edificio.link = null_edificio{
									flag_2 = true
									break
								}
							}
						}
						if flag_2{
							draw_set_color(c_blue)
							draw_line_off(temp_complex_2.a, temp_complex_2.b, temp_edificio.x, temp_edificio.y)
						}
					}
					//Planta de Reciclaje
					else if build_index = id_planta_de_reciclaje{
						draw_set_color(c_lime)
						draw_circle_off(temp_complex_2.a, temp_complex_2.b, 250, true)
					}
				}
				if mouse_check_button_pressed(mb_left) and flag and comprable and not edificio_bool[# mx, my]
					construir(build_index, build_dir, mx, my)
			}
			if edificio_energia[build_index] and build_index != id_cable{
				var temp_complex_2 = abtoxy(mx, my), temp_list_complex = get_size(mx, my, build_dir, 7)
				for(var a = ds_list_size(temp_list_complex) - 1; a >= 0; a--){
					var temp_complex_3= temp_list_complex[|a], aa = temp_complex_3.a, bb = temp_complex_3.b
					if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
						continue
					if (aa != mx or bb != my) and edificio_draw[# aa, bb]{
						var temp_edificio = edificio_id[# aa, bb]
						if temp_edificio.index = id_cable
							draw_line_off(temp_complex_2.a, temp_complex_2.b, temp_edificio.x, temp_edificio.y)
					}
				}
			}
			draw_text_background(min(room_width - string_width(temp_text), mouse_x + 20), min(room_height - string_height(temp_text), mouse_y), temp_text)
		}
	}
	last_mx = mx
	last_my = my
}
//Destruir edificio
else{
	clicked = false
	if ((mouse_check_button(mb_right) and prev_change) or mouse_check_button_pressed(mb_right)) and temp_hexagono != noone and edificio_bool[# mx, my] and edificio.index != id_nucleo{
		if edificio_bool[# mx, my]
			prev_change = true
		delete_edificio(mx, my)
	}
}
var temp_text_right = ""
//Ciclos
if pausa = 0{
	var frame_time = min(delta_time / 1_000_000, 0.25)
	acumulator += frame_time
	for(ticks = 0; (acumulator >= LOGIC_DT and ticks < 5) or ticks = 0; ticks++){
		acumulator -= LOGIC_DT
		timer++
		//Ciclo edificios
		for(var a = array_length(edificios_activos) - 1; a >= 0; a--){
			edificio = edificios_activos[a]
			if edificio.idle or edificio.vida <= 0
				continue
			edificio_script[edificio.index](edificio)
		}
		for(var a = array_length(edificios_pendientes) - 1; a >= 0; a--){
			edificio = array_pop(edificios_pendientes)
			if edificio.eliminar and edificio.pointer >= 0{
				edificio.eliminar = false
				edificios_activos[edificio.pointer] = edificios_activos[array_length(edificios_activos) - 1]
				edificios_activos[edificio.pointer].pointer = edificio.pointer
				array_pop(edificios_activos)
				edificio.pointer = -1
			}
			if edificio.agregar and edificio.pointer = -1{
				edificio.agregar = false
				edificio.pointer = array_length(edificios_activos)
				array_push(edificios_activos, edificio)
			}
		}
		//Ciclo de los enemigos
		var cam_center_x = (camx + room_width * zoom / 2), cam_center_y = (camy + room_height * zoom / 2)
		for(var a = array_length(enemigos) - 1; a >= 0; a--){
			var dron = enemigos[a], aa = dron.a, bb = dron.b, index = dron.index, dron_vel = 1
			draw_dron(dron, true)
			if distance_sqr(cam_center_x, cam_center_y, aa, bb) > 250_000{
				draw_set_color(c_red)
				var angle = arctan2(cam_center_y - bb, cam_center_x - aa), cosa = cos(angle), sina = sin(angle)
				draw_line(room_width / 2 - 60 * cosa, room_height / 2 - 60 * sina, room_width / 2 - 90 * cosa, room_height / 2 - 90 * sina)
			}
			for(var b = 0; b < efectos_max; b++)
				if dron.efecto[b] > 0{
					dron.efecto[b]--
					if b = 0
						dron_vel /= 2
					else if b = 1
						dron.vida -= 0.25
					else if b = 2
						dron_vel *= 1.2
				}
			if dron.vida <= 0{
				destroy_dron(dron)
				continue
			}
			if aa < 0
				dron.a++
			else if aa > xsize * 48
				dron.a--
			if bb < 0
				dron.b++
			else if bb > ysize * 14
				dron.b--
			if dron.target != null_edificio and dron.target.vida <= 0
				dron.target = null_edificio
			if in(index, 0, 4, 6){
				if array_length(edificios) > 0 and dron.target = null_edificio{
					var temp_complex = xytoab(aa, bb)
					dron.target = edificio_cercano[# temp_complex.a, temp_complex.b]
				}
			}
			else if dron_aereo[index]{
				var min_dis = infinity
				for(var i = array_length(nucleos) - 1; i >= 0; i--){
					edificio = nucleos[i]
					var dis = distance_sqr(aa, bb, edificio.x, edificio.y)
					if dis < min_dis{
						min_dis = dis
						dron.target = edificio
					}
				}
			}
			//Target edificios y drones
			if dron.target != null_edificio{
				edificio = dron.target
				dron.dir = (9 * dron.dir + radtodeg(arctan2(edificio.y - bb, aa - edificio.x))) / 10
				var temp_complex = xytoab(aa, bb), aaa = temp_complex.a, bbb = temp_complex.b, dir = -1, ataque = false
				var dis = distance_sqr(aa, bb, edificio.x, edificio.y)
				//Moverse
				if in(index, 0, 4, 6){
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
						if dir = -1
							dir = 0
						dron.a += dron_vel * cos_angle_dir[dir]
						dron.b -= dron_vel * sin_angle_dir[dir]
						if index = 4
							dron.dir_move += angle_difference(dron.dir_move, radtodeg(arctan2(sin_angle_dir[dir], cos_angle_dir[dir]))) / 100
					}
				}
				else if dron_aereo[index]{
					var dis_2 = sqrt(dis)
					dron.a += 2 * dron_vel * (edificio.x - dron.a) / dis_2
					dron.b += 2 * dron_vel * (edificio.y - dron.b) / dis_2
				}
				if dis < dron_alcance[index]{
					ataque = true
					if atacar_dron(dron, edificio)
						continue
				}
				//Targetear unidades
				else if array_length(drones_aliados) > 0{
					var closest_dron = null_enemigo, closest_dis = dron_alcance[dron.index]
					for(var b = array_length(drones_aliados) - 1; b >= 0; b--){
						var temp_dron = drones_aliados[b], temp_dis = distance_sqr(aa, bb, temp_dron.a, temp_dron.b)
						if temp_dis < closest_dis{
							closest_dis = temp_dis
							closest_dron = temp_dron
						}
					}
					if closest_dron != null_enemigo{
						ataque = true
						if atacar_dron(dron,, closest_dron)
							continue
					}
				}
				//Targetear edificios
				if ataque = false{
					if dron.temp_target = null_edificio{
						var dis_max = dron_alcance[index], closest_dis = infinity
						var maxu = min(ds_grid_width(chunk_edificios) - 1, dron.chunk_x + dron_alcance_chunk_x[index])
						var maxv = min(ds_grid_height(chunk_edificios) - 1, dron.chunk_y + dron_alcance_chunk_y[index])
						for(var u = max(0, dron.chunk_x - dron_alcance_chunk_x[index]); u <= maxu; u++)
							for(var v = max(0, dron.chunk_y - dron_alcance_chunk_y[index]); v <= maxv; v++){
								var chunk = chunk_edificios[# u, v]
								for(var i = array_length(chunk) - 1; i >= 0; i--){
									edificio = chunk[i]
									dis = distance_sqr(aa, bb, edificio.x, edificio.y)
									if dis < dis_max and dis < closest_dis{
										dron.temp_target = edificio
										closest_dis = dis
									}
								}
							}
					}
					else{
						edificio = dron.temp_target
						if edificio.vida <= 0
							dron.temp_target = null_edificio
						else{
							dis = distance_sqr(aa, bb, edificio.x, edificio.y)
							dron.dir = (9 * dron.dir + radtodeg(arctan2(edificio.y - bb, aa - edificio.x))) / 10
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
			var temp_dron_size = dron_size[index], temp_array = chunk_enemigos[# dron.chunk_x, dron.chunk_y]
			for(var b = array_length(temp_array) - 1; b >= 0; b--){
				var temp_enemigo = temp_array[b]
				if temp_enemigo = null_enemigo or temp_enemigo = dron or not is_struct(temp_enemigo) or temp_enemigo.vida <= 0{
					if not is_struct(temp_enemigo)
						show_debug_message($"Error en el enemigo {b}/{array_length(temp_array)} de chunk_enemigos[# {dron.chunk_x}, {dron.chunk_y}] (step{image_index})")
					continue
				}
				var dis = max(0.01, distance_sqr(aa, bb, temp_enemigo.a, temp_enemigo.b))
				if dis < temp_dron_size{
					var aaa = sign(aa - temp_enemigo.a), bbb = sign(bb - temp_enemigo.b)
					dron.a += aaa
					dron.b += bbb
					temp_enemigo.a -= aaa
					temp_enemigo.b -= bbb
				}
			}
			//Cambiar de chunk
			var temp_complex = xytoab(aa, bb)
			aa = temp_complex.a
			bb = temp_complex.b
			if aa != dron.posa or bb != dron.posb{
				dron.posa = aa
				dron.posb = bb
				if array_length(edificios) > 0 and terreno_caminable[terreno[# aa, bb]]
					dron.target = edificio_cercano[# aa, bb]
				var chunk_x = clamp(round(aa / chunk_width), 0, ds_grid_width(chunk_enemigos) - 1), chunk_y = clamp(round(bb / chunk_height), 0, ds_grid_height(chunk_enemigos) - 1)
				if chunk_x != dron.chunk_x or chunk_y != dron.chunk_y{
					remove_dron_chunk(dron)
					dron.chunk_x = chunk_x
					dron.chunk_y = chunk_y
					temp_array = chunk_enemigos[# chunk_x, chunk_y]
					dron.chunk_pointer = array_length(temp_array)
					array_push(temp_array, dron)
					ds_grid_set(chunk_enemigos, dron.chunk_x, dron.chunk_y, temp_array)
				}
			}
			if terreno[# dron.posa, dron.posb] = idt_hielo
				dron.efecto[2] = 30
		}
		for(var a = array_length(enemigos) - 1; a >= 0; a--){
			var dron = enemigos[a]
			draw_vida(dron.a * zoom - camx, dron.b * zoom - camy, dron.vida, dron.vida_max)
		}
		//Ciclo drones aliados
		for(var a = array_length(drones_aliados) - 1; a >= 0; a--){
			var dron = drones_aliados[a], aa = dron.a, bb = dron.b, index = dron.index
			draw_dron(dron, false)
			if dron.vida <= 0{
				var temp_dron = drones_aliados[array_length(drones_aliados) - 1]
				drones_aliados[dron.pointer] = temp_dron
				temp_dron.pointer = dron.pointer
				array_pop(drones_aliados)
				continue
			}
			//Dron de Transporte
			if index = 1{
				if array_length(puerto_carga_array) > 0{
					if dron.modo = 0{
						puerto_carga_atended = (++puerto_carga_atended) mod array_length(puerto_carga_array)
						dron.target = puerto_carga_array[puerto_carga_atended]
						dron.modo = 1
					}
					else{
						edificio = dron.target
						var dis = distance_sqr(aa, bb, edificio.x, edificio.y)
						if dis > dron_alcance[dron.index]{
							dis = sqrt(dis)
							dron.dir = (9 * dron.dir + radtodeg(arctan2(edificio.y - bb, aa - edificio.x))) / 10
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
			else if index = 2{
				if dron.modo = 0{
					edificio = edificios[irandom(array_length(edificios) - 1)]
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
					if dis > dron_alcance[dron.index]{
						dron.dir = (9 * dron.dir + radtodeg(arctan2(edificio.y - bb, aa - edificio.x))) / 10
						dron.a += (edificio.x - aa) / dis
						dron.b += (edificio.y - bb) / dis
					}
					else{
						draw_set_color(c_green)
						draw_line_off(aa, bb, edificio.x, edificio.y)
						if edificio_curar(edificio, 1)
							dron.modo = 0
					}
				}
			}
			//Drones aereos
			else if in(index, 3, 5){
				if dron.modo = 1{
					dron.dir = (9 * dron.dir + radtodeg(arctan2(dron.array_real[1], -dron.array_real[0]))) / 10
					dron.a += 2 * dron.array_real[0]
					dron.b += 2 * dron.array_real[1]
					dron.array_real[2] -= 2
					if dron.array_real[2] <= 0
						dron.modo = 0
				}
				if array_length(enemigos) > 0{
					var closest_dron = null_enemigo, closest_dis = dron_alcance[dron.index]
					for(var b = array_length(enemigos) - 1; b >= 0; b--){
						var temp_dron = enemigos[b], temp_dis = distance_sqr(aa, bb, temp_dron.a, temp_dron.b)
						if temp_dis < closest_dis{
							closest_dis = temp_dis
							closest_dron = temp_dron
						}
					}
					if closest_dron != null_enemigo and atacar_dron(dron,,, closest_dron, false)
						continue
				}
			}
			//Evitar colisiones
			var size_2 = array_length(drones_aliados)
			for(var b = a + 1; b < size_2; b++){
				var temp_dron = drones_aliados[b], dis = max(0.01, distance_sqr(aa, bb, temp_dron.a, temp_dron.b))
				if dis < 400{//20^2
					var aaa = (aa - temp_dron.a) / dis, bbb = (bb - temp_dron.b) / dis
					dron.a += aaa
					dron.b += bbb
					temp_dron.a -= aaa
					temp_dron.b -= bbb
				}
			}
		}
		for(var a = array_length(drones_aliados) - 1; a >= 0; a--){
			var dron = drones_aliados[a]
			draw_vida(dron.a * zoom - camx, dron.b * zoom - camy, dron.vida, dron.vida_max)
		}
		//Ciclo de disparos
		draw_set_color(c_black)
		for(var a = 0; a < array_length(municiones); a++){
			var municion = municiones[a], target = municion.target
			if municion.tipo != 2
				draw_circle_off(municion.x, municion.y, 2, false)
			municion.x += municion.hmove
			municion.y += municion.vmove
			//Munición perforadora
			if municion.tipo = 4{
				var temp_complex = xytoab(municion.x, municion.y)
				herir_hexagono(temp_complex.a, temp_complex.b, floor(municion.dmg / 2), false)
			}
			if --municion.dis <= 0{
				municiones[a--] = municiones[array_length(municiones) - 1]
				array_pop(municiones)
				//Daño unidad
				if target != null_enemigo and target.vida > 0{
					//Daño fuego
					if municion.tipo = 2
						target.efecto[1] = 60
					//Daño área
					else
						herir_hexagono(target.posa, target.posb, municion.dmg)
					if target.vida > 0{
						target.vida -= municion.dmg
						if target.vida <= 0
							destroy_dron(target)
					}
						
				}
				//Daño edificio
				if municion.target_build != null_edificio and municion.target_build.vida > 0
					edificio_herir(municion.target_build, municion.dmg)
				//Misil aliado
				if municion.tipo = 1
					explosion(municion.x, municion.y,, false, 2500)
				//Misil enemigo
				else if municion.tipo = 3
					explosion(municion.x, municion.y, municion.target_build)
			}
		}
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
			if show_smoke and humo.a >= mina and humo.b >= minb and humo.a <= maxa and humo.b <= maxb{
				draw_sprite_off(spr_blur_32, 0, humo.x, humo.y)
				humo.x += humo.hmove
				humo.y += humo.vmove
			}
			if --humo.time <= 0{
				humos[a--] = humos[array_length(humos) - 1]
				array_pop(humos)
			}
		}
		//Fuego
		draw_set_alpha(0.4)
		for(var a = 0; a < array_length(fuegos); a++){
			var fuego = fuegos[a]
			if show_smoke and fuego.a >= mina and fuego.b >= minb and fuego.a <= maxa and fuego.b <= maxb{
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
				if grafic_humo and fuego.a >= mina and fuego.b >= minb and fuego.a <= maxa and fuego.b <= maxb
					array_push(humos, add_humo(fuego.x, fuego.y, fuego.a, fuego.b, random_range(-1, 1), random_range(-1, 1), 15))
			}
		}
		draw_set_alpha(1)
		if oleadas and (++oleadas_timer >= 60 * oleadas_tiempo_primera or keyboard_check_pressed(vk_enter)){
			var time = oleadas_timer / 60 - oleadas_tiempo_primera
			if (time mod oleadas_tiempo) = 0 or keyboard_check_pressed(vk_enter){
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
					if not terreno_caminable[terreno[# aa, bb]] or edificio_cercano[# aa, bb] = null_edificio or (tutorial = 0 and random(1) < 0.05){
						if irandom(min(ds_list_size(temp_complex_list), d)) > i + 5{
							enemigo = add_dron(aa, bb, 5)
							i += 4
						}
						else
							enemigo = add_dron(aa, bb, 3)
					}
					else{
						if irandom(min(ds_list_size(temp_complex_list), d)) > i + 15{
							enemigo = add_dron(aa, bb, 6)
							i += 14
						}
						else if irandom(min(ds_list_size(temp_complex_list), d)) > i + 6{
							enemigo = add_dron(aa, bb, 4)
							i += 5
						}
						else
							enemigo = add_dron(aa, bb, 0)
					}
					enemigo.vida_max = enemigo.vida * power(d / 3, 1.1) * multiplicador_vida_enemigos / 100
					enemigo.vida = enemigo.vida_max
					var temp_array = ds_grid_get(chunk_enemigos, enemigo.chunk_x, enemigo.chunk_y)
					enemigo.chunk_pointer = array_length(temp_array)
					array_push(temp_array, enemigo)
					ds_grid_set(chunk_enemigos, enemigo.chunk_x, enemigo.chunk_y, temp_array)
					enemigo.target = edificio_cercano[# aa, bb]
					enemigo.pointer = array_length(enemigos)
					array_push(enemigos, enemigo)
				}
			}
		}
		if mision_actual >= 0 and win = 0{
			var a = mision_actual
			if in(mision_objetivo[a], 5, 7) and not oleadas and keyboard_check_pressed(vk_enter){
				keyboard_clear(vk_enter)
				pasar_mision()
			}
			draw_set_halign(fa_center)
			for(var b = 0; b < array_length(mision_texto[a]); b++){
				var texto = mision_texto[a, b]
				draw_text_background(texto.x * zoom - camx, texto.y * zoom - camy, text_wrap(texto.texto, 250))
			}
			draw_set_halign(fa_left)
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
			if draw_boton(room_width - 20, string_height(temp_text_right) + 64, L.win_siguiente_mision, ui_boton_verde){
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
		}
		//Ciclo flujos
		for(var a = array_length(flujos) - 1; a >= 0; a--){
			var flujo = flujos[a]
			flujo.almacen = clamp(flujo.almacen + (flujo.generacion - flujo.consumo) / 30, 0, flujo.almacen_max)
			if flujo.almacen = 0
				flujo.eficiencia = clamp(flujo.generacion / max(1, flujo.eficiencia), 0, 1)
			else
				flujo.eficiencia = 1
			if flujo.almacen < 1 and flujo.generacion = 0{
				if grafic_luz and flujo.liquido = 3
					for(var b = array_length(flujo.edificios) - 1; b >= 0; b--){
						edificio = flujo.edificios[b]
						if edificio.luz{
							edificio.luz = false
							add_luz(edificio.a, edificio.b, -1)
						}
					}
				flujo.liquido = -1
			}
		}
		if --nuclear_step > 0{
			if nuclear_step > 150{
				draw_set_color(c_white)
				draw_set_alpha((nuclear_step - 150) / 150)
				draw_rectangle(0, 0, room_width, room_height, false)
			}
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
		var time = oleadas_timer / 60
		var seg = floor(oleadas_tiempo_primera - time)
		temp_text_right += $"{seg > 60 ? string(floor(seg / 60)) + "m " : ""}{seg mod 60}s {L.game_first_wave}\n"
	}
	else{
		var time = (oleadas_timer / 60) - oleadas_tiempo_primera
		var seg = floor(oleadas_tiempo - (time mod oleadas_tiempo))
		temp_text_right += $"{seg > 60 ? string(floor(seg / 60)) + "m " : ""}{seg mod 60}s {L.game_next_wave}\n"
	}
}
if mision_actual >= 0 and win = 0{
	var a = mision_actual
	if not in(mision_objetivo[a], 5, 6)
		temp_text_right += $"\n\n{mision_nombre[a]}\n{objetivos_nombre_display[mision_objetivo[a]]} {mision_target_num[a]} "
	if mision_objetivo[a] < 2
		temp_text_right += recurso_nombre_display[mision_target_id[a]]
	else if in(mision_objetivo[a], 2, 3, 7)
		temp_text_right += edificio_nombre_display[mision_target_id[a]]
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
if draw_sprite_boton(spr_manual, room_width - 64, string_height(temp_text_right), 64, 64, $"{L.game_enciclopedia} (Y)")
	enciclopedia = true
//Input
if keyboard_check_pressed(vk_anykey) and win = 0 and not show_menu{
	if keyboard_check_pressed(ord("P")){
		if pausa = 2
			pausa = 0
		else if pausa = 0
			pausa = 2
	}
	if keyboard_check_pressed(ord("U"))
		info = not info
	if keyboard_check_pressed(ord("L"))
		flow = (flow + 1) mod 6
	if cheat and keyboard_check(ord("T"))
		image_index += 20
	//Mostrar redes electricas
	if keyboard_check(ord("O")){
		temp_text = ""
		for(var a = array_length(redes) - 1; a >= 0; a--){
			var red = redes[a]
			temp_text += $"{L.red_red} {a}:\n"
			temp_text += $"  {L.red_consumo}: {red.consumo}\n"
			temp_text += $"  {L.red_generacion}: {red.generacion}\n"
			temp_text += $"  {L.red_bateria}: {floor(red.bateria)}/{red.bateria_max}\n"
			temp_text += red_text(red)
			draw_set_color(make_color_hsv(255 * a / array_length(redes), 255, 255))
			for(var b = array_length(red.edificios) - 1; b >= 0; b--){
				edificio = red.edificios[b]
				for(var c = array_length(edificio.energia_link) - 1; c >= 0; c--){
					var edificio_2 = edificio.energia_link[c]
					draw_arrow_off(edificio.x, edificio.y, edificio_2.x, edificio_2.y, 8)
				}
			}
		}
		draw_text_background(0, 0, temp_text)
	}
	//Mostrar redes hidraulicas
	if keyboard_check(ord("I")){
		temp_text = ""
		for(var a = array_length(flujos) - 1; a >= 0; a--){
			var flujo = flujos[a]
			temp_text += $"{L.flujo_flujo} {a}:\n"
			if flujo.liquido = -1
				temp_text += $"{L.flujo_sin_liquido}\n"
			else
				temp_text += $"{liquido_nombre_display[flujo.liquido]}\n"
			temp_text += $"  {L.flujo_generacion}: {flujo.generacion}\n"
			temp_text += $"  {L.flujo_consumo}: {flujo.consumo}\n"
			temp_text += $"  {L.flujo_almacenado}: {floor(flujo.almacen)}/{flujo.almacen_max}\n"
			temp_text += flujo_text(flujo)
			draw_set_color(make_color_hsv(255 * a / array_length(flujos), 255, 255))
			for(var b = array_length(flujo.edificios) - 1; b >= 0; b--){
				edificio = flujo.edificios[b]
				for(var c = array_length(edificio.flujo_link) - 1; c >= 0; c--){
					var edificio_2 = edificio.flujo_link[c]
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
		if pausa > 0
			pausa = 0
		else{
			selected_dron = null_enemigo
			pausa = 1
			build_index = 0
			show_menu = false
			puerto_carga_bool = false
			build_menu = 0
			mouse_clear(mb_any)
			keyboard_clear(vk_anykey)
		}
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
		if not sonido{
			for(var a = 0; a < sonidos_max; a++)
				audio_pause_sound(sonido_id[a])
			for(var a = 0; a < array_length(musica); a++)
				audio_pause_sound(musica[a])
		}
		if sonido for(var a = 0; a < sonidos_max; a++)
			audio_resume_sound(sonido_id[a])
	}
	if keyboard_check_pressed(ord("Y")){
		if enciclopedia = 0
			enciclopedia = 1
		else
			enciclopedia = 0
	}
	if cheat and mision_actual >= 0 and string_ends_with(keyboard_string, "uwu")
		pasar_mision()
}
if mision_actual >= 0 and --mision_camara_step > 0{
	zoom = 1
	camx = clamp(((mision_camara_x[mision_actual] - room_width / 2) * (60 - mision_camara_step) + mision_camara_x_start * mision_camara_step) / 60, 0, xsize * 48 * zoom - room_width)
	camy = clamp(((mision_camara_y[mision_actual] - room_height / 2) * (60 - mision_camara_step) + mision_camara_y_start * mision_camara_step) / 60, 0, ysize * 14 * zoom - room_height)
}
else
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
if sonido{
	for(var a = 0; a < sonidos_max; a++){
		if not audio_is_paused(sonido_id[a]) and volumen[a] = 0
			audio_pause_sound(sonido_id[a])
		if audio_is_paused(sonido_id[a]) and volumen[a] > 0
			audio_resume_sound(sonido_id[a])
		audio_sound_gain(sonido_id[a], volumen[a], 0)
	}
	if random(1) < 0.001{
		flag = true
		for(var a = array_length(musica) - 1; a >= 0; a--)
			if audio_is_playing(musica[a]){
				flag = false
				break
			}
		if flag
			audio_play_sound(musica[irandom(array_length(musica) - 1)], 1, false)
	}
}
if win > 0{
	draw_set_color(c_black)
	draw_set_alpha(min(++win_step / 100, 0.5))
	draw_rectangle(0, 0, room_width, room_height, false)
	draw_set_color(c_white)
	if win_step > 25{
		draw_set_alpha(min((win_step - 25) / 100, 1))
		draw_set_font(ft_titulo)
		draw_set_halign(fa_center)
		draw_text(room_width / 2, 100, win = 1 ? L.win_victoria : L.win_derrota)
		draw_set_font(ft_letra)
		var ypos = 200, sec = floor(--timer / 60)
		ypos = draw_text_ypos(room_width / 2, ypos, $"{L.win_tiempo}: {sec >= 60 ? string(floor(sec / 60)) + "m " : ""}{sec mod 60}s")
		if edificios_construidos > 0
			ypos = draw_text_ypos(room_width / 2, ypos, $"{L.win_edificios}: {edificios_construidos}")
		if drones_construidos > 0
			ypos = draw_text_ypos(room_width / 2, ypos, $"{L.win_drones}: {drones_construidos}")
		if enemigos_eliminados > 0
			ypos = draw_text_ypos(room_width / 2, ypos, $"{L.win_enemigos}: {enemigos_eliminados}")
		if tecnologia
			ypos = draw_text_ypos(room_width / 2, ypos, $"{L.win_tecnologias}: {tecnologias_estudiadas}")
		if modo_misiones
			ypos = draw_text_ypos(room_width / 2, ypos, $"{L.win_misiones}: {misiones_pasadas}")
		//Victoria
		if win = 1{
			if in(tutorial, 1, 2, 3, 4) and draw_boton(room_width / 2, room_height - 250, L.win_siguiente_mision, ui_boton_verde){
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
				win_step = 0
				win = 0
			}
		}
		//Derrota
		if win = 2 and tutorial > 0 and draw_boton(room_width / 2, room_height - 250, L.win_reintentar, ui_boton_azul){
			if tutorial = 1
				cargar_escenario("mision_1.txt")
			if tutorial = 2
				cargar_escenario("mision_2.txt")
			if tutorial = 3
				cargar_escenario("mision_3.txt")
			game_start()
		}
		if draw_boton(room_width / 2, room_height - 150, L.win_salir, ui_boton_rojo) or keyboard_check_pressed(vk_escape){
			keyboard_clear(vk_escape)
			game_restart()
		}
	}
	draw_set_alpha(1)
}
