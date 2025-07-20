function mover_in(edificio = control.null_edificio){
	with control{
		for(var a = 0; a < ds_list_size(edificio.inputs); a++){
			var temp_edificio = edificio.inputs[|a]
			if temp_edificio.waiting and mover(temp_edificio.a, temp_edificio.b) and temp_edificio.carga_total = 0
				temp_edificio.waiting = false
		}
	}
}