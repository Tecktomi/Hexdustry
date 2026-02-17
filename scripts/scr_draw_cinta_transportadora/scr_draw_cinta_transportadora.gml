function scr_draw_cinta_transportadora(edificio = control.null_edificio, offset_x = 0, offset_y = 0){
	with control{
		var dir = edificio.dir, aa = edificio.x + offset_x, bb = edificio.y + offset_y
		draw_sprite_off(camino_general[dir, edificio.array_real[4]], image_index >> 1, aa, bb)
	}
}