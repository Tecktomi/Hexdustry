function panel_enciclopedia_recurso(xpos = 0, ypos = 0, param = {_this_input_layer : 0}){
	with control{
		var ei = enciclopedia_item, _this_input_layer = param._this_input_layer
		draw_set_font(font_titulo)
		ypos = draw_text_ypos(xpos + 10, ypos, recurso_nombre[ei])
		draw_set_font(font_normal)
		ypos = draw_text_ypos(xpos + 10, ypos, recurso_descripcion[ei])
		if recurso_combustion[ei]
			ypos = draw_text_ypos(xpos + 10, ypos, $"{L.enciclopedia_combustible} {recurso_combustion_time[ei] / 60}[s]")
		ypos = draw_text_ypos(xpos + 10, ypos, L.enciclopedia_usado_en)
		var a, b, aa
		for(a = 0; a < edificio_max; a++){
			aa = edi_sort[a]
			for(b = 0; b < array_length(edificio_input_id[aa]); b++)
				if edificio_input_id[aa, b] = ei{
					if draw_boton(xpos + 20, ypos, edificio_nombre[aa],,,, false, _this_input_layer){
						enciclopedia_link(4, aa)
						return [xpos, ypos]
					}
					ypos += 20
					break
				}
		}
		ypos = draw_text_ypos(xpos + 10, ypos, $"{L.enciclopedia_producido_en}:")
		for(a = 0; a < edificio_max; a++){
			aa = edi_sort[a]
			for(b = 0; b < array_length(edificio_output_id[aa]); b++)
				if edificio_output_id[aa, b] = ei{
					if draw_boton(xpos + 20, ypos, edificio_nombre[aa],,,, false, _this_input_layer){
						enciclopedia_link(4, aa)
						return [xpos, ypos]
					}
					ypos += 20
					break
				}
		}
		var flag = false
		for(a = 0; a < edificio_max; a++){
			for(b = 0; b < array_length(edificio_precio_id[a]); b++)
				if edificio_precio_id[a, b] = ei{
					flag = true
					break
				}
			if flag
				break
		}
		if flag{
			ypos = draw_text_ypos(xpos + 10, ypos, $"{L.enciclopedia_necesario_para_construir}:")
			for(a = 0; a < edificio_max; a++){
				aa = edi_sort[a]
				for(b = 0; b < array_length(edificio_precio_id[aa]); b++)
					if edificio_precio_id[aa, b] = ei{
						if draw_boton(xpos + 20, ypos, edificio_nombre[aa],,,, false, _this_input_layer){
							enciclopedia_link(4, aa)
							return [xpos, ypos]
						}
						ypos += 20
						break
					}
			}
		}
		else
			ypos = draw_text_ypos(xpos + 10, ypos, L.enciclopedia_inutil)
		flag = false
		for(a = 0; a < dron_max; a++){
			for(b = 0; b < array_length(dron_precio_id[a]); b++)
				if dron_precio_id[a, b] = ei{
					flag = true
					break
				}
			if flag
				break
		}
		if flag{
			ypos = draw_text_ypos(xpos + 10, ypos, $"{L.enciclopedia_necesario_para_producir}:")
			for(a = 0; a < dron_max; a++)
				for(b = 0; b < array_length(dron_precio_id[a]); b++)
					if dron_precio_id[a, b] = ei{
						if draw_boton(xpos + 20, ypos, dron_nombre[a],,,, false, _this_input_layer){
							enciclopedia_link(6, a)
							return [xpos, ypos]
						}
						ypos += 20
						break
					}
		}
		draw_sprite_ext(recurso_sprite[ei], 0, room_width - 200, 200, 4, 4, 0, c_white, 1)
		return [xpos, ypos]
	}
}