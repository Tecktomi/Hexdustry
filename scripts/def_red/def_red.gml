function def_red(){
	var red = {
		edificios : array_create(0, control.null_edificio),
		generacion: 0,
		consumo : 0,
		bateria : 0,
		bateria_max : 0,
		eficiencia : 0,
		punteros : array_create(0, 0),
		promedio : 0
	}
	return red
}