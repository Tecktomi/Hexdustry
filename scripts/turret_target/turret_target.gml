function turret_target(edificio = control.null_edificio, alc_min = 0){
	with control{
		if array_length(enemigos) = 0
			break
		var dis = edificio_alcance_sqr[edificio.index], enemigo_final = null_enemigo
		if alc_min = 0{
			for(var a = array_length(edificio.target_chunks) - 1; a >= 0; a--){
				var temp_complex = edificio.target_chunks[a], temp_array = chunk_enemigos[# temp_complex.a, temp_complex.b]
				for(var b = array_length(temp_array) - 1; b >= 0; b--){
					var enemigo = temp_array[b]
					if enemigo.vida <= 0
						continue
					var temp_dis = distance_sqr(edificio.x, edificio.y, enemigo.a, enemigo.b)
					if temp_dis < dis{
						dis = temp_dis
						enemigo_final = enemigo
					}
				}
			}
		}
		else for(var a = array_length(edificio.target_chunks) - 1; a >= 0; a--){
			var temp_complex = edificio.target_chunks[a], temp_array = chunk_enemigos[# temp_complex.a, temp_complex.b]
			for(var b = array_length(temp_array) - 1; b >= 0; b--){
				var enemigo = temp_array[b]
				if enemigo.vida < 0
					continue
				var temp_dis = distance_sqr(edificio.x, edificio.y, enemigo.a, enemigo.b)
				if temp_dis < dis and temp_dis > alc_min{
					dis = temp_dis
					enemigo_final = enemigo
				}
			}
		}
		var prev_enemigo = edificio.target
		if enemigo_final != null_enemigo and prev_enemigo != enemigo_final{
			if prev_enemigo != null_enemigo
				array_disorder_remove(prev_enemigo.torres, edificio, 2)
			array_disorder_push(enemigo_final.torres, edificio, 2)
			edificio.target = enemigo_final
		}
		else
			edificio.target = enemigo_final
	}
}