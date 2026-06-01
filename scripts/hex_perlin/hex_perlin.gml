function hex_perlin(_xsize, _ysize, _octava = 3, borde = false){
	/*
	var xw = 24, yh = 16
	var _chunkx = ceil(_xsize / 2), _chunky = ceil(_ysize / 4)
	var output = ds_grid_create(_chunkx * 2, _chunky * 4)
	var mask = ds_grid_create(_chunkx + 1, _chunky + 1)
	for(var a = 0; a <= _chunkx; a++)
		for(var b = 0; b <= _chunky; b++)
			mask[# a, b] = random_range(-1, 1)
	if _octava > 0{
		var octava = hex_perlin(_chunkx + 1, _chunky + 1, _octava - 1)
		ds_grid_multiply_region(octava, 0, 0, _chunkx + 1, _chunky + 1, 0.5)
		ds_grid_add_grid_region(mask, octava, 0, 0, _chunkx + 1, _chunky + 1, 0, 0)
	}
	var dis0 = sqrt(sqr(xw) + sqr(yh))
	var dis1 = sqrt(4 * sqr(xw) + sqr(yh))
	var dis2 = sqrt(sqr(xw) + 9 * sqr(yh))
	var dis3 = 3 * dis0
	var dis_total = 1 / dis0 + 1 / dis1 + 1 / dis2 + 1 / dis3
	dis0 *= dis_total
	dis1 *= dis_total
	dis2 *= dis_total
	dis3 *= dis_total
	for(var a = 0; a < _chunkx; a++){
		var aa = a * 2
		for(var b = 0; b < _chunky; b++){
			var bb = b * 4
			var a0 = mask[# a, b], a1 = mask[# a + 1, b], a2 = mask[# a, b + 1], a3 = mask[# a + 1, b + 1]
			output[# aa, bb] = a0
			output[# aa + 1, bb] = (a0 + a1) / 2
			output[# aa, bb + 1] = a0 / dis0 + a1 / dis1 + a2 / dis2 + a3 / dis3
			output[# aa + 1, bb + 1] = a0 / dis1 + a1 / dis0 + a2 / dis3 + a3 / dis2
			output[# aa, bb + 2] = (a0 + a2) / 2
			output[# aa + 1, bb + 2] = (a0 + a1 + a2 + a3) / 4
			output[# aa, bb + 3] = a0 / dis2 + a1 / dis3 + a2 / dis0 + a3 / dis1
			output[# aa + 1, bb + 3] = a0 / dis3 + a1 / dis2 + a2 / dis1 + a3 / dis0
		}
	}
	ds_grid_resize(output, _xsize, _ysize)
	return output
	*/
	var mask = perlin(2 * _xsize + 2, _ysize + 1, _octava)
	if borde{
		var med = min(_xsize + 1, _ysize / 2)
		for(var i = 0; i < 10; i++)
			ds_grid_add_disk(mask, _xsize + 1, _ysize / 2, med * i / 10, 1)
	}
	var output = ds_grid_create(_xsize, _ysize)
	for(var b = 0; b < _ysize; b++){
		var bmod = b & 1, bplus = b + 1, bmodplus = bmod + 1
		for(var a = 0; a < _xsize; a++)
			output[# a, b] = (mask[# 2 * a + bmod, b] + mask[# 2 * a + bmodplus, b] + mask[# 2 * a + bmod, bplus] + mask[# 2 * a + bmodplus, bplus]) / 4
	}
	return output
}