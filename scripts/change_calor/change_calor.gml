function change_calor(calor, edificio = control.null_edificio){
	with control{
		if calor = edificio.calor_generado
			exit
		var a = calor - edificio.calor_generado, i, temp_complex, aa, bb
		edificio.calor += 2 * a
		edificio.calor_generado = calor
		for(i = array_length(edificio.bordes) - 1; i >= 0; i--){
			temp_complex = edificio.bordes[i]
			aa = temp_complex[0]
			bb = temp_complex[1]
			if aa >= 0 and bb >= 0 and aa < xsize and bb < ysize{
				temperatura[# aa, bb] += a
				if edificio_bool[# aa, bb]
					edificio_id[# aa, bb].calor += a
			}
		}
	}
}