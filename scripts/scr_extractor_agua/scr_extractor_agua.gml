function scr_extractor_agua(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		var red = edificio.red, red_power = red.eficiencia
		var flujo = edificio.flujo
		if in(flujo.liquido, -1, idl_agua) and flujo.almacen < flujo.almacen_max{
			edificio_encender(edificio,,, false,, false)
			change_flujo(red_power * edificio_flujo_consumo[index] * edificio.select, edificio)
			flujo.liquido = idl_agua
		}
		else
			edificio_encender(edificio, false,,,, false)
	}
}