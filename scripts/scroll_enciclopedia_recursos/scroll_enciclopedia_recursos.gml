function scroll_enciclopedia_recursos(a = 0, param = {xpos : 140, ypos : 0, _this_input_layer : 0}){
	with control{
		draw_sprite_stretched(recurso_sprite[rss_sort[a]], 0, param.xpos - 20, param.ypos + 10, devise ? 18 : 36, devise ? 18 : 36)
		if draw_boton(param.xpos, param.ypos, recurso_nombre[rss_sort[a]],,,, false, param._this_input_layer)
			enciclopedia_link(3, rss_sort[a])
		param.ypos += editor_item_size
	}
	return -1
}