function scr_draw_enrutador(edificio = control.null_edificio, offset_x = 0, offset_y = 0){
	with control
		draw_sprite_off(
			((edificio.dir mod 3) = 1) ? edificio_sprite[edificio.index] : edificio_sprite_2[edificio.index],
			(edificio.index = id_cinta_rapida) ? image_index : image_index >> 1,
			edificio.x + offset_x, edificio.y + offset_y, edificio.xscale, edificio.yscale)
}