function camino_calcular_in(edificio = control.null_edificio){
	with control{
		var bmod = edificio.b & 1
		edificio.array_real[4] = 0
		for(var c = 0; c < 6; c++){
			if c = edificio.dir or c = ((edificio.dir + 3) mod 6)
				continue
			var aa = edificio.a + DESFACE_A[bmod, c], bb = edificio.b + DESFACE_B[bmod, c]
			if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
				continue
			if edificio_bool[# aa, bb]{
				var temp_edificio = edificio_id[# aa, bb]
				if temp_edificio.index = id_cruce{
					aa = aa + DESFACE_A[bb & 1, c]
					bb = bb + DESFACE_B[bb & 1, c]
					if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize or not edificio_bool[# aa, bb]
						continue
					temp_edificio = edificio_id[# aa, bb]
				}
				if array_contains(edificio.inputs, temp_edificio)
					edificio.array_real[4] += (1 << c)
			}
		}
	}
}