function dibujar_fondo(editor = 0){
	with control{
		if editor = 1{
			var step = image_index / 10
			var mina = max(floor(camx / zoom / 48), 0), minb = max(floor(camy / zoom / 14) - 1, 0), maxa = ceil((camx + room_width) / zoom / 48), maxb = ceil((camy + room_height) / zoom / 14)
			for(var a = mina; a < maxa; a++)
				for(var b = minb; b < maxb; b++){
					var temp_complex = abtoxy(a, b), aa = temp_complex.a, bb = temp_complex.b, d = terreno[# a, b], e = ore[# a, b]
					if terreno_pared[d]
						draw_sprite_off(terreno_sprite[d], terreno_pared_index[# a, b], aa, bb)
					else
						draw_sprite_off(terreno_sprite[d], 0, aa, bb)
					if e >= 0
						draw_sprite_off(ore_sprite[e], round(ore_random[# a, b]) + 2 * (ore_amount[# a, b] < 50), aa, bb)
					if d = 14
						draw_sprite_off(spr_lava_animacion, step + 16 * ore_random[# a, b], aa, bb)
				}
			break
		}
		if editor = 2{
			var step = image_index / 10
			var mina = max(floor(camx / zoom / 48), 0), minb = max(floor(camy / zoom / 14) - 1, 0), maxa = ceil((camx + room_width) / zoom / 48), maxb = ceil((camy + room_height) / zoom / 14)
			for(var a = mina; a < maxa; a++)
				for(var b = minb; b < maxb; b++)
					if terreno[# a, b] = 14{
						var temp_complex = abtoxy(a, b), aa = temp_complex.a, bb = temp_complex.b
						draw_sprite_off(spr_lava_animacion, step + 16 * ore_random[# a, b], aa, bb)
					}
			break
		}
		for(var a = 0; a < xsize / chunk_width; a++)
			for(var b = 0; b < ysize / chunk_height; b++){
				if background[a, b] = spr_hexagono{
					var temp_surf = surface_create(room_width, room_height)
					surface_set_target(temp_surf)
					var minc = a * chunk_width, mind = b * chunk_height, maxc = min((a + 1) * chunk_width, xsize), maxd = min((b + 1) * chunk_height, ysize)
					if better_walls{
						for(var c = minc; c < maxc; c++)
							for(var d = mind; d < maxd; d++){
								var temp_complex = abtoxy(c, d), aa = temp_complex.a - a * chunk_width * 48, bb = temp_complex.b - b * chunk_height * 14, f = terreno[# c, d], e = ore[# c, d]
								if terreno_pared[f]
									draw_sprite(terreno_sprite[f], terreno_pared_index[# c, d], aa, bb)
								else{
									draw_sprite(terreno_sprite[f], 0, aa, bb)
									if e >= 0
										draw_sprite(ore_sprite[e], round(ore_random[# c, d]) + 2 * (ore_amount[# c, d] < 50), aa, bb)
								}
							}
					}
					else{
						for(var c = minc; c < maxc; c++)
							for(var d = mind; d < maxd; d++){
								var temp_complex = abtoxy(c, d), aa = temp_complex.a - a * chunk_width * 48, bb = temp_complex.b - b * chunk_height * 14, e = ore[# c, d]
								draw_sprite(terreno_sprite[terreno[# c, d]], 0, aa, bb)
								if e >= 0
									draw_sprite(ore_sprite[e], round(ore_random[# c, d]) + 2 * (ore_amount[# c, d] < 50), aa, bb)
							}
					}
					array_set(background[a], b, sprite_create_from_surface(temp_surf, 0, 0, room_width, room_height, false, false, 0, 0))
					surface_reset_target()
					surface_free(temp_surf)
				}
				draw_sprite_stretched(background[a, b], 0, -camx + a * chunk_width * 48 * zoom, -camy + b * chunk_height * 14 * zoom, room_width * zoom, room_height * zoom)
			}
	}
}