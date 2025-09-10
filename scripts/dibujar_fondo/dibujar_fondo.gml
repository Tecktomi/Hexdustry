function dibujar_fondo(editor = false){
	with control{
		if editor{
			var step = image_index / 10
			var mina = max(floor(camx / zoom / 48), 0), minb = max(floor(camy / zoom / 14) - 1, 0), maxa = ceil((camx + room_width) / zoom / 48), maxb = ceil((camy + room_height) / zoom / 14)
			for(var a = mina; a < maxa; a++)
				for(var b = minb; b < maxb; b++){
					var temp_terreno = terreno[a, b], temp_complex = abtoxy(a, b), aa = temp_complex.a, bb = temp_complex.b, c = temp_terreno.terreno, e = temp_terreno.ore
					draw_sprite_off(terreno_sprite[c], 0, aa, bb)
					if e >= 0
						draw_sprite_off(ore_sprite[e], round(temp_terreno.ore_random) + 2 * (temp_terreno.ore_amount < 50), aa, bb)
					if c = 14
						draw_sprite_off(spr_lava_animacion, step + 16 * temp_terreno.ore_random, aa, bb)
				}
			break
		}
		for(var a = 0; a < xsize / chunk_width; a++)
			for(var b = 0; b < ysize / chunk_height; b++){
				if background[a, b] = spr_hexagono{
					var temp_surf = surface_create(room_width, room_height)
					surface_set_target(temp_surf)
					for(var c = a * chunk_width; c < min((a + 1) * chunk_width, xsize); c++)
						for(var d = b * chunk_height; d < min((b + 1) * chunk_height, ysize); d++){
							var temp_terreno = terreno[c, d], temp_complex = abtoxy(c, d), aa = temp_complex.a - a * chunk_width * 48, bb = temp_complex.b - b * chunk_height * 14, e = temp_terreno.ore
							draw_sprite(terreno_sprite[temp_terreno.terreno], 0, aa, bb)
							if e >= 0
								draw_sprite(ore_sprite[e], round(temp_terreno.ore_random) + 2 * (temp_terreno.ore_amount < 50), aa, bb)
						}
					array_set(background[a], b, sprite_create_from_surface(temp_surf, 0, 0, room_width, room_height, false, false, 0, 0))
					surface_reset_target()
					surface_free(temp_surf)
				}
				draw_sprite_stretched(background[a, b], 0, -camx + a * chunk_width * 48 * zoom, -camy + b * chunk_height * 14 * zoom, room_width * zoom, room_height * zoom)
			}
	}
}