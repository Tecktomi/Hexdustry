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
			if (edificio.carga[id_carbon] > 0 or edificio.carga[id_combustible] > 0) and flujo_power > 0{
				if edificio.carga[id_combustible] > 0{
					edificio.fuel = recurso_combustion_time[12]
					edificio.carga[id_combustible]--
				}
				else if edificio.carga[id_carbon] > 0{
					edificio.fuel = recurso_combustion_time[1]
					edificio.carga[id_carbon]--
				}
				encender_luz(1, edificio)
				change_energia(edificio_energia_consumo[index] * flujo_power, edificio)
				change_flujo(edificio_flujo_consumo[index], edificio)
				edificio.carga_total--
				mover_in(edificio)
			}
			//Apagar
			else{
				encender_luz(-1, edificio)
				change_energia(0, edificio)
				change_flujo(0, edificio)
			}
		}
	}
}