function explosion(aa = 0, bb = 0, edificio = control.null_edificio, enemigo = true, radio = 14_400, dmg = 1000, incendiario = false){
	with control{
		sound_play(snd_explosion, aa, bb)
		array_push(efectos, add_efecto(spr_explosion, 0, aa, bb, 24, 1 / 3))
		if edificio != null_edificio
			herir_edificio(dmg / 10, edificio)
		var temp_complex = xytoab(aa, bb)
		if temp_complex.a < 0
			exit
		var chunk_x = floor(temp_complex.a / chunk_width), chunk_y = floor(temp_complex.b / chunk_height)
		var mina = max(chunk_x - 1, 0), minb = max(chunk_y - 1, 0), maxa = min(chunk_x + 1, chunk_xsize - 1), maxb = min(chunk_y + 1, chunk_ysize - 1)
		var temp_chunk_edificios = (enemigo ? chunk_edificios : chunk_edificios_enemigo), temp_array_dron = (enemigo ? chunk_dron_aliado : chunk_dron_enemigo), dmg_total = 0
		if incendiario{
			for(var a = mina; a <= maxa; a++)
				for(var b = minb; b <= maxb; b++){
					//Herir edificios
					for(var i = array_length(temp_chunk_edificios[# a, b]) - 1; i >= 0; i--){
						edificio = temp_chunk_edificios[# a, b][i]
						var dis = distance_sqr(aa, bb, edificio.center_x, edificio.center_y)
						if dis < radio
							herir_edificio(dmg / (10 + sqrt(dis)), edificio)
					}
					//Herir drones
					for(var i = array_length(temp_array_dron[# a, b]) - 1; i >= 0; i--){
						var dron = temp_array_dron[# a, b][i], dis = distance_sqr(aa, bb, dron.x, dron.y)
						if dis < radio and not herir_dron(dmg / (10 + sqrt(dis)), dron)
							aplicar_efecto(1, 120, dron)
					}
				}
		}
		else{
			for(var a = mina; a <= maxa; a++)
				for(var b = minb; b <= maxb; b++){
					//Herir edificios
					for(var i = array_length(temp_chunk_edificios[# a, b]) - 1; i >= 0; i--){
						edificio = temp_chunk_edificios[# a, b][i]
						var dis = distance_sqr(aa, bb, edificio.center_x, edificio.center_y)
						if dis < radio
							herir_edificio(dmg / (10 + sqrt(dis)), edificio)
					}
					//Herir drones
					for(var i = array_length(temp_array_dron[# a, b]) - 1; i >= 0; i--){
						var dron = temp_array_dron[# a, b][i], dis = distance_sqr(aa, bb, dron.x, dron.y)
						if dis < radio
							herir_dron(dmg / (10 + sqrt(dis)), dron)
					}
				}
		}
	}
}