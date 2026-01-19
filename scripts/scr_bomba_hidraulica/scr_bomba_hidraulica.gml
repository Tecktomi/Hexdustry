function scr_bomba_hidraulica(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		if edificio_energia[index]
			var red = edificio.red, red_power = red.eficiencia
		if edificio_flujo[index]
			var flujo = edificio.flujo
		//Está encendido
		if in(flujo.liquido, -1, edificio.fuel) and red_power > 0{
			change_energia(edificio_energia_consumo[index], edificio)
			change_flujo(red_power * edificio_flujo_consumo[index] * edificio.select / 3 * (1 + 0.2 * edificio.modulo), edificio)
			flujo.generacion -= edificio.proceso
			if flujo.almacen >= flujo.almacen_max and flujo.generacion >= flujo.consumo{
				change_energia(0, edificio)
				change_flujo(0, edificio)
			}
			if flujo.liquido != 3 and edificio.fuel = 3
				encender_luz(, edificio)
			flujo.liquido = edificio.fuel
		}
		else{
			change_energia(0, edificio)
			change_flujo(0, edificio)
		}
	}
}