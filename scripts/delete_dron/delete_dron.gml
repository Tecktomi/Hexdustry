function delete_dron(dron = control.null_dron){
	with control{
		var enemigo = dron.enemigo, _jugador = dron.jugador, a, edificio, temp_dron
		array_disorder_remove(drones, dron, ptrd_total)
		dron_chunk_remove(dron)
		array_disorder_remove(drones_jugador[_jugador], dron, ptrd_jugador)
		//Dron enemigo
		if _jugador != jugador{
			enemigos_eliminados++
			if mision_actual >= 0 and mision.objetivo = idm_sobrevivir_oleadas and array_length(drones_jugador[_jugador]) = 0 and mision_counter >= mision.target_num
				pasar_mision()
		}
		//Dron aliado
		else{
			drones_perdidos++
			if dron.selected
				array_remove(selected_drones, dron)
			if array_length(drones_jugador[_jugador]) < 8 + 2 * nucleos[_jugador].modulo
				for(a = array_length(edificios_salida_drones) - 1; a >= 0; a--){
					edificio = edificios_salida_drones[a]
					if edificio.jugador = _jugador and edificio.select != -1 and edificio.waiting
						mover_carga(edificio)
				}
		}
		//Cambiar target de torres
		if array_length(drones_jugador[_jugador]) > 0{
			for(a = array_length(dron.torres) - 1; a >= 0; a--){
				edificio = dron.torres[a]
				if edificio.target = dron{
					edificio.target = null_dron
					if edificio.index = id_mortero
						turret_target(edificio, MORTERO_MIN_RANGE)
					else
						turret_target(edificio)
				}
			}
		}
		else for(a = array_length(dron.torres) - 1; a >= 0; a--){
			edificio = dron.torres[a]
			if edificio.target = dron
				edificio.target = null_dron
		}
		//Cambiar target drones
		for(a = array_length(drones) - 1; a >= 0; a--){
			temp_dron = drones[a]
			if temp_dron.target_dron = dron
				temp_dron.target_dron = null_dron
		}
		//Ser reciclado
		for(a = array_length(edificios_index[id_planta_de_reciclaje]) - 1; a >= 0; a--){
			edificio = edificios_index[id_planta_de_reciclaje][a]
			if edificio.select = -1 and edificio.jugador = _jugador and point_distance(dron.x, dron.y, edificio.center_x, edificio.center_y) < PLANTA_RECICLAJE_RANGE{
				edificio.mode = false
				edificio.select = dron.index
				break
			}
		}
		array_push(efectos, add_efecto(spr_arana_muerta, 0, dron.x, dron.y, 5, 1))
		dron.vida = 0
		delete dron
	}
}