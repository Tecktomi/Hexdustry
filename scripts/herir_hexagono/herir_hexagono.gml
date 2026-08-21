function herir_hexagono(a, b, dmg, efecto = true, enemigo = false){
	with control{
		var chunk_x = clamp(a / CHUNK_WIDTH, 0, chunk_xsize - 1), chunk_y = clamp(a / CHUNK_WIDTH, 0, chunk_ysize - 1), dmg_total = 0
		var temp_array_dron = (enemigo ? chunk_dron_aliado[# chunk_x, chunk_y] : chunk_dron_enemigo[# chunk_x, chunk_y]), c, dron, edificio, temp_complex
		for(c = array_length(temp_array_dron) - 1; c >= 0; c--){
			dron = temp_array_dron[c]
			if dron.a = a and dron.b = b
				herir_dron(dmg, dron)
		}
		if edificio_bool[# a, b]{
			edificio = edificio_id[# a, b]
			if edificio.enemigo != enemigo and edificio.vida >= 0
				herir_edificio(dmg, edificio)
		}
		if efecto{
			temp_complex = abtoxy(a, b)
			array_push(efectos, add_efecto(spr_impacto, 0, temp_complex[0], temp_complex[1], 7, 1))
		}
	}
}