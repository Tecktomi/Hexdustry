function scr_extractor_agua(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		var red = edificio.red, red_power = red.eficiencia
		var flujo = edificio.flujo
		if in(flujo.liquido, -1, 0) and flujo.almacen < flujo.almacen_max{
			change_energia(edificio_energia_consumo[index], edificio)
			change_flujo(red_power * edificio_flujo_consumo[index] * edificio.select, edificio)
			flujo.liquido = 0
		}
		else{
			change_energia(0, edificio)
			change_flujo(0, edificio)
		}
	}
}