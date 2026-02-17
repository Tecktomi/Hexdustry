function scr_draw_liquido_sin_bomba(edificio = control.null_edificio, offset_x = 0, offset_y = 0){
	with control{
		var index = edificio.index, dir = edificio.dir, aa = edificio.x + offset_x, bb = edificio.y + offset_y
		draw_sprite_off(edificio_sprite[index], 0, aa, bb)
		if edificio.flujo.liquido = -1
			draw_sprite_off(edificio_sprite_2[index], 0, aa, bb)
		else
			draw_sprite_off(edificio_sprite_2[index], 0, aa, bb,,,, liquido_color[edificio.flujo.liquido], edificio.flujo.almacen / edificio.flujo.almacen_max)
	}
}