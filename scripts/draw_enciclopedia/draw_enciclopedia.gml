function draw_enciclopedia(_tecnologia = true, _this_input_layer = 0){
	with control{
		draw_set_valign(fa_top)
		draw_set_halign(fa_left)
		draw_set_color(ui_fondo)
		draw_rectangle(100, 100, room_width - 100, room_height - 100, false)
		draw_set_color(ui_texto)
		draw_rectangle(100, 100, room_width - 100, room_height - 100, true)
		var width = 100, ypos = 100
		if draw_boton(width, ypos, L.enciclopedia_recursos,,,,, _this_input_layer)
			enciclopedia_link(1, 0)
		width += text_x + 20
		if draw_boton(width, ypos, L.enciclopedia_edificios,,,,, _this_input_layer)
			enciclopedia_link(2, 0)
		width += text_x + 20
		if draw_boton(width, ypos, L.enciclopedia_unidades,,,,, _this_input_layer)
			enciclopedia_link(5, 0)
		width += text_x + 20
		if _tecnologia and tecnologia{
			if draw_boton(width, ypos, L.enciclopedia_tecnologia,,,,, _this_input_layer)
				enciclopedia_link(7, 0)
			width += text_x + 20
		}
		if draw_boton(width, ypos, L.enciclopedia_consejos,,,,, _this_input_layer)
			enciclopedia_link(8, 0)
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
		else if enciclopedia = 6
			draw_panel(120, ypos, room_width - 240, room_height - 120 - ypos, 0, 1, 1, panel_enciclopedia_dron, {_this_input_layer : _this_input_layer, _tecnologia : _tecnologia})
		//Tecnología
		else if enciclopedia = 7
			draw_panel(120, ypos, room_width - 240, room_height - 120 - ypos, 0, 1, 1, panel_enciclopedia_tecnologia, {_this_input_layer : _this_input_layer})
		//Menú Consejos
		else if enciclopedia = 8
			scroll(120, ypos, array_length(consejos_nombre), editor_max_height, editor_item_size, scroll_enciclopedia_consejos, {xpos : 140, ypos : ypos, _this_input_layer : _this_input_layer}, 0)
		//Detalle Consejo
		else if enciclopedia = 9
			draw_panel(120, ypos, room_width - 240, room_height - 120 - ypos, 0, 1, 1, panel_enciclopedia_consejo, {_this_input_layer : _this_input_layer})
		if keyboard_check_pressed(vk_escape) or keyboard_check_pressed(CONTROL_ENCICLOPEDIA) or mouse_check_button_pressed(mb_right) or (mouse_check_button_pressed(mb_left) and (mouse_x < 100 or mouse_y < 100 or mouse_x > room_width - 100 or mouse_y > room_height - 100)){
			mouse_clear(mouse_lastbutton)
			keyboard_clear(vk_escape)
			keyboard_clear(CONTROL_ENCICLOPEDIA)
			enciclopedia = 0
		}
		update_cursor()
	}
}