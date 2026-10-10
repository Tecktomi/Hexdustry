function draw_mision_texto(minx = 0){
	with control{
		if array_length(mision.texto) > 0{
			if mision_text_hide{
				if draw_sprite_boton(spr_arriba, 0, room_width - 120, room_height - 50, 40, 40)
					mision_text_hide = false
			}
			else{
				draw_set_color(ui_fondo)
				draw_set_alpha(0.5)
				draw_rectangle(minx + 80, room_height - 100, room_width - 80, room_height - 10, false)
				draw_set_color(ui_texto)
				draw_set_alpha(1)
				draw_rectangle(minx + 80, room_height - 100, room_width - 80, room_height - 10, true)
				draw_text(minx + 90, room_height - 90, text_wrap(mision.texto[mision_text, idioma], room_width - (180 + minx)))
				if draw_sprite_boton(spr_abajo, 0, room_width - 120, room_height - 50, 40, 40)
					mision_text_hide = true
				if mouse_x > minx + 80 and mouse_y > room_height - 100 and mouse_x < room_width - 80 and mouse_y < room_height - 10{
					if mouse_check_button_pressed(mb_left){
						mouse_clear(mb_left)
						if mision_text < array_length(mision.texto) - 1
							mision_text++
					}
					if mouse_check_button_pressed(mb_right){
						mouse_clear(mb_right)
						if mision_text > 0
							mision_text--
					}
				}
			}
		}
	}
}