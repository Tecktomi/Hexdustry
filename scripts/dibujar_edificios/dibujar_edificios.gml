function dibujar_edificios(){
	with control{
		var mina = max(floor(camx / zoom / 48), 0), minb = max(floor(camy / zoom / 14), 0), maxa = ceil((camx + room_width) / zoom / 48), maxb = ceil((camy + room_height) / zoom / 14)
		for(var a = mina; a < maxa; a++)
			for(var b = minb; b < maxb; b++){
				var temp_terreno = terreno[a, b]
				if temp_terreno.edificio_draw{
					var edificio = terreno[a, b].edificio, index = edificio.index, var_edificio_nombre = edificio_nombre[index], dir = edificio.dir, aa = edificio.x, bb = edificio.y
					//Dibujo caminos
					if edificio_camino[index] or var_edificio_nombre = "Túnel"{
						if in(var_edificio_nombre, "Selector", "Overflow")
							draw_sprite_off(edificio_sprite[index], real(edificio.mode), aa, bb,,, (dir - 1) * 60)
						else if in(var_edificio_nombre, "Cinta Transportadora", "Enrutador", "Cinta Magnética"){
							var c = image_index / 2
							if in(var_edificio_nombre, "Cinta Magnética")
								c = image_index
							if (dir mod 3) = 1
								draw_sprite_off(edificio_sprite[index], c, aa, bb,, power(-1, dir > 1))
							else
								draw_sprite_off(edificio_sprite_2[index], c, aa, bb, power(-1, ((dir + 1) mod 6) > 1), power(-1, dir > 2))
						}
						else
							draw_sprite_off(edificio_sprite[index], image_index / 4, aa, bb,,, (dir - 1) * 60)
						if var_edificio_nombre = "Selector" and edificio.select >= 0
							draw_sprite_off(edificio_sprite_2[index], image_index / 4, aa, bb,,, (dir - 1) * 60, recurso_color[edificio.select])
					}
					else{
						//Dibujo edificios con horno
						if in(var_edificio_nombre, "Horno", "Generador") and edificio.fuel > 0
							draw_sprite_off(edificio_sprite_2[index], image_index / 4, aa, bb, power(-1, dir))
						else if in(var_edificio_nombre, "Horno de Lava") and edificio.flujo.liquido = 3
							draw_sprite_off(edificio_sprite_2[index], image_index / 4, aa, bb, power(-1, dir))
						//Dibujo de bateria
						else if in(var_edificio_nombre, "Batería")
							draw_sprite_off(edificio_sprite[index], floor(10 * edificio.red.bateria / edificio.red.bateria_max), aa, bb,,, dir * 60)
						//Dibujo bomba
						else if in(var_edificio_nombre, "Bomba Hidráulica", "Turbina", "Refinería de Petróleo"){
							draw_sprite_off(edificio_sprite[index], 0, aa, bb, power(-1, dir))
							if edificio.flujo.liquido = -1
								draw_sprite_off(spr_bomba_color, 0, aa + power(-1, dir) * 8, bb + 14)
							else
								draw_sprite_off(spr_bomba_color, 0, aa + power(-1, dir) * 8, bb + 14,,,, liquido_color[edificio.flujo.liquido], edificio.flujo.almacen / edificio.flujo.almacen_max)
							draw_sprite_off(spr_bomba_rotor, 1, aa + power(-1, dir) * 8, bb + 14,,, image_index)
							draw_sprite_off(spr_bomba_cupula, 1, aa + power(-1, dir) * 8, bb + 14)
						}
						else if in(var_edificio_nombre, "Tubería", "Depósito", "Líquido Infinito", "Refinería de Petróleo", "Bomba de Evaporación"){
							draw_sprite_off(edificio_sprite[index], 0, aa, bb)
							if edificio.flujo.liquido = -1
								draw_sprite_off(edificio_sprite_2[index], 0, aa, bb)
							else
								draw_sprite_off(edificio_sprite_2[index], 0, aa, bb,,,, liquido_color[edificio.flujo.liquido], edificio.flujo.almacen / edificio.flujo.almacen_max)
						}
						//Torres 1x1
						else if in(var_edificio_nombre, "Torre"){
							draw_sprite_off(edificio_sprite[index], 0, aa, bb)
							draw_sprite_off(edificio_sprite_2[index], 0, aa, bb,,, edificio.select)
						}
						//Torres 2x2
						else if in(var_edificio_nombre, "Rifle"){
							draw_sprite_off(edificio_sprite[index], 0, aa, bb, power(-1, dir))
							draw_sprite_off(edificio_sprite_2[index], 0, aa + 9 * power(-1, dir), bb + 14,,, edificio.select)
						}
						//Dibujo 2x2
						else if edificio_size[index] mod 2 = 0
							draw_sprite_off(edificio_sprite[index], image_index / 4, aa, bb, power(-1, dir))
						//Dibujo predeterminado
						else
							draw_sprite_off(edificio_sprite[index], image_index / 4, aa, bb,,, dir * 60)
						if var_edificio_nombre = "Recurso Infinito" and edificio.select >= 0
							draw_sprite_off(edificio_sprite_2[index], image_index / 4, aa, bb,,,, recurso_color[edificio.select])
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
						draw_set_color(make_color_hsv(120 * edificio.vida / edificio_vida[index], 255, 255))
						draw_circle_off(aa, bb, 5, false)
						draw_set_color(c_white)
					}
				}
			}
	}
}