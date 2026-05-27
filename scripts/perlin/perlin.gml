function perlin(xsize, ysize, octava = 3, xw = 2, yh = 2){
	var chunkx = ceil(xsize / xw) + 1, chunky = ceil(ysize / yh) + 1
	//MASK
	var mask = ds_grid_create(chunkx, chunky)
	for(var a = 0; a < chunkx; a++)
		for(var b = 0; b < chunky; b++)
			mask[# a, b] = irandom(1)
	if octava > 0{
		var temp_octava = perlin(chunkx, chunky, octava - 1, xw, yh)
		ds_grid_add_grid_region(mask, temp_octava, 0, 0, chunkx, chunky, 0, 0)
	}
	chunkx -= 1
	chunky -= 1
	//DESFACE
	var add0 = ds_grid_create(xw, yh)
	var add1 = ds_grid_create(xw, yh)
	var add2 = ds_grid_create(xw, yh)
	var add3 = ds_grid_create(xw, yh)
	for(var a = 0; a < xw; a++)
		for(var b = 0; b < yh; b++){
			add0[# a, b] = xw - a + yh - b
			add1[# a, b] = a + yh - b
			add2[# a, b] = xw - a + b
			add3[# a, b] = a + b
		}
	//OUTPUT
	var grid = ds_grid_create(xw * chunkx, yh * chunky)
	for(var a = 0; a < chunkx; a++){
		var aa = a * xw
		for(var b = 0; b < chunky; b++){
			var bb = b * yh
			var mask0 = mask[# a, b], mask1 = mask[# a + 1, b], mask2 = mask[# a, b + 1], mask3 = mask[# a + 1, b + 1]
			for(var c = 0; c < xw; c++)
				for(var d = 0; d < yh; d++)
					grid[# aa + c, bb + d] = mask0 * add0[# c, d] + mask1 * add1[# c, d] + mask2 * add2[# c, d] + mask3 * add3[# c, d]
		}
	}
	ds_grid_resize(grid, xsize, ysize)
	return grid
}