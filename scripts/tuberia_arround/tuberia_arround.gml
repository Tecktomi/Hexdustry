function tuberia_arround(edificio = control.null_edificio){
	with control{
		var enemigo = edificio.enemigo, temp_complex, aa, bb, c, temp_edificio, temp_liquido
		var my_liquido = (edificio.flujo = null_flujo) ? -1 : edificio.flujo.liquido
		edificio.select = 0
		for(c = 0; c < 6; c++){
			temp_complex = next_to(edificio.a, edificio.b, c)
			aa = temp_complex[0]
			bb = temp_complex[1]
			if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize or not edificio_bool[# aa, bb]
				continue
			temp_edificio = edificio_id[# aa, bb]
			temp_liquido = temp_edificio.flujo.liquido
			if edificio_flujo[temp_edificio.index] and temp_edificio.enemigo = enemigo and (my_liquido = -1 or temp_liquido = -1 or temp_liquido = my_liquido or temp_edificio.flujo_2.liquido = my_liquido)
				edificio.select += 1 << c
		}
	}
}