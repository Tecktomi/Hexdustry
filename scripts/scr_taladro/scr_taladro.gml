function scr_taladro(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		if edificio_energia[index]
			var red = edificio.red, red_power = red.eficiencia
		var carga = edificio.carga
		var flujo = edificio.flujo, aa, bb, temp_complex, flag, i, j, len
		if edificio.carga_total < edificio_carga_max[index]{
			var temp_progreso = 0
			if index = id_taladro_electrico{
				change_energia(edificio_energia_consumo[index], edificio)
				if red_power > 0 and flujo.liquido = idl_lubricante
					change_flujo(edificio_flujo_consumo[index], edificio)
				temp_progreso = red_power * edificio.select * (1 + 0.4 * edificio.modulo)
			}
			else if index = id_taladro{
				if flujo.liquido = idl_lubricante
					change_flujo(edificio_flujo_consumo[index], edificio)
				temp_progreso = edificio.select * (1 + 0.4 * edificio.modulo)
			}
			if flujo.liquido = idl_lubricante
				temp_progreso *= (1 + 0.3 * flujo.eficiencia)
			if temp_progreso > 0
				sound_play_edificio(3, edificio.center_x, edificio.center_y, 0.4)
			edificio.proceso += temp_progreso
			if edificio.proceso >= edificio_proceso[index]{
				if carga[idr_alumina] > 0.1{
					carga[idr_alumina] -= 0.1
					edificio.carga_total -= 0.1
					edificio.proceso += edificio_proceso[index] / 4
				}
				edificio.proceso -= edificio_proceso[index]
				len = array_length(edificio.coordenadas)
				j = 2 * irandom(len / 2 - 1)
				flag = false
				for(i = 0; i < len;){
					aa = edificio.coordenadas[(i++ + j) mod len]
					bb = edificio.coordenadas[(i++ + j) mod len]
					if in(ore[# aa, bb], ido_cobre, ido_hierro, ido_carbon){
						carga[ore_recurso[ore[# aa, bb]]]++
						edificio.carga_total++
						if edificio.carga_total >= edificio_carga_max[index]
							edificio_encender(edificio, false,,, false)
						if minar(aa, bb)
							edificio.select -= 0.05
						flag = true
						break
					}
					else if terreno_recurso_bool[terreno[# aa, bb]] and index = id_taladro_electrico{
						carga[terreno_recurso_id[terreno[# aa, bb]]]++
						edificio.carga_total++
						if edificio.carga_total = edificio_carga_max[index]
							edificio_encender(edificio, false,,, false)
						flag = true
						break
					}
				}
				if flag
					edificio.waiting = not mover(edificio)
				else{
					edificio.idle = true
					edificio_encender(edificio, false,,, false)
				}
			}
		}
		if edificio.carga_total > 0
			edificio.waiting = not mover(edificio)
	}
}