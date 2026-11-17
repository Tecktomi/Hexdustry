function dibujar_fondo(){
	with control{
		var a, b, c, d, e, f, CHUNK_WIDTH_48 = CHUNK_WIDTH * 48, CHUNK_HEIGHT_14 = CHUNK_HEIGHT * 14
		var xpos = CHUNK_WIDTH_48 * zoom, ypos = CHUNK_HEIGHT_14 * zoom, maxd, des_a, des_b, cplus, surf, temp_step
		for(a = min_chunka; a < max_chunka; a++)
			for(b = min_chunkb; b < max_chunkb; b++){
				surf = background[# a, b]
				if not background_bool[# a, b] or not surface_exists(surf){
					if not surface_exists(surf){
						surf = null_surface
						while array_length(fondo_pool) > 0 and not surface_exists(surf)
							surf = array_pop(fondo_pool)
						if not surface_exists(surf)
							surf = surface_create((CHUNK_WIDTH * 48 + 8), (CHUNK_HEIGHT + 1) * 14)
					}
					surface_set_target(surf)
					draw_clear_alpha(c_black, 0)
					maxd = min((b + 1) * CHUNK_HEIGHT, ysize)
					des_a = a * CHUNK_WIDTH_48
					des_b = b * CHUNK_HEIGHT_14
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
					for(c = array_length(chunk_explosion[# a, b]) - 1; c >= 0; c--)
						draw_sprite_ext(spr_explosion_mark, 0, chunk_explosion[# a, b][c].x - des_a, chunk_explosion[# a, b][c].y - des_b, 1, 1, chunk_explosion[# a, b][c].rot, c_white, 0.3)
					array_resize(chunk_explosion[# a, b], 0)
					background_bool[# a, b] = true
					background[# a, b] = surf
					surface_reset_target()
				}
				chunk_last_load[# a, b] = image_index
				draw_surface_ext(surf, -camx + a * xpos, -camy + b * ypos, zoom, zoom, 0, c_white, 1)
			}
		if grafic_tile_animation and zoom >= 1{
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
		}
		//Refresh background
		if image_index mod 60 = 0
			for(a = 0; a < chunk_xsize; a++)
				for(b = 0; b < chunk_ysize; b++)
					if surface_exists(background[# a, b]) and chunk_last_load[# a, b] < image_index - 60{
						background_bool[# a, b] = false
						if surface_exists(background[# a, b]){
							if array_length(fondo_pool) < 64
								array_push(fondo_pool, background[# a, b])
							else
								surface_free(background[# a, b])
						}
						background[# a, b] = null_surface
						if surface_exists(chunk_edificios_background[# a, b])
							surface_free(chunk_edificios_background[# a, b])
						chunk_edificios_background[# a, b] = null_surface
						chunk_edificios_dirty[# a, b] = true
					}
	}
}