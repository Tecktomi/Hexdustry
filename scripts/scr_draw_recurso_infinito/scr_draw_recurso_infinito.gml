function scr_draw_recurso_infinito(edificio = control.null_edificio){
	with control{
		var index = edificio.index, dir = edificio.dir, aa = edificio.x, bb = edificio.y
		draw_sprite_off(edificio_sprite[index], 0, aa, bb)
		if edificio.select >= 0
			draw_sprite_off(edificio_sprite_2[index], 0, aa, bb,,,, recurso_color[edificio.select])
	}
}