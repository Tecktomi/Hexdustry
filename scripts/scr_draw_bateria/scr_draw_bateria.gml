function scr_draw_bateria(edificio = control.null_edificio){
	with control{
		var index = edificio.index, dir = edificio.dir, aa = edificio.x, bb = edificio.y
		draw_sprite_off(edificio_sprite[index], floor(10 * edificio.red.bateria / edificio.red.bateria_max), aa, bb)
	}
}