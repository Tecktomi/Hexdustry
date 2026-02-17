function scr_draw_armas_no_laser(edificio = control.null_edificio){
	with control{
		var index = edificio.index, dir = edificio.dir, aa = edificio.x, bb = edificio.y
		//Torres tamaño impar
		if edificio_size[index] mod 2 = 1{
			draw_sprite_off(edificio_sprite[index], 0, aa, bb)
			draw_sprite_off(edificio_sprite_2[index], 0, aa, bb,,, edificio.select)
		}
		//Torres tamaño par
		else{
			if edificio.dir = 0
				draw_sprite_off(edificio_sprite[index], 0, aa, bb)
			else
				draw_sprite_off(edificio_sprite[index], 0, aa, bb, -1)
			if index != id_onda_de_choque
				draw_sprite_off(edificio_sprite_2[index], 0, edificio.center_x, edificio.center_y,,, edificio.select)
		}
	}
}