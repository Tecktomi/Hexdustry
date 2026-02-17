function scr_draw_overflow(edificio = control.null_edificio){
	with control{
		var dir = edificio.dir, aa = edificio.x, bb = edificio.y
		draw_sprite_off(edificio_sprite[id_selector], real(edificio.mode), aa, bb,,, edificio.draw_rot)
	}
}