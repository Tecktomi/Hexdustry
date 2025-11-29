function draw_sprite_boton(sprite, x, y, width = 32, height = 28, text = "", input_layer = 0, subindex = 0){
	draw_sprite_stretched(sprite, subindex, x, y, width, height)
	if control.input_layer = input_layer and mouse_x > x and mouse_y > y and mouse_x < x + width and mouse_y < y + height{
		control.cursor = cr_handpoint
		sprite_boton_text = text
		if mouse_check_button_pressed(mb_any){
			mouse_clear(mb_any)
			return true
		}
	}
	return false
}