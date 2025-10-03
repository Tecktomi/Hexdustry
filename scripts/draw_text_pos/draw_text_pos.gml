function draw_text_pos(x, y, text){
	draw_text(x, y, text)
	control.text_x = string_width(text)
	control.text_y = string_height(text)
	return y + control.text_y
}