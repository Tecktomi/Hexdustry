function cinta_grande_check(a, b, dir, index){
	with control{
		var build_size = get_size(a, b, dir, edificio_size[index]), build_arround = get_arround(a, b, dir, edificio_size[index]), inputs = array_create(0, null_edificio), outputs = array_create(0, null_edificio)
		var c, temp_complex, aa, bb, flag, flag_2, edificio, temp_Array, d, e, aaa, bbb, temp_complex_2, aaaa, bbbb
		//INPUTS
		for(c = array_length(build_arround) - 1; c >= 0; c--){
			temp_complex = build_arround[c]
			aa = temp_complex[0]
			bb = temp_complex[1]
			flag = false
			flag_2 = false
			if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
				continue
			if edificio_bool[# aa, bb]{
				edificio = edificio_id[# aa, bb]
				if in(edificio.index, id_fabrica_de_drones, id_cinta_grande) and not array_contains(inputs, edificio){
					var temp_array = next_to_cinta_grande(edificio.a, edificio.b, edificio.dir)
					for(d = array_length(temp_array) - 1; d >= 0; d--){
						aaa = temp_array[d, 0]
						bbb = temp_array[d, 1]
						for(e = array_length(build_size) - 1; e >= 0; e--){
							temp_complex_2 = build_size[e]
							aaaa = temp_complex_2[0]
							bbbb = temp_complex_2[1]
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
			for(c = 0; c < 4; c++){
				aa = temp_array[c, 0]
				bb = temp_array[c, 1]
				if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
					continue
				if edificio_bool[# aa, bb]{
					edificio = edificio_id[# aa, bb]
					if tag_dron_encima[edificio.index] and not array_contains(inputs, edificio){
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