function draw_sprite_boton(sprite, subindex = 0, x, y, width = -1, height = -1, this_input_layer = 0, hover_function = null_function, data = {}){
	with control{
		if width = -1
			width = sprite_get_width(sprite)
		if height = -1
			height = sprite_get_height(sprite)
		draw_sprite_stretched(sprite, subindex, x, y, width, height)
		text_x = width
		text_y = height
		if input_layer = this_input_layer and mouse_x > x and mouse_y > y and mouse_x < x + width and mouse_y < y + height{
			hover_function(data)
			cursor = cr_handpoint
			if mouse_check_button_pressed(mb_any){
				mouse_clear(mb_any)
				return true
			}
		}
		return false
	}
}