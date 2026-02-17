function scr_draw_bateria(edificio = control.null_edificio, offset_x = 0, offset_y = 0){
	with control{
		var index = edificio.index, dir = edificio.dir, aa = edificio.x + offset_x, bb = edificio.y + offset_y
		draw_sprite_off(edificio_sprite[index], floor(10 * edificio.red.bateria / edificio.red.bateria_max), aa, bb)
	}
}