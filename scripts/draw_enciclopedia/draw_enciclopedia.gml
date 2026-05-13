function draw_enciclopedia(_tecnologia = true, _this_input_layer = 0){
	with control{
		draw_set_halign(fa_left)
		draw_set_color(c_gray)
		draw_rectangle(100, 100, room_width - 100, room_height - 100, false)
		draw_set_color(c_black)
		draw_rectangle(100, 100, room_width - 100, room_height - 100, true)
		var width = 100, ypos = 100
		if draw_boton(width, ypos, L.enciclopedia_recursos,,,,, _this_input_layer){
			deslizante[0] = 0
			enciclopedia = 1
		}
		width += text_x + 20
		if draw_boton(width, ypos, L.enciclopedia_edificios,,,,, _this_input_layer){
			deslizante[0] = 0
			enciclopedia = 2
		}
		width += text_x + 20
		if draw_boton(width, ypos, L.enciclopedia_unidades,,,,, _this_input_layer){
			deslizante[0] = 0
			enciclopedia = 5
		}
		width += text_x + 20
		if _tecnologia and tecnologia and draw_boton(width, ypos, L.enciclopedia_tecnologia,,,,, _this_input_layer){
			deslizante[0] = 0
			enciclopedia = 7
		}
		ypos += text_y * 1.2
		//Menú Recursos
		if enciclopedia = 1
			scroll(120, ypos, rss_max, editor_max_height, editor_item_size, scroll_enciclopedia_recursos, {xpos : 140, ypos : ypos, _this_input_layer : _this_input_layer}, 0)
		//Menú Edificios
		else if enciclopedia = 2
			scroll(120, ypos, edificio_max, editor_max_height, editor_item_size, scroll_enciclopedia_edificios, {xpos : 140, ypos : ypos, _this_input_layer : _this_input_layer})
		//Detalles Recurso
		else if enciclopedia = 3
			draw_panel(120, ypos, room_width - 240, room_height - 120 - ypos, 0, 1, 1, panel_enciclopedia_recurso, {_this_input_layer : _this_input_layer})
		//Detalles Edificio
		else if enciclopedia = 4
			draw_panel(120, ypos, room_width - 240, room_height - 120 - ypos, 0, 1, 1, panel_enciclopedia_edificio, {_this_input_layer : _this_input_layer, _tecnologia : _tecnologia})
		//Menú Unidades
		else if enciclopedia = 5
			scroll(120, ypos, dron_max, editor_max_height, editor_item_size, scroll_enciclopedia_drones, {xpos : 140, ypos : ypos, _this_input_layer : _this_input_layer})
		//Detalles Dron
		else if enciclopedia = 6{
			draw_set_font(font_titulo)
			ypos = draw_text_ypos(120, ypos, dron_nombre[enciclopedia_item])
			draw_set_font(font_normal)
			ypos = draw_text_ypos(120, ypos, dron_descripcion[enciclopedia_item])
			ypos = draw_text_ypos(120, ypos, $"{L.enciclopedia_vida}: {dron_vida_max[enciclopedia_item]}")
			if dron_aereo[enciclopedia_item]
				ypos = draw_text_ypos(140, ypos, L.enciclopedia_aerea)
			if array_length(dron_precio_id[enciclopedia_item]) > 0{
				ypos += 10
				ypos = draw_text_ypos(120, ypos, $"{L.enciclopedia_coste_construccion}:")
				for(var a = 0; a < array_length(dron_precio_id[enciclopedia_item]); a++){
					if draw_boton(140, ypos, $"{dron_precio_num[enciclopedia_item, a]} {recurso_nombre[dron_precio_id[enciclopedia_item, a]]}",,,, false, _this_input_layer){
						enciclopedia_item = dron_precio_id[enciclopedia_item, a]
						enciclopedia = 3
						exit
					}
					ypos += 20
				}
			}
			draw_sprite_ext(dron_sprite[enciclopedia_item], image_index / 2, room_width - 200, 200, 2, 2, 0, c_white, 1)
			draw_sprite_ext(dron_sprite_color[enciclopedia_item], image_index / 2, room_width - 200, 200, 2, 2, 0, c_white, 1)
		}
		//Tecnología
		else if enciclopedia = 7{
			sprite_boton_text = ""
			var xpos = room_width / 2
			draw_set_font(font_titulo)
			ypos = draw_text_ypos(120, ypos, L.enciclopedia_tecnologia)
			draw_set_font(font_normal)
			ypos = 140
			for(var a = 0; a < array_length(tecnologia_nivel_edificios); a++){
				ypos += 60
				width = array_length(tecnologia_nivel_edificios[a])
				for(b = 0; b < width; b++){
					var c = tecnologia_nivel_edificios[a, b]
					if edificio_tecnologia[c]
						draw_set_color(c_green)
					else if edificio_tecnologia_desbloqueable[c]
						draw_set_color(c_yellow)
					else
						draw_set_color(c_red)
					draw_circle(xpos + 60 * b - 30 * (width - 1), ypos, 25, false)
					draw_set_color(c_black)
					draw_circle(xpos + 60 * b - 30 * (width - 1), ypos, 25, true)
					if draw_sprite_boton(edificio_sprite[c],, xpos - 20 + 60 * b - 30 * (width - 1), ypos - 20, 40, 40,, hover_sprite_boton_text, {a : edificio_nombre[c]}){
						enciclopedia_item = c
						enciclopedia = 4
						exit
					}
				}
			}
			draw_text_background(mouse_x + 20, mouse_y, sprite_boton_text)
		}
		if keyboard_check_pressed(vk_escape) or keyboard_check_pressed(CONTROL_ENCICLOPEDIA) or mouse_check_button_pressed(mb_right) or (mouse_check_button_pressed(mb_left) and (mouse_x < 100 or mouse_y < 100 or mouse_x > room_width - 100 or mouse_y > room_height - 100)){
			mouse_clear(mouse_lastbutton)
			keyboard_clear(vk_escape)
			keyboard_clear(CONTROL_ENCICLOPEDIA)
			enciclopedia = false
		}
		update_cursor()
	}
}