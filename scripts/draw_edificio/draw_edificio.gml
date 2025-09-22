function draw_edificio(a, b, index, dir, alpha = 1){
	with control{
		var var_edificio_nombre = edificio_nombre[index]
		if edificio_camino[index] or in(var_edificio_nombre, "Túnel", "Túnel salida"){
			if in(var_edificio_nombre, "Cinta Transportadora", "Enrutador", "Cinta Magnética"){
				var c = image_index / 2
				if in(var_edificio_nombre, "Cinta Magnética")
					c = image_index
				if dir mod 3 = 1
					draw_sprite_off(edificio_sprite[index], c, a, b, 1, power(-1, dir > 1),,, alpha)
				else
					draw_sprite_off(edificio_sprite_2[index], c, a, b, power(-1, ((dir + 1) mod 6) > 1), power(-1, dir > 2),,, alpha)
			}
			else
				draw_sprite_off(edificio_sprite[index], 0, a, b,,, (dir - 1) * 60,, alpha)
		}
		else if edificio_size[build_index] mod 2 = 0
			draw_sprite_off(edificio_sprite[index], 0, a, b, power(-1, dir),,,, alpha)
		else if in(var_edificio_nombre, "Tubería")
			draw_sprite_off(edificio_sprite[index], 0, a, b,,,,, alpha)
		else
			draw_sprite_off(edificio_sprite[index], 0, a, b,,, dir * 60,, alpha)
	}
}