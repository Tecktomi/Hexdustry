function aplicar_efecto(efecto, duracion, dron = control.null_efecto){
	if dron != null_dron
		dron.efecto[efecto] = max(dron.efecto[efecto], duracion)
}