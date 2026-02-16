function draw_boton(x, y, texto, back_color = control.ui_boton_gris, text_color = control.ui_texto, boton = mb_left, box = true, input_layer = 0, round_box = true){
	with control{
		if texto = ""
			return false
		var color = draw_get_color(), width = string_width(texto), height = string_height(texto)
		var xx = draw_get_halign() = fa_left ? 0 : (draw_get_halign() = fa_center ? width / 2 : width)
		var yy = draw_get_valign() = fa_top ? 0 : (draw_get_valign() = fa_middle ? height / 2 : height)
		if box{
			draw_set_color(back_color)
			if round_box{
				draw_roundrect(x - xx, y - yy, x + width + 8 - xx, y + height + 8 - yy, false)
				draw_set_color(ui_sombra)
				draw_roundrect(x - xx, y - yy, x + width + 8 - xx, y + height + 8 - yy, true)
			}
			else{
				draw_rectangle(x - xx, y - yy, x + width + 8 - xx, y + height + 8 - yy, false)
				draw_set_color(ui_sombra)
				draw_rectangle(x - xx, y - yy, x + width + 8 - xx, y + height + 8 - yy, true)
			}
		}
		draw_set_color(text_color)
		if box{
			draw_text(x + 4, y + 4, texto)
			text_x = width + 8
			text_y = height + 8
		}
		else{
			draw_text(x, y, texto)
			text_x = width
			text_y = height
		}
		draw_set_color(color)
		if input_layer = control.input_layer and mouse_x > x - xx and mouse_y > y - yy and ((box and mouse_x < x + width + 8 - xx and mouse_y < y + height + 8 - yy) or (not box and mouse_x < x + width - xx and mouse_y < y + height - yy)){
			cursor = cr_handpoint
			if not box
				draw_line(x - xx, y + height - 4, x - xx + width, y + height - 4)
			if mouse_check_button_pressed(boton){
				mouse_clear(boton)
				return true
			}
		}
		return false
	}
}