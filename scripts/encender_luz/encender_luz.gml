function encender_luz(fuerza, edificio = control.null_edificio){
	if control.grafic_luz and ((not edificio.luz and fuerza > 0) or (edificio.luz and fuerza < 0)){
		edificio.luz = true
		var temp_list = edificio.coordenadas
		for(var b = ds_list_size(temp_list) - 1; b >= 0; b--){
			var temp_complex = temp_list[|b]
			add_luz(temp_complex.a, temp_complex.b, fuerza)
		}
	}
}