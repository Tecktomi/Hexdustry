function panel_enciclopedia_tecnologia(xpos = 0, ypos = 0, param = {_this_input_layer : 0}){
	with control{
		var _this_input_layer = param._this_input_layer, a, b, c, width
		sprite_boton_text = ""
		draw_set_font(font_titulo)
		ypos = draw_text_ypos(120, ypos, L.enciclopedia_tecnologia)
		draw_set_font(font_normal)
		for(a = 0; a < array_length(tecnologia_nivel_edificios); a++){
			ypos += 60
			width = array_length(tecnologia_nivel_edificios[a])
			for(b = 0; b < width; b++){
				c = tecnologia_nivel_edificios[a, b]
				if edificio_tecnologia[jugador, c]
					draw_set_color(ui_boton_verde)
				else if edificio_tecnologia_desbloqueable[jugador, c]
					draw_set_color(ui_color_lava)
				else
					draw_set_color(ui_boton_rojo)
				draw_circle(room_width / 2 + 60 * b - 30 * (width - 1), ypos, 25, false)
				draw_set_color(ui_fondo)
				draw_circle(room_width / 2 + 60 * b - 30 * (width - 1), ypos, 25, true)
				if draw_sprite_boton(edificio_sprite[c],, room_width / 2 - 20 + 60 * b - 30 * (width - 1), ypos - 20, 40, 40, _this_input_layer, hover_sprite_boton_text, {a : edificio_nombre[c]}){
					enciclopedia_link(4, c)
					return [xpos, ypos]
				}
			}
		}
		ypos += 60
		draw_text_background(mouse_x + 20, mouse_y, sprite_boton_text)
		return [xpos, ypos]
	}
}