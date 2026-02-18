function draw_text_background(x, y, text, sprites = false, dinamic = true){
	if control.grafic_hideui or text = ""
		return undefined
	var color = draw_get_color(), height = string_height(text)
	if sprites
		var width = draw_text_sprites(x, y, text, true)
	else
		width = string_width(text)
	var xx = draw_get_halign() = fa_left ? 0 : (draw_get_halign() = fa_center ? width / 2 : width)
	var yy = draw_get_valign() = fa_top ? 0 : (draw_get_valign() = fa_middle ? height / 2 : height)
	if dinamic{
		x = clamp(x, xx, room_width + xx - width)
		y = clamp(y, yy, room_height + yy - height)
	}
	draw_set_color(c_black)
	draw_set_alpha(0.5)
	draw_rectangle(x - xx, y - yy, x + width - xx, y + height - yy, false)
	draw_set_alpha(1)
	draw_rectangle(x - xx, y - yy, x + width - xx, y + height - yy, true)
	draw_set_color(c_white)
	if sprites
		draw_text_sprites(x, y, text)
	else
		draw_text(x, y, text)
	draw_set_color(color)
}