function set_grid_size(){
	with control{
		clear_edificios()
		chunk_xsize = ceil(xsize / CHUNK_WIDTH)
		chunk_ysize = ceil(ysize / CHUNK_HEIGHT)
		xsizeplus = xsize + 1
		ysizeplus = ysize + 1
		ds_grid_resize(blueprint_grid, xsize, ysize)
		ds_grid_clear(blueprint_grid, false)
		ds_grid_resize(edificio_bool, xsize, ysize)
		ds_grid_clear(edificio_bool, false)
		ds_grid_resize(edificio_id, xsize, ysize)
		ds_grid_clear(edificio_id, null_edificio)
		ds_grid_resize(edificio_draw, xsize, ysize)
		ds_grid_clear(edificio_draw, false)
		ds_grid_resize(ore, xsize, ysize)
		ds_grid_clear(ore, -1)
		ds_grid_resize(ore_amount, xsize, ysize)
		ds_grid_clear(ore_amount, 0)
		ds_grid_resize(ore_random, xsize, ysize)
		ds_grid_clear(ore_random, 0)
		ds_grid_resize(terreno, xsize, ysize)
		ds_grid_clear(terreno, 1)
		var a, b, a2, aplus, temp_complex, edificio, prev_width = ds_grid_width(background_bool), prev_height = ds_grid_height(background_bool)
		ds_grid_resize(pre_abtoxy, xsize + 2, ysize + 2)
		ds_grid_clear(pre_abtoxy, [0, 0])
		pre_abtox = ds_grid_create(xsize + 2, ysize + 2)
		ds_grid_clear(pre_abtox, 0)
		pre_abtoy = ds_grid_create(xsize + 2, ysize + 2)
		ds_grid_clear(pre_abtoy, 0)
		for(a = 0; a < xsize; a++){
			aplus = a + 1
			pre_abtoxy[# a, 0] = [a * 48 + 40, 0]
			pre_abtoxy[# a, ysizeplus] = [a * 48 + 40, (ysize + 2) * 14]
			pre_abtox[# a, 0] = (a + 0.5) * 48 + 16
			pre_abtox[# a, ysizeplus] = (a + 0.5) * 48 + 16
			pre_abtoy[# a, ysizeplus] = (ysize + 2) * 14
			for(b = 0; b < ysize; b++){
				pre_abtoxy[# aplus, b + 1] = [(a + (b & 1) / 2) * 48 + 16, (b + 1) * 14]
				pre_abtox[# aplus, b + 1] = (a + (b & 1) / 2) * 48 + 16
				pre_abtoy[# aplus, b + 1] = (b + 1) * 14
				ore_random[# a, b] = random(1)
			}
		}
		for(b = 0; b < ysize; b++){
			pre_abtoxy[# 0, b] = [((b & 1) / 2) * 48 + 16, (b + 1) * 14]
			pre_abtoxy[# xsizeplus, b] = [(xsizeplus + (b & 1) / 2) * 48 + 16, (b + 1) * 14]
			pre_abtox[# 0, b] = ((b & 1) / 2) * 48 + 16
			pre_abtox[# xsizeplus, b] = (xsizeplus + (b & 1) / 2) * 48 + 16
			pre_abtoy[# 0, b] = (b + 1) * 14
			pre_abtoy[# xsizeplus, b] = (b + 1) * 14
		}
		ds_grid_resize(terreno_pared_index, xsize, ysize)
		ds_grid_clear(terreno_pared_index, 0)
		ds_grid_resize(repair_id, xsize, ysize)
		ds_grid_clear(repair_id, -1)
		ds_grid_resize(repair_dir, xsize, ysize)
		ds_grid_clear(repair_dir, 0)
		ds_grid_resize(repair_mode, xsize, ysize)
		ds_grid_clear(repair_mode, false)
		ds_grid_resize(repair_select, xsize, ysize)
		ds_grid_clear(repair_select, 0)
		ds_grid_resize(background_bool, chunk_xsize, chunk_ysize)
		ds_grid_clear(background_bool, false)
		ds_grid_resize(usable_grid_bool, xsize, ysize)
		ds_grid_clear(usable_grid_bool, false)
		ds_grid_resize(usable_grid_real, xsize, ysize)
		ds_grid_clear(usable_grid_real, 0)
		ds_grid_resize(grid_water_distance, xsize, ysize)
		ds_grid_clear(grid_water_distance, infinity)
		ds_grid_resize(background, chunk_xsize, chunk_ysize)
		ds_grid_resize(chunk_dron, chunk_xsize, chunk_ysize)
		ds_grid_resize(chunk_edificios, chunk_xsize, chunk_ysize)
		ds_grid_resize(chunk_edificios_estatico, chunk_xsize, chunk_ysize)
		ds_grid_resize(chunk_edificios_dinamico, chunk_xsize, chunk_ysize)
		ds_grid_resize(chunk_edificios_draw, chunk_xsize, chunk_ysize)
		ds_grid_resize(chunk_edificios_background, chunk_xsize, chunk_ysize)
		ds_grid_resize(chunk_edificios_dirty, chunk_xsize, chunk_ysize)
		ds_grid_clear(chunk_edificios_dirty, true)
		for(a = 0; a < chunk_xsize; a++)
			for(b = 0; b < chunk_ysize; b++){
				if background[# a, b] != spr_hexagono
					sprite_delete(background[# a, b])
				ds_grid_set(background, a, b, spr_hexagono)
				if chunk_edificios_background[# a, b] != spr_hexagono
					sprite_delete(chunk_edificios_background[# a, b])
				ds_grid_set(chunk_edificios_background, a, b, spr_hexagono)
				ds_grid_set(chunk_dron, a, b, array_create(0, null_dron))
				ds_grid_set(chunk_edificios, a, b, array_create(0, null_edificio))
				ds_grid_set(chunk_edificios_estatico, a, b, array_create(0, null_edificio))
				ds_grid_set(chunk_edificios_dinamico, a, b, array_create(0, null_edificio))
				ds_grid_set(chunk_edificios_draw, a, b, array_create(0, null_edificio))
			}
		ds_grid_resize(beta_grid, xsize, ysize)
		ds_grid_clear(beta_grid, null_beta)
		for(a = array_length(edificios_index[id_nucleo]) - 1; a >= 0; a--){
			edificio = edificios_index[id_nucleo][a]
			ds_grid_resize(edificio.coordenadas_dis, xsize, ysize)
			ds_grid_clear(edificio.coordenadas_dis, 0)
		}
		ds_grid_resize(tile_animado_chunk, chunk_xsize, chunk_ysize)
		ds_grid_clear(tile_animado_chunk, 0)
		ds_grid_resize(ia_grid_real, xsize, ysize)
		ds_grid_resize(ia_grid_camino, xsize, ysize)
	}
}