function mover_in(edificio = control.null_edificio){
	with control{
		var size = ds_list_size(edificio.inputs)
		for(var a = 0; a < size; a++){
			var temp_edificio = edificio.inputs[|a]
			if temp_edificio.waiting and mover(temp_edificio.a, temp_edificio.b) and temp_edificio.carga_total = 0
				temp_edificio.waiting = false
		}
	}
}