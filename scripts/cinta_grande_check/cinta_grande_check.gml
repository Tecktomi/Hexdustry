function cinta_grande_check(a, b, dir, index, _jugador = jugador){
	with control{
		var build_size = get_size(a, b, dir, edificio_size[index]), build_arround = get_arround(a, b, dir, edificio_size[index]), inputs = array_create(0, null_edificio), outputs = array_create(0, null_edificio)
		var c, temp_complex, aa, bb, flag, flag_2, edificio, d, e, aaa, bbb, aaaa, bbbb, agua = false, agua_x = -1, agua_y = -1, len = array_length(build_size), prev_build
		//INPUTS
		for(c = 0; c < array_length(build_arround);){
			aa = build_arround[c++]
			bb = build_arround[c++]
			flag = false
			flag_2 = false
			if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
				continue
			if edificio_bool[# aa, bb]{
				edificio = edificio_id[# aa, bb]
				if _jugador = edificio.jugador and in(edificio.index, id_fabrica_de_drones, id_cinta_grande) and not array_contains(inputs, edificio){
					for(d = 0; d < 8;){
						aaa = edificio.a + next_to_cinta_grande[edificio.b & 1, edificio.dir][d++]
						bbb = edificio.b + next_to_cinta_grande[edificio.b & 1, edificio.dir][d++]
						for(e = 0; e < len;){
							aaaa = build_size[e++]
							bbbb = build_size[e++]
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
			prev_build = null_edificio
			for(c = 0; c < 8;){
				aa = a + next_to_cinta_grande[b & 1, dir][c++]
				bb = b + next_to_cinta_grande[b & 1, dir][c++]
				if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
					continue
				if edificio_bool[# aa, bb]{
					edificio = edificio_id[# aa, bb]
					if _jugador = edificio.jugador and tag_dron_encima[edificio.index] and not array_contains(inputs, edificio){
						if edificio = prev_build
							array_push(outputs, edificio)
						else
							prev_build = edificio
						if edificio.array_real[2] = 1
							agua = true
					}
				}
				if tag_agua[terreno[# aa, bb]]{
					agua = true
					agua_x = aa
					agua_y = bb
				}
			}
		}
		return {
			inputs : inputs,
			outputs : outputs,
			agua : agua,
			agua_x : agua_x,
			agua_y : agua_y
		}
	}
}