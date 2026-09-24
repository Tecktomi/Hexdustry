function aplicar_efecto(efecto, duracion, dron = control.null_dron){
	if dron != control.null_dron
		dron.efecto[efecto] = max(dron.efecto[efecto], duracion)
}