function resize_grid(minx = 0, miny = 0){
	with control{
		chunk_xsize = ceil(xsize / CHUNK_WIDTH)
		chunk_ysize = ceil(ysize / CHUNK_HEIGHT)
		ds_grid_resize(background, chunk_xsize, chunk_ysize)
		ds_grid_resize(background_bool, chunk_xsize, chunk_ysize)
		var a, aplus, b, temp_complex_2
		for(a = floor(minx / CHUNK_WIDTH); a < chunk_xsize; a++)
			for(b = floor(miny / CHUNK_HEIGHT); b < chunk_ysize; b++){
				if background[# a, b] != spr_hexagono
					sprite_delete(background[# a, b])
				ds_grid_set(background, a, b, spr_hexagono)
				ds_grid_set(background_bool, a, b, false)
				update_background(a * CHUNK_WIDTH, b * CHUNK_HEIGHT)
			}
		ds_grid_resize(edificio_bool, xsize, ysize)
		ds_grid_resize(edificio_id, xsize, ysize)
		ds_grid_resize(edificio_draw, xsize, ysize)
		ds_grid_resize(ore, xsize, ysize)
		ds_grid_resize(ore_amount, xsize, ysize)
		ds_grid_resize(ore_random, xsize, ysize)
		ds_grid_resize(terreno, xsize, ysize)
		var prev_width = ds_grid_width(background_bool), prev_height = ds_grid_height(background_bool)
		ds_grid_resize(pre_abtoxy, xsize + 1, ysize + 1)
		ds_grid_resize(terreno_pared_index, xsize, ysize)
		ds_grid_resize(repair_id, xsize, ysize)
		ds_grid_resize(repair_dir, xsize, ysize)
		ds_grid_resize(background_bool, chunk_xsize, chunk_ysize)
		ds_grid_resize(beta_grid, xsize, ysize)
		ds_grid_resize(ia_grid_real, xsize, ysize)
		ds_grid_resize(ia_grid_camino, xsize, ysize)
		ds_grid_resize(tile_animado_chunk, chunk_xsize, chunk_ysize)
		for(a = array_length(edificios_index[id_nucleo]) - 1; a >= 0; a--)
			ds_grid_resize(edificios_index[id_nucleo, a].coordenadas_dis, xsize, ysize)
		ds_grid_resize(tile_animado_chunk, chunk_xsize, chunk_ysize)
		ds_grid_resize(ia_grid_real, xsize, ysize)
		ds_grid_resize(ia_grid_camino, xsize, ysize)
		ds_grid_set_region(terreno, minx, miny, xsize, ysize, 1)
		ds_grid_set_region(ore, minx, miny, xsize, ysize, -1)
		ds_grid_set_region(ore_amount, minx, miny, xsize, ysize, 0)
		ds_grid_set_region(edificio_id, minx, miny, xsize, ysize, null_edificio)
		for(a = minx; a < xsize; a++){
			aplus = a + 1
			for(b = miny; b < ysize; b++){
				temp_complex_2 = [real(a + (b & 1) / 2) * 48 + 16, real(b + 1) * 14]
				ds_grid_set(pre_abtoxy, aplus, b + 1, temp_complex_2)
				ds_grid_set(ore_random, a, b, random(1))
			}
		}
	}
}