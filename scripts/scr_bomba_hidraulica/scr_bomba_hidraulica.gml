function scr_bomba_hidraulica(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		var red = edificio.red, red_power = red.eficiencia
		var flujo = edificio.flujo
		//Está encendido
		if in(flujo.liquido, -1, edificio.fuel) and red_power > 0{
			change_flujo(red_power * edificio_flujo_consumo[index] * edificio.select / 3 * (1 + 0.2 * edificio.modulo), edificio)
			edificio_encender(edificio,,, false,, false)
			flujo.generacion -= edificio.proceso
			edificio.draw_rot += red_power
			if flujo.almacen >= flujo.almacen_max and flujo.generacion >= flujo.consumo
				edificio_encender(edificio, false,,,, false)
			if flujo.liquido != idl_lava and edificio.fuel = idl_lava
				encender_luz(, edificio)
			flujo.liquido = edificio.fuel
		}
		else
			edificio_encender(edificio, false,,,, false)
	}
}