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
			if prev_enemigo != null_enemigo{
				var temp_edificio = prev_enemigo.torres[array_length(prev_enemigo.torres) - 1]
				if temp_edificio != edificio{
					prev_enemigo.torres[edificio.target_pointer] = temp_edificio
					temp_edificio.target_pointer = edificio.target_pointer
				}
				array_pop(prev_enemigo.torres)
			}
			edificio.target = enemigo_final
			edificio.target_pointer = array_length(enemigo_final.torres)
			array_push(enemigo_final.torres, edificio)
		}
		else
			edificio.target = enemigo_final
	}
}