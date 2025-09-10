function deslizante(x1, x2, y, val, val_min, val_max){
	draw_line(x1, y, x2, y)
	draw_circle(x1 + (x2 - x1) * (val - val_min) / (val_max - val_min), y, 4, false)
	if mouse_x > x1 - 5 and mouse_y > y - 5 and mouse_x <  x2 + 5 and mouse_y < y + 5{
		cursor = cr_handpoint
		if mouse_check_button(mb_left){
			mouse_clear(mb_left)
			return (mouse_x - x1) / (x2 - x1) * (val_max - val_min) + val_min
		}
	}
	return val
}