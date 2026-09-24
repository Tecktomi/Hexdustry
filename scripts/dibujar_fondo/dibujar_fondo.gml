function dibujar_fondo(editor = 0){
	with control{
		var temp_step, a, b, temp_complex, aa, bb, c, d, surf = undefined
		if editor = 1{
			temp_step = image_index / 10
			for(a = mina; a < maxa; a++)
				for(b = minb; b < maxb; b++){
					temp_complex = pre_abtoxy[# min(a + 1, xsizeplus), min(b + 1, ysizeplus)]//abtoxy
					aa = temp_complex[0]
					bb = temp_complex[1]
					c = terreno[# a, b]
					d = ore[# a, b]
					if terreno_pared[c]
						draw_sprite_off(terreno_sprite[c], terreno_pared_index[# a, b], aa, bb)
					else
						draw_sprite_off(terreno_sprite[c], 0, aa, bb)
					if d >= 0
						draw_sprite_off(ore_sprite[d], round(ore_random[# a, b]) + 2 * (ore_amount[# a, b] < 50), aa, bb)
					if c = 14
						draw_sprite_off(spr_lava_animacion, temp_step + 16 * ore_random[# a, b], aa, bb)
					else if c = 18
						draw_sprite_off(olas[terreno_pared_index[# a, b]], temp_step + 16 * ore_random[# a, b], aa, bb)
				}
			exit
		}
		//Fondos animados
		var e
		if editor = 2{
			temp_step = image_index / 10
			for(a = min_chunka; a < max_chunka; a++)
				for(b = min_chunkb; b < max_chunkb; b++)
					if tile_animado_chunk[# a, b] > 0
						for(c = a * CHUNK_WIDTH; c < min((a + 1) * CHUNK_WIDTH, xsize); c++)
							for(d = b * CHUNK_HEIGHT; d < min((b + 1) * CHUNK_HEIGHT, ysize); d++){
								e = terreno[# c, d]
								if e = idt_lava{
									temp_complex = pre_abtoxy[# min(c + 1, xsizeplus), min(d + 1, ysizeplus)]//abtoxy
									draw_sprite_off(spr_lava_animacion, temp_step + 16 * ore_random[# c, d], temp_complex[0], temp_complex[1])
								}
								else if e = idt_agua_salada{
									temp_complex = pre_abtoxy[# min(c + 1, xsizeplus), min(d + 1, ysizeplus)]//abtoxy
									draw_sprite_off(olas[terreno_pared_index[# c, d]], temp_step + 16 * ore_random[# c, d], temp_complex[0], temp_complex[1])
								}
							}
			exit
		}
		var chunkhplus = CHUNK_HEIGHT + 1, xsize2 = (CHUNK_WIDTH * 48 + 8) * zoom, ysize2 = chunkhplus * 14 * zoom, xpos = CHUNK_WIDTH * 48 * zoom, ypos = CHUNK_HEIGHT * 14 * zoom
		var minc, mind, maxc, maxd, f, des_a, des_b, cplus
		for(a = min_chunka; a < max_chunka; a++)
			for(b = min_chunkb; b < max_chunkb; b++){
				if not background_bool[# a, b]{
					if not surface_exists(background_surface)
						background_surface = surface_create((CHUNK_WIDTH * 48 + 8), (CHUNK_HEIGHT + 1) * 14)
					surface_set_target(background_surface)
					draw_clear_alpha(c_black, 0)
					minc = a * CHUNK_WIDTH
					mind = b * CHUNK_HEIGHT
					maxc = min((a + 1) * CHUNK_WIDTH, xsize)
					maxd = min((b + 1) * CHUNK_HEIGHT, ysize)
					des_a = a * CHUNK_WIDTH * 48
					des_b = b * CHUNK_HEIGHT * 14
					for(c = minc; c < maxc; c++){
						cplus = c + 1
						for(d = mind; d < maxd; d++){
							temp_complex = pre_abtoxy[# min(cplus, xsizeplus), min(d + 1, ysizeplus)]//abtoxy
							aa = temp_complex[0] - des_a
							bb = temp_complex[1] - des_b
							f = terreno[# c, d]
							e = ore[# c, d]
							if terreno_pared[f]
								draw_sprite(terreno_sprite[f], terreno_pared_index[# c, d], aa, bb)
							else{
								draw_sprite(terreno_sprite[f], 0, aa, bb)
								if e >= 0
									draw_sprite(ore_sprite[e], round(ore_random[# c, d]) + 2 * (ore_amount[# c, d] < 50), aa, bb)
							}
						}
					}
					background[# a, b] = sprite_create_from_surface(background_surface, 0, 0, CHUNK_WIDTH * 48 + 8, chunkhplus * 14, false, false, 0, 0)
					background_bool[# a, b] = true
					surface_reset_target()
				}
				draw_sprite_stretched(background[# a, b], 0, -camx + a * xpos, -camy + b * ypos, xsize2, ysize2)
			}
	}
}