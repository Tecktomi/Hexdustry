function dibujar_edificios(){
	with control{
		var xsize2 = (chunk_width + 1) * 48 * zoom, ysize2 = (chunk_height + 1) * 14 * zoom, xpos = chunk_width * 48 * zoom, ypos = chunk_height * 14 * zoom
		var prev_camx = camx, prev_camy = camy, prev_zoom = zoom
		for(var a = min_chunka; a < max_chunka; a++)
			for(var b = min_chunkb; b < max_chunkb; b++){
				if chunk_edificios_dirty[# a, b]{
					camx = 0
					camy = 0
					zoom = 1
					chunk_edificios_dirty[# a, b] = false
					var temp_surf = surface_create((chunk_width + 1) * 48, (chunk_height + 1) * 14)
					surface_set_target(temp_surf)
					draw_clear_alpha(c_black, 0)
					var chunk = chunk_edificios_estatico[# a, b], len = array_length(chunk)
					for(var c = 0; c < len; c++){
						var edificio = chunk[c]
						edificio_draw_function[edificio.index](edificio, -a * chunk_width * 48, -b * chunk_height * 14)
					}
					ds_grid_set(chunk_edificios_background, a, b, sprite_create_from_surface(temp_surf, 0, 0, (chunk_width + 1) * 48, (chunk_height + 1) * 14, false, false, 0, 0))
					surface_reset_target()
					surface_free(temp_surf)
				}
				camx = prev_camx
				camy = prev_camy
				zoom = prev_zoom
				draw_sprite_stretched(chunk_edificios_background[# a, b], 0, -camx + a * xpos, -camy + b * ypos, xsize2, ysize2)
				var chunk = chunk_edificios_dinamico[# a, b], len = array_length(chunk)
				for(var c = 0; c < len; c++){
					var edificio = chunk[c], aa = edificio.x, bb = edificio.y
					edificio_draw_function[edificio.index](edificio)
				}
			}
		draw_set_color(c_white)
	}
}