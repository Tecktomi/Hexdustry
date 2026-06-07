function scr_generador_geotermico(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		var flujo = edificio.flujo, flujo_power = flujo.eficiencia
		if in(edificio.flujo.liquido, -1, idl_agua, idl_agua_salada){
			change_energia(flujo_power * edificio_energia_consumo[index] * edificio.select / 3, edificio)
			change_flujo(edificio_flujo_consumo[index] * (1 - 0.25 * edificio.modulo), edificio)
			edificio_encender(edificio,, false, false)
			edificio.draw_rot += flujo_power
		}
		else
			edificio_encender(edificio, false)
	}
}