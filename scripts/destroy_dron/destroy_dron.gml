function destroy_dron(enemigo = control.null_enemigo){
	with control{
		var temp_array = chunk_enemigos[# enemigo.chunk_x, enemigo.chunk_y]
		if array_length(temp_array) > 1{
			var temp_enemigo = temp_array[array_length(temp_array) - 1]
			temp_array[enemigo.chunk_pointer] = temp_enemigo
			temp_enemigo.chunk_pointer = enemigo.chunk_pointer
		}
		array_pop(temp_array)
		if array_length(enemigos) > 1{
			var temp_enemigo = enemigos[array_length(enemigos) - 1]
			enemigos[enemigo.pointer] = temp_enemigo
			temp_enemigo.pointer = enemigo.pointer
		}
		array_pop(enemigos)
		array_push(efectos, add_efecto(spr_arana_muerta, 0, enemigo.a, enemigo.b, 5, 1))
		enemigos_eliminados++
		if mision_actual >= 0 and mision_objetivo[mision_actual] = 4 and ++mision_counter >= mision_target_num[mision_actual]
			pasar_mision()
		for(var i = array_length(enemigo.torres) - 1; i >= 0; i--){
			var edificio = enemigo.torres[i]
			if edificio.target = enemigo{
				edificio.target = null_enemigo
				if array_length(enemigos) > 0{
					if edificio_nombre[edificio.index] = "Mortero"
						turret_target(edificio, 10000)//100^2
					else
						turret_target(edificio)
				}
			}
		}
		delete enemigo
	}
}