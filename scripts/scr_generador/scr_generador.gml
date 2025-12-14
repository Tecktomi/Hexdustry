function scr_generador(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		if edificio.fuel > 0{
			edificio.fuel--
			sound_play_edificio(2, edificio.x, edificio.y)
		}
		if edificio.fuel <= 0{
			//Encender
			if edificio.carga[1] > 0 or edificio.carga[12] > 0{
				if edificio.carga[12] > 0{
					edificio.fuel = recurso_combustion_time[12]
					edificio.carga[12]--
					change_energia(floor(edificio_energia_consumo[index] * 1.2), edificio)
				}
				if edificio.carga[1] > 0{
					edificio.fuel = recurso_combustion_time[1]
					edificio.carga[1]--
					change_energia(edificio_energia_consumo[index], edificio)
				}
				if grafic_luz and not edificio.luz{
					edificio.luz = true
					add_luz(edificio.a, edificio.b, 1)
				}
				edificio.carga_total--
				mover_in(edificio)
			}
			//Apagar
			else{
				if grafic_luz and edificio.luz{
					edificio.luz = false
					add_luz(edificio.a, edificio.b, -1)
				}
				change_energia(0, edificio)
			}
		}
	}
}