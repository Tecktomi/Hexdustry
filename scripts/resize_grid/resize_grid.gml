function resize_grid(minx = 0, miny = 0){
	with control{
		ds_grid_resize(background, chunk_xsize, chunk_ysize)
		ds_grid_resize(background_bool, chunk_xsize, chunk_ysize)
		for(var a = floor(minx / chunk_width); a < chunk_xsize; a++)
			for(var b = floor(miny / chunk_height); b < chunk_ysize; b++){
				ds_grid_set(background, a, b, spr_hexagono)
				ds_grid_set(background_bool, a, b, false)
				update_background(a * chunk_width, b * chunk_height)
			}
		ds_grid_resize(edificio_bool, xsize, ysize)
		ds_grid_resize(edificio_id, xsize, ysize)
		ds_grid_resize(edificio_draw, xsize, ysize)
		ds_grid_resize(ore, xsize, ysize)
		ds_grid_resize(ore_amount, xsize, ysize)
		ds_grid_resize(ore_random, xsize, ysize)
		ds_grid_resize(terreno, xsize, ysize)
		ds_grid_resize(edificio_cercano, xsize, ysize)
		ds_grid_resize(edificio_cercano_dis, xsize, ysize)
		ds_grid_resize(edificio_cercano_dir, xsize, ysize)
		ds_grid_resize(edificio_cercano_priority, xsize, ysize)
		ds_grid_resize(pre_abtoxy, xsize + 1, ysize + 1)
		ds_grid_resize(terreno_pared_index, xsize, ysize)
		ds_grid_resize(repair_id, xsize, ysize)
		ds_grid_resize(repair_dir, xsize, ysize)
		ds_grid_resize(background_bool, chunk_xsize, chunk_ysize)
		ds_grid_set_region(terreno, minx, miny, xsize, ysize, 1)
		ds_grid_set_region(ore, minx, miny, xsize, ysize, -1)
		ds_grid_set_region(ore_amount, minx, miny, xsize, ysize, 0)
		ds_grid_set_region(edificio_id, minx, miny, xsize, ysize, null_edificio)
		ds_grid_set_region(edificio_cercano, minx, miny, xsize, ysize, null_edificio)
		for(var a = minx; a < xsize; a++)
			for(var b = miny; b < ysize; b++){
				var temp_complex_2 = {
					a : real(a + (b mod 2) / 2) * 48 + 16,
					b : real(b + 1) * 14
				}
				ds_grid_set(pre_abtoxy, a + 1, b + 1, temp_complex_2)
				ds_grid_set(ore_random, a, b, random(1))
				var temp_priority = ds_priority_create()
				ds_priority_add(temp_priority, null_edificio, 0)
				ds_priority_delete_max(temp_priority)
				ds_grid_set(edificio_cercano_priority, a, b, temp_priority)
			}
	}
}