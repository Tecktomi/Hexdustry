function hex_perlin(_xsize, _ysize, _octava = 3, borde = false){
	var mask = perlin(2 * _xsize + 2, _ysize + 1, _octava), med, i, output, b, bmod, bplus, bmodplus, a
	if borde{
		med = min(_xsize + 1, _ysize / 2)
		for(i = 0; i < 10; i++)
			ds_grid_add_disk(mask, _xsize + 1, _ysize / 2, med * i / 10, 1)
	}
	output = ds_grid_create(_xsize, _ysize)
	for(b = 0; b < _ysize; b++){
		bmod = b & 1
		bplus = b + 1
		bmodplus = bmod + 1
		for(a = 0; a < _xsize; a++)
			output[# a, b] = (mask[# 2 * a + bmod, b] + mask[# 2 * a + bmodplus, b] + mask[# 2 * a + bmod, bplus] + mask[# 2 * a + bmodplus, bplus]) / 4
	}
	return output
}