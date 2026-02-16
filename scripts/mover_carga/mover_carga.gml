function mover_carga(edificio = control.null_edificio){
	with control{
		if edificio.select = -1
			return false
		var flag = false
		//Liberar Dron
		if array_length(edificio.outputs_carga) = 0{
			if array_length(drones_aliados) < 8 + 2 * nucleo.modulo{
				var dron = add_dron(edificio.a, edificio.b, edificio.select, edificio.enemigo)
				dron.x = edificio.center_x + random(0.1)
				dron.y = edificio.center_y + random(0.1)
				flag = true
			}
		}
		//Entregar a outputs
		else{
			for(var a = 0; a < array_length(edificio.outputs_carga); a++){
				var temp_edificio = edificio.outputs_carga[(a + edificio.outputs_carga_index) mod array_length(edificio.outputs_carga)]
				if temp_edificio.select = -1{
					temp_edificio.select = edificio.select
					edificio.outputs_carga_index = (edificio.outputs_carga_index + a + 1) mod array_length(edificio.outputs_carga)
					flag = true
				}
			}
		}
		//Avisar a inputs
		if flag{
			for(var a = 0; a < array_length(edificio.inputs_carga); a++){
				var temp_edificio = edificio.inputs_carga[a]
				if temp_edificio.waiting{
					mover_carga(temp_edificio)
					break
				}
			}
		}
		return flag
	}
}