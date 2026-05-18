function panel_enciclopedia_dron(xpos = 0, ypos = 0, param = {_this_input_layer : 0}){
	with control{
		var ei = enciclopedia_item, _this_input_layer = param._this_input_layer
		draw_set_font(font_titulo)
		ypos = draw_text_ypos(120, ypos, dron_nombre[ei])
		draw_set_font(font_normal)
		ypos = draw_text_ypos(120, ypos, dron_descripcion[ei])
		ypos = draw_text_ypos(120, ypos, $"{L.enciclopedia_vida}: {dron_vida_max[ei]}")
		if dron_aereo[ei]
			ypos = draw_text_ypos(140, ypos, L.enciclopedia_aerea)
		if array_length(dron_precio_id[ei]) > 0{
			ypos += 10
			ypos = draw_text_ypos(120, ypos, $"{L.enciclopedia_coste_construccion}:")
			for(var a = 0; a < array_length(dron_precio_id[ei]); a++){
				if draw_boton(140, ypos, $"{dron_precio_num[ei, a]} {recurso_nombre[dron_precio_id[ei, a]]}",,,, false, _this_input_layer){
					enciclopedia_link(3, dron_precio_id[ei, a])
					return [xpos, ypos]
				}
				ypos += 20
			}
		}
		draw_sprite_ext(dron_sprite[ei], image_index / 2, room_width - 200, 200, 2, 2, 0, c_white, 1)
		draw_sprite_ext(dron_sprite_color[ei], image_index / 2, room_width - 200, 200, 2, 2, 0, c_white, 1)
		return [xpos, ypos]
	}
}