function draw_text_xpos(x, y, text){
	draw_text(x, y, text)
	control.text_x = string_width(text)
	control.text_y = string_height(text)
	return x + control.text_x
}