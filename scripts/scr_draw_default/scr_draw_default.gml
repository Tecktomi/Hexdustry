function scr_draw_default(edificio = control.null_edificio){
	with control{
		var index = edificio.index, dir = edificio.dir, aa = edificio.x, bb = edificio.y
		//Dibujo predeterminado tamaño par
		if edificio_size[index] mod 2 = 0
			draw_edificio(aa, bb, index, dir,, edificio.enemigo)
		//Dibujo predeterminado tamaño 2.5
		else if edificio_size[index] = 2.5{
			var sprite = edificio_sprite[index]
			if index = id_horno_de_lava and edificio.flujo.liquido = 3
				sprite = edificio_sprite_2[index]
			if dir = 0
				draw_sprite_off(sprite, 0, aa, bb)
			else if dir = 1
				draw_sprite_off(sprite, 0, aa, bb,, -1)
			else if dir = 2
				draw_sprite_off(sprite, 1, aa, bb)
			else if dir = 3
				draw_sprite_off(sprite, 0, aa, bb, -1, -1)
			else if dir = 4
				draw_sprite_off(sprite, 0, aa, bb, -1)
			else if dir = 5
				draw_sprite_off(sprite, 1, aa, bb,, -1)
			if index = id_laser
				draw_sprite_off(edificio_sprite_2[index], 0, edificio.center_x, edificio.center_y,,, edificio.select)
		}
		//Dibujo predeterminado tamaño impar
		else
			draw_sprite_off(edificio_sprite[index], image_index << 2, aa, bb)
	}
}