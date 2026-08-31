function draw_edificio(x, y, index, dir, alpha = 1, _jugador = jugador){
	with control{
		if tag_camino_o_tunel[index]{
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
		else if edificio_size[index] mod 2 = 0{
			if edificio_rotable[index]{
				if dir = 0
					draw_sprite_off(edificio_sprite[index], 0, x, y,,,,, alpha)
				else if dir = 1
					draw_sprite_off(edificio_sprite_2[index], 0, x, y, -1,,,, alpha)
				else if dir = 2
					draw_sprite_off(edificio_sprite_2[index], 0, x, y,,,,, alpha)
				else if dir = 3
					draw_sprite_off(edificio_sprite[index], 0, x, y, -1,,,, alpha)
				else if dir = 4
					draw_sprite_off(edificio_sprite_2[index], 0, x, y + TILE_HEIGHT,, -1,,, alpha)
				else if dir = 5
					draw_sprite_off(edificio_sprite_2[index], 0, x, y + TILE_HEIGHT, -1, -1,,, alpha)
			}
			else
				draw_sprite_off(edificio_sprite[index], 0, x, y, -1 + 2 * (dir = 0),,,, alpha)
		}
		else if edificio_size[index] = 2.5{
			if dir = 0
				draw_sprite_off(edificio_sprite[index], 0, x, y)
			else if dir = 1
				draw_sprite_off(edificio_sprite[index], 0, x, y,, -1)
			else if dir = 2
				draw_sprite_off(edificio_sprite[index], 1, x, y)
			else if dir = 3
				draw_sprite_off(edificio_sprite[index], 0, x, y, -1, -1)
			else if dir = 4
				draw_sprite_off(edificio_sprite[index], 0, x, y, -1)
			else if dir = 5
				draw_sprite_off(edificio_sprite[index], 1, x, y,, -1)
		}
		else
			draw_sprite_off(edificio_sprite[index], 0, x, y,,, dir * 60,, alpha)
		if _jugador != jugador{
			draw_set_color(EQUIPO_COLOR[_jugador])
			draw_set_alpha(alpha)
			draw_circle_off(x + 8, y, 4, false)
			draw_set_alpha(1)
		}
	}
}