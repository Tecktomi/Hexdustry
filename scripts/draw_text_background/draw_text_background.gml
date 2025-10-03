function draw_text_background(x, y, text){
	if text = ""
		return
	var color = draw_get_color(), width = string_width(text), height = string_height(text)
	var xx = draw_get_halign() = fa_left ? 0 : (draw_get_halign() = fa_center ? width / 2 : width)
	var yy = draw_get_valign() = fa_top ? 0 : (draw_get_valign() = fa_middle ? height / 2 : height)
	draw_set_color(c_black)
	draw_set_alpha(0.5)
	draw_rectangle(x - xx, y - yy, x + width - xx, y + height - yy, false)
	draw_set_alpha(1)
	draw_rectangle(x - xx, y - yy, x + width - xx, y + height - yy, true)
	draw_set_color(c_white)
	draw_text(x, y, text)
	draw_set_color(color)
}