function add_dron(a, b, index, _jugador = jugador){
	with control{
		var temp_complex = abtoxy(a, b), enemigo = (_jugador != jugador)
		var dron = {
			a : a,
			b : b,
			index : real(index),
			enemigo : enemigo,
			x : temp_complex[0] + random_range(-4, 4),
			y : temp_complex[1] + random_range(-4, 4),
			vida_max : dron_vida_max[index],
			vida : dron_vida_max[index],
			target : null_edificio,
			temp_target : null_edificio,
			target_dron : null_dron,
			chunk_x : clamp(round(a / CHUNK_WIDTH), 0, chunk_xsize - 1),
			chunk_y : clamp(round(b / CHUNK_HEIGHT), 0, chunk_ysize - 1),
			carga : array_create(rss_max, 0),
			carga_total : 0,
			modo : 0,
			torres : array_create(0, null_edificio),
			dir : 0,
			dir_move : 0,
			step : 0,
			efecto : array_create(efectos_max, 0),
			move_xmove : 0,
			move_ymove : 0,
			move_dis : 0,
			move_x : 0,
			move_y : 0,
			target_a : 0,
			target_b : 0,
			last_dir : -1,
			oleada : 0,
			random_int : random(1),
			selected : false,
			jugador : _jugador,
			change_pos : false,
			move_dir : 0,
			punteros : array_create(ptrd_MAX, -1),
		}
		if _jugador = 1{
			dron.vida_max = ceil(dron.vida * power((oleada_count + 3) / 3, 1.1) * multiplicador_vida_enemigos / 100)
			dron.vida = dron.vida_max
			dron.target = edificio_cercano[# a, b]
			if dron_aereo[dron.index]{
				if brandom()
					dron_set_target(dron, [id_nucleo])
				else
					dron_set_target(dron, [id_silo_de_misiles, id_planta_nuclear, id_generador_geotermico, id_turbina, id_generador, id_panel_solar, id_nucleo])
			}
			else if tag_dron_marino[index]
				dron_set_target(dron, [id_nucleo])
		}
		else
			drones_construidos++
		array_disorder_push(drones_jugador[_jugador], dron, ptrd_jugador)
		array_disorder_push(drones, dron, ptrd_total)
		dron_chunk_push(dron)
		return dron
	}
}