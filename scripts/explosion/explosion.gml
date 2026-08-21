function explosion(aa = 0, bb = 0, edificio = control.null_edificio, enemigo = true, radio = 14_400, dmg = 1000, incendiario = false, _jugador = jugador){
	with control{
		sound_play(snd_explosion, aa, bb)
		array_push(efectos, add_efecto(spr_explosion, 0, aa, bb, 24, 1 / 3))
		var temp_complex = xytoab(aa, bb), chunk_x, chunk_y, mina, minb, maxa, maxb, temp_chunk_edificios, temp_array_dron, dmg_total, a, b, i, dis, dron
		if temp_complex[0] < 0
			exit
		chunk_x = floor(temp_complex[0] / CHUNK_WIDTH)
		chunk_y = floor(temp_complex[1] / CHUNK_HEIGHT)
		mina = max(chunk_x - 1, 0)
		minb = max(chunk_y - 1, 0)
		maxa = min(chunk_x + 1, chunk_xsize - 1)
		maxb = min(chunk_y + 1, chunk_ysize - 1)
		temp_chunk_edificios = (enemigo ? chunk_edificios : chunk_edificios_enemigo)
		temp_array_dron = (enemigo ? chunk_dron_aliado : chunk_dron_enemigo)
		dmg_total = 0
		if incendiario{
			for(a = mina; a <= maxa; a++)
				for(b = minb; b <= maxb; b++){
					//Herir edificios
					for(i = array_length(temp_chunk_edificios[# a, b]) - 1; i >= 0; i--){
						edificio = temp_chunk_edificios[# a, b][i]
						dis = distance_sqr(aa, bb, edificio.center_x, edificio.center_y)
						if dis < radio
							herir_edificio(dmg / (10 + sqrt(dis)), edificio)
					}
					//Herir drones
					for(i = array_length(temp_array_dron[# a, b]) - 1; i >= 0; i--){
						dron = temp_array_dron[# a, b][i]
						dis = distance_sqr(aa, bb, dron.x, dron.y)
						if dis < radio and not herir_dron(dmg / (10 + sqrt(dis)), dron)
							aplicar_efecto(1, 120, dron)
					}
				}
		}
		else{
			for(a = mina; a <= maxa; a++)
				for(b = minb; b <= maxb; b++){
					//Herir edificios
					for(i = array_length(temp_chunk_edificios[# a, b]) - 1; i >= 0; i--){
						edificio = temp_chunk_edificios[# a, b][i]
						dis = distance_sqr(aa, bb, edificio.center_x, edificio.center_y)
						if dis < radio
							herir_edificio(dmg / (10 + sqrt(dis)), edificio)
					}
					//Herir drones
					for(i = array_length(temp_array_dron[# a, b]) - 1; i >= 0; i--){
						dron = temp_array_dron[# a, b][i]
						dis = distance_sqr(aa, bb, dron.x, dron.y)
						if dis < radio
							herir_dron(dmg / (10 + sqrt(dis)), dron)
					}
				}
		}
	}
}