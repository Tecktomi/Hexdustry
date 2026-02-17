function scr_draw_tuberia(edificio = control.null_edificio){
	with control{
		var index = edificio.index, dir = edificio.dir, aa = edificio.x, bb = edificio.y
		draw_sprite_off(edificio_sprite[index], edificio.select, aa, bb)
		if edificio.flujo.liquido = -1
			draw_sprite_off(edificio_sprite_2[index], edificio.select, aa, bb)
		else
			draw_sprite_off(edificio_sprite_2[index], edificio.select, aa, bb,,,, liquido_color[edificio.flujo.liquido], edificio.flujo.almacen / edificio.flujo.almacen_max)
	}
}