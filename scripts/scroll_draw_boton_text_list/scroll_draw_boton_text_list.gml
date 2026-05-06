function scroll_draw_boton_text_list(a, param = {xpos : 0, ypos : 0, array : [0], array_name : [""], a : 0, color : c_black}){
	with control{
		if draw_boton(param.xpos, param.ypos, param.array_name[param.array[a]],,,, false, 1){
			get_keyboard_string = -1
			input_layer = 0
			text_x = param.a
			draw_set_color(param.color)
			return param.array[a]
		}
		param.ypos += text_y
	}
	return -1
}