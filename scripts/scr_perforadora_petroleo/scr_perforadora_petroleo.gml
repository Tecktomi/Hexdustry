function scr_perforadora_petroleo(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		var red = edificio.red, red_power = red.eficiencia
		var flujo = edificio.flujo
		//Está encendido
		if in(flujo.liquido, -1, 2) and red_power > 0 and flujo.almacen < flujo.almacen_max{
			change_energia(edificio_energia_consumo[index] * (1 - 0.25 * edificio.modulo), edificio)
			change_flujo(red_power * edificio_flujo_consumo[index], edificio)
			flujo.liquido = 2
			encender_luz(, edificio)
		}
		//Está apagado
		else{
			change_energia(0, edificio)
			change_flujo(0, edificio)
			encender_luz(false, edificio)
		}
	}
}