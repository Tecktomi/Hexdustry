function scr_torres_basicas(edificio = control.null_edificio){
	with control{
		var index = edificio.index, center_x = edificio.center_x, center_y = edificio.center_y, enemigo = edificio.enemigo
		if index = id_lanzallamas
			edificio.array_real[5] = 0
		if edificio_flujo[index]
			var flujo = edificio.flujo, flujo_power = flujo.eficiencia
		//Buscar enemigos
		if ((image_index mod 10) = 0 and edificio.target = null_dron) or edificio.target.vida <= 0{
			edificio.target = null_dron
			if (not enemigo and array_length(enemigos) > 0) or (enemigo and array_length(drones_aliados) > 0){
				if index = id_mortero
					turret_target(edificio, 10000)//100^2
				else
					turret_target(edificio)
			}
		}
		var dron = edificio.target
		//Buscar edificios
		if dron = null_dron and ((image_index mod 10) = 0 and edificio.target_edificio = null_edificio) or edificio.target_edificio.vida <= 0{
			edificio.target_edificio = null_edificio
			if (not enemigo and array_length(edificios_enemigos) > 0) or (enemigo and array_length(edificios) > 0){
				if index = id_mortero
					turret_target(edificio, 10000)//100^2
				else
					turret_target(edificio)
			}
		}
		var target_edificio = edificio.target_edificio
		if dron != null_dron or target_edificio != null_edificio{
			var target_x = 0, target_y = 0
			if dron != null_dron{
				target_x = dron.x
				target_y = dron.y
			}
			else{
				target_x = target_edificio.center_x
				target_y = target_edificio.center_y
			}
			var dmg_factor = 1, angle = -arctan2(center_x - target_x, target_y - edificio.center_y) - pi / 2
			edificio.select = radtodeg(angle)
			if ((in(index, id_torre_basica, id_rifle) and flujo.liquido = idl_agua) or (index = id_lanzallamas and flujo.liquido = idl_petroleo)){
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
				var dis = distance_sqr(center_x, edificio.center_y, target_x, target_y)
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
					if dron.vida > 0 or target_edificio.vida > 0{
						var tiro_struct = armas[arma, tiro]
						if index = id_lanzallamas{
							edificio.array_real[4]++
							edificio.array_real[5] = 1
							if edificio.array_real[4] = 1{
								if edificio.sound != undefined
									audio_pause_sound(edificio.sound)
								edificio.sound = sound_play(snd_flame_init, center_x, center_y, 0.1)
							}
							else if (edificio.array_real[4] - 60) mod 119 = 0{
								if edificio.sound != undefined
									audio_pause_sound(edificio.sound)
								edificio.sound = sound_play(snd_flame_cont, center_x, center_y, 0.1)
							}
							if dron != null_dron{
								var temp_array_dron = (enemigo ? chunk_dron_aliado[# dron.chunk_x, dron.chunk_y] : chunk_dron_enemigo[# dron.chunk_x, dron.chunk_y])
								var disi = edificio_alcance[index], x1 = center_x + disi * cos(angle + pi / 6), y1 = center_y - disi * sin(angle + pi / 6), x2 = center_x + disi * cos(angle - pi / 6), y2 = center_y - disi * sin(angle - pi / 6), total_dmg = 0
								for(var c = array_length(temp_array_dron) - 1; c >= 0; c--){
									var temp_dron = temp_array_dron[c]
									if point_in_triangle(temp_dron.x, temp_dron.y, center_x, center_y, x1, y1, x2, y2){
										aplicar_efecto(1, 300, temp_dron)
										herir_dron(1, temp_dron)
									}
								}
								if enemigo
									dmg_recibido += total_dmg
								else
									dmg_causado += total_dmg
							}
						}
						else if index = id_torre_basica
							sound_play(snd_disparo, center_x, center_y, 0.1)
						else
							sound_play(snd_rifle, center_x, center_y, 0.2)
						edificio.carga[tiro_struct.recurso] -= tiro_struct.cantidad
						edificio.carga_total -= tiro_struct.cantidad
						dis = sqrt(dis)
						var municion
						if index = id_lanzallamas
							municion = add_municion(center_x, center_y, 20 * (target_x - center_x) / dis, 20 * (target_y - center_y) / dis, 2, dis / 20, tiro_struct.dmg * dmg_factor,, dron, target_edificio, enemigo)
						else if index = id_mortero{
							if edificio.carga[idr_compuesto_incendiario] > 0{
								edificio.carga[idr_compuesto_incendiario]--
								edificio.carga_total--
								municion = add_municion(center_x, center_y, 20 * (target_x - center_x) / dis, 20 * (target_y - center_y) / dis, 3, dis / 20, tiro_struct.dmg * dmg_factor, 10_000, dron, target_edificio, enemigo)
							}
							else
								municion = add_municion(center_x, center_y, 20 * (target_x - center_x) / dis, 20 * (target_y - center_y) / dis, 1, dis / 20, tiro_struct.dmg * dmg_factor, 4900, dron, target_edificio, enemigo)
						}
						else if index = id_rifle
							municion = add_municion(center_x, center_y, 30 * (target_x - center_x) / dis, 30 * (target_y - center_y) / dis, 4, dis / 30 + 2, tiro_struct.dmg * dmg_factor,, dron, target_edificio, enemigo)
						else if index = id_torre_basica
							municion = add_municion(center_x, center_y, 25 * (target_x - center_x) / dis, 25 * (target_y - center_y) / dis, 0, dis / 25, tiro_struct.dmg * dmg_factor,, dron, target_edificio, enemigo)
						array_push(municiones, municion)
						if index = id_lanzallamas{
							angle = arctan2(center_y - target_y, center_x - target_x)
							var b = angle + random_range(-pi / 16, pi / 16)
							array_push(fuegos, add_fuego(center_x - 20 * cos(angle), center_y - 20 * sin(angle), edificio.a, edificio.b, 12 * -cos(b), 12 * -sin(b), 40))
						}
						mover_in(edificio)
					}
					else{
						edificio.target = null_dron
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
			if not audio_is_paused(edificio.sound)
				audio_pause_sound(edificio.sound)
			edificio.sound = sound_play(snd_flame_end, center_x, center_y, 0.1)
		}
	}
}