function scr_draw_enrutador(edificio = control.null_edificio){
	with control{
		var index = edificio.index, dir = edificio.dir, aa = edificio.x, bb = edificio.y
		var d = image_index >> 1
		if index = id_cinta_magnetica
			d = image_index
		if (dir mod 3) = 1
			draw_sprite_off(edificio_sprite[index], d, aa, bb,, edificio.yscale)
		else
			draw_sprite_off(edificio_sprite_2[index], d, aa, bb, edificio.xscale, edificio.yscale)
	}
}