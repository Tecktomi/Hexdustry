function scr_draw_cinta_transportadora(edificio = control.null_edificio){
	with control{
		var dir = edificio.dir, aa = edificio.x, bb = edificio.y
		draw_sprite_off(camino_general[dir, edificio.array_real[4]], image_index >> 1, aa, bb)
	}
}