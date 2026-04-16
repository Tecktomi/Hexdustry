function scr_taladro(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		if edificio_energia[index]
			var red = edificio.red, red_power = red.eficiencia
		var flujo = edificio.flujo
		if edificio.carga_total < edificio_carga_max[index]{
			if index = id_taladro_electrico{
				change_energia(edificio_energia_consumo[index], edificio)
				if red_power > 0 and flujo.liquido = idl_agua
					change_flujo(edificio_flujo_consumo[index], edificio)
				edificio.proceso += red_power * (1 + 0.6 * (flujo.liquido = idl_agua ? flujo.eficiencia : 0)) * edificio.select * (1 + 0.4 * edificio.modulo)
			}
			else if index = id_taladro
				edificio.proceso += edificio.select * (1 + 0.4 * edificio.modulo)
			sound_play_edificio(3, edificio.center_x, edificio.center_y, 0.4)
			if edificio.proceso >= edificio_proceso[index]{
				edificio.proceso = 0
				var temp_list = array_create(array_length(edificio.coordenadas)), temp_complex_2 = {a : 0, b : 0}, flag = false
				array_clone(temp_list, edificio.coordenadas)
				array_shuffle(temp_list)
				while array_length(temp_list) > 0{
					temp_complex_2 = temp_list[array_length(temp_list) - 1]
					var aa = temp_complex_2[0], bb = temp_complex_2[1]
					array_pop(temp_list)
					if in(ore[# aa, bb], ido_cobre, ido_hierro, ido_carbon){
						edificio.carga[ore_recurso[ore[# aa, bb]]]++
						edificio.carga_total++
						if edificio.carga_total = edificio_carga_max[index]
							change_energia(0, edificio)
						if minar(aa, bb)
							edificio.select -= 0.05
						flag = true
						break
					}
					else if terreno_recurso_bool[terreno[# aa, bb]] and index = id_taladro_electrico{
						edificio.carga[terreno_recurso_id[terreno[# aa, bb]]]++
						edificio.carga_total++
						if edificio.carga_total = edificio_carga_max[index]
							change_energia(0, edificio)
						flag = true
						break
					}
				}
				if flag
					edificio.waiting = not mover(edificio)
				else{
					edificio.idle = true
					change_energia(0, edificio)
				}
				if index = id_taladro_electrico and flujo.liquido = idl_agua
					change_flujo(0, edificio)
			}
		}
		if edificio.carga_total > 0
			edificio.waiting = not mover(edificio)
	}
}