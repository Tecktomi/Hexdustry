function add_dron(a, b, index, aliado = false){
	with control{
		var temp_complex = abtoxy(a, b)
		var dron = {
			a : temp_complex.a,
			b : temp_complex.b,
			index : real(index),
			vida : dron_vida_max[index],
			vida_max : dron_vida_max[index],
			target : null_edificio,
			temp_target : null_edificio,
			chunk_x : clamp(round(a / chunk_width), 0, ds_grid_width(chunk_enemigos) - 1),
			chunk_y : clamp(round(b / chunk_height), 0, ds_grid_height(chunk_enemigos) - 1),
			chunk_pointer : 0,
			posa : a,
			posb : b,
			carga : array_create(rss_max, 0),
			carga_total : 0,
			modo : 0,
			pointer : 0,
			torres : array_create(0, null_edificio),
			dir : 0,
			dir_move : 0,
			step : 0,
			efecto : array_create(efectos_max, 0),
			array_real : array_create(0, 0)
		}
		if aliado
			drones_construidos++
		return dron
	}
}