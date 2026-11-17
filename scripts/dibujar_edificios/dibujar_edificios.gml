function dibujar_edificios(){
	with control{
		var xpos = CHUNK_WIDTH * 48 * zoom, ypos = CHUNK_HEIGHT * 14 * zoom
		var prev_camx = camx, prev_camy = camy, prev_zoom = zoom, a, b, surf, chunk, len, c, edificio
		for(a = min_chunka; a < max_chunka; a++)
			for(b = min_chunkb; b < max_chunkb; b++){
				chunk = chunk_edificios_estatico[# a, b]
				surf = chunk_edificios_background[# a, b]
				if array_length(chunk) = 0{
					if surface_exists(surf)
						surface_free(surf)
					chunk_edificios_background[# a, b] = null_surface
					chunk_edificios_dirty[# a, b] = false
				}
				else{
					if chunk_edificios_dirty[# a, b] or not surface_exists(surf){
						if not surface_exists(surf){
							surf = surface_create((CHUNK_WIDTH * 48 + 8), (CHUNK_HEIGHT + 1) * 14)
							chunk_edificios_background[# a, b] = surf
						}
						camx = 0
						camy = 0
						zoom = 1
						surface_set_target(surf)
						draw_clear_alpha(c_black, 0)
						len = array_length(chunk)
						for(c = 0; c < len; c++){
							edificio = chunk[c]
							edificio_draw_function[edificio.index](edificio, -a * CHUNK_WIDTH * 48, -b * CHUNK_HEIGHT * 14)
						}
						surface_reset_target()
						camx = prev_camx
						camy = prev_camy
						zoom = prev_zoom
						chunk_edificios_dirty[# a, b] = false
					}
					draw_surface_ext(surf, -camx + a * xpos, -camy + b * ypos, zoom, zoom, 0, c_white, 1)
				}
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