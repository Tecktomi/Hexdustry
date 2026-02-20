function scr_generador(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		if edificio.fuel > 0{
			edificio.fuel--
			sound_play_edificio(2, edificio.center_x, edificio.center_y)
		}
		if edificio.fuel <= 0{
			//Encender
			if edificio.carga[idr_carbon] > 0 or edificio.carga[idr_compuesto_incendiario] > 0{
				if edificio.carga[idr_compuesto_incendiario] > 0{
					edificio.fuel = recurso_combustion_time[idr_compuesto_incendiario]
					edificio.carga[idr_compuesto_incendiario]--
					change_energia(floor(edificio_energia_consumo[index] * 1.2), edificio)
				}
				if edificio.carga[idr_carbon] > 0{
					edificio.fuel = recurso_combustion_time[idr_carbon]
					edificio.carga[idr_carbon]--
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