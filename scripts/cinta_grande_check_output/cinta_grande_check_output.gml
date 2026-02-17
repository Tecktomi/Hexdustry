function cinta_grande_check(a, b, dir, index){
	with control{
		var build_size = get_size(a, b, dir, edificio_size[index]), build_arround = get_arround(a, b, dir, edificio_size[index]), inputs = array_create(0, null_edificio), outputs = array_create(0, null_edificio)
		//INPUTS
		for(var c = ds_list_size(build_arround) - 1; c >= 0; c--){
			var temp_complex = build_arround[|c], aa = temp_complex.a, bb = temp_complex.b, flag = false, flag_2 = false
			if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
				continue
			if edificio_bool[# aa, bb]{
				var edificio = edificio_id[# aa, bb]
				if in(edificio.index, id_fabrica_de_drones, id_cinta_grande) and not array_contains(inputs, edificio){
					var temp_array = next_to_cinta_grande(edificio.a, edificio.b, edificio.dir)
					for(var d = array_length(temp_array) - 1; d >= 0; d--){
						var aaa = temp_array[d, 0], bbb = temp_array[d, 1]
						for(var e = ds_list_size(build_size) - 1; e >= 0; e--){
							var temp_complex_2 = build_size[|e], aaaa = temp_complex_2.a, bbbb = temp_complex_2.b
							if aaa = aaaa and bbb = bbbb{
								if flag_2{
									array_push(inputs, edificio)
									flag = true
									break
								}
								else
									flag_2 = true
							}
						}
						if flag
							break
					}
				}
			}
		}
		//OUTPUTS
		if in(index, id_fabrica_de_drones, id_cinta_grande){
			var temp_array = next_to_cinta_grande(a, b, dir), prev_build = null_edificio
			for(var c = 0; c < 4; c++){
				var aa = temp_array[c, 0], bb = temp_array[c, 1]
				if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
					continue
				if edificio_bool[# aa, bb]{
					var edificio = edificio_id[# aa, bb]
					if grafic_array_dron_encima[edificio.index] and not array_contains(inputs, edificio){
						if edificio = prev_build
							array_push(outputs, edificio)
						else
							prev_build = edificio
					}
				}
			}
		}
		return {
			inputs : inputs,
			outputs : outputs
		}
	}
}