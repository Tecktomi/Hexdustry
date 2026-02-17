function add_dron(a, b, index, enemigo = true){
	with control{
		var temp_complex = abtoxy(a, b)
		var dron = {
			x : temp_complex.a + random_range(-4, 4),
			y : temp_complex.b + random_range(-4, 4),
			index : real(index),
			vida : dron_vida_max[index],
			vida_max : dron_vida_max[index],
			target : null_edificio,
			temp_target : null_edificio,
			target_dron : null_dron,
			chunk_x : clamp(round(a / chunk_width), 0, chunk_xsize - 1),
			chunk_y : clamp(round(b / chunk_height), 0, chunk_ysize - 1),
			a : a,
			b : b,
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
			selected : false,
			//0 = [enemigos, aliados], 1 = chunk_pointer
			punteros : array_create(2, 0),
		}
		if enemigo{
			array_disorder_push(enemigos, dron, 0)
			dron.vida_max = dron.vida * power((oleada_count + 3) / 3, 1.1) * multiplicador_vida_enemigos / 100
			dron.vida = dron.vida_max
			dron.target = edificio_cercano[# a, b]
			if dron_aereo[dron.index]{
				var min_dis = infinity, temp_edificio = dron.target, aaa = temp_complex.a, bbb = temp_complex.b
				if brandom(){
					for(var j = array_length(nucleos) - 1; j >= 0; j--){
						temp_edificio = nucleos[j]
						var dis = distance_sqr(aaa, bbb, temp_edificio.center_x, temp_edificio.center_y)
						if dis < min_dis{
							min_dis = dis
							dron.target = temp_edificio
						}
					}
				}
				else{
					if array_length(edificios_index[id_silo_de_misiles]) > 0
						temp_edificio = edificios_index[id_silo_de_misiles, 0]
					else if array_length(edificios_index[id_planta_nuclear]) > 0
						temp_edificio = edificios_index[id_planta_nuclear, 0]
					else if array_length(edificios_index[id_generador_geotermico]) > 0
						temp_edificio = edificios_index[id_generador_geotermico, 0]
					else if array_length(edificios_index[id_turbina]) > 0
						temp_edificio = edificios_index[id_turbina, 0]
					else if array_length(edificios_index[id_generador]) > 0
						temp_edificio = edificios_index[id_generador, 0]
					else if array_length(edificios_index[id_panel_solar]) > 0
						temp_edificio = edificios_index[id_panel_solar, 0]
					dron.target = temp_edificio
				}
			}
		}
		else{
			array_disorder_push(drones_aliados, dron, 0)
			drones_construidos++
		}
		dron_chunk_push(dron)
		return dron
	}
}