function calculate_in_out(edificio = null_edificio){
	var index = edificio.index
	with control{
		if edificio_input_all[index]{
			for(var c = 0; c < rss_max; c++)
				edificio.carga_max[c] = edificio_carga_max[index]
		}
		else{
			var d = 0
			for(var c = 0; c < rss_max; c++)
				if d < array_length(edificio_input_id[index]) and c = edificio_input_id[index, d]
					edificio.carga_max[c] = edificio_input_num[index, d++]
				else
					edificio.carga_max[c] = 0
		}
		if edificio_output_all[index]{
			for(var c = 0; c < rss_max; c++)
				edificio.carga_output[c] = true
		}
		else{
			var d = 0
			for(var c = 0; c < rss_max; c++){
				if d < array_length(edificio_output_id[index]) and edificio_output_id[index, d] = c{
					edificio.carga_output[c] = true
					d++
				}
				else
					edificio.carga_output[c] = false
			}
		}
	}
}