function turret_target(edificio = control.null_edificio, alc_min = 0){
	with control{
		var dis = edificio_alcance_sqr[edificio.index], enemigo_final = null_dron, center_x = edificio.center_x, center_y = edificio.center_y
		var target_chunk = (edificio.enemigo ? chunk_dron_aliado : chunk_dron_enemigo)
		if (edificio.enemigo and array_length(drones_aliados) = 0) or (not edificio.enemigo and array_length(enemigos) = 0)
			exit
		//Disparo normal
		if alc_min = 0{
			for(var a = array_length(edificio.target_chunks) - 1; a >= 0; a--){
				var temp_complex = edificio.target_chunks[a], temp_array = target_chunk[# temp_complex.a, temp_complex.b]
				for(var b = array_length(temp_array) - 1; b >= 0; b--){
					var enemigo = temp_array[b]
					if enemigo.vida <= 0
						continue
					var temp_dis = distance_sqr(center_x, center_y, enemigo.x, enemigo.y)
					if temp_dis < dis{
						dis = temp_dis
						enemigo_final = enemigo
					}
				}
			}
		}
		//Mortero
		else for(var a = array_length(edificio.target_chunks) - 1; a >= 0; a--){
			var temp_complex = edificio.target_chunks[a], temp_array = target_chunk[# temp_complex.a, temp_complex.b]
			for(var b = array_length(temp_array) - 1; b >= 0; b--){
				var enemigo = temp_array[b]
				if enemigo.vida < 0
					continue
				var temp_dis = distance_sqr(center_x, center_y, enemigo.x, enemigo.y)
				if temp_dis < dis and temp_dis > alc_min{
					dis = temp_dis
					enemigo_final = enemigo
				}
			}
		}
		var prev_enemigo = edificio.target
		if enemigo_final != null_dron and prev_enemigo != enemigo_final{
			if prev_enemigo != null_dron
				array_disorder_remove(prev_enemigo.torres, edificio, 2)
			array_disorder_push(enemigo_final.torres, edificio, 2)
			edificio.target = enemigo_final
		}
		else
			edificio.target = enemigo_final
	}
}