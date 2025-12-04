function dibujar_edificios(){
	with control{
		var c = image_index * vel
		for(var a = mina; a <= maxa; a++)
			for(var b = minb; b <= maxb; b++)
				if edificio_draw[# a, b]{
					var edificio = edificio_id[# a, b], index = edificio.index, var_edificio_nombre = edificio_nombre[index], dir = edificio.dir, aa = edificio.x, bb = edificio.y
					//Dibujo caminos
					if edificio_camino[index] or in(var_edificio_nombre, "Túnel", "Túnel salida"){
						if in(var_edificio_nombre, "Selector", "Overflow")
							draw_sprite_off(edificio_sprite[index], real(edificio.mode), aa, bb,,, edificio.draw_rot)
						else if in(var_edificio_nombre, "Cinta Transportadora", "Enrutador", "Cinta Magnética"){
							var d = c >> 1
							if var_edificio_nombre = "Cinta Magnética"
								d = c
							if (dir mod 3) = 1
								draw_sprite_off(edificio_sprite[index], d, aa, bb,, edificio.yscale)
							else
								draw_sprite_off(edificio_sprite_2[index], d, aa, bb, edificio.xscale, edificio.yscale)
						}
						else
							draw_sprite_off(edificio_sprite[index], c << 2, aa, bb,,, edificio.draw_rot)
						if var_edificio_nombre = "Selector" and edificio.select >= 0
							draw_sprite_off(edificio_sprite_2[index], c << 2, aa, bb,,, edificio.draw_rot, recurso_color[edificio.select])
					}
					else{
						//Dibujo edificios con horno
						if in(var_edificio_nombre, "Horno", "Generador") and edificio.fuel > 0
							draw_sprite_off(edificio_sprite_2[index], c << 2, aa, bb, edificio.array_real[2] / 8)
						else if in(var_edificio_nombre, "Horno de Lava") and edificio.flujo.liquido = 3
							draw_sprite_off(edificio_sprite_2[index], c << 2, aa, bb, edificio.array_real[2] / 8)
						//Dibujo de bateria
						else if in(var_edificio_nombre, "Batería")
							draw_sprite_off(edificio_sprite[index], floor(10 * edificio.red.bateria / edificio.red.bateria_max), aa, bb,,, dir * 60)
						//Dibujo bomba tamaño par
						else if in(var_edificio_nombre, "Bomba Hidráulica", "Turbina", "Generador Geotérmico"){
							draw_sprite_off(edificio_sprite[index], 0, aa, bb, edificio.array_real[2] / 8)
							if edificio.flujo.liquido = -1
								draw_sprite_off(spr_bomba_color, 0, aa + edificio.array_real[2], bb + 14)
							else
								draw_sprite_off(spr_bomba_color, 0, aa + edificio.array_real[2], bb + 14,,,, liquido_color[edificio.flujo.liquido], edificio.flujo.almacen / edificio.flujo.almacen_max)
							draw_sprite_off(spr_bomba_rotor, 1, aa + edificio.array_real[2], bb + 14,,, c)
							draw_sprite_off(spr_bomba_cupula, 1, aa + edificio.array_real[2], bb + 14)
						}
						//Dibujo bomba tamaño impar
						else if in(var_edificio_nombre, "Perforadora de Petróleo"){
							draw_sprite_off(edificio_sprite[index], 0, aa, bb)
							if edificio.flujo.liquido = -1
								draw_sprite_off(spr_bomba_color, 0, aa, bb)
							else
								draw_sprite_off(spr_bomba_color, 0, aa, bb,,,, liquido_color[edificio.flujo.liquido], edificio.flujo.almacen / edificio.flujo.almacen_max)
							draw_sprite_off(spr_bomba_rotor, 1, aa, bb,,, c)
							draw_sprite_off(spr_bomba_cupula, 1, aa, bb)
						}
						//Dibujo líquido sin bomba
						else if in(var_edificio_nombre, "Tubería", "Depósito", "Líquido Infinito", "Bomba de Evaporación"){
							draw_sprite_off(edificio_sprite[index], 0, aa, bb)
							if edificio.flujo.liquido = -1
								draw_sprite_off(edificio_sprite_2[index], 0, aa, bb)
							else
								draw_sprite_off(edificio_sprite_2[index], 0, aa, bb,,,, liquido_color[edificio.flujo.liquido], edificio.flujo.almacen / edificio.flujo.almacen_max)
						}
						else if edificio_armas[index]{
							//Torres tamaño impar
							if edificio_size[index] mod 2 = 1{
								draw_sprite_off(edificio_sprite[index], 0, aa, bb)
								draw_sprite_off(edificio_sprite_2[index], 0, aa, bb,,, edificio.select)
							}
							//Torres tamaño par
							else{
								draw_sprite_off(edificio_sprite[index], 0, aa, bb, edificio.array_real[2] / 8)
								if var_edificio_nombre != "Onda de Choque"
									draw_sprite_off(edificio_sprite_2[index], 0, aa + 9 * edificio.array_real[2] / 8, bb + 14,,, edificio.select)
							}
						}
						//Dibujo predeterminado tamaño par
						else if edificio_size[index] mod 2 = 0
							draw_sprite_off(edificio_sprite[index], c << 2, aa, bb, edificio.array_real[2] / 8)
						//Dibujo predeterminado tamaño impar
						else
							draw_sprite_off(edificio_sprite[index], c << 2, aa, bb,,, dir * 60)
						if var_edificio_nombre = "Recurso Infinito" and edificio.select >= 0
							draw_sprite_off(edificio_sprite_2[index], c << 2, aa, bb,,,, recurso_color[edificio.select])
					}
					//Dibujo estados
					if info and edificio.waiting{
						draw_set_color(c_yellow)
						draw_circle_off(aa, bb + 16, 4, false)
					}
					if edificio.idle{
						draw_set_color(c_red)
						draw_circle_off(aa, bb + 8, 4, false)
					}
					if edificio.vida < edificio_vida[index]{
						draw_set_color(make_color_rgb(255 * (1 - edificio.vida / edificio_vida[index]), 255 * edificio.vida / edificio_vida[index], 0))
						draw_circle_off(aa, bb, 5, false)
					}
				}
	draw_set_color(c_white)
	}
}