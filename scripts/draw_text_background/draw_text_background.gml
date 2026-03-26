function draw_text_background(x, y, text, sprites = false, dinamic = true){
	if control.grafic_hideui or text = ""
		return undefined
	var sprite_pos
	if sprites{
		for(var a = 0; a < rss_max; a++){
			var temp_text = text
			for(var b = 0; b < rss_max; b++)
				if a != b
					temp_text = string_replace_all(temp_text, $"/{recurso_keyword[b]}", "   ")
			sprite_pos[a] = string_pos_all(temp_text, $"/{recurso_keyword[a]}")
		}
		for(var a = 0; a < rss_max; a++)
			text = string_replace_all(text, $"/{recurso_keyword[a]}", "   ")
	}
	if string_starts_with(text, "\n")
		text = string_delete(text, 1, 2)
	var color = draw_get_color(), height = string_height(text), width = string_width(text)
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
	draw_text(x, y, text)
	if sprites{
		for(var a = 0; a < rss_max; a++){
			var len = string_length(text)
			for(var b = 0; b < array_length(sprite_pos[a]); b++){
				var substring = string_delete(text, sprite_pos[a, b], len), altura = string_height(substring)
				while string_pos("\n", substring)
					substring = string_delete(substring, 1, string_pos("\n", substring))
				draw_sprite(recurso_sprite[a], 0, x + string_width(substring) - xx - 10, y + altura - yy - 10)
			}
		}
	}
	draw_set_color(color)
}