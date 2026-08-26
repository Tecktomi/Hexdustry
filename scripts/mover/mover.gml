function mover(edificio = control.null_edificio){
	with control{
		if not edificio.emisor
			exit
		var index = edificio.index, flag = false, out = 0, temp_edificio = null_edificio, b = 0, bmod = edificio.b & 1, aaa, bbb, a, dir = edificio.dir
		var _mina = (index = id_cinta_transportadora ? edificio.carga_id : 0), _maxa = (index = id_cinta_transportadora ? edificio.carga_id + 1 : rss_max)
		//Selección de recursos
		for(out = _mina; out < _maxa; out++)
			if edificio.carga_output[out] and edificio.carga[out] > 0{
				//Output selector
				if index = id_selector{
					//Output selector frontal
					if (edificio.carga_id = edificio.select xor edificio.mode){
						aaa = edificio.a + DESFACE_A[bmod, dir]
						bbb = edificio.b + DESFACE_B[bmod, dir]
						if edificio_bool[# aaa, bbb]{
							temp_edificio = edificio_id[# aaa, bbb]
							if mover_check(out, edificio, temp_edificio){
								flag = true
								break
							}
						}
					}
					//Output selector lateral
					else for(a = 0; a < 2; a++){
						if edificio.output_index = 0
							b = a
						else
							b = 1 - a
						aaa = edificio.a + DESFACE_A[bmod, (dir + 1 + b * 4) mod 6]
						bbb = edificio.b + DESFACE_B[bmod, (dir + 1 + b * 4) mod 6]
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
						aaa = edificio.a + DESFACE_A[bmod, dir]
						bbb = edificio.b + DESFACE_B[bmod, dir]
						if edificio_bool[# aaa, bbb]{
							temp_edificio = edificio_id[# aaa, bbb]
							if mover_check(out, edificio, temp_edificio){
								flag = true
								break
							}
						}
					}
					//Output lateral
					for(a = 0; a < 2; a++){
						if edificio.output_index = 0
							b = a
						else
							b = 1 - a
						aaa = edificio.a + DESFACE_A[bmod, (dir + 1 + b * 4) mod 6]
						bbb = edificio.b + DESFACE_B[bmod, (dir + 1 + b * 4) mod 6]
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
						aaa = edificio.a + DESFACE_A[bmod, dir]
						bbb = edificio.b + DESFACE_B[bmod, dir]
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
					for(a = 0; a < array_length(edificio.outputs); a++){
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
			index = temp_edificio.index
			edificio.carga[out]--
			edificio.carga_total--
			if mision_actual >= 0 and mision.objetivo = 7 and mision.target_id = index
				pasar_mision()
			if tag_recurso_piedra[out] and tag_edificio_piedra[index]
				out = idr_piedra
			else if tag_recurso_uranio[out] and tag_edificio_uranio[index]
				out = idr_uranio_bruto
			if index = id_nucleo{
				recursos_obtenidos_time_temp[out]++
				if online and servidor
					jugador_recursos[edificio.jugador - 2, out]++
				else if not (online and not servidor and edificio.jugador != jugador)
					jugador_recursos[0, out]++
				if mision_actual >= 0 and mision.objetivo = 0 and mision.target_id = out and ++mision_counter >= mision.target_num
					pasar_mision()
			}
			temp_edificio.carga[out]++
			temp_edificio.carga_total++
			temp_edificio.carga_id = out
			if edificio.carga_total = 0
				edificio.waiting = false
			if edificio.receptor or edificio.index = id_tunel_salida
				mover_in(edificio)
		}
		return flag
	}
}