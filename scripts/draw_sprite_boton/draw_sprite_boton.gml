function draw_sprite_boton(sprite, x, y, width = 32, height = 28, text = ""){
	draw_sprite_stretched(sprite, 0, x, y, width, height)
	if mouse_x > x and mouse_y > y and mouse_x < x + width and mouse_y < y + height{
		control.cursor = cr_handpoint
		sprite_boton_text = text
		if mouse_check_button_pressed(mb_left){
			mouse_clear(mb_left)
			return true
		}
	}
	return false
}