function scr_perforadora_petroleo(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		var red = edificio.red, red_power = red.eficiencia
		var flujo = edificio.flujo
		//Está encendido
		if in(flujo.liquido, -1, idl_petroleo) and red_power > 0 and flujo.almacen < flujo.almacen_max{
			change_energia(edificio_energia_consumo[index] * (1 - 0.25 * edificio.modulo), edificio)
			change_flujo(red_power * edificio_flujo_consumo[index], edificio)
			edificio_encender(edificio,, false, false)
			edificio.draw_rot += red_power
			flujo.liquido = idl_petroleo
			encender_luz(, edificio)
			change_calor(edificio_temperatura[index], edificio)
		}
		//Está apagado
		else
			edificio_encender(edificio, false)
	}
}