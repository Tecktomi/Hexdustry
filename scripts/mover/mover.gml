function mover(edificio = control.null_edificio){
	var flag = false, out = 0, temp_edificio
	//Selección de recursos
	for(out = 0; out < control.rss_max; out++)
		if edificio.carga[out] > 0 and edificio.carga_output[out]{
			//Output selector
			if in(control.edificio_nombre[edificio.index], "Selector"){
				//Output selector frontal
				if (edificio.carga_id = edificio.select xor not edificio.mode){
					var temp_complex = next_to(edificio.a, edificio.b, edificio.dir)
					var temp_terreno = control.terreno[temp_complex.a, temp_complex.b]
					if temp_terreno.edificio_bool{
						temp_edificio = temp_terreno.edificio
						if (temp_edificio.carga_total < control.edificio_carga_max[temp_edificio.index] and temp_edificio.carga[out] < temp_edificio.carga_max[out]) or temp_edificio.index = 0{
							flag = true
							break
						}
					}
				}
				//Output selector lateral
				else for(var a = 0; a < 2; a++){
					var b
					if edificio.output_index = 0
						b = a
					else
						b = 1 - a
					var temp_complex = next_to(edificio.a, edificio.b, (edificio.dir + 1 + b * 4) mod 6)
					var temp_terreno = control.terreno[temp_complex.a, temp_complex.b]
					if temp_terreno.edificio_bool{
						temp_edificio = temp_terreno.edificio
						if (temp_edificio.carga_total < control.edificio_carga_max[temp_edificio.index] and temp_edificio.carga[out] < temp_edificio.carga_max[out]) or temp_edificio.index = 0{
							flag = true
							edificio.output_index = 1 - b
							break
						}
					}
				}
			}
			//Output overflow
			else if in(control.edificio_nombre[edificio.index], "Overflow"){
				//Output frontal
				if not edificio.mode{
					var temp_complex = next_to(edificio.a, edificio.b, edificio.dir)
					var temp_terreno = control.terreno[temp_complex.a, temp_complex.b]
					if temp_terreno.edificio_bool{
						temp_edificio = temp_terreno.edificio
						if (temp_edificio.carga_total < control.edificio_carga_max[temp_edificio.index] and temp_edificio.carga[out] < temp_edificio.carga_max[out]) or temp_edificio.index = 0{
							show_debug_message(1)
							flag = true
							break
						}
					}
				}
				//Output lateral
				for(var a = 0; a < 2; a++){
					var b
					if edificio.output_index = 0
						b = a
					else
						b = 1 - a
					var temp_complex = next_to(edificio.a, edificio.b, (edificio.dir + 1 + b * 4) mod 6)
					var temp_terreno = control.terreno[temp_complex.a, temp_complex.b]
					if temp_terreno.edificio_bool{
						temp_edificio = temp_terreno.edificio
						if (temp_edificio.carga_total < control.edificio_carga_max[temp_edificio.index] and temp_edificio.carga[out] < temp_edificio.carga_max[out]) or temp_edificio.index = 0{
							show_debug_message(2)
							flag = true
							edificio.output_index = 1 - b
							break
						}
					}
				}
				//Output frontal
				if edificio.mode{
					var temp_complex = next_to(edificio.a, edificio.b, edificio.dir)
					var temp_terreno = control.terreno[temp_complex.a, temp_complex.b]
					if temp_terreno.edificio_bool{
						temp_edificio = temp_terreno.edificio
						if (temp_edificio.carga_total < control.edificio_carga_max[temp_edificio.index] and temp_edificio.carga[out] < temp_edificio.carga_max[out]) or temp_edificio.index = 0{
							show_debug_message(3)
							flag = true
							break
						}
					}
				}
			}
			//Output general
			else for(var a = 0; a < ds_list_size(edificio.outputs); a++){
				temp_edificio = ds_list_find_value(edificio.outputs, (edificio.output_index + a) mod ds_list_size(edificio.outputs))
				if (temp_edificio.carga_total < control.edificio_carga_max[temp_edificio.index] and temp_edificio.carga[out] < temp_edificio.carga_max[out]) or temp_edificio.index = 0{
					flag = true
					edificio.output_index = (edificio.output_index + a + 1) mod ds_list_size(edificio.outputs)
					break
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
		if control.edificio_receptor[edificio.index]
			for(var a = 0; a < ds_list_size(edificio.inputs); a++){
				temp_edificio = ds_list_find_value(edificio.inputs, a)
				if temp_edificio.waiting and mover(temp_edificio) and temp_edificio.carga = 0
					temp_edificio.waiting = false
			}
	}
	return flag
}