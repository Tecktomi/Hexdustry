function scroll_enciclopedia_drones(a = 0, param = {xpos : 140, ypos : 0, _this_input_layer : 0}){
	with control{
		draw_sprite_stretched(dron_sprite[dron_sort[a]], 0, param.xpos - 20, param.ypos, devise ? 18 : 36, devise ? 18 : 36)
		if draw_boton(param.xpos, param.ypos, dron_nombre[dron_sort[a]],,,, false, param._this_input_layer)
			enciclopedia_link(6, dron_sort[a])
		param.ypos += editor_item_size
	}
	return -1
}