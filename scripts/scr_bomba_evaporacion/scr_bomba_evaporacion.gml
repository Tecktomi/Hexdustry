function scr_bomba_evaporacion(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		change_flujo(energia_solar * edificio_flujo_consumo[index], edificio)
	}
}