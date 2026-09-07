function mover_light(edificio = control.null_edificio){
	with control{
		if array_length(edificio.outputs) = 0
			return false
		var temp_edificio = edificio.outputs[0], out = edificio.carga_id
		if mover_check_light(out, temp_edificio){
			var index = temp_edificio.index, dir = edificio.dir
			edificio.carga[out]--
			edificio.carga_total--
			if temp_edificio.jugador = jugador and mision_actual >= 0 and mision.objetivo = idm_cargar_edificio and mision.target_id = index
				pasar_mision()
			if tag_recurso_piedra[out] and tag_edificio_piedra[index]
				out = idr_piedra
			else if tag_recurso_uranio[out] and tag_edificio_uranio[index]
				out = idr_uranio_bruto
			if index = id_nucleo{
				jugador_recursos[edificio.jugador, out]++
				if temp_edificio.jugador = jugador{
					recursos_obtenidos_time_temp[out]++
					if mision_actual >= 0 and mision.objetivo = idm_conseguir and mision.target_id = out and ++mision_counter >= mision.target_num
						pasar_mision()
				}
			}
			temp_edificio.carga[out]++
			temp_edificio.carga_total++
			temp_edificio.carga_id = out
			if edificio_camino[index]{
				var temp_dir = temp_edificio.dir
				if temp_dir != dir{
					if (temp_dir = ((dir + 1) mod 6)) or (temp_dir = ((dir + 5) mod 6))
						temp_edificio.proceso = edificio_proceso[index] / 3
					else if (temp_dir = ((dir + 2) mod 6)) or (temp_dir = ((dir + 4) mod 6))
						temp_edificio.proceso = edificio_proceso[index] / 2
				}
			}
			if edificio.carga_total = 0
				edificio.waiting = false
			mover_in(edificio)
			return true
		}
		return false
	}
}