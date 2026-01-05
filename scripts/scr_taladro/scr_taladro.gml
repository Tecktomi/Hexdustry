function scr_taladro(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		if edificio_energia[index]
			var red = edificio.red
		var flujo = edificio.flujo
		if edificio.carga_total < edificio_carga_max[index]{
			if index = id_taladro_electrico{
				change_energia(edificio_energia_consumo[index], edificio)
				if red.eficiencia > 0 and edificio.flujo_consumo = 0 and flujo.liquido = 1
					change_flujo(edificio_flujo_consumo[index], edificio)
				edificio.proceso += red.eficiencia * (1 + 0.6 * (flujo.liquido = 1 ? flujo.eficiencia : 0))
			}
			else if index = id_taladro{
				change_flujo(edificio_flujo_consumo[index], edificio)
				edificio.proceso += 1 + 0.6 * (flujo.liquido = 0 ? flujo.eficiencia : 0)
			}
			sound_play_edificio(0, edificio.x, edificio.y, 2)
			if edificio.proceso >= edificio_proceso[index]{
				edificio.proceso = 0
				var temp_list = ds_list_create(), temp_complex_2 = null_complex, flag = false
				ds_list_copy(temp_list, edificio.coordenadas)
				ds_list_shuffle(temp_list)
				while not ds_list_empty(temp_list){
					temp_complex_2 = temp_list[|0]
					var aa = temp_complex_2.a, bb = temp_complex_2.b
					ds_list_delete(temp_list, 0)
					if in(ore[# aa, bb], 0, 1, 2){
						edificio.carga[ore_recurso[ore[# aa, bb]]]++
						edificio.carga_total++
						if edificio.carga_total = edificio_carga_max[index]
							change_energia(0, edificio)
						ds_grid_add(ore_amount, aa, bb, -1)
						if ore_amount[# aa, bb] = 50
							update_background(aa, bb)
						else if ore_amount[# aa, bb] = 0
							ds_grid_set(ore, aa, bb, -1)
							update_background(aa, bb)
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
				ds_list_destroy(temp_list)
				if flag
					edificio.waiting = not mover(edificio.a, edificio.b)
				else{
					edificio.idle = true
					change_energia(0, edificio)
				}
				if index = id_taladro_electrico and flujo.liquido = 1
					change_flujo(0, edificio)
				if index = id_taladro and flujo.liquido = 0
					change_flujo(0, edificio)
			}
		}
	}
}