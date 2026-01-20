function mover(edificio = control.null_edificio){
	with control{
		if not edificio.emisor
			exit
		var index = edificio.index, flag = false, out = 0, temp_edificio = null_edificio, b = 0
		//Selección de recursos
		for(out = 0; out < rss_max; out++)
			if edificio.carga_output[out] and edificio.carga[out] > 0{
				//Output selector
				if index = id_selector{
					//Output selector frontal
					if (edificio.carga_id = edificio.select xor edificio.mode){
						var temp_complex = next_to(edificio.a, edificio.b, edificio.dir), aaa = temp_complex.a, bbb = temp_complex.b
						if edificio_bool[# aaa, bbb]{
							temp_edificio = edificio_id[# aaa, bbb]
							if mover_check(out, edificio, temp_edificio){
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
							if mover_check(out, edificio, temp_edificio){
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
							if mover_check(out, edificio, temp_edificio){
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
							if mover_check(out, edificio, temp_edificio){
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
							if mover_check(out, edificio, temp_edificio){
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
						if mover_check(out, edificio, temp_edificio){
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
				if mision_objetivo[mision_actual] = 0 and mision_target_id[mision_actual] = out and temp_edificio.index = id_nucleo and ++mision_counter >= mision_target_num[mision_actual]
					pasar_mision()
				else if mision_objetivo[mision_actual] = 7 and mision_target_id[mision_actual] = temp_edificio.index
					pasar_mision()
			}
			if temp_edificio.index = id_nucleo
				recursos_obtenidos_time_temp[out]++
			if in(out, idr_piedra_cuprica, idr_piedra_ferrica, idr_piedra_sulfatada) and in(temp_edificio.index, id_nucleo, id_triturador, id_fabrica_de_concreto)
				out = idr_piedra
			else if in(out, idr_uranio_enriquecido, idr_uranio_empobrecido) and in(temp_edificio.index, id_nucleo, id_rifle, id_mortero, id_fabrica_de_drones)
				out = idr_uranio_bruto
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