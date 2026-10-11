function scr_draw_bateria(edificio = control.null_edificio, offset_x = 0, offset_y = 0){
	draw_sprite_off(control.edificio_sprite[edificio.index], floor(10 * edificio.red.bateria / edificio.red.bateria_max), edificio.x + offset_x, edificio.y + offset_y)
}