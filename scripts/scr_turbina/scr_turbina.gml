function scr_turbina(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		var flujo = edificio.flujo, flujo_power = flujo.eficiencia
		//Ya está encendido
		if edificio.fuel > 0{
			edificio.fuel--
			if flujo.liquido = -1 or flujo.liquido = idl_agua{
				edificio.draw_rot += flujo_power
				change_energia(edificio_energia_consumo[index] * flujo_power, edificio)
				sound_play_edificio(2, edificio.center_x, edificio.center_y)
			}
		}
		if edificio.fuel = 0 and flujo.liquido = idl_agua{
			//Encender
			if (edificio.carga[idr_carbon] > 0 or edificio.carga[idr_compuesto_incendiario] > 0) and flujo_power > 0{
				if edificio.carga[idr_compuesto_incendiario] > 0{
					edificio.fuel = recurso_combustion_time[idr_compuesto_incendiario]
					edificio.carga[idr_compuesto_incendiario]--
				}
				else if edificio.carga[idr_carbon] > 0{
					edificio.fuel = recurso_combustion_time[idr_carbon]
					edificio.carga[idr_carbon]--
				}
				edificio_encender(edificio)
				change_energia(edificio_energia_consumo[index] * flujo_power, edificio)
				change_flujo(edificio_flujo_consumo[index] * (1 - 0.25 * edificio.modulo), edificio)
				edificio.carga_total--
				mover_in(edificio)
			}
			//Apagar
			else
				edificio_encender(edificio, false)
		}
	}
}