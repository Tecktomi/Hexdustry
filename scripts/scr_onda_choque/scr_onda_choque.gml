function scr_onda_choque(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		if edificio_energia[index]
			var red = edificio.red, red_power = red.eficiencia
		if edificio.proceso < edificio_proceso[index]{
			change_energia(edificio_energia_consumo[index], edificio)
			edificio.proceso += red_power
		}
		else{
			change_energia(0, edificio)
			if edificio.select = 0{
				var dis = edificio_alcance_sqr[index]
				for(var b = array_length(edificio.target_chunks) - 1; b >= 0; b--){
					var temp_complex = edificio.target_chunks[b], temp_array = chunk_enemigos[# temp_complex.a, temp_complex.b]
					for(var c = array_length(temp_array) - 1; c >= 0; c--){
						var enemigo = temp_array[c], temp_dis = distance_sqr(edificio.x, edificio.y, enemigo.a, enemigo.b)
						if temp_dis < dis{
							edificio.select = 20
							break
						}
					}
					if edificio.select > 0
						break
				}
			}
			else{
				edificio.select -= vel
				if edificio.select <= 0{
					edificio.select = 0
					var dis = edificio_alcance_sqr[index]
					for(var b = array_length(edificio.target_chunks) - 1; b >= 0; b--){
						var temp_complex = edificio.target_chunks[b], temp_array = chunk_enemigos[# temp_complex.a, temp_complex.b]
						for(var c = array_length(temp_array) - 1; c >= 0; c--){
							var enemigo = temp_array[c], temp_dis = distance_sqr(edificio.x, edificio.y, enemigo.a, enemigo.b)
							if temp_dis < dis{
								enemigo.vida -= 100
								enemigo.efecto[0] = 30 * vel
								if enemigo.vida <= 0
									destroy_dron(enemigo)
							}
						}
					}
					array_push(efectos, add_efecto(spr_shokwave, 0, edificio.x, edificio.y, 5, 1))
					edificio.proceso = 0
				}
			}
		}
	}
}