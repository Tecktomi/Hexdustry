function tuberia_arround(edificio = control.null_edificio){
	with control{
		var enemigo = edificio.enemigo
		edificio.select = 0
		for(var c = 0; c < 6; c++){
			temp_complex = next_to(edificio.a, edificio.b, c)
			var aa = temp_complex.a, bb = temp_complex.b
			if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize or not edificio_bool[# aa, bb]
				continue
			var temp_edificio = edificio_id[# aa, bb]
			if edificio_flujo[temp_edificio.index] and temp_edificio.enemigo = enemigo
				edificio.select += 1 << c
		}
	}
}