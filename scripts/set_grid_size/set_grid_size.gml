function set_grid_size(){
	with control{
		chunk_xsize = ceil(xsize / CHUNK_WIDTH)
		chunk_ysize = ceil(ysize / CHUNK_HEIGHT)
		ds_grid_resize(null_edificio.coordenadas_dis, xsize, ysize)
		ds_grid_clear(null_edificio.coordenadas_dis, 0)
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
		ds_grid_resize(edificio_cercano, xsize, ysize)
		ds_grid_clear(edificio_cercano, null_edificio)
		ds_grid_resize(edificio_cercano_dis, xsize, ysize)
		ds_grid_clear(edificio_cercano_dis, infinity)
		ds_grid_resize(edificio_cercano_dir, xsize, ysize)
		ds_grid_clear(edificio_cercano_dir, -1)
		var a, b, a2, a3, temp_priority, temp_complex, edificio, prev_width = ds_grid_width(edificio_cercano_priority), prev_height = ds_grid_height(edificio_cercano_priority)
		for(a = 0; a < prev_width; a++)
			for(b = 0; b < prev_height; b++)
				if a >= xsize or b >= ysize
					ds_priority_destroy(edificio_cercano_priority[# a, b])
		ds_grid_resize(edificio_cercano_priority, xsize, ysize)
		ds_grid_resize(pre_abtoxy, xsize + 2, ysize + 2)
		ds_grid_clear(pre_abtoxy, [0, 0])
		for(a = 0; a < xsize; a++){
			a2 = a + 0.5
			a3 = a + 1
			ds_grid_set(pre_abtoxy, a, 0, [a2 * 48 + 16, 0])
			ds_grid_set(pre_abtoxy, a, ysize + 1, [a2 * 48 + 16, (ysize + 2) * 14])
			for(b = 0; b < ysize; b++){
				temp_complex = [real(a + (b mod 2) / 2) * 48 + 16, real(b + 1) * 14]
				ds_grid_set(pre_abtoxy, a3, b + 1, temp_complex)
				ds_grid_set(ore_random, a, b, random(1))
				if a >= prev_width or b >= prev_height{
					temp_priority = ds_priority_create()
					ds_priority_add(temp_priority, null_edificio, 0)
					ds_priority_delete_max(temp_priority)
					ds_grid_set(edificio_cercano_priority, a, b, temp_priority)
				}
			}
		}
		for(b = 0; b < ysize; b++){
			ds_grid_set(pre_abtoxy, 0, b, [real((b mod 2) / 2) * 48 + 16, real(b + 1) * 14])
			ds_grid_set(pre_abtoxy, xsize + 1, b, [real(xsize + 1 + (b mod 2) / 2) * 48 + 16, real(b + 1) * 14])
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
				ds_grid_set(background, a, b, spr_hexagono)
				ds_grid_set(chunk_edificios_background, a, b, spr_hexagono)
				ds_grid_set(chunk_dron, a, b, array_create(0, null_dron))
				ds_grid_set(chunk_edificios, a, b, array_create(0, null_edificio))
				ds_grid_set(chunk_edificios_estatico, a, b, array_create(0, null_edificio))
				ds_grid_set(chunk_edificios_dinamico, a, b, array_create(0, null_edificio))
				ds_grid_set(chunk_edificios_draw, a, b, array_create(0, null_edificio))
			}
		ds_grid_resize(beta, xsize, ysize)
		ds_grid_clear(beta, null_beta)
		for(a = array_length(nucleos) - 1; a >= 0; a--){
			edificio = nucleos[a]
			 ds_grid_resize(edificio.coordenadas_dis, xsize, ysize)
			ds_grid_clear(edificio.coordenadas_dis, 0)
		}
	}
}