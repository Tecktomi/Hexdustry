function camino_calcular_in(edificio = control.null_edificio){
	with control{
		edificio.array_real[4] = 0
		for(var c = 0; c < 6; c++){
			if c = edificio.dir or c = ((edificio.dir + 3) mod 6)
				continue
			var temp_complex = next_to(edificio.a, edificio.b, c), aa = temp_complex.a, bb = temp_complex.b
			if edificio_bool[# aa, bb]{
				var temp_edificio = edificio_id[# aa, bb]
				if array_contains(edificio.inputs, temp_edificio)
					edificio.array_real[4] += (1 << c)
			}
		}
	}
}