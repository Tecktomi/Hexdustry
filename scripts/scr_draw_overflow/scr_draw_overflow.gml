function scr_draw_overflow(edificio = control.null_edificio, offset_x = 0, offset_y = 0){
	draw_sprite_off(control.edificio_sprite[control.id_selector], real(edificio.mode), edificio.x + offset_x, edificio.y + offset_y,,, edificio.draw_rot)
}