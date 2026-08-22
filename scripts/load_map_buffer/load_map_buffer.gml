function load_map_buffer(buffer){
	with control{
		var prev_xsize = xsize, prev_ysize = ysize
		xsize = buffer_read(buffer, buffer_u8)
		if xsize != prev_xsize
			resize_grid(prev_xsize, 0)
		ysize = buffer_read(buffer, buffer_u8)
		if ysize != prev_ysize
			resize_grid(0, prev_ysize)
		var base = buffer_read(buffer, buffer_u8), a, len, b, _x, _y, i
		ds_grid_clear(terreno, base)
		for(a = 0; a < terreno_max; a++)
			if a != base{
				len = buffer_read(buffer, buffer_u16)
				for(b = 0; b < len; b++){
					_x = real(buffer_read(buffer, buffer_u8))
					_y = real(buffer_read(buffer, buffer_u8))
					ds_grid_set(terreno, _x, _y, a)
				}
			}
		len = buffer_read(buffer, buffer_u16)
		for(i = 0; i < len; i++){
			a = buffer_read(buffer, buffer_u8)
			b = buffer_read(buffer, buffer_u8)
			ds_grid_set(ore, a, b, real(buffer_read(buffer, buffer_u8)))
			ds_grid_set(ore_amount, a, b, real(buffer_read(buffer, buffer_u16)))
		}
	}
}