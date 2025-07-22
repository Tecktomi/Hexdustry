function change_energia(energia, edificio = control.null_edificio){
	var index = edificio.index
	if edificio_energia[index]{
		//Fábrica
		if edificio_energia_consumo[index] > 0{
			edificio.red.consumo -= edificio.energia_consumo
			edificio.energia_consumo = energia
			edificio.red.consumo += edificio.energia_consumo
		}
		//Generador
		else{
			edificio.red.generacion += edificio.energia_consumo
			edificio.energia_consumo = energia
			edificio.red.generacion -= edificio.energia_consumo
		}
	}
}