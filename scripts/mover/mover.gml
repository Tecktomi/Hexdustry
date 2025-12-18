function mover(aa, bb){
	with control{
		if not edificio_bool[# aa, bb]
			exit
		var edificio = edificio_id[# aa, bb], flag = false, out = 0, temp_edificio = null_edificio, b = 0, index = edificio.index, var_edificio_nombre = edificio_nombre[index]
		//Selección de recursos
		for(out = 0; out < rss_max; out++)
			if edificio.carga[out] > 0 and edificio.carga_output[out]{
				//Output selector
				if index = id_selector{
					//Output selector frontal
					if (edificio.carga_id = edificio.select xor edificio.mode){
						var temp_complex = next_to(edificio.a, edificio.b, edificio.dir), aaa = temp_complex.a, bbb = temp_complex.b
						if edificio_bool[# aaa, bbb]{
							temp_edificio = edificio_id[# aaa, bbb]
							if array_contains(edificio.outputs, temp_edificio) and (temp_edificio.carga_total < edificio_carga_max[temp_edificio.index] and temp_edificio.carga[out] < temp_edificio.carga_max[out]) or temp_edificio.index = id_nucleo{
								flag = true
								break
							}
						}
					}
					//Output selector lateral
					else for(var a = 0; a < 2; a++){
						if edificio.output_index = 0
							b = a
						else
							b = 1 - a
						var temp_complex = next_to(edificio.a, edificio.b, (edificio.dir + 1 + b * 4) mod 6), aaa = temp_complex.a, bbb = temp_complex.b
						if edificio_bool[# aaa, bbb]{
							temp_edificio = edificio_id[# aaa, bbb]
							if array_contains(edificio.outputs, temp_edificio) and (temp_edificio.carga_total < edificio_carga_max[temp_edificio.index] and temp_edificio.carga[out] < temp_edificio.carga_max[out]) or temp_edificio.index = id_nucleo{
								flag = true
								edificio.output_index = 1 - b
								break
							}
						}
					}
				}
				//Output overflow
				else if index = id_overflow{
					//Output frontal
					if not edificio.mode{
						var temp_complex = next_to(edificio.a, edificio.b, edificio.dir), aaa = temp_complex.a, bbb = temp_complex.b
						if edificio_bool[# aaa, bbb]{
							temp_edificio = edificio_id[# aaa, bbb]
							if array_contains(edificio.outputs, temp_edificio) and (temp_edificio.carga_total < edificio_carga_max[temp_edificio.index] and temp_edificio.carga[out] < temp_edificio.carga_max[out]) or temp_edificio.index = id_nucleo{
								flag = true
								break
							}
						}
					}
					//Output lateral
					for(var a = 0; a < 2; a++){
						if edificio.output_index = 0
							b = a
						else
							b = 1 - a
						var temp_complex = next_to(edificio.a, edificio.b, (edificio.dir + 1 + b * 4) mod 6), aaa = temp_complex.a, bbb = temp_complex.b
						if edificio_bool[# aaa, bbb]{
							temp_edificio = edificio_id[# aaa, bbb]
							if array_contains(edificio.outputs, temp_edificio) and (temp_edificio.carga_total < edificio_carga_max[temp_edificio.index] and temp_edificio.carga[out] < temp_edificio.carga_max[out]) or temp_edificio.index = id_nucleo{
								flag = true
								edificio.output_index = 1 - b
								break
							}
						}
					}
					//Output frontal
					if edificio.mode and not flag{
						var temp_complex = next_to(edificio.a, edificio.b, edificio.dir), aaa = temp_complex.a, bbb = temp_complex.b
						if edificio_bool[# aaa, bbb]{
							temp_edificio = edificio_id[# aaa, bbb]
							if array_contains(edificio.outputs, temp_edificio) and (temp_edificio.carga_total < edificio_carga_max[temp_edificio.index] and temp_edificio.carga[out] < temp_edificio.carga_max[out]) or temp_edificio.index = id_nucleo{
								flag = true
								break
							}
						}
					}
				}
				//Output general
				else{
					for(var a = 0; a < array_length(edificio.outputs); a++){
						temp_edificio = edificio.outputs[(edificio.output_index + a) mod array_length(edificio.outputs)]
						if (temp_edificio.carga_total < edificio_carga_max[temp_edificio.index] and temp_edificio.carga[out] < temp_edificio.carga_max[out]) or temp_edificio.index = id_nucleo{
							flag = true
							edificio.output_index = (edificio.output_index + a + 1) mod array_length(edificio.outputs)
							break
						}
					}
				}
				if flag
					break
			}
		//Movimiento de recursos
		if flag{
			edificio.carga[out]--
			edificio.carga_total--
			if mision_actual >= 0{
				if mision_objetivo[mision_actual] = 0 and mision_target_id[mision_actual] = out and temp_edificio.index = 0 and ++mision_counter >= mision_target_num[mision_actual]
					pasar_mision()
				else if mision_objetivo[mision_actual] = 7 and mision_target_id[mision_actual] = temp_edificio.index
					pasar_mision()
			}
			if in(out, 9, 10, 11) and temp_edificio.index = id_nucleo
				out = 6
			temp_edificio.carga[out]++
			temp_edificio.carga_total++
			temp_edificio.carga_id = out
			if edificio.carga_total = 0
				edificio.waiting = false
			if edificio.receptor or index = id_tunel_salida
				mover_in(edificio)
		}
		return flag
	}
}