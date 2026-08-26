function dibujar_edificios(){
	with control{
		var xsize2 = (CHUNK_WIDTH + 1) * 48 * zoom, ysize2 = (CHUNK_HEIGHT + 1) * 14 * zoom, xpos = CHUNK_WIDTH * 48 * zoom, ypos = CHUNK_HEIGHT * 14 * zoom
		var prev_camx = camx, prev_camy = camy, prev_zoom = zoom, a, b, surf, chunk, len, c, edificio, sprite, aa, bb
		for(a = min_chunka; a < max_chunka; a++)
			for(b = min_chunkb; b < max_chunkb; b++){
				if chunk_edificios_dirty[# a, b]{
					camx = 0
					camy = 0
					zoom = 1
					chunk_edificios_dirty[# a, b] = false
					surf = surface_create((CHUNK_WIDTH + 1) * 48, (CHUNK_HEIGHT + 1) * 14)
					surface_set_target(surf)
					draw_clear_alpha(c_black, 0)
					chunk = chunk_edificios_estatico[# a, b]
					len = array_length(chunk)
					for(c = 0; c < len; c++){
						edificio = chunk[c]
						edificio_draw_function[edificio.index](edificio, -a * CHUNK_WIDTH * 48, -b * CHUNK_HEIGHT * 14)
					}
					sprite = sprite_create_from_surface(surf, 0, 0, (CHUNK_WIDTH + 1) * 48, (CHUNK_HEIGHT + 1) * 14, false, false, 0, 0)
					if chunk_edificios_background[# a, b] != spr_hexagono
						sprite_delete(chunk_edificios_background[# a, b])
					ds_grid_set(chunk_edificios_background, a, b, sprite)
					surface_reset_target()
					surface_free(surf)
				}
				camx = prev_camx
				camy = prev_camy
				zoom = prev_zoom
				draw_sprite_stretched(chunk_edificios_background[# a, b], 0, -camx + a * xpos, -camy + b * ypos, xsize2, ysize2)
				chunk = chunk_edificios_dinamico[# a, b]
				len = array_length(chunk)
				for(c = 0; c < len; c++){
					edificio = chunk[c]
					edificio_draw_function[edificio.index](edificio)
				}
			}
		draw_set_color(c_white)
	}
}