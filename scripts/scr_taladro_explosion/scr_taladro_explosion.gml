function scr_taladro_explosion(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		if edificio.carga[idr_explosivo] > 0{
			if edificio.carga_total < edificio_carga_max[index]{
				edificio.proceso += 1 + 0.4 * edificio.modulo
				if edificio.proceso >= edificio_proceso[index]{
					sound_play(snd_explosion, edificio.center_x, edificio.center_y)
					edificio.carga[idr_explosivo]--
					edificio.carga_total--
					var temp_list = get_size(edificio.a, edificio.b, edificio.dir, edificio_size[index] + 2), flag = false
					for(var b = ds_list_size(temp_list) - 1; b >= 0; b--){
						var temp_complex = temp_list[|b], aa = temp_complex.a, bb = temp_complex.b
						if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
							continue
						if ore[# aa, bb] >= 0{
							edificio.carga[ore_recurso[ore[# aa, bb]]]++
							edificio.carga_total++
							flag = true
						}
						else if terreno_recurso_bool[terreno[# aa, bb]]{
							edificio.carga[terreno_recurso_id[terreno[# aa, bb]]]++
							edificio.carga_total++
							flag = true
						}
					}
					if flag
						edificio.waiting = not mover(edificio)
					else
						edificio.idle = true
					edificio.proceso = 0
				}
			}
		}
		if not edificio.waiting and edificio.carga_total > edificio.carga[idr_explosivo]
			edificio.waiting = not mover(edificio)
	}
}