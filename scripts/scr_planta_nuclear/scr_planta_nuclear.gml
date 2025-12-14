function scr_planta_nuclear(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		if edificio_flujo[index]
			var flujo = edificio.flujo, flujo_power = flujo.eficiencia
		//Está encendido
		if edificio.fuel > 0{
			edificio.fuel--
			if flujo.liquido != 0{
				if edificio_herir(edificio, 4)
					break
			}
			else{
				if flujo_power < 1 and edificio_herir(edificio, 1 - flujo_power)
					break
				change_energia(edificio_energia_consumo[index] * flujo_power, edificio)
			}
		}
		if edificio.fuel = 0 and flujo.liquido = 0{
			//Encender
			if edificio.carga[18] > 0 and edificio.carga[19] > 0 and flujo_power > 0{
				edificio.fuel = 900
				edificio.carga[18] -= 0.05
				edificio.carga[19]--
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
				edificio.carga_total -= 1.05
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