function change_flujo(cantidad, edificio = control.null_edificio, flujo = control.null_flujo){
	with control{
		if flujo = null_flujo
			flujo = edificio.flujo
		var consumo = (flujo = edificio.flujo) ? edificio.flujo_consumo : edificio.flujo_2_consumo
		if cantidad = consumo
			exit
		var index = edificio.index
		if edificio_flujo[index]{
			var a = cantidad - consumo
			if flujo = edificio.flujo
				edificio.flujo_consumo = cantidad
			else
				edificio.flujo_2_consumo = cantidad
			//Fábrica
			if edificio.flujo_consumo_max >= 0
				flujo.consumo += a
			//Generador
			else
				flujo.generacion -= a
		}
	}
}