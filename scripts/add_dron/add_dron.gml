function add_dron(a, b, index, enemigo = true){
	with control{
		var temp_complex = abtoxy(a, b)
		var dron = {
			a : temp_complex.a + random_range(-4, 4),
			b : temp_complex.b + random_range(-4, 4),
			index : real(index),
			vida : dron_vida_max[index],
			vida_max : dron_vida_max[index],
			target : null_edificio,
			temp_target : null_edificio,
			chunk_x : clamp(round(a / chunk_width), 0, chunk_xsize - 1),
			chunk_y : clamp(round(b / chunk_height), 0, chunk_ysize - 1),
			posa : a,
			posb : b,
			carga : array_create(rss_max, 0),
			carga_total : 0,
			modo : 0,
			torres : array_create(0, null_edificio),
			dir : 0,
			dir_move : 0,
			step : 0,
			efecto : array_create(efectos_max, 0),
			array_real : array_create(0, 0),
			oleada : 0,
			random_int : random(1),
			enemigo : enemigo,
			//0 = [enemigos, aliados], 1 = chunk_pointer
			punteros : array_create(2, 0),
		}
		if enemigo{
			array_disorder_push(enemigos, dron, 0)
			dron_chunk_push(dron)
		}
		else{
			array_disorder_push(drones_aliados, dron, 0)
			drones_construidos++
		}
		return dron
	}
}