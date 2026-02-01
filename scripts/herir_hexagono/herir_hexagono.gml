function herir_hexagono(a, b, dmg, efecto = true, enemigo = false){
	with control{
		var chunk_x = clamp(a / chunk_width, 0, chunk_xsize - 1), chunk_y = clamp(a / chunk_width, 0, chunk_ysize - 1), dmg_total = 0
		var temp_array_dron = (enemigo ? chunk_dron_aliado[# chunk_x, chunk_y] : chunk_dron_enemigo[# chunk_x, chunk_y])
		for(var c = array_length(temp_array_dron) - 1; c >= 0; c--){
			var dron = temp_array_dron[c]
			if dron.a = a and dron.b = b
				herir_dron(dmg, dron)
		}
		if efecto{
			var temp_complex = abtoxy(a, b)
			array_push(efectos, add_efecto(spr_impacto, 0, temp_complex.a, temp_complex.b, 7, 1))
		}
	}
}