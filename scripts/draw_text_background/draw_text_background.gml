function draw_text_background(x, y, text, sprites = false, dinamic = true){
	if control.grafic_hideui or text = ""
		return undefined
	if string_starts_with(text, "\n")
		text = string_delete(text, 1, 1)
	var markers = [], a, pos, kw, kwlen, matched, matched_len, r, scan_from
	if sprites{
		pos = string_pos_ext("/", text, 1)
		scan_from = 1
		while pos != 0{
			matched = -1
			for(a = 0; a < rss_max; a++){
				r = recurso_keyword_orden[a]
				kw = recurso_keyword[r]
				kwlen = string_length(kw)
				if string_copy(text, pos + 1, kwlen) = kw{
					matched = r
					matched_len = kwlen
					break
				}
			}
			if matched != -1{
				array_push(markers, {rss: matched, pos: pos})
				text = string_copy(text, 1, pos - 1) + "   " + string_copy(text, pos + matched_len + 1, string_length(text) - pos - matched_len)
				scan_from = pos + 3
			}
			else
				scan_from = pos + 1
			pos = string_pos_ext("/", text, scan_from)
		}
	}
	var color = draw_get_color(), height = string_height(text), width = string_width(text)
	var halign = draw_get_halign()
	var xx = halign = fa_left ? 0 : (halign = fa_center ? width / 2 : width)
	var yy = draw_get_valign() = fa_top ? 0 : (draw_get_valign() = fa_middle ? height / 2 : height)
	if dinamic{
		x = clamp(x, xx, room_width + xx - width)
		y = clamp(y, yy, room_height + yy - height)
	}
	draw_set_color(ui_sombra)
	draw_set_alpha(0.5)
	draw_rectangle(x - xx, y - yy, x + width - xx, y + height - yy, false)
	draw_set_alpha(1)
	draw_rectangle(x - xx, y - yy, x + width - xx, y + height - yy, true)
	draw_set_color(ui_texto)
	draw_text(x, y, text)
	if sprites{
		var line_height = string_height("A"), text_len = string_length(text)
		var line_num = 0, line_start = 1, nl2 = string_pos_ext("\n", text, 1), m, line_end, line_width, xx_line, x_off
		for(a = 0; a < array_length(markers); a++){
			m = markers[a]
			while nl2 != 0 and nl2 < m.pos{
				line_num++
				line_start = nl2 + 1
				nl2 = string_pos_ext("\n", text, nl2 + 1)
			}
			line_end = (nl2 = 0) ? text_len + 1 : nl2
			line_width = string_width(string_copy(text, line_start, line_end - line_start))
			xx_line = halign = fa_left ? 0 : (halign = fa_center ? line_width / 2 : line_width)
			x_off = string_width(string_copy(text, line_start, m.pos - line_start))
			draw_sprite(recurso_sprite[m.rss], 0, x + x_off - xx_line + 10, y + (line_num + 1) * line_height - yy - 10)
		}
	}
	draw_set_color(color)
}