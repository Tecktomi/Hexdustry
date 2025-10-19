function draw_deslizante_vertical(x, y1, y2, val, val_min, val_max, id, input_layer = 0){
	draw_line(x, y1, x, y2)
	draw_circle(x, y1 + (y2 - y1) * (val - val_min) / (val_max - val_min), 4, false)
	if control.input_layer = input_layer and mouse_x > x - 3 and mouse_y > y1 - 5 and mouse_x <  x + 3 and mouse_y < y2 + 5{
		control.cursor = cr_handpoint
		if mouse_check_button_pressed(mb_left)
			control.deslizante_id = id
	}
	if control.deslizante_id = id{
		control.cursor = cr_handpoint
		if mouse_check_button_released(mb_left)
			control.deslizante_id = -1
		return clamp((mouse_y - y1) / (y2 - y1) * (val_max - val_min) + val_min, val_min, val_max)
	}
	return real(val)
}