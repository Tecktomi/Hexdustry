function turret_target(edificio = control.null_edificio, alc_min = 0){
	with control{
		var dis = edificio_alcance_sqr[edificio.index], dron_final = null_dron, center_x = edificio.center_x, center_y = edificio.center_y
		var temp_array_dron, _jugador = edificio.jugador
		var a, b, temp_complex, temp_dis, dron, temp_edificio, temp_array_edificio
		//Disparo normal
		if alc_min = 0{
			for(a = array_length(edificio.target_chunks) - 1; a >= 0; a--){
				temp_complex = edificio.target_chunks[a]
				temp_array_dron = ds_grid_get(chunk_dron, temp_complex[0], temp_complex[1])
				for(b = array_length(temp_array_dron) - 1; b >= 0; b--){
					dron = temp_array_dron[b]
					if dron.vida <= 0
						continue
					if dron.jugador != _jugador{
						temp_dis = distance_sqr(center_x, center_y, dron.x, dron.y)
						if temp_dis < dis{
							dis = temp_dis
							dron_final = dron
						}
					}
				}
			}
		}
		//Mortero
		else for(a = array_length(edificio.target_chunks) - 1; a >= 0; a--){
			temp_complex = edificio.target_chunks[a]
			temp_array_dron = ds_grid_get(chunk_dron, temp_complex[0], temp_complex[1])
			for(b = array_length(temp_array_dron) - 1; b >= 0; b--){
				dron = temp_array_dron[b]
				if dron.vida < 0
					continue
				if dron.jugador != _jugador{
					temp_dis = distance_sqr(center_x, center_y, dron.x, dron.y)
					if temp_dis < dis and temp_dis > alc_min{
						dis = temp_dis
						dron_final = dron
					}
				}
			}
		}
		var prev_enemigo = edificio.target
		if prev_enemigo != dron_final{
		    if prev_enemigo != null_dron
		        array_disorder_remove(prev_enemigo.torres, edificio, ptre_torre_dron)
		    if dron_final != null_dron
		        array_disorder_push(dron_final.torres, edificio, ptre_torre_dron)
		}
		edificio.target = dron_final
		//Target edificios
		if edificio.target != null_dron{
			if edificio.target_edificio != null_edificio
				array_disorder_remove(edificio.target_edificio.torres, edificio, ptre_torre_edificio)
			edificio.target_edificio = null_edificio
			exit
		}
		var edificio_final = null_edificio
		//Disparo normal
		if alc_min = 0{
			for(a = array_length(edificio.target_chunks) - 1; a >= 0; a--){
				temp_complex = edificio.target_chunks[a]
				temp_array_edificio = ds_grid_get(chunk_edificios, temp_complex[0], temp_complex[1])
				for(b = array_length(temp_array_edificio) - 1; b >= 0; b--){
					temp_edificio = temp_array_edificio[b]
					if temp_edificio.vida <= 0
						continue
					if temp_edificio.jugador != _jugador{
						temp_dis = distance_sqr(center_x, center_y, temp_edificio.center_x, temp_edificio.center_y)
						if temp_dis < dis{
							dis = temp_dis
							edificio_final = temp_edificio
						}
					}
				}
			}
		}
		//Mortero
		else for(a = array_length(edificio.target_chunks) - 1; a >= 0; a--){
			temp_complex = edificio.target_chunks[a]
			temp_array_edificio = ds_grid_get(chunk_edificios, temp_complex[0], temp_complex[1])
			for(b = array_length(temp_array_edificio) - 1; b >= 0; b--){
				temp_edificio = temp_array_edificio[b]
				if temp_edificio.vida < 0
					continue
				if temp_edificio.jugador != _jugador{
					temp_dis = distance_sqr(center_x, center_y, temp_edificio.center_x, temp_edificio.center_y)
					if temp_dis < dis and temp_dis > alc_min{
						dis = temp_dis
						edificio_final = temp_edificio
					}
				}
			}
		}
		var prev_edificio = edificio.target_edificio
		if prev_edificio != edificio_final{
		    if prev_edificio != null_edificio
		        array_disorder_remove(prev_edificio.torres, edificio, ptre_torre_edificio)
		    if edificio_final != null_edificio
		        array_disorder_push(edificio_final.torres, edificio, ptre_torre_edificio)
		}
		edificio.target_edificio = edificio_final
	}
}