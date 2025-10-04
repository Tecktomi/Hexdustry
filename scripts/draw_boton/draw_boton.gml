function draw_boton(x, y, texto, back_color = c_white, text_color = c_black, boton = mb_left, box = true){
	if texto = ""
		return
	var color = draw_get_color(), width = string_width(texto), height = string_height(texto)
	var xx = draw_get_halign() = fa_left ? 0 : (draw_get_halign() = fa_center ? width / 2 : width)
	var yy = draw_get_valign() = fa_top ? 0 : (draw_get_valign() = fa_middle ? height / 2 : height)
	if box{
		draw_set_color(back_color)
		draw_rectangle(x - xx, y - yy, x + width + 8 - xx, y + height + 8 - yy, false)
	}
	draw_set_color(text_color)
	if box{
		draw_rectangle(x - xx, y - yy, x + width + 8 - xx, y + height + 8 - yy, true)
		draw_text(x + 4, y + 4, texto)
	}
	else
		draw_text(x, y, texto)
	draw_set_color(color)
	if mouse_x > x - xx and mouse_y > y - yy and ((box and mouse_x < x + width + 8 - xx and mouse_y < y + height + 8 - yy) or (not box and mouse_x < x + width - xx and mouse_y < y + height - yy)){
		control.cursor = cr_handpoint
		if mouse_check_button_pressed(boton){
			mouse_clear(mb_left)
			return true
		}
	}
	return false
}