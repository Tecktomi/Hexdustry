function change_flujo(cantidad, edificio = control.null_edificio){
	if cantidad = edificio.flujo_consumo
		exit
	var index = edificio.index
	if edificio_flujo[index]{
		var flujo = edificio.flujo, a = cantidad - edificio.flujo_consumo
		edificio.flujo_consumo = cantidad
		//Fábrica
		if edificio.flujo_consumo_max >= 0
			flujo.consumo += a
		//Generador
		else
			flujo.generacion -= a
	}
}