function mover(aa, bb){
	with control{
		var temp_terreno = terreno[aa, bb]
		if temp_terreno.edificio_bool
			var edificio = temp_terreno.edificio
		else
			exit
		var flag = false, out = 0, temp_edificio = null_edificio, b = 0
		var var_edificio_nombre = edificio_nombre[edificio.index]
		//Selección de recursos
		for(out = 0; out < rss_max; out++)
			if edificio.carga[out] > 0 and edificio.carga_output[out]{
				//Output selector
				if in(var_edificio_nombre, "Selector"){
					//Output selector frontal
					if (edificio.carga_id = edificio.select xor not edificio.mode){
						var temp_complex = next_to(edificio.a, edificio.b, edificio.dir)
						temp_terreno = terreno[temp_complex.a, temp_complex.b]
						if temp_terreno.edificio_bool{
							temp_edificio = temp_terreno.edificio
							if ds_list_in(edificio.outputs, temp_edificio) and (temp_edificio.carga_total < edificio_carga_max[temp_edificio.index] and temp_edificio.carga[out] < temp_edificio.carga_max[out]) or temp_edificio.index = 0{
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
						var temp_complex = next_to(edificio.a, edificio.b, (edificio.dir + 1 + b * 4) mod 6)
						temp_terreno = terreno[temp_complex.a, temp_complex.b]
						if temp_terreno.edificio_bool{
							temp_edificio = temp_terreno.edificio
							if ds_list_in(edificio.outputs, temp_edificio) and (temp_edificio.carga_total < edificio_carga_max[temp_edificio.index] and temp_edificio.carga[out] < temp_edificio.carga_max[out]) or temp_edificio.index = 0{
								flag = true
								edificio.output_index = 1 - b
								break
							}
						}
					}
				}
				//Output overflow
				else if in(var_edificio_nombre, "Overflow"){
					//Output frontal
					if not edificio.mode{
						var temp_complex = next_to(edificio.a, edificio.b, edificio.dir)
						temp_terreno = terreno[temp_complex.a, temp_complex.b]
						if temp_terreno.edificio_bool{
							temp_edificio = temp_terreno.edificio
							if ds_list_in(edificio.outputs, temp_edificio) and (temp_edificio.carga_total < edificio_carga_max[temp_edificio.index] and temp_edificio.carga[out] < temp_edificio.carga_max[out]) or temp_edificio.index = 0{
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
						var temp_complex = next_to(edificio.a, edificio.b, (edificio.dir + 1 + b * 4) mod 6)
						temp_terreno = terreno[temp_complex.a, temp_complex.b]
						if temp_terreno.edificio_bool{
							temp_edificio = temp_terreno.edificio
							if ds_list_in(edificio.outputs, temp_edificio) and (temp_edificio.carga_total < edificio_carga_max[temp_edificio.index] and temp_edificio.carga[out] < temp_edificio.carga_max[out]) or temp_edificio.index = 0{
								flag = true
								edificio.output_index = 1 - b
								break
							}
						}
					}
					//Output frontal
					if edificio.mode and not flag{
						var temp_complex = next_to(edificio.a, edificio.b, edificio.dir)
						temp_terreno = terreno[temp_complex.a, temp_complex.b]
						if temp_terreno.edificio_bool{
							temp_edificio = temp_terreno.edificio
							if ds_list_in(edificio.outputs, temp_edificio) and (temp_edificio.carga_total < edificio_carga_max[temp_edificio.index] and temp_edificio.carga[out] < temp_edificio.carga_max[out]) or temp_edificio.index = 0{
								flag = true
								break
							}
						}
					}
				}
				//Output general
				else{
					for(var a = 0; a < ds_list_size(edificio.outputs); a++){
						temp_edificio = edificio.outputs[|(edificio.output_index + a) mod ds_list_size(edificio.outputs)]
						if (temp_edificio.carga_total < edificio_carga_max[temp_edificio.index] and temp_edificio.carga[out] < temp_edificio.carga_max[out]) or temp_edificio.index = 0{
							flag = true
							edificio.output_index = (edificio.output_index + a + 1) mod ds_list_size(edificio.outputs)
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
			temp_edificio.carga[out]++
			temp_edificio.carga_total++
			temp_edificio.carga_id = out
			if edificio.carga_total = 0
				edificio.waiting = false
			if edificio_receptor[edificio.index] or in(var_edificio_nombre, "Túnel")
				mover_in(edificio)
		}
		return flag
	}
}