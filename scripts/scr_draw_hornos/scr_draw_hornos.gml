function scr_draw_hornos(edificio = control.null_edificio, offset_x = 0, offset_y = 0){
	if edificio.fuel > 0
		draw_sprite_off(control.edificio_sprite_2[edificio.index], image_index << 2, edificio.x + offset_x, edificio.y + offset_y, edificio.xscale)
	else
		scr_draw_default(edificio)
}