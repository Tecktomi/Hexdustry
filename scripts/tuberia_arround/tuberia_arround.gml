function tuberia_arround(edificio = control.null_edificio){
	with control{
		var _jugador = edificio.jugador, temp_complex, aa, bb, c, temp_edificio, temp_liquido
		var my_liquido = (edificio.flujo = null_flujo) ? -1 : edificio.flujo.liquido, bmod = edificio.b & 1
		edificio.select = 0
		for(c = 0; c < 6; c++){
			aa = edificio.a + DESFACE_A[bmod, c]
			bb = edificio.b + DESFACE_B[bmod, c]
			if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize or not edificio_bool[# aa, bb]
				continue
			temp_edificio = edificio_id[# aa, bb]
			temp_liquido = temp_edificio.flujo.liquido
			if temp_edificio.jugador = _jugador and edificio_flujo[temp_edificio.index] and (my_liquido = -1 or temp_liquido = -1 or temp_liquido = my_liquido or temp_edificio.flujo_2.liquido = my_liquido)
				edificio.select += 1 << c
		}
	}
}