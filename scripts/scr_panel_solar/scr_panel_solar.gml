function scr_panel_solar(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		change_energia(energia_solar * edificio_energia_consumo[index], edificio)
	}
}