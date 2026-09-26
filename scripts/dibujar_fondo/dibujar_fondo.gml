function dibujar_fondo(editor = 0){
	with control{
		var temp_step, a, b, temp_complex, aa, bb, c, d, surf = undefined, aplus
		if editor = 1{
			temp_step = image_index / 10
			for(a = mina; a < maxa; a++){
				aplus = a + 1
				for(b = minb; b < maxb; b++){
					c = terreno[# a, b]
					d = ore[# a, b]
					if terreno_pared[c]
						draw_sprite_off(terreno_sprite[c], terreno_pared_index[# a, b], pre_abtox[# aplus, b + 1], pre_abtoy[# aplus, b + 1])
					else
						draw_sprite_off(terreno_sprite[c], 0, pre_abtox[# aplus, b + 1], pre_abtoy[# aplus, b + 1])
					if d >= 0
						draw_sprite_off(ore_sprite[d], round(ore_random[# a, b]) + 2 * (ore_amount[# a, b] < 50), pre_abtox[# aplus, b + 1], pre_abtoy[# aplus, b + 1])
					if c = idt_lava
						draw_sprite_off(spr_lava_animacion, temp_step + 16 * ore_random[# a, b], pre_abtox[# aplus, b + 1], pre_abtoy[# aplus, b + 1])
					else if c = idt_agua_salada
						draw_sprite_off(olas[terreno_pared_index[# a, b]], temp_step + 16 * ore_random[# a, b], pre_abtox[# aplus, b + 1], pre_abtoy[# aplus, b + 1])
				}
			}
			exit
		}
		//Fondos animados
		if editor = 2{
			var minc, mind, maxc, maxd
			temp_step = image_index / 10
			for(a = min_chunka; a < max_chunka; a++)
				for(b = min_chunkb; b < max_chunkb; b++)
					if tile_animado_chunk[# a, b] > 0{
						maxd = min((b + 1) * CHUNK_HEIGHT, ysize)
						for(c = a * CHUNK_WIDTH; c < min((a + 1) * CHUNK_WIDTH, xsize); c++)
							for(d = b * CHUNK_HEIGHT; d < maxd; d++){
								if terreno[# c, d] = idt_agua_salada
									draw_sprite_off(olas[terreno_pared_index[# c, d]], temp_step + 16 * ore_random[# c, d], pre_abtox[# c + 1, d + 1], pre_abtoy[# c + 1, d + 1])
								else if terreno[# c, d] = idt_lava
									draw_sprite_off(spr_lava_animacion, temp_step + 16 * ore_random[# c, d], pre_abtox[# c + 1, d + 1], pre_abtoy[# c + 1, d + 1])
							}
					}
			exit
		}
		var chunkhplus = CHUNK_HEIGHT + 1, xsize2 = (CHUNK_WIDTH * 48 + 8) * zoom, ysize2 = chunkhplus * 14 * zoom, xpos = CHUNK_WIDTH * 48 * zoom, ypos = CHUNK_HEIGHT * 14 * zoom
		var minc, mind, maxc, maxd, f, des_a, des_b, cplus, e
		for(a = min_chunka; a < max_chunka; a++)
			for(b = min_chunkb; b < max_chunkb; b++){
				if not background_bool[# a, b]{
					if not surface_exists(background_surface)
						background_surface = surface_create((CHUNK_WIDTH * 48 + 8), (CHUNK_HEIGHT + 1) * 14)
					surface_set_target(background_surface)
					draw_clear_alpha(c_black, 0)
					maxd = min((b + 1) * CHUNK_HEIGHT, ysize)
					des_a = a * CHUNK_WIDTH * 48
					des_b = b * CHUNK_HEIGHT * 14
					for(c = a * CHUNK_WIDTH; c < min((a + 1) * CHUNK_WIDTH, xsize); c++){
						cplus = c + 1
						for(d = b * CHUNK_HEIGHT; d < maxd; d++){
							f = terreno[# c, d]
							e = ore[# c, d]
							if terreno_pared[f]
								draw_sprite(terreno_sprite[f], terreno_pared_index[# c, d], pre_abtox[# cplus, d + 1] - des_a, pre_abtoy[# cplus, d + 1] - des_b)
							else{
								draw_sprite(terreno_sprite[f], 0, pre_abtox[# cplus, d + 1] - des_a, pre_abtoy[# cplus, d + 1] - des_b)
								if e >= 0
									draw_sprite(ore_sprite[e], round(ore_random[# c, d]) + 2 * (ore_amount[# c, d] < 50), pre_abtox[# cplus, d + 1] - des_a, pre_abtoy[# cplus, d + 1] - des_b)
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