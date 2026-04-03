function load_map_buffer(buffer){
	with control{
		var prev_xsize = xsize, prev_ysize = ysize
		xsize = buffer_read(buffer, buffer_u8)
		if xsize != prev_xsize
			resize_grid(prev_xsize, 0)
		ysize = buffer_read(buffer, buffer_u8)
		if ysize != prev_ysize
			resize_grid(0, prev_ysize)
		var base = buffer_read(buffer, buffer_u8)
		ds_grid_clear(terreno, base)
		for(var a = 0; a < terreno_max; a++)
			if a != base{
				var len = buffer_read(buffer, buffer_u16)
				for(var b = 0; b < len; b++){
					var _x = real(buffer_read(buffer, buffer_u8))
					var _y = real(buffer_read(buffer, buffer_u8))
					ds_grid_set(terreno, _x, _y, a)
				}
			}
		var len = buffer_read(buffer, buffer_u16)
		for(var i = 0; i < len; i++){
			var a = buffer_read(buffer, buffer_u8)
			var b = buffer_read(buffer, buffer_u8)
			ds_grid_set(ore, a, b, real(buffer_read(buffer, buffer_u8)))
			ds_grid_set(ore_amount, a, b, real(buffer_read(buffer, buffer_u16)))
		}
	}
}