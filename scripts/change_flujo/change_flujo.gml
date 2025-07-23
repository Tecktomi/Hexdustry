function change_flujo(cantidad, edificio = control.null_edificio){
	var index = edificio.index
	if edificio_flujo[index]{
		var flujo = edificio.flujo
		//Fábrica
		if edificio_flujo_consumo[index] > 0{
			flujo.consumo -= edificio.flujo_consumo
			edificio.flujo_consumo = cantidad
			flujo.consumo += edificio.flujo_consumo
		}
		//Generador
		else{
			flujo.generacion += edificio.flujo_consumo
			edificio.flujo_consumo = cantidad
			flujo.generacion -= edificio.flujo_consumo
		}
	}
}