function scr_draw_camino(edificio = control.null_edificio){
	with control{
		var index = edificio.index, dir = edificio.dir, aa = edificio.x, bb = edificio.y
		draw_sprite_off(edificio_sprite[index], image_index << 2, aa, bb,,, edificio.draw_rot)
	}
}