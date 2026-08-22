function scr_panel_solar(edificio = control.null_edificio){
	with control
		change_energia(energia_solar * edificio_energia_consumo[edificio.index], edificio)
}