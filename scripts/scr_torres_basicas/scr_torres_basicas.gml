function scr_torres_basicas(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		if index = id_lanzallamas
			edificio.array_real[5] = 0
		if edificio_flujo[index]
			var flujo = edificio.flujo, flujo_power = flujo.eficiencia
		//Buscar enemigos
		if (image_index mod 10 = 0 and edificio.target = null_enemigo) or edificio.target.vida <= 0{
			edificio.target = null_enemigo
			if array_length(enemigos) > 0{
				if index = id_mortero
					turret_target(edificio, 10000)//100^2
				else
					turret_target(edificio)
			}
		}
		var enemigo = edificio.target
		if enemigo != null_enemigo{
			var dmg_factor = 1, angle = -arctan2(edificio.x - enemigo.a, enemigo.b - edificio.y) - pi / 2
			edificio.select = radtodeg(angle)
			if ((in(index, id_torre_basica, id_rifle) and flujo.liquido = 0) or (index = id_lanzallamas and flujo.liquido = 2)){
				change_flujo(edificio_flujo_consumo[index], edificio)
				if in(index, id_torre_basica, id_rifle)
					edificio.proceso += 0.5
				else if index = id_lanzallamas
					dmg_factor = 2
			}
			if edificio.modulo{
				if index = id_lanzallamas
					dmg_factor *= 1.3
				else
					edificio.proceso += 0.3
			}
			//Disparo
			if ++edificio.proceso >= edificio_proceso[index]{
				edificio.proceso = 0
				var dis = distance_sqr(edificio.x, edificio.y, enemigo.a, enemigo.b)
				if dis > edificio_alcance_sqr[index]{
					array_disorder_remove(edificio.target.torres, edificio, 2)
					edificio.target = null_edificio
					continue
				}
				var tiro = -1, arma = edificio_arma[index]
				for(var b = 0; b < array_length(armas[arma]); b++){
					var tiro_struct = armas[arma, b]
					if edificio.carga[tiro_struct.recurso] >= tiro_struct.cantidad{
						tiro = b
						break
					}
				}
				if tiro >= 0{
					if enemigo.vida > 0{
						var tiro_struct = armas[arma, tiro], aa = edificio.x, bb = edificio.y
						if edificio_size[index] mod 2 = 0{
							bb = bb + 14
							aa = aa + edificio.array_real[2]
						}
						if index = id_lanzallamas{
							edificio.array_real[4]++
							edificio.array_real[5] = 1
							if edificio.array_real[4] = 1{
								if edificio.sound != undefined
									audio_pause_sound(edificio.sound)
								edificio.sound = sound_play(snd_flame_init, aa, bb, 0.1)
							}
							else if (edificio.array_real[4] - 60) mod 119 = 0{
								if edificio.sound != undefined
									audio_pause_sound(edificio.sound)
								edificio.sound = sound_play(snd_flame_cont, aa, bb, 0.1)
							}
							var temp_array = chunk_enemigos[# enemigo.chunk_x, enemigo.chunk_y], disi = edificio_alcance[index], x1 = aa + disi * cos(angle + pi / 6), y1 = bb - disi * sin(angle + pi / 6), x2 = aa + disi * cos(angle - pi / 6), y2 = bb - disi * sin(angle - pi / 6)
							for(var c = array_length(temp_array) - 1; c >= 0; c--){
								var temp_enemigo = temp_array[c]
								if point_in_triangle(temp_enemigo.a, temp_enemigo.b, aa, bb, x1, y1, x2, y2){
									temp_enemigo.efecto[1] = 300
									if --temp_enemigo.vida <= 0
										destroy_dron(temp_enemigo)
								}
							}
						}
						else
							sound_play(snd_disparo, edificio.x, edificio.y, 0.1)
						edificio.carga[tiro_struct.recurso] -= tiro_struct.cantidad
						edificio.carga_total -= tiro_struct.cantidad
						dis = sqrt(dis)
						var municion
						if index = id_lanzallamas
							municion = add_municion(aa, bb, 20 * (enemigo.a - aa) / dis, 20 * (enemigo.b - bb) / dis, 2, dis / 20, tiro_struct.dmg * dmg_factor, enemigo, null_edificio)
						else if index = id_mortero
							municion = add_municion(aa, bb, 20 * (enemigo.a - aa) / dis, 20 * (enemigo.b - bb) / dis, 1, dis / 20, tiro_struct.dmg * dmg_factor, enemigo, null_edificio)
						else if index = id_rifle
							municion = add_municion(aa, bb, 30 * (enemigo.a - aa) / dis, 30 * (enemigo.b - bb) / dis, 4, dis / 30 + 2, tiro_struct.dmg * dmg_factor, enemigo, null_edificio)
						else 
							municion = add_municion(aa, bb, 25 * (enemigo.a - aa) / dis, 25 * (enemigo.b - bb) / dis, 0, dis / 25, tiro_struct.dmg * dmg_factor, enemigo, null_edificio)
						array_push(municiones, municion)
						if index = id_lanzallamas{
							angle = arctan2(bb - enemigo.b, aa - enemigo.a)
							var b = angle + random_range(-pi / 16, pi / 16)
							array_push(fuegos, add_fuego(aa - 20 * cos(angle), bb - 20 * sin(angle), edificio.a, edificio.b, 12 * -cos(b), 12 * -sin(b), 40))
						}
						mover_in(edificio)
					}
					else{
						edificio.target = null_enemigo
						if array_length(enemigos) > 0{
							if index = id_mortero
								turret_target(edificio, 10000)//100^2
							else
								turret_target(edificio)
						}
					}
				}
			}
		}
		else
			change_flujo(0, edificio)
		if index = id_lanzallamas and edificio.array_real[5] = 0 and edificio.array_real[4] > 0{
			edificio.array_real[4] = 0
			audio_pause_sound(edificio.sound)
			edificio.sound = sound_play(snd_flame_end, edificio.x, edificio.y, 0.1)
		}
	}
}