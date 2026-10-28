function herir_hexagono(a, b, dmg, efecto = true, _jugador){
	with control{
		var chunk_x = clamp(a / CHUNK_WIDTH, 0, chunk_xsize - 1), chunk_y = clamp(b / CHUNK_HEIGHT, 0, chunk_ysize - 1), dmg_total = 0
		var c, d, dron, edificio, temp_complex, temp_array_dron
		for(d = 0; d < EQUIPOS; d++) if not aliados[# _jugador, d]{
			temp_array_dron = ds_grid_get(chunk_dron_jugador[d], chunk_x, chunk_y)
			for(c = array_length(temp_array_dron) - 1; c >= 0; c--){
				dron = temp_array_dron[c]
				if dron.a = a and dron.b = b
					herir_dron(dmg, dron)
			}
		}
		if edificio_bool[# a, b]{
			edificio = edificio_id[# a, b]
			if not aliados[# _jugador, edificio.jugador] and edificio.vida >= 0
				herir_edificio(dmg, edificio)
		}
		if efecto{
			temp_complex = abtoxy(a, b)
			array_push(efectos, add_efecto(spr_impacto, 0, temp_complex[0], temp_complex[1], 7, 1))
		}
	}
}