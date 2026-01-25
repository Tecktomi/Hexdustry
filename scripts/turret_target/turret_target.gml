function turret_target(edificio = control.null_edificio, alc_min = 0){
	with control{
		var dis = edificio_alcance_sqr[edificio.index], dron_final = null_dron, center_x = edificio.center_x, center_y = edificio.center_y
		var temp_array_dron = (edificio.enemigo ? chunk_dron_aliado : chunk_dron_enemigo), flag = true
		if (edificio.enemigo and array_length(drones_aliados) = 0) or (not edificio.enemigo and array_length(enemigos) = 0)
			flag = false
		if flag{
			//Disparo normal
			if alc_min = 0{
				for(var a = array_length(edificio.target_chunks) - 1; a >= 0; a--){
					var temp_complex = edificio.target_chunks[a], temp_array = temp_array_dron[# temp_complex.a, temp_complex.b]
					for(var b = array_length(temp_array) - 1; b >= 0; b--){
						var dron = temp_array[b]
						if dron.vida <= 0
							continue
						var temp_dis = distance_sqr(center_x, center_y, dron.x, dron.y)
						if temp_dis < dis{
							dis = temp_dis
							dron_final = dron
						}
					}
				}
			}
			//Mortero
			else for(var a = array_length(edificio.target_chunks) - 1; a >= 0; a--){
				var temp_complex = edificio.target_chunks[a], temp_array = temp_array_dron[# temp_complex.a, temp_complex.b]
				for(var b = array_length(temp_array) - 1; b >= 0; b--){
					var dron = temp_array[b]
					if dron.vida < 0
						continue
					var temp_dis = distance_sqr(center_x, center_y, dron.x, dron.y)
					if temp_dis < dis and temp_dis > alc_min{
						dis = temp_dis
						dron_final = dron
					}
				}
			}
			var prev_enemigo = edificio.target
			if dron_final != null_dron and prev_enemigo != dron_final{
				if prev_enemigo != null_dron
					array_disorder_remove(prev_enemigo.torres, edificio, 2)
				array_disorder_push(dron_final.torres, edificio, 2)
				edificio.target = dron_final
			}
			else
				edificio.target = dron_final
			//Target edificios
			if edificio.target != null_dron
				exit
		}
		var edificio_final = null_edificio, target_chunk_edificio = (edificio.enemigo ? chunk_edificios : chunk_edificios_enemigo)
		//Disparo normal
		if alc_min = 0{
			for(var a = array_length(edificio.target_chunks) - 1; a >= 0; a--){
				var temp_complex = edificio.target_chunks[a], temp_array_edificio = target_chunk_edificio[# temp_complex.a, temp_complex.b]
				for(var b = array_length(temp_array_edificio) - 1; b >= 0; b--){
					var temp_edificio = temp_array_edificio[b]
					if temp_edificio.vida <= 0
						continue
					var temp_dis = distance_sqr(center_x, center_y, temp_edificio.center_x, temp_edificio.center_y)
					if temp_dis < dis{
						dis = temp_dis
						edificio_final = temp_edificio
					}
				}
			}
		}
		//Mortero
		else for(var a = array_length(edificio.target_chunks) - 1; a >= 0; a--){
			var temp_complex = edificio.target_chunks[a], temp_array_edificio = target_chunk_edificio[# temp_complex.a, temp_complex.b]
			for(var b = array_length(temp_array_edificio) - 1; b >= 0; b--){
				var temp_edificio = temp_array_edificio[b]
				if temp_edificio.vida < 0
					continue
				var temp_dis = distance_sqr(center_x, center_y, temp_edificio.center_x, temp_edificio.center_y)
				if temp_dis < dis and temp_dis > alc_min{
					dis = temp_dis
					edificio_final = temp_edificio
				}
			}
		}
		var prev_enemigo_edificio = edificio.target_edificio
		if edificio_final != null_edificio and prev_enemigo_edificio != edificio_final{
			if prev_enemigo_edificio != null_edificio
				array_disorder_remove(prev_enemigo_edificio.torres, edificio, 7)
			array_disorder_push(edificio_final.torres, edificio, 7)
			edificio.target_edificio = edificio_final
		}
		else
			edificio.target_edificio = edificio_final
	}
}