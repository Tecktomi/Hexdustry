function mover_in(edificio = control.null_edificio){
	with control{
		var size = array_length(edificio.inputs)
		for(var a = 0; a < size; a++){
			var temp_edificio = edificio.inputs[(edificio.input_index + a) mod size]
			if temp_edificio.waiting and temp_edificio.carga_total > 0 and mover(temp_edificio.a, temp_edificio.b){
				edificio.input_index = (edificio.input_index + a + 1) mod size
				if temp_edificio.carga_total = 0
					temp_edificio.waiting = false
				if edificio.carga_total >= edificio_carga_max[edificio.index]
					return true
			}
		}
	}
}