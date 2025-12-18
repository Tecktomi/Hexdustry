function add_luz(x, y, luz_extra){
	with control{
		var temp_array = get_size(x, y, 0, 7)
		for(var a = ds_list_size(temp_array) - 1; a >= 0; a--){
			var temp_complex = temp_array[|a], aa = temp_complex.a, bb = temp_complex.b
			if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
				continue
			ds_grid_add(luz, aa, bb, real(luz_extra))
		}
	}
}