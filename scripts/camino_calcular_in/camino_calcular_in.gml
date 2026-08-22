function camino_calcular_in(edificio = control.null_edificio){
	with control{
		var bmod = edificio.b & 1, a, aa, bb, temp_edificio
		edificio.array_real[4] = 0
		for(a = 0; a < 6; a++){
			if a = edificio.dir or a = ((edificio.dir + 3) mod 6)
				continue
			aa = edificio.a + DESFACE_A[bmod, a]
			bb = edificio.b + DESFACE_B[bmod, a]
			if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
				continue
			if edificio_bool[# aa, bb]{
				temp_edificio = edificio_id[# aa, bb]
				if temp_edificio.index = id_cruce{
					aa = aa + DESFACE_A[bb & 1, a]
					bb = bb + DESFACE_B[bb & 1, a]
					if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize or not edificio_bool[# aa, bb]
						continue
					temp_edificio = edificio_id[# aa, bb]
				}
				if array_contains(edificio.inputs, temp_edificio)
					edificio.array_real[4] += (1 << a)
			}
		}
	}
}