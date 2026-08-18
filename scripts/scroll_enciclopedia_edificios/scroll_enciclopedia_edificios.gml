function scroll_enciclopedia_edificios(a = 0, param = {xpos : 140, ypos : 0, _this_input_layer : 0}){
	with control{
		draw_sprite_stretched(edificio_sprite[edi_sort[a]], 0, param.xpos - 20, param.ypos, DEVISE ? 18 : 36, DEVISE ? 18 : 36)
		if draw_boton(param.xpos + 10, param.ypos, edificio_nombre[edi_sort[a]],,,, false, param._this_input_layer)
			enciclopedia_link(4, edi_sort[a])
		param.ypos += editor_item_size
	}
	return -1
}