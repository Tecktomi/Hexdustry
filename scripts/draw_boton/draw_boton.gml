function draw_boton(x, y, texto, back_color = c_white, text_color = c_black, boton = mb_left, box = true){
	var width = string_width(texto), height = string_height(texto), color = draw_get_color()
	if box{
		draw_set_color(back_color)
		draw_rectangle(x, y, x + width + 8, y + height + 8, false)
	}
	draw_set_color(text_color)
	if box{
		draw_rectangle(x, y, x + width + 8, y + height + 8, true)
		draw_text(x + 4, y + 4, texto)
	}
	else
		draw_text(x, y, texto)
	draw_set_color(color)
	if mouse_x > x and mouse_y > y and ((box and mouse_x < x + width + 8 and mouse_y < y + height + 8) or (not box and mouse_x < x + width and mouse_y < y + height)){
		control.cursor = cr_handpoint
		if mouse_check_button_pressed(boton){
			mouse_clear(mb_left)
			return true
		}
	}
	return false
}