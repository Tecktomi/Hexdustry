function draw_sprite_boton(sprite, x, y){
	var width = sprite_get_width(sprite), height = sprite_get_height(sprite)
	draw_sprite(sprite, 0, x + width / 2, y + height / 2)
	if mouse_x > x and mouse_y > y and mouse_x < x + width and mouse_y < y + height{
		control.cursor = cr_handpoint
		if mouse_check_button_pressed(mb_left){
			mouse_clear(mb_left)
			return true
		}
	}
	return false
}