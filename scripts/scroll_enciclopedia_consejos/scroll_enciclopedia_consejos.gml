function scroll_enciclopedia_consejos(a = 0, param = {xpos : 140, ypos : 0, _this_input_layer : 0}){
	with control{
		if draw_boton(param.xpos, param.ypos, consejos_nombre[a],,,, false, param._this_input_layer)
			enciclopedia_link(9, a)
		param.ypos += editor_item_size
	}
	return -1
}