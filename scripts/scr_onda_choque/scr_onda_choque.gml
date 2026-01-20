function scr_onda_choque(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		var red = edificio.red, red_power = red.eficiencia
		if edificio.proceso < edificio_proceso[index]{
			change_energia(edificio_energia_consumo[index], edificio)
			edificio.proceso += red_power
		}
		else{
			change_energia(0, edificio)
			if edificio.select = 0{
				var dis = edificio_alcance_sqr[index], center_x = edificio.center_x, center_y = edificio.center_y
				for(var a = array_length(edificio.target_chunks) - 1; a >= 0; a--){
					var temp_complex = edificio.target_chunks[a], temp_array = (edificio.enemigo ? chunk_dron_aliado[# temp_complex.a, temp_complex.b] : chunk_dron_enemigo[# temp_complex.a, temp_complex.b])
					for(var b = array_length(temp_array) - 1; b >= 0; b--){
						var dron = temp_array[b], temp_dis = distance_sqr(center_x, center_y, dron.x, dron.y)
						if temp_dis < dis{
							edificio.select = 20
							break
						}
					}
					if edificio.select > 0
						break
				}
			}
			else if --edificio.select <= 0{
				edificio.select = 0
				var dis = edificio_alcance_sqr[index] + 10, stun = 30 + 10 * edificio.modulo, center_x = edificio.center_x, center_y = edificio.center_y, total_dmg = 0
				for(var a = array_length(edificio.target_chunks) - 1; a >= 0; a--){
					var temp_complex = edificio.target_chunks[a], temp_array = (edificio.enemigo ? chunk_dron_aliado[# temp_complex.a, temp_complex.b] : chunk_dron_enemigo[# temp_complex.a, temp_complex.b])
					for(var b = array_length(temp_array) - 1; b >= 0; b--){
						var dron = temp_array[b], temp_dis = distance_sqr(center_x, center_y, dron.x, dron.y)
						if temp_dis < dis{
							dron.vida -= 130
							total_dmg += min(130, dron.vida)
							dron.efecto[0] = stun
							if dron.vida <= 0
								delete_dron(dron)
						}
					}
				}
				if edificio.enemigo
					dmg_recibido += total_dmg
				else
					dmg_causado += total_dmg
				sound_play(snd_pulso, edificio.center_x, edificio.center_y, 1)
				array_push(efectos, add_efecto(spr_shokwave, 0, edificio.center_x, edificio.center_y, 5, 1))
				edificio.proceso -= edificio_proceso[index]
				edificio.start = false
			}
		}
	}
}