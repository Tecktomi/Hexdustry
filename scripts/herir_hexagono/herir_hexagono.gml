function herir_hexagono(a, b, dmg, efecto = true){
	with control{
		var temp_array = chunk_enemigos[# a / chunk_width, b / chunk_height]
		for(var c = array_length(temp_array) - 1; c >= 0; c--){
			var target = temp_array[c]
			if target.posa = a and target.posb = b{
				target.vida -= dmg
				if target.vida <= 0
					destroy_dron(target)
			}
		}
		if efecto{
			var temp_complex = abtoxy(a, b)
			array_push(efectos, add_efecto(spr_impacto, 0, temp_complex.a, temp_complex.b, 7, 1))
		}
	}
}