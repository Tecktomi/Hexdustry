function panel_enciclopedia_edificio(xpos = 0, ypos = 0, param = {_this_input_layer : 0, _tecnologia : false}){
	with control{
		var ei = enciclopedia_item, _this_input_layer = param._this_input_layer, _tecnologia = param._tecnologia
		var a, b
		draw_set_font(font_titulo)
		ypos = draw_text_ypos(xpos + 10, ypos, edificio_nombre[ei])
		draw_set_font(font_normal)
		ypos = draw_text_ypos(xpos + 10, ypos, edificio_descripcion[ei]) + 10
		ypos = draw_text_ypos(xpos + 10, ypos, $"{L.enciclopedia_vida}: {edificio_vida[ei]}")
		ypos = draw_text_ypos(xpos + 10, ypos, $"{L.enciclopedia_size}: {edificio_size[ei]}")
		if array_length(edificio_precio_id[ei]) > 0{
			ypos += 10
			ypos = draw_text_ypos(xpos + 10, ypos, $"{L.enciclopedia_coste_construccion}:")
			for(a = 0; a < array_length(edificio_precio_id[ei]); a++){
				if draw_boton(xpos + 20, ypos, $"{edificio_precio_num[ei, a]} {recurso_nombre[edificio_precio_id[ei, a]]}",,,, false, _this_input_layer){
					enciclopedia_link(3, edificio_precio_id[ei, a])
					return [xpos, ypos]
				}
				ypos += 20
			}
		}
		if array_length(edificio_input_id[ei]) > 0{
			ypos += 10
			ypos = draw_text_ypos(xpos + 10, ypos, $"{L.enciclopedia_consume}:")
			for(a = 0; a < array_length(edificio_input_id[ei]); a++){
				if draw_boton(xpos + 20, ypos, recurso_nombre[edificio_input_id[ei, a]],,,, false, _this_input_layer){
					enciclopedia_link(3, edificio_input_id[ei, a])
					return [xpos, ypos]
				}
				ypos += 20
			}
		}
		if array_length(edificio_output_id[ei]) > 0{
			ypos += 10
			ypos = draw_text_ypos(xpos + 10, ypos, $"{L.enciclopedia_produce}:")
			for(a = 0; a < array_length(edificio_output_id[ei]); a++){
				if draw_boton(xpos + 20, ypos, recurso_nombre[edificio_output_id[ei, a]],,,, false, _this_input_layer){
					enciclopedia_link(3, edificio_output_id[ei, a])
					return [xpos, ypos]
				}
				ypos += 20
			}
		}
		if edificio_energia[ei]{
			ypos += 10
			if edificio_energia_consumo[ei] > 0
				ypos = draw_text_ypos(xpos + 10, ypos, $"{L.enciclopedia_consume} {edificio_energia_consumo[ei]} {L.red_energia}/s")
			else if edificio_energia_consumo[ei] < 0
				ypos = draw_text_ypos(xpos + 10, ypos, $"{L.enciclopedia_produce} {abs(edificio_energia_consumo[ei])} {L.red_energia}/s")
		}
		if edificio_flujo[ei]{
			ypos += 10
			var temp_text = ""
			if array_length(edificio_flujo_liquido[ei]) = 0
				temp_text = L.flujo_liquido
			else
				for(a = 0; a < array_length(edificio_flujo_liquido[ei]); a++)
					temp_text += (temp_text = "" ? "" : " & ") + liquido_nombre[edificio_flujo_liquido[ei, a]]
			if edificio_flujo_consumo[ei] > 0
				ypos = draw_text_ypos(xpos + 10, ypos, $"{L.enciclopedia_consume} {edificio_flujo_consumo[ei]} {temp_text}/s")
			else if edificio_flujo_consumo[ei] < 0
				ypos = draw_text_ypos(xpos + 10, ypos, $"{L.enciclopedia_produce} {abs(edificio_flujo_consumo[ei])} {temp_text}/s")
		}
		if ((_tecnologia and edificio_tecnologia[ei]) or cheat) and draw_boton(xpos + 10, ypos + 40, L.enciclopedia_construir, ui_verde,,,, _this_input_layer){
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
		if _tecnologia and tecnologia{
			sprite_boton_text = ""
			var size = array_length(tecnologia_prev[ei])
			xpos = 800
			ypos = 200
			for(a = 0; a < size; a++){
				b = tecnologia_prev[ei, a]
				if edificio_tecnologia[b]
					draw_set_color(c_green)
				else if edificio_tecnologia_desbloqueable[b]
					draw_set_color(c_yellow)
				else
					draw_set_color(c_red)
				draw_line(xpos + 50 * a - 25 * (size - 1), ypos, xpos + 10, ypos + 100)
				draw_circle(xpos + 50 * a - 25 * (size - 1), ypos, 25, false)
				draw_set_color(c_black)
				draw_circle(xpos + 50 * a - 25 * (size - 1), ypos, 25, true)
				if draw_sprite_boton(edificio_sprite[b],, xpos - 20 + 50 * a - 25 * (size - 1), ypos - 20, 40, 40,, hover_sprite_boton_text, {a : edificio_nombre[b]}){
					enciclopedia_link(4, b)
					return [xpos, ypos]
				}
				draw_text_background(mouse_x + 20, mouse_y, sprite_boton_text)
			}
			size = array_length(tecnologia_next[ei])
			for(a = 0; a < size; a++){
				b = tecnologia_next[ei, a]
				if edificio_tecnologia[b]
					draw_set_color(c_green)
				else if edificio_tecnologia_desbloqueable[b]
					draw_set_color(c_yellow)
				else
					draw_set_color(c_red)
				draw_line(xpos + 50 * a - 25 * (size - 1), ypos + 200, xpos + 10, ypos + 100)
				draw_circle(xpos + 50 * a - 25 * (size - 1), ypos + 200, 25, false)
				draw_set_color(c_black)
				draw_circle(xpos + 50 * a - 25 * (size - 1), ypos + 200, 25, true)
				if draw_sprite_boton(edificio_sprite[b],, xpos - 20 + 50 * a - 25 * (size - 1), ypos + 180, 40, 40,, hover_sprite_boton_text, {a : edificio_nombre[b]}){
					enciclopedia_link(4, b)
					return [xpos, ypos]
				}
				draw_text_background(mouse_x + 20, mouse_y, sprite_boton_text)
			}
			if edificio_tecnologia[ei]
				draw_set_color(c_green)
			else if edificio_tecnologia_desbloqueable[ei]{
				var flag = true, temp_text = ""
				if not cheat
					for(a = 0; a < array_length(tecnologia_precio_id[ei]); a++){
						temp_text += $"\n{recurso_nombre[tecnologia_precio_id[ei, a]]}: {tecnologia_precio_num[ei, a]}"
						if jugador_recursos[0, tecnologia_precio_id[ei, a]] < tecnologia_precio_num[ei, a]{
							flag = false
							temp_text += " !!"
						}
					}
				draw_set_valign(fa_middle)
				if draw_boton(xpos + 100, ypos + 100, (flag ? L.enciclopedia_investigar : L.almacen_sin_recursos) + temp_text, flag ? ui_verde : ui_rojo,,,, _this_input_layer) and flag
					investigar(ei)
				draw_set_valign(fa_top)
				draw_set_color(c_yellow)
			}
			else
				draw_set_color(c_red)
			draw_circle(xpos + 10, ypos + 100, 25, false)
			draw_set_color(c_black)
			draw_circle(xpos + 10, ypos + 100, 25, true)
			draw_sprite_stretched(edificio_sprite[ei], 0, xpos - 20, ypos + 80, 40, 40)
		}
		return [xpos, ypos]
	}
}