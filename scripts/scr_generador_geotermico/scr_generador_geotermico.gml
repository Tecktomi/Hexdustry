function scr_generador_geotermico(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		var flujo = edificio.flujo, flujo_power = flujo.eficiencia
		if in(edificio.flujo.liquido, -1, idl_agua){
			change_energia(flujo_power * edificio_energia_consumo[index] * edificio.select / 3, edificio)
			change_flujo(edificio_flujo_consumo[index] * (1 - 0.25 * edificio.modulo), edificio)
			encender_luz(, edificio)
			edificio.draw_rot += flujo_power
		}
		else{
			change_energia(0, edificio)
			change_flujo(0, edificio)
			encender_luz(false, edificio)
		}
	}
}