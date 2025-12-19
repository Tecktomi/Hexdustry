function destroy_dron(dron = control.null_enemigo, enemigo = true){
	with control{
		if enemigo{
			remove_dron_chunk(dron)
			if array_length(enemigos) > 1 and dron.pointer != array_length(enemigos) - 1{
				var temp_enemigo = enemigos[array_length(enemigos) - 1]
				enemigos[dron.pointer] = temp_enemigo
				temp_enemigo.pointer = dron.pointer
			}
			array_pop(enemigos)
			enemigos_eliminados++
			if mision_actual >= 0 and mision_objetivo[mision_actual] = 4 and ++mision_counter >= mision_target_num[mision_actual]
				pasar_mision()
			for(var i = array_length(dron.torres) - 1; i >= 0; i--){
				var edificio = dron.torres[i]
				if edificio.target = dron{
					edificio.target = null_enemigo
					if array_length(enemigos) > 0{
						if edificio.index = id_mortero
							turret_target(edificio, 10000)//100^2
						else
							turret_target(edificio)
					}
				}
			}
		}
		else{
			if selected_dron = dron
				selected_dron = null_enemigo
			var temp_dron = drones_aliados[array_length(drones_aliados) - 1]
			drones_aliados[dron.pointer] = temp_dron
			temp_dron.pointer = dron.pointer
			array_pop(drones_aliados)
			drones_construidos--
		}
		if array_length(plantas_de_reciclaje) > 0{
			var temp_edificio_array = array_create(0, null_edificio)
			for(var a = array_length(plantas_de_reciclaje) - 1; a >= 0; a--){
				var edificio = plantas_de_reciclaje[a]
				if distance_sqr(dron.a, dron.b, edificio.x, edificio.y) < 40_000 //200^2
					array_push(temp_edificio_array, edificio)
			}
			var size = array_length(temp_edificio_array)
			for(var a = size - 1; a >= 0; a--){
				var edificio = temp_edificio_array[a]
				for(var b = array_length(dron_precio_id[dron.index]) - 1; b >= 0; b--){
					var c = min(10 - edificio.carga[dron_precio_id[dron.index, b]], round(dron_precio_num[dron.index, b] / size / 2 * edificio.red.eficiencia * edificio.flujo.eficiencia))
					edificio.carga[dron_precio_id[dron.index, b]] += c
					edificio.carga_total += c
				}
			}
		}
		array_push(efectos, add_efecto(spr_arana_muerta, 0, dron.a, dron.b, 5, 1))
		delete dron
	}
}