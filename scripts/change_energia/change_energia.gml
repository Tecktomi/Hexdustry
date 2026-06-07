function change_energia(energia, edificio = control.null_edificio){
	if energia = edificio.energia_consumo
		exit
	var index = edificio.index
	if edificio_energia[index]{
		var red = edificio.red, a = energia - edificio.energia_consumo
		edificio.energia_consumo = energia
		//Fábrica
		if edificio.energia_consumo_max >= 0
			red.consumo += a
		//Generador
		else
			red.generacion -= a
	}
}