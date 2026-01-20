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
				for(var b = array_length(edificio.target_chunks) - 1; b >= 0; b--){
					var temp_complex = edificio.target_chunks[b], temp_array = chunk_dron_enemigo[# temp_complex.a, temp_complex.b]
					for(var c = array_length(temp_array) - 1; c >= 0; c--){
						var enemigo = temp_array[c], temp_dis = distance_sqr(center_x, center_y, enemigo.a, enemigo.b)
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
				var dis = edificio_alcance_sqr[index] + 10, stun = 30 + 10 * edificio.modulo, center_x = edificio.center_x, center_y = edificio.center_y
				for(var b = array_length(edificio.target_chunks) - 1; b >= 0; b--){
					var temp_complex = edificio.target_chunks[b], temp_array = chunk_dron_enemigo[# temp_complex.a, temp_complex.b]
					for(var c = array_length(temp_array) - 1; c >= 0; c--){
						var enemigo = temp_array[c], temp_dis = distance_sqr(center_x, center_y, enemigo.a, enemigo.b)
						if temp_dis < dis{
							enemigo.vida -= 130
							enemigo.efecto[0] = stun
							if enemigo.vida <= 0
								delete_dron(enemigo)
						}
					}
				}
				if sonido
					sound_play(snd_pulso, edificio.center_x, edificio.center_y, 1)
				array_push(efectos, add_efecto(spr_shokwave, 0, edificio.center_x, edificio.center_y, 5, 1))
				edificio.proceso -= edificio_proceso[index]
				edificio.start = false
			}
		}
	}
}