function add_luz(x, y, luz_extra){
	with control{
		var temp_array = get_arround_impar(x, y, 5), size = array_length(temp_array)
		for(var a = 0; a < size; a++){
			var temp_complex = temp_array[a], aa = temp_complex.a, bb = temp_complex.b
			if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
				continue
			ds_grid_add(luz, aa, bb, real(luz_extra))
		}
	}
}