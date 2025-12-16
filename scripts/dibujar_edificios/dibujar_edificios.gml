function dibujar_edificios(){
	with control{
		for(var a = mina; a <= maxa; a++)
			for(var b = minb; b <= maxb; b++)
				if edificio_draw[# a, b]{
					var edificio = edificio_id[# a, b], index = edificio.index, var_edificio_nombre = edificio_nombre[index], dir = edificio.dir, aa = edificio.x, bb = edificio.y
					//Dibujo caminos
					if index = id_cinta_transportadora
						draw_sprite_off(camino_general[dir, edificio.array_real[4]], image_index >> 1, aa, bb)
					else if edificio_camino[index] or in(index, id_tunel, id_tunel_salida){
						if in(index, id_selector, id_overflow)
							draw_sprite_off(edificio_sprite[index], real(edificio.mode), aa, bb,,, edificio.draw_rot)
						else if in(index, id_enrutador, id_cinta_magnetica){
							var d = image_index >> 1
							if index = id_cinta_magnetica
								d = image_index
							if (dir mod 3) = 1
								draw_sprite_off(edificio_sprite[index], d, aa, bb,, edificio.yscale)
							else
								draw_sprite_off(edificio_sprite_2[index], d, aa, bb, edificio.xscale, edificio.yscale)
						}
						else
							draw_sprite_off(edificio_sprite[index], image_index << 2, aa, bb,,, edificio.draw_rot)
						if index = id_selector and edificio.select >= 0
							draw_sprite_off(edificio_sprite_2[index], image_index << 2, aa, bb,,, edificio.draw_rot, recurso_color[edificio.select])
					}
					else{
						//Dibujo edificios con horno
						if in(index, id_horno, id_generador) and edificio.fuel > 0
							draw_sprite_off(edificio_sprite_2[index], image_index << 2, aa, bb, edificio.array_real[2] / 8)
						else if index = id_horno_de_lava and edificio.flujo.liquido = 3
							draw_sprite_off(edificio_sprite_2[index], image_index << 2, aa, bb, edificio.array_real[2] / 8)
						//Dibujo de bateria
						else if index = id_bateria
							draw_sprite_off(edificio_sprite[index], floor(10 * edificio.red.bateria / edificio.red.bateria_max), aa, bb,,, dir * 60)
						//Dibujo bomba tamaño par
						else if in(index, id_bomba_hidraulica, id_turbina, id_generador_geotermico){
							draw_sprite_off(edificio_sprite[index], 0, aa, bb, edificio.array_real[2] / 8)
							if edificio.flujo.liquido = -1
								draw_sprite_off(spr_bomba_color, 0, aa + edificio.array_real[2], bb + 14)
							else
								draw_sprite_off(spr_bomba_color, 0, aa + edificio.array_real[2], bb + 14,,,, liquido_color[edificio.flujo.liquido], edificio.flujo.almacen / edificio.flujo.almacen_max)
							draw_sprite_off(spr_bomba_rotor, 1, aa + edificio.array_real[2], bb + 14,,, image_index)
							draw_sprite_off(spr_bomba_cupula, 1, aa + edificio.array_real[2], bb + 14)
						}
						//Dibujo bomba tamaño impar
						else if index = id_perforadora_de_petroleo{
							draw_sprite_off(edificio_sprite[index], 0, aa, bb)
							if edificio.flujo.liquido = -1
								draw_sprite_off(spr_bomba_color, 0, aa, bb)
							else
								draw_sprite_off(spr_bomba_color, 0, aa, bb,,,, liquido_color[edificio.flujo.liquido], edificio.flujo.almacen / edificio.flujo.almacen_max)
							draw_sprite_off(spr_bomba_rotor, 1, aa, bb,,, image_index)
							draw_sprite_off(spr_bomba_cupula, 1, aa, bb)
						}
						//Dibujo líquido sin bomba
						else if in(index, id_tuberia, id_deposito, id_liquido_infinito, id_bomba_de_evaporacion){
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
								if index != id_onda_de_choque
									draw_sprite_off(edificio_sprite_2[index], 0, aa + 9 * edificio.array_real[2] / 8, bb + 14,,, edificio.select)
							}
						}
						//Dibujo predeterminado tamaño par
						else if edificio_size[index] mod 2 = 0
							draw_sprite_off(edificio_sprite[index], image_index << 2, aa, bb, edificio.array_real[2] / 8)
						//Dibujo predeterminado tamaño impar
						else
							draw_sprite_off(edificio_sprite[index], image_index << 2, aa, bb,,, dir * 60)
						if index = id_recurso_infinito and edificio.select >= 0
							draw_sprite_off(edificio_sprite_2[index], image_index << 2, aa, bb,,,, recurso_color[edificio.select])
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
				}
	draw_set_color(c_white)
	}
}