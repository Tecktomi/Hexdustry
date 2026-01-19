function scr_generador(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		if edificio.fuel > 0{
			edificio.fuel--
			sound_play_edificio(2, edificio.x, edificio.y)
		}
		if edificio.fuel <= 0{
			//Encender
			if edificio.carga[id_carbon] > 0 or edificio.carga[id_combustible] > 0{
				if edificio.carga[id_combustible] > 0{
					edificio.fuel = recurso_combustion_time[id_combustible]
					edificio.carga[id_combustible]--
					change_energia(floor(edificio_energia_consumo[index] * 1.2), edificio)
				}
				if edificio.carga[id_carbon] > 0{
					edificio.fuel = recurso_combustion_time[id_carbon]
					edificio.carga[id_carbon]--
					change_energia(edificio_energia_consumo[index], edificio)
				}
				encender_luz(, edificio)
				edificio.carga_total--
				mover_in(edificio)
			}
			//Apagar
			else{
				encender_luz(false, edificio)
				change_energia(0, edificio)
			}
		}
	}
}