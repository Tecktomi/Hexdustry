function scr_torres_basicas(edificio = control.null_edificio){
	with control{
		var index = edificio.index, var_edificio_nombre = edificio_nombre[index]
		if edificio_flujo[index]
			var flujo = edificio.flujo, flujo_power = flujo.eficiencia
		//Buscar enemigos
		if (image_index mod 10 = 0 and edificio.target = null_enemigo) or edificio.target.vida <= 0{
			edificio.target = null_enemigo
			if array_length(enemigos) > 0{
				if var_edificio_nombre = "Mortero"
					turret_target(edificio, 10000)//100^2
				else
					turret_target(edificio)
			}
		}
		var enemigo = edificio.target
		if enemigo != null_enemigo{
			var dmg_factor = 1, angle = -arctan2(edificio.x - enemigo.a, enemigo.b - edificio.y) - pi / 2
			edificio.select = radtodeg(angle)
			if ((in(var_edificio_nombre, "Torre básica", "Rifle") and flujo.liquido = 0) or (var_edificio_nombre = "Lanzallamas" and flujo.liquido = 2)){
				change_flujo(edificio_flujo_consumo[index], edificio)
				if in(var_edificio_nombre, "Torre básica", "Rifle")
					edificio.proceso += 0.5
				else if var_edificio_nombre = "Lanzallamas"
					dmg_factor = 2
			}
			//Disparo
			if ++edificio.proceso >= edificio_proceso[index]{
				edificio.proceso = 0
				var dis = distance_sqr(edificio.x, edificio.y, enemigo.a, enemigo.b)
				if dis > edificio_alcance_sqr[index]{
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
						if var_edificio_nombre = "Lanzallamas"{
							sound_play(snd_disparo, aa, bb, 0.01)
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
						var municion = add_municion(aa, bb, 25 * (enemigo.a - aa) / dis, 25 * (enemigo.b - bb) / dis, var_edificio_nombre = "Mortero" ? 1 : (var_edificio_nombre = "Lanzallamas" ? 2 : 0), dis / 25, tiro_struct.dmg * dmg_factor, enemigo, null_edificio)
						array_push(municiones, municion)
						if var_edificio_nombre = "Lanzallamas"{
							angle = arctan2(bb - enemigo.b, aa - enemigo.a)
							var b = angle + random_range(-pi / 16, pi / 16)
							array_push(fuegos, add_fuego(aa - 20 * cos(angle), bb - 20 * sin(angle), edificio.a, edificio.b, 12 * -cos(b), 12 * -sin(b), 40))
						}
						mover_in(edificio)
					}
					else{
						edificio.target = null_enemigo
						if array_length(enemigos) > 0{
							if var_edificio_nombre = "Mortero"
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
	}
}