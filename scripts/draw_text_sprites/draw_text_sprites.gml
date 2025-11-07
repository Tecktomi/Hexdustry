function draw_text_sprites(x, y, text, size = false){
    var linea = string_copy(text, 1, string_length(text)), xx = x, yy = y, height = string_height("a"), max_x = 0
	if size{
		while string_count("[", linea) + string_count("\n", linea) > 0{
			var a = string_pos("[", linea), b = string_pos("]", linea), c = string_pos("\n", linea)
			if a = 0 or c < a{
				var trozo = string_copy(linea, 1, c - 1)
				max_x = max(max_x, xx + string_width(trozo))
				xx = x
				yy += height
				linea = string_delete(linea, 1, c)
			}
			else{
				var trozo = string_copy(linea, 1, a - 1)
				xx += string_width(trozo) + 20
				linea = string_delete(linea, 1, b)
			}
		}
		control.text_x = max(max_x, xx + string_width(linea)) - xx
		control.text_y = yy - y
		return control.text_x
	}
	else{
		var lineas_total = string_split(linea, "\n", false), i = 0
		var desface = 0
		if draw_get_halign() != fa_left{
			desface = string_width(lineas_total[i++])
			if draw_get_halign() = fa_center
				desface /= 2
			x -= desface
		}
		while string_count("[", linea) + string_count("\n", linea) > 0{
			var a = string_pos("[", linea), b = string_pos("]", linea), c = string_pos("\n", linea)
			if a = 0 or c < a{
				var trozo = string_copy(linea, 1, c - 1)
				max_x = max(max_x, draw_text_xpos(xx, yy, trozo))
				if draw_get_halign() != fa_left{
					desface = string_width(lineas_total[i++])
					if draw_get_halign() = fa_center
						desface /= 2
					x -= desface
				}
				xx = x - desface
				yy += height
				linea = string_delete(linea, 1, c)
			}
			else{
				var trozo = string_copy(linea, 1, a - 1)
				xx = draw_text_xpos(xx, yy, trozo)
				draw_sprite(control.recurso_sprite[real(string_copy(linea, a + 1, b - a - 1))], 0, xx, yy + 10)
				xx += 20
				linea = string_delete(linea, 1, b)
			}
		}
		draw_text(xx, yy, linea)
	}
}
