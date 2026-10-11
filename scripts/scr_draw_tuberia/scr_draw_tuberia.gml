function scr_draw_tuberia(edificio = control.null_edificio, offset_x = 0, offset_y = 0){
	with control{
		var index = edificio.index, _x = edificio.x + offset_x, _y = edificio.y + offset_y
		draw_sprite_off(edificio_sprite[index], edificio.select, _x, _y)
		if edificio.flujo.liquido = -1
			draw_sprite_off(edificio_sprite_2[index], edificio.select, _x, _y)
		else
			draw_sprite_off(edificio_sprite_2[index], edificio.select, _x, _y,,,, liquido_color[edificio.flujo.liquido], edificio.flujo.almacen / edificio.flujo.almacen_max)
	}
}