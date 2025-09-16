function resize_grid(minx = 0, miny = 0){
	with control{
		for(var a = minx; a < xsize; a++)
			for(var b = floor(miny / chunk_width); b < ysize; b++){
				background[a, b] = spr_hexagono
				update_background(a * chunk_width, b * chunk_height)
			}
		ds_grid_resize(bool_unidad, xsize, ysize)
		ds_grid_resize(edificio_bool, xsize, ysize)
		ds_grid_resize(edificio_id, xsize, ysize)
		ds_grid_resize(edificio_draw, xsize, ysize)
		ds_grid_resize(ore, xsize, ysize)
		ds_grid_resize(ore_amount, xsize, ysize)
		ds_grid_resize(ore_random, xsize, ysize)
		ds_grid_resize(terreno, xsize, ysize)
		ds_grid_set_region(terreno, minx, miny, xsize, ysize, 1)
		ds_grid_set_region(ore, minx, miny, xsize, ysize, -1)
		ds_grid_set_region(edificio_id, minx, miny, xsize, ysize, null_edificio)
		for(var a = minx; a < xsize; a++)
			for(var b = miny; b < ysize; b++){
				var temp_complex = abtoxy(a, b), temp_hexagono = instance_create_layer(temp_complex.a, temp_complex.b, "instances", obj_hexagono)
				temp_hexagono.a = a
				temp_hexagono.b = b
				ds_grid_set(ore_random, a, b, random(1))
			}
	}
}