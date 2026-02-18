function def_flujo(){
	var flujo = {
		edificios : array_create(0, control.null_edificio),
		liquido : -1,
		generacion: 0,
		consumo: 0,
		almacen : 0,
		almacen_max : 0,
		eficiencia : 0,
		punteros : array_create(0, 0),
		promedio : 0
	}
	return flujo
}