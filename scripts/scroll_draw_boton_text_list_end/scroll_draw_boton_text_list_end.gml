function scroll_draw_boton_text_list_end(a = 0, param = {xpos : 0, ypos : 0}){
	draw_boton(param.xpos, param.ypos, editor_array_name[editor_array[a]],,,, false, 1)
	param.ypos += text_y
	return -1
}