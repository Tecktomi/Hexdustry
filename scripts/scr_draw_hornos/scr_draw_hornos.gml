function scr_draw_hornos(edificio = control.null_edificio){
	with control{
		var index = edificio.index, dir = edificio.dir, aa = edificio.x, bb = edificio.y
		if edificio.fuel > 0
			draw_sprite_off(edificio_sprite_2[index], image_index << 2, aa, bb, edificio.array_real[2] / 8)
		else
			scr_draw_default(edificio)
	}
}