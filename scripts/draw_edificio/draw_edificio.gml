function draw_edificio(x, y, index, dir, alpha = 1){
	with control{
		if edificio_camino[index] or in(index, id_tunel, id_tunel_salida){
			if in(index, id_cinta_transportadora, id_enrutador, id_cinta_magnetica){
				var c = image_index >> 1
				if index = id_cinta_magnetica
					c = image_index
				if dir mod 3 = 1
					draw_sprite_off(edificio_sprite[index], c, x, y, 1, power(-1, dir > 1),,, alpha)
				else
					draw_sprite_off(edificio_sprite_2[index], c, x, y, power(-1, ((dir + 1) mod 6) > 1), power(-1, dir > 2),,, alpha)
			}
			else
				draw_sprite_off(edificio_sprite[index], 0, x, y,,, (dir - 1) * 60,, alpha)
		}
		else if edificio_size[index] mod 2 = 0
			draw_sprite_off(edificio_sprite[index], 0, x, y, power(-1, dir),,,, alpha)
		else if index = id_turbina
			draw_sprite_off(edificio_sprite[index], 0, x, y,,,,, alpha)
		else
			draw_sprite_off(edificio_sprite[index], 0, x, y,,, dir * 60,, alpha)
	}
}