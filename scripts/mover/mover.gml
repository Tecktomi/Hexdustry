function mover(edificio = control.null_edificio){
	var flag = false, out = 0
	for(out = 0; out < control.ore_max; out++)
		if edificio.carga[out] > 0 and edificio.carga_output[out]
			break
	if out < control.ore_max{
		for(var a = 0; a < ds_list_size(edificio.outputs); a++){
			var temp_edificio = ds_list_find_value(edificio.outputs, (edificio.output_index + a) mod ds_list_size(edificio.outputs))
			if (temp_edificio.carga_total < control.edificio_carga_max[temp_edificio.index] and temp_edificio.carga[out] < temp_edificio.carga_max[out]) or temp_edificio.index = 0{
				edificio.carga[out]--
				edificio.carga_total--
				temp_edificio.carga[out]++
				temp_edificio.carga_total++
				temp_edificio.carga_id = out
				edificio.output_index = (edificio.output_index + a + 1) mod ds_list_size(edificio.outputs)
				flag = true
				break
			}
		}
	}
	if flag{
		if edificio.carga_total = 0
			edificio.waiting = false
		if control.edificio_receptor[edificio.index]
			for(var a = 0; a < ds_list_size(edificio.inputs); a++){
				var temp_edificio = ds_list_find_value(edificio.inputs, a)
				if temp_edificio.waiting and mover(temp_edificio) and temp_edificio.carga = 0
					temp_edificio.waiting = false
			}
	}
	return flag
}