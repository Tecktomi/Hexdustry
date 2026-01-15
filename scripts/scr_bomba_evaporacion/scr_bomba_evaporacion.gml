function scr_bomba_evaporacion(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		var flujo = edificio.flujo
		if in(flujo.liquido, -1, 0){
			change_flujo(energia_solar * edificio_flujo_consumo[index], edificio)
			flujo.liquido = 0
		}
	}
}