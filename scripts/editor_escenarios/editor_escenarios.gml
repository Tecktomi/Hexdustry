function editor_escenarios(){
	with control{
		dibujar_fondo(1)
		dibujar_edificios()
		var xmouse = (mouse_x + camx) / zoom, ymouse = (mouse_y + camy) / zoom
		var temp_complex_mouse = xytoab(xmouse, ymouse), mx = temp_complex_mouse.a, my = temp_complex_mouse.b, outside = false
		if mx < 0 or my < 0 or mx >= xsize or my >= ysize{
			outside = true
			mx = clamp(mx, 0, xsize - 1)
			my = clamp(my, 0, ysize - 1)
		}
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
				else if in(mision_objetivo[i], 2, 3, 7, 8){
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
						if not mision_edificios[a]
							draw_set_color(c_red)
						else if edificio_tecnologia[a]
							draw_set_color(c_green)
						else
							draw_set_color(c_yellow)
						draw_circle(xpos, ypos, 18, false)
						draw_set_color(c_black)
						draw_circle(xpos, ypos, 18, true)
						if draw_sprite_boton(edificio_sprite[a], xpos - 15, ypos - 15){
							if not mision_edificios[a]{
								mision_edificios[a] = true
								edificio_tecnologia[a] = true
								edificio_tecnologia_desbloqueable[a] = false
							}
							else if edificio_tecnologia[a]{
								mision_edificios[a] = true
								edificio_tecnologia[a] = false
								edificio_tecnologia_desbloqueable[a] = true
							}
							else{
								mision_edificios[a] = false
								edificio_tecnologia[a] = false
								edificio_tecnologia_desbloqueable[a] = false
							}
						
						}
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
			xsize = round(draw_deslizante(xpos, xpos + 100, ypos + 10, xsize, 28, 144, 0))
			chunk_xsize = ceil(xsize / chunk_width)
			draw_text(xpos + 100, ypos, $"{xsize}")
			if xsize > prev_xsize
				resize_grid(prev_xsize, 0)
			ypos += text_y
			var prev_ysize = ysize
			ysize = round(draw_deslizante(xpos, xpos + 100, ypos + 10, ysize, 60, 288, 1))
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
		if mouse_x > 200 and not outside{
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
						var temp_queue = ds_queue_create(), visitado = usable_grid_bool
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
						delete_edificio(nucleo, false)
						nucleo = temp_nucleo
						editor_herramienta = 0
					}
				}
				//Terreno
				else if (build_index >= 0 and build_index < terreno_max + ore_max) or editor_herramienta = 3{
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
							else if build_index < terreno_max + ore_max{
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
				var temp_text = terreno_nombre_display[terreno[# mx, my]]
				if ore[# mx, my] >= 0
					temp_text += $"\n{recurso_nombre_display[ore_recurso[ore[# mx, my]]]}: {ore_amount[# mx, my]}"
				if edificio_bool[# mx, my]
					temp_text += $"\n{edificio_nombre_display[edificio_id[# mx, my].index]}"
				draw_text_background(200, 0, temp_text)
			}
			//Borrar edificio
			if mouse_check_button_pressed(mb_right) and edificio_bool[# mx, my]{
				mouse_clear(mb_right)
				var edificio = edificio_id[# mx, my]
				if edificio.index != id_nucleo
					delete_edificio(edificio)
			}
		}
		//Cancelar construcción
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
		var size = terreno_max + ore_max + 2, ypos = 10
		sprite_boton_text = ""
		if size > 40
			deslizante[0] = 5 * floor(draw_deslizante_vertical(5, 10, 290, deslizante[0], 0, size - 40, 0) / 5)
		for(var a = deslizante[0]; a < min(deslizante[0] + 40, size); a++){
			var b = 0
			if a < terreno_max and draw_sprite_boton(terreno_sprite[a], 10 + (a mod 5) * 36, ypos,,, terreno_nombre_display[a]){
				build_index = a
				editor_herramienta = 0
			}
			b += terreno_max
			if a >= b and a - b < ore_max and draw_sprite_boton(ore_sprite[a - b], 10 + (a mod 5) * 36, ypos,,, recurso_nombre_display[ore_recurso[a - b]]){
				build_index = a
				editor_herramienta = 0
			}
			b += ore_max
			if a = b++ and draw_sprite_boton(dron_sprite[idd_arana], 10 + (a mod 5) * 36, ypos,,, "Cambiar spawn enemigo")
				editor_herramienta = 1
			if a = b++ and draw_sprite_boton(edificio_sprite[id_nucleo], 10 + (a mod 5) * 36, ypos,,, "Cambiar posición del núcleo")
				editor_herramienta = 2
			if (a mod 5) = 4
				ypos += 36
		}
		if deslizante[0] + 40 < size and mouse_wheel_down() and mouse_x < 200
			deslizante[0] += 5
		if deslizante[0] > 4 and mouse_wheel_up() and mouse_x < 200
			deslizante[0] -= 5
		if sprite_boton_text != ""
			draw_text_background(mouse_x + 20, mouse_y, sprite_boton_text)
		ypos = room_height - 400
		if draw_boton(10, ypos, L.editor_objetivos, ui_boton_azul){
			editor_menu = 1
			exit
		}
		ypos += text_y + 10
		if draw_boton(10, ypos, L.editor_editar_mapa, ui_boton_azul){
			editor_menu = 2
			exit
		}
		ypos += text_y + 10
		if draw_boton(10, ypos, "Editar desde dentro"){
			clear_edit()
			menu = 3
			cheat = true
			build_enemigo = true
			camx = max(camx, 0)
		}
		ypos += text_y + 10
		build_size = round(draw_deslizante(50, 150, ypos, build_size, 1, 5, 2))
		if browser and draw_boton(10, room_height - 100, L.editor_guardar, ui_boton_azul) or (keyboard_check(vk_lcontrol) and keyboard_check_pressed(ord("S"))){
			get_file = 2
			input_layer = 1
			scan_files_save()
			keyboard_clear(ord("S"))
		}
		if browser and draw_boton(10, room_height - 60, L.editor_cargar, ui_boton_azul) or (keyboard_check(vk_lcontrol) and keyboard_check_pressed(ord("A"))){
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
					var xpos = 120 + 120 * (a mod 9)
					ypos = 200 + 120 * floor(a / 9)
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
			camx = max(camx, 0)
		}
		control_camara(-200)
		update_cursor()
	}
}