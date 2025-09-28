function draw_text_background(x, y, text){
	var color = draw_get_color()
	draw_set_color(c_black)
	draw_set_alpha(0.5)
	draw_rectangle(x, y, x + string_width(text) * (draw_get_halign() = fa_left ? 1 : -1), y + string_height(text), false)
	draw_set_alpha(1)
	draw_set_color(c_white)
	draw_text(x, y, text)
	draw_set_color(color)
}