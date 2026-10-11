function scr_draw_armas_no_laser(edificio = control.null_edificio, offset_x = 0, offset_y = 0){
	with control{
		var index = edificio.index, _x = edificio.x + offset_x, _y = edificio.y + offset_y
		//Torres tamaño impar
		if edificio_size[index] mod 2 = 1{
			draw_sprite_off(edificio_sprite[index], 0, _x, _y)
			draw_sprite_off(edificio_sprite_2[index], 0, _x, _y,,, edificio.select)
		}
		//Torres tamaño par
		else{
			draw_sprite_off(edificio_sprite[index], 0, _x, _y, edificio.xscale)
			if index != id_onda_de_choque
				draw_sprite_off(edificio_sprite_2[index], 0, edificio.center_x, edificio.center_y,,, edificio.select)
		}
	}
}