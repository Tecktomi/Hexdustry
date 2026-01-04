function scr_horno(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		if edificio.fuel > 0{
			edificio.fuel--
			sound_play_edificio(2, edificio.x, edificio.y)
		}
		if (edificio.carga[id_cobre] > 1 or edificio.carga[id_hierro] > 1 or edificio.carga[id_arena] > 1) and
			(edificio.carga[id_carbon] > 0 or edificio.carga[id_combustible] > 0 or edificio.fuel > 0) and
			(edificio.carga[id_bronce] < 10 and edificio.carga[id_acero] < 10 and edificio.carga[id_silicio] < 10){
			if edificio.fuel = 0
				if (edificio.carga[id_carbon] > 0 or edificio.carga[id_combustible] > 0){
					if edificio.carga[id_combustible] > 0{
						edificio.fuel = recurso_combustion_time[id_combustible]
						edificio.carga[id_combustible]--
					}
					else if edificio.carga[id_carbon] > 0{
						edificio.fuel = recurso_combustion_time[id_carbon]
						edificio.carga[id_carbon]--
					}
					if grafic_luz and not edificio.luz{
						edificio.luz = true
						var temp_list = edificio.coordenadas
						for(var b = ds_list_size(temp_list) - 1; b >= 0; b--){
							var temp_complex = temp_list[|b]
							add_luz(temp_complex.a, temp_complex.b, 1)
						}
					}
					edificio.carga_total--
					mover_in(edificio)
				}
				else if grafic_luz and edificio.luz{
					edificio.luz = false
					var temp_list = edificio.coordenadas
					for(var b = ds_list_size(temp_list) - 1; b >= 0; b--){
						var temp_complex = temp_list[|b]
						add_luz(temp_complex.a, temp_complex.b, -1)
					}
				}
			edificio.proceso++
			if edificio.proceso >= edificio_proceso[index]{
				if edificio.carga[id_arena] > 1{
					edificio.carga[id_arena] -= 2
					edificio.carga[id_silicio]++
					edificio.carga_total--
					edificio.proceso = 0
					if edificio.carga[id_sal] > 0{
						edificio.carga[id_sal] -= 0.1
						edificio.carga_total -= 0.1
						edificio.proceso = floor(edificio_proceso[index] / 4)
					}
				}
				else if edificio.carga[id_hierro] > 1{
					edificio.carga[id_hierro] -= 2
					edificio.carga[id_acero]++
					edificio.carga_total--
					edificio.proceso = -edificio_proceso[index] / 2
				}
				else if edificio.carga[id_cobre] > 1{
					edificio.carga[id_cobre] -= 2
					edificio.carga[id_bronce]++
					edificio.carga_total--
					edificio.proceso = 0
				}
				edificio.waiting = not mover(edificio.a, edificio.b)
			}
		}
	}
}