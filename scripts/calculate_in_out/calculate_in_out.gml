function calculate_in_out(edificio = control.null_edificio){
	var index = edificio.index
	with control{
		if edificio_input_all[index]{
			edificio.carga_max = array_create(rss_max, edificio_carga_max[index])
			edificio.carga_input = array_create(rss_max, true)
		}
		else{
			edificio.carga_max = array_create(rss_max, 0)
			edificio.carga_input = array_create(rss_max, false)
			for(var a = array_length(edificio_input_id[index]) - 1; a >= 0; a--){
				edificio.carga_max[edificio_input_id[index, a]] = edificio_input_num[index, a]
				edificio.carga_input[edificio_input_id[index, a]] = true
			}
		}
		if edificio_output_all[index]{
			edificio.carga_output = array_create(rss_max, true)
		}
		else{
			edificio.carga_output = array_create(rss_max, false)
			for(var a = array_length(edificio_output_id[index]) - 1; a >= 0; a--)
				edificio.carga_output[edificio_output_id[index, a]] = true
		}
	}
}