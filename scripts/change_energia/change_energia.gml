function change_energia(energia, edificio = control.null_edificio){
	var index = edificio.index
	if edificio_energia[index]{
		var red = edificio.red
		//Fábrica
		if edificio.energia_consumo_max >= 0{
			red.consumo -= edificio.energia_consumo
			edificio.energia_consumo = energia
			red.consumo += edificio.energia_consumo
		}
		//Generador
		else{
			red.generacion += edificio.energia_consumo
			edificio.energia_consumo = energia
			red.generacion -= edificio.energia_consumo
		}
	}
}