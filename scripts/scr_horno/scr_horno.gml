function scr_horno(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		if edificio.fuel > 0{
			edificio.fuel--
			sound_play_edificio(2, edificio.x, edificio.y)
		}
		if (edificio.carga[0] > 1 or edificio.carga[3] > 1 or edificio.carga[5] > 1) and
			(edificio.carga[1] > 0 or edificio.carga[12] > 0 or edificio.fuel > 0) and
			(edificio.carga[2] < 10 and edificio.carga[4] < 10 and edificio.carga[7] < 10){
			if edificio.fuel = 0
				if (edificio.carga[1] > 0 or edificio.carga[12] > 0){
					if edificio.carga[12] > 0{
						edificio.fuel = recurso_combustion_time[12]
						edificio.carga[12]--
					}
					else if edificio.carga[1] > 0{
						edificio.fuel = recurso_combustion_time[1]
						edificio.carga[1]--
					}
					if grafic_luz and not edificio.luz{
						edificio.luz = true
						var temp_list = edificio.coordenadas, size = ds_list_size(temp_list)
						for(var b = 0; b < size; b++){
							var temp_complex = temp_list[|b]
							add_luz(temp_complex.a, temp_complex.b, 1)
						}
					}
					edificio.carga_total--
					mover_in(edificio)
				}
				else if grafic_luz and edificio.luz{
					edificio.luz = false
					var temp_list = edificio.coordenadas, size = ds_list_size(temp_list)
					for(var b = 0; b < size; b++){
						var temp_complex = temp_list[|b]
						add_luz(temp_complex.a, temp_complex.b, -1)
					}
				}
			edificio.proceso++
			if edificio.proceso >= edificio_proceso[index]{
				if edificio.carga[5] > 1{
					edificio.carga[5] -= 2
					edificio.carga[7]++
					edificio.carga_total--
					edificio.proceso = 0
				}
				else if edificio.carga[3] > 1{
					edificio.carga[3] -= 2
					edificio.carga[4]++
					edificio.carga_total--
					edificio.proceso = -edificio_proceso[index] / 2
				}
				else if edificio.carga[0] > 1{
					edificio.carga[0] -= 2
					edificio.carga[2]++
					edificio.carga_total--
					edificio.proceso = 0
				}
				edificio.waiting = not mover(edificio.a, edificio.b)
			}
		}
	}
}