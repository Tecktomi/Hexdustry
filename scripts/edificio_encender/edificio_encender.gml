function edificio_encender(edificio = control.null_edificio, encender = true, energia = true, flujo = true, calor = true, luz = true){
	if encender{
		if energia
			change_energia(edificio.energia_consumo_max, edificio)
		if flujo
			change_flujo(edificio.flujo_consumo_max, edificio)
		if calor
			change_calor(control.edificio_temperatura[edificio.index], edificio)
	}
	else{
		if energia
			change_energia(0, edificio)
		if flujo
			change_flujo(0, edificio)
		if calor
			change_calor(0, edificio)
	}
	if luz
		encender_luz(encender, edificio)
}