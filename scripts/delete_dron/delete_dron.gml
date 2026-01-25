function delete_dron(dron = control.null_dron){
	with control{
		var enemigo = dron.enemigo, array_drones
		dron_chunk_remove(dron)
		//Dron enemigo
		if enemigo{
			enemigos_eliminados++
			if mision_actual >= 0 and mision_objetivo[mision_actual] = 4 and array_length(enemigos) = 0 and mision_counter >= mision_target_num[mision_actual]
				pasar_mision()
			array_drones = enemigos
		}
		//Dron aliado
		else{
			drones_perdidos++
			if selected_dron = dron
				selected_dron = null_dron
			array_drones = drones_aliados
		}
		array_disorder_remove(array_drones, dron, 0)
		//Cambiar target de torres
		if array_length(array_drones) > 0{
			for(var i = array_length(dron.torres) - 1; i >= 0; i--){
				var edificio = dron.torres[i]
				if edificio.target = dron{
					edificio.target = null_dron
					if edificio.index = id_mortero
						turret_target(edificio, 10_000)//100^2
					else
						turret_target(edificio)
				}
			}
		}
		else for(var i = array_length(dron.torres) - 1; i >= 0; i--){
			var edificio = dron.torres[i]
			if edificio.target = dron
				edificio.target = null_dron
		}
		//Ser reciclado
		for(var a = array_length(plantas_de_reciclaje) - 1; a >= 0; a--){
			var edificio = plantas_de_reciclaje[a]
			if edificio.select = -1 and distance_sqr(dron.x, dron.y, edificio.center_x, edificio.center_y) < 62_500{ //250^2
				edificio.select = dron.index
				break
			}
		}
		array_push(efectos, add_efecto(spr_arana_muerta, 0, dron.x, dron.y, 5, 1))
		dron.vida = 0
		delete dron
	}
}