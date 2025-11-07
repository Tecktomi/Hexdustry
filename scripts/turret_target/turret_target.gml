function turret_target(edificio = control.null_edificio, alc_min = 0){
	with control{
		if array_length(enemigos) = 0
			break
		var dis = edificio_alcance_sqr[edificio.index], size = array_length(enemigos), enemigo_final = null_enemigo
		if alc_min = 0{
			for(var a = array_length(edificio.target_chunks) - 1; a >= 0; a--){
				var temp_complex = edificio.target_chunks[a], temp_array = chunk_enemigos[# temp_complex.a, temp_complex.b]
				for(var b = array_length(temp_array) - 1; b >= 0; b--){
					var enemigo = temp_array[b], temp_dis = distance_sqr(edificio.x, edificio.y, enemigo.a, enemigo.b)
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
				var enemigo = temp_array[b], temp_dis = distance_sqr(edificio.x, edificio.y, enemigo.a, enemigo.b)
				if temp_dis < dis and temp_dis > alc_min{
					dis = temp_dis
					enemigo_final = enemigo
				}
			}
		}
		if enemigo_final != null_enemigo and edificio.target != enemigo_final{
			if edificio.target != null_enemigo
				array_remove(edificio.target.torres, edificio)
			edificio.target = enemigo_final
			array_push(enemigo_final.torres, edificio)
		}
		else
			edificio.target = enemigo_final
	}
}