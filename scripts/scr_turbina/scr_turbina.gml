function scr_turbina(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		if edificio_flujo[index]
			var flujo = edificio.flujo, flujo_power = flujo.eficiencia
		//Ya está encendido
		if edificio.fuel > 0{
			edificio.fuel--
			if in(flujo.liquido, -1, 0)
				change_energia(edificio_energia_consumo[index] * flujo_power, edificio)
			sound_play_edificio(2, edificio.x, edificio.y)
		}
		if edificio.fuel = 0 and flujo.liquido = 0{
			//Encender
			if (edificio.carga[1] > 0 or edificio.carga[12] > 0) and flujo_power > 0{
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
				change_energia(edificio_energia_consumo[index] * flujo_power, edificio)
				change_flujo(edificio_flujo_consumo[index], edificio)
				edificio.carga_total--
				mover_in(edificio)
			}
			//Apagar
			else{
				if grafic_luz and edificio.luz{
					edificio.luz = false
					var temp_list = edificio.coordenadas, size = ds_list_size(temp_list)
					for(var b = 0; b < size; b++){
						var temp_complex = temp_list[|b]
						add_luz(temp_complex.a, temp_complex.b, -1)
					}
				}
				change_energia(0, edificio)
				change_flujo(0, edificio)
			}
		}
	}
}