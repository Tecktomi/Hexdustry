function scr_draw_default(edificio = control.null_edificio, offset_x = 0, offset_y = 0){
	with control{
		var index = edificio.index, _x = edificio.x + offset_x, _y = edificio.y + offset_y
		//Dibujo predeterminado tamaño par
		if edificio_size[index] mod 2 = 0{
			var dir = edificio.dir
			draw_edificio(_x, _y, index, dir,,  edificio.jugador)
		}
		//Dibujo predeterminado tamaño 2.5
		else if edificio_size[index] = 2.5{
			var sprite = edificio_sprite[index], dir = edificio.dir
			if index = id_horno_de_lava and edificio.flujo.liquido = 3
				sprite = edificio_sprite_2[index]
			if dir = 0
				draw_sprite_off(sprite, 0, _x, _y)
			else if dir = 1
				draw_sprite_off(sprite, 0, _x, _y,, -1)
			else if dir = 2
				draw_sprite_off(sprite, 1, _x, _y)
			else if dir = 3
				draw_sprite_off(sprite, 0, _x, _y, -1, -1)
			else if dir = 4
				draw_sprite_off(sprite, 0, _x, _y, -1)
			else if dir = 5
				draw_sprite_off(sprite, 1, _x, _y,, -1)
			if index = id_laser
				draw_sprite_off(edificio_sprite_2[index], 0, edificio.center_x, edificio.center_y,,, edificio.select)
		}
		//Dibujo predeterminado tamaño impar
		else
			draw_sprite_off(edificio_sprite[index], image_index << 2, _x, _y)
	}
}