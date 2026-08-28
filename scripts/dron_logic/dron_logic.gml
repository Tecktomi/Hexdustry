function dron_logic(){
	with control{
		var cam_center_x = (camx + room_width * zoom / 2), cam_center_y = (camy + room_height * zoom / 2)
		var a, b, dron, aa, bb, index, vel, enemigo, chunk_x, temp_complex, edificio, i, j
		var u, v, dis, min_dis, aaa, bbb, angle, cosa, sina, dir, c, d, _comprable, flag, temp_beta, temp_terreno, temp_complex_2
		var min_puerto, temp_almacenes, minu, minv, maxu, maxv, ataque, min_dis_eu, aaaa, bbbb, disi, dis_2, _posibles, closest_dis, chunk, max_prioridad
		var temp_chunk_dron, temp_dron_2, temp_dron_size, temp_array, temp_enemigo, temp_dis, temp_dron, _jugador
		for(a = array_length(drones) - 1; a >= 0; a--){
			if a >= array_length(drones)
				continue
			dron = drones[a]
			_jugador = dron.jugador
			aa = dron.x
			bb = dron.y
			index = dron.index
			vel = dron_vel[index]
			enemigo = dron.enemigo
			chunk_x = dron.chunk_x
			chunk_y = dron.chunk_y
			if draw_once{
				draw_dron(dron, enemigo)
				if distance_sqr(cam_center_x, cam_center_y, aa, bb) > 250_000{
					draw_set_color(enemigo ? c_red : c_blue)
					angle = arctan2(cam_center_y - bb, cam_center_x - aa)
					cosa = cos(angle)
					sina = sin(angle)
					draw_line(room_width / 2 - 60 * cosa, room_height / 2 - 60 * sina, room_width / 2 - 90 * cosa, room_height / 2 - 90 * sina)
				}
			}
			//Efectos
			flag = false
			for(b = 0; b < efectos_max; b++)
				if dron.efecto[b] > 0{
					dron.efecto[b]--
					//Shock
					if b = 0
						vel /= 2
					//Fuego
					else if b = 1{
						if herir_dron(dron_vida_max[index] / 2000, dron){
							flag = true
							break
						}
						if grafic_humo and (image_index mod 10) = (a mod 10){
							dir = viento_dir + random_range(-pi / 4, pi / 4)
							array_push(humos, add_humo(aa, bb, dron.a, dron.b, cos(dir) * viento_mag, sin(dir) * viento_mag, irandom_range(40, 70)))
						}
					}
				}
			if flag
				continue
			if dron.vida <= 0{
				delete_dron(dron)
				continue
			}
			if aa < 0
				dron.x++
			else if aa > xsize * 48
				dron.x--
			if bb < 0
				dron.y++
			else if bb > ysize * 14
				dron.y--
			if dron.target != null_edificio and dron.target.vida <= 0
				dron.target = null_edificio
			if enemigo and tag_drones_terrestres[index] and dron.target = null_edificio and array_length(edificios_jugador[_jugador]) < array_length(edificios_totales)
				dron.target = edificio_cercano[# dron.a, dron.b]
			if not dron_aereo[index]{
				if terreno[# dron.a, dron.b] = idt_hielo
					vel *= 1.2
				if edificio_bool[# dron.a, dron.b]{
					edificio = edificio_id[# dron.a, dron.b]
					if edificio.index = id_mina{
						flag = explosion(edificio.center_x, edificio.center_y,, 10_000, 1000,, edificio.jugador, dron)
						delete_edificio(edificio)
						if flag
							continue
					}
				}
			}
			if dron.step != dron_step[index]
				dron.step++
			//Dron de Transporte
			if index = idd_mula{
				if array_length(puerto_carga_array[_jugador]) > 0{
					if dron.modo = 0{
						puerto_carga_atended[_jugador] = (++puerto_carga_atended[_jugador]) mod array_length(puerto_carga_array[_jugador])
						dron.target = puerto_carga_array[_jugador][puerto_carga_atended[_jugador]]
						dron.modo = 1
					}
					else{
						edificio = dron.target
						dis = distance_sqr(aa, bb, edificio.center_x, edificio.center_y)
						if dis > dron_alcance[dron.index]{
							dis = sqrt(dis)
							dron.dir += 0.05 * angle_difference(point_direction(aa, bb, edificio.center_x, edificio.center_y), dron.dir)
							dron.x += vel * (edificio.center_x - aa) / dis
							dron.y += vel * (edificio.center_y - bb) / dis
						}
						else{
							if dron.modo = 1{
								for(b = 0; b < rss_max; b++){
									dron.carga[b] += edificio.carga[b]
									edificio.carga[b] = 0
								}
								edificio.carga_total = 0
								mover_in(edificio)
								dron.target = edificio.link
								dron.modo = 2
							}
							else if dron.modo = 2{
								for(b = 0; b < rss_max; b++){
									c = dron.carga[b]
									d = edificio_carga_max[edificio.index] - edificio.carga_total
									if d > c{
										edificio.carga[b] += c
										edificio.carga_total += c
										dron.carga[b] = 0
									}
									else{
										edificio.carga[b] += d
										edificio.carga_total += d
										dron.carga[b] -= d
										break
									}
								}
								mover(edificio)
								puerto_carga_atended[_jugador] = (++puerto_carga_atended[_jugador]) mod array_length(puerto_carga_array[_jugador])
								dron.target = puerto_carga_array[_jugador][puerto_carga_atended[_jugador]]
								dron.modo = 1
							}
						}
					}
				}
			}
			//Dron Reparador
			else if index = idd_reparador{
				if dron.modo = 0 and array_length(edificios_jugador[_jugador]) > 0{
					edificio = array_choose(edificios_jugador[_jugador])
					if edificio.vida < edificio_vida[edificio.index]{
						dron.modo = 1
						dron.target = edificio
					}
				}
				else{
					edificio = dron.target
					if edificio.vida <= 0{
						dron.modo = 0
						continue
					}
					dis = distance_sqr(aa, bb, edificio.center_x, edificio.center_y)
					if dis > dron_alcance[dron.index]{
						dron.dir += 0.05 * angle_difference(point_direction(aa, bb, edificio.center_x, edificio.center_y), dron.dir)
						dis = sqrt(dis)
						dron.x += vel * (edificio.center_x - aa) / dis
						dron.y += vel * (edificio.center_y - bb) / dis
					}
					else if ++dron.step >= 30{
						dron.step = 0
						draw_set_color(c_green)
						draw_line_off(aa, bb, edificio.center_x, edificio.center_y)
						if edificio_curar(edificio, 30)
							dron.modo = 0
					}
				}
			}
			//Dron Reconstructor
			else if index = idd_reconstructor{
				//Buscar edificios destruidos
				if dron.modo = 0{
					i = irandom(xsize - 1)
					j = irandom(ysize - 1)
					if repair_id[# i, j] > 0{
						dron.move_x = i
						dron.move_y = j
						temp_complex = abtoxy(i, j)
						dron.move_xmove = temp_complex[0]
						dron.move_ymove = temp_complex[1]
						dron.modo = 1
					}
				}
				//Reconstruir edificios
				else if dron.modo = 1{
					dis = distance_sqr(aa, bb, dron.move_xmove, dron.move_ymove)
					//Ir al lugar
					if dis > dron_alcance[index]{
						dron.dir += 0.05 * angle_difference(point_direction(aa, bb, dron.move_xmove, dron.move_ymove), dron.dir)
						dis = sqrt(dis)
						dron.x += vel * (dron.move_xmove - aa) / dis
						dron.y += vel * (dron.move_ymove - bb) / dis
					}
					//Reconstruir
					else{
						i = dron.move_x
						j = dron.move_y
						b = repair_id[# i, j]
						_comprable = (b > 0)
						if _comprable and not cheat
							_comprable = check_reconstruible(b, false, _jugador)._comprable
						if _comprable{
							edificio = construir(b, repair_dir[# i, j], i, j)
							if tag_edificio_seteable[b]
								set_edificio(repair_mode[# i, j], repair_select[# i, j], edificio)
						}
						dron.modo = 0
					}
				}
			}
			//Dron Minero
			else if index = idd_minero{
				//Minar
				if dron.modo = 1{
					temp_complex = xytoab(dron.move_x, dron.move_y)
					if ore[# temp_complex[0], temp_complex[1]] != -1{
						dis = distance_sqr(dron.x, dron.y, dron.move_x, dron.move_y)
						//Ir al recurso
						if dis > 2500{
							dis = sqrt(dis)
							dron.dir += 0.05 * angle_difference(point_direction(aa, bb, dron.move_x, dron.move_y), dron.dir)
							dron.x += vel * (dron.move_x - aa) / dis
							dron.y += vel * (dron.move_y - bb) / dis
						}
						//Minar
						else{
							flag = (dron.carga_total >= 20)
							if not flag and ++dron.step >= dron_step[index]{
								dron.step = 0
								dron.carga_total++
								if ++dron.carga[ore_recurso[ore[# temp_complex[0], temp_complex[1]]]] >= 20
									flag = true
								if minar(temp_complex[0], temp_complex[1]){
									temp_beta = beta[# temp_complex[0], temp_complex[1]]
									temp_terreno = array_choose(temp_beta.terrenos)
									temp_complex_2 = abtoxy(temp_terreno[0], temp_terreno[1])
									dron.move_x = temp_complex_2[0]
									dron.move_y = temp_complex_2[1]
									flag = true
								}
							}
							if flag{
								dron.modo = 0
								min_dis = infinity
								min_puerto = null_edificio
								for(b = array_length(edificios_index[id_almacen]) - 1; b >= 0; b--){
									edificio = edificios_index[id_almacen, b]
									if edificio.jugador = _jugador and edificio.carga_total < edificio_carga_max[edificio.index]{
										dis = distance_sqr(dron.x, dron.y, edificio.center_x, edificio.center_y)
										if dis < min_dis{
											min_dis = dis
											min_puerto = edificio
										}
									}
								}
								dron.target = min_puerto
							}
						}
					}
				}
				//Llevar recursos a un puerto
				else if dron.target != null_edificio{
					dis = distance_sqr(dron.x, dron.y, dron.target.center_x, dron.target.center_y)
					//Ir al almacén
					if dis > 2500{
						dis = sqrt(dis)
						dron.dir += 0.05 * angle_difference(point_direction(dron.x, dron.y, dron.target.center_x, dron.target.center_y), dron.dir)
						dron.x += vel * (dron.target.center_x - dron.x) / dis
						dron.y += vel * (dron.target.center_y - dron.y) / dis
					}
					//Depositar recursos
					else{
						for(b = 0; b < rss_max; b++){
							dron.target.carga[b] += dron.carga[b]
							dron.target.carga_total += dron.carga[b]
							dron.carga[b] = 0
						}
						dron.carga_total = 0
						dron.modo = 1
					}
				}
			}
			//Target edificios y drones
			else if dron.target != null_edificio{
				minu = max(0, chunk_x - dron_alcance_chunk_x[index])
				maxu = min(chunk_xsize - 1, chunk_x + dron_alcance_chunk_x[index])
				minv = max(0, chunk_y - dron_alcance_chunk_y[index])
				maxv = min(chunk_ysize - 1, chunk_y + dron_alcance_chunk_y[index])
				edificio = dron.target
				temp_complex = xytoab(aa, bb)
				aaa = temp_complex[0]
				bbb = temp_complex[1]
				dir = -1
				ataque = false
				dis = distance_sqr(aa, bb, edificio.center_x, edificio.center_y)
				if index != idd_bombardero and (dron_aereo[index] or dis < dron_alcance[index])
					dron.dir += 0.1 * angle_difference(point_direction(aa, bb, edificio.center_x, edificio.center_y), dron.dir)
				//Seguir instrucciones
				if dron.modo >= 1{
					if index = idd_bombardero{
						if dron.step <= dron_step[index]{
							dron.dir += 0.02 * angle_difference(point_direction(dron.x, dron.y, dron.move_xmove, dron.move_ymove) + random_range(-0.01, 0.01), dron.dir)
							vel *= 0.9
						}
						else
							vel *= 1.2
						dron.x += lengthdir_x(vel, dron.dir)
						dron.y += lengthdir_y(vel, dron.dir)
					}
					else if tag_drones_terrestres[index]
						dron_move_terrestre(dron)
					else{
						dron.dir += 0.05 * angle_difference(point_direction(aa, bb, dron.move_xmove, dron.move_ymove), dron.dir)
						dron.x += vel * dron.move_xmove
						dron.y += vel * dron.move_ymove
						if --dron.move_dis <= 0
							dron.modo = 0
					}
				}
				//Moverse
				else{
					if tag_drones_terrestres[index]{
						if edificio_cercano_dis[# aaa, bbb] > 1 and dis > dron_alcance[index] / 2{
							if dron.change_pos{
								if edificio_cercano_dir[# aaa, bbb] = -1{
									min_dis = edificio_cercano_dis[# aaa, bbb]
									min_dis_eu =  infinity
									for(i = 0; i < 6; i++){
										temp_complex = next_to(aaa, bbb, i)
										aaaa = temp_complex[0]
										bbbb = temp_complex[1]
										if aaaa < 0 or bbbb < 0 or aaaa >= xsize or bbbb >= ysize
											continue
										if not terreno_caminable[terreno[# aaaa, bbbb]]{
											dron.x -= vel * COS_ANGLE_DIR[i] / 2
											dron.y += vel * SIN_ANGLE_DIR[i] / 2
											continue
										}
										disi = edificio_cercano_dis[# aaaa, bbbb]
										if disi < min_dis{
											min_dis = disi
											dir = i
											ds_grid_set(edificio_cercano_dir, aaa, bbb, i)
											temp_complex = abtoxy(aaaa, bbbb)
											min_dis_eu = distance_sqr(temp_complex[0], temp_complex[1], edificio.center_x, edificio.center_y)
										}
										else if disi = min_dis{
											temp_complex = abtoxy(aaaa, bbbb)
											c = distance_sqr(temp_complex[0], temp_complex[1], edificio.center_x, edificio.center_y)
											if c < min_dis_eu{
												min_dis = disi
												dir = i
												ds_grid_set(edificio_cercano_dir, aaa, bbb, i)
												min_dis_eu = c
											}
										}
									}
								}
								else
									dir = edificio_cercano_dir[# aaa, bbb]
								dron.move_dir = dir
							}
							dron.dir += 0.05 * angle_difference(60 * dron.move_dir + 30, dron.dir)
							dron.x += vel * COS_ANGLE_DIR[dron.move_dir]
							dron.y -= vel * SIN_ANGLE_DIR[dron.move_dir]
							if index = idd_tanque
								dron.dir_move += angle_difference(dron.dir_move, radtodeg(arctan2(SIN_ANGLE_DIR[dron.move_dir], COS_ANGLE_DIR[dron.move_dir]))) / 100
						}
					}
					else if dron_aereo[index]{
						if index = idd_bombardero{
							if dron.step <= dron_step[index]{
								dron.dir += 0.02 * angle_difference(point_direction(dron.x, dron.y, edificio.center_x, edificio.center_y) + random_range(-0.01, 0.01), dron.dir)
								vel *= 0.9
							}
							else
								vel *= 1.2
							dron.x += lengthdir_x(vel, dron.dir)
							dron.y += lengthdir_y(vel, dron.dir)
							if dron.step >= dron_step[index] + 75
								dron.step = 0
						}
						else if index = idd_kamikaze or dis > 10_000{//100^2
							dis_2 = sqrt(dis)
							dron.x += vel * (edificio.center_x - dron.x) / dis_2
							dron.y += vel * (edificio.center_y - dron.y) / dis_2
						}
					}
					else if tag_dron_marino[index] and dis > dron_alcance[index] * 0.9{
						if dron.change_pos{
							min_dis = grid_water_distance[# aaa, bbb]
							_posibles = array_create(0, 0)
							for(i = 0; i < 6; i++){
								temp_complex = next_to(aaa, bbb, i)
								aaaa = temp_complex[0]
								bbbb = temp_complex[1]
								if aaaa < 0 or bbbb < 0 or aaaa >= xsize or bbbb >= ysize
									continue
								disi = grid_water_distance[# aaaa, bbbb]
								if disi = infinity{
									dron.x -= vel * COS_ANGLE_DIR[i] / 2
									dron.y += vel * SIN_ANGLE_DIR[i] / 2
								}
								else if disi < min_dis{
									_posibles = array_create(1, i)
									min_dis = disi
								}
								else if disi = min_dis
									array_push(_posibles, i)
							}
							dron.move_dir = array_choose(_posibles)
						}
						dron.dir += 0.05 * angle_difference(60 * dron.move_dir + 30, dron.dir)
						dron.x += vel * COS_ANGLE_DIR[dron.move_dir]
						dron.y -= vel * SIN_ANGLE_DIR[dron.move_dir]
					}
				}
				if dis < dron_alcance[index]{
					ataque = true
					if atacar_dron(dron, edificio)
						continue
				}
				//Targetear unidades
				else{
					if dron.target_dron = null_dron{
						if (image_index mod 10) = (a mod 10){
							closest_dis = dron_alcance[index]
							for(u = minu; u <= maxu; u++)
								for(v = minv; v <= maxv; v++){
									temp_chunk_dron = chunk_dron[# u, v]
									for(i = array_length(temp_chunk_dron) - 1; i >= 0; i--){
										temp_dron = temp_chunk_dron[i]
										if temp_dron.jugador != _jugador{
											temp_dis = distance_sqr(aa, bb, temp_dron.x, temp_dron.y)
											if temp_dis < closest_dis{
												closest_dis = temp_dis
												dron.target_dron = temp_dron
											}
										}
									}
								}
						}
					}
					else if dron.target_dron.vida > 0{
						dis = distance_sqr(aa, bb, dron.target_dron.x, dron.target_dron.y)
						if dis < dron_alcance[index]{
							ataque = true
							if atacar_dron(dron,, dron.target_dron)
								continue
						}
						else
							dron.target_dron = null_dron
					}
					else
						dron.target_dron = null_dron
				}
				//Targetear edificios
				if ataque = false{
					if dron.temp_target = null_edificio{
						if (image_index mod 10) = ((a + 5) mod 10){
							closest_dis = dron_alcance[index]
							max_prioridad = 0
							for(u = minu; u <= maxu; u++)
								for(v = minv; v <= maxv; v++){
									chunk = ds_grid_get(chunk_edificios, u, v)
									for(i = array_length(chunk) - 1; i >= 0; i--){
										edificio = chunk[i]
										if edificio.jugador != _jugador and edificio.prioridad >= max_prioridad{
											max_prioridad = edificio.prioridad
											dis = distance_sqr(aa, bb, edificio.center_x, edificio.center_y)
											if dis < closest_dis{
												dron.temp_target = edificio
												closest_dis = dis
											}
										}
									}
								}
						}
					}
					else{
						edificio = dron.temp_target
						if edificio.vida <= 0
							dron.temp_target = null_edificio
						else{
							dis = distance_sqr(aa, bb, edificio.center_x, edificio.center_y)
							if index != idd_bombardero
								dron.dir += 0.05 * angle_difference(point_direction(aa, bb, edificio.center_x, edificio.center_y), dron.dir)
							if dis > dron_alcance[index]
								dron.temp_target = null_edificio
							else{
								ataque = true
								if atacar_dron(dron, edificio)
									continue
							}
						}
					}
				}
			}
			else if dron.modo >= 1{
				if index = idd_bombardero{
					if dron.step <= dron_step[index]{
						dron.dir += 0.02 * angle_difference(point_direction(dron.x, dron.y, dron.move_xmove, dron.move_ymove) + random_range(-0.01, 0.01), dron.dir)
						vel *= 0.9
					}
					else
						vel *= 1.2
					dron.x += lengthdir_x(vel, dron.dir)
					dron.y += lengthdir_y(vel, dron.dir)
				}
				else if tag_drones_terrestres[index]
					dron_move_terrestre(dron)
				else{
					dron.dir += 0.05 * angle_difference(point_direction(aa, bb, dron.move_xmove, dron.move_ymove), dron.dir)
					dron.x += vel * dron.move_xmove
					dron.y += vel * dron.move_ymove
					if --dron.move_dis <= 0
						dron.modo = 0
				}
			}
			//Alejarse de los enemigos cercanos
			temp_dron_size = dron_size[index]
			temp_array = chunk_dron[# chunk_x, chunk_y]
			for(b = array_length(temp_array) - 1; b >= 0; b--){
				temp_dron = temp_array[b]
				dis = distance_sqr(aa, bb, temp_dron.x, temp_dron.y)
				if dis < temp_dron_size{
					aaa = sign(aa - temp_dron.x)
					bbb = sign(bb - temp_dron.y)
					dron.x += aaa
					dron.y += bbb
					temp_dron.x -= aaa
					temp_dron.y -= bbb
				}
			}
			temp_complex = xytoab(aa, bb)
			aa = clamp(temp_complex[0], 0, xsize - 1)
			bb = clamp(temp_complex[1], 0, ysize - 1)
			dron.change_pos = false
			//Cambio de coordenada
			if aa != dron.a or bb != dron.b{
				dron.a = aa
				dron.b = bb
				dron.change_pos = true
				if not dron_aereo[index] and not tag_dron_marino[index] and terreno_caminable[terreno[# aa, bb]] and array_length(edificios_jugador[_jugador]) < array_length(edificios_totales)
					dron.target = edificio_cercano[# aa, bb]
				chunk_x = clamp(round(aa / CHUNK_WIDTH), 0, chunk_xsize - 1)
				chunk_y = clamp(round(bb / CHUNK_HEIGHT), 0, chunk_ysize - 1)
				if chunk_x != dron.chunk_x or chunk_y != dron.chunk_y{
					dron_chunk_remove(dron)
					dron.chunk_x = chunk_x
					dron.chunk_y = chunk_y
					dron_chunk_push(dron)
				}
			}
		}
		if draw_once
			for(a = array_length(drones) - 1; a >= 0; a--){
				dron = drones[a]
				draw_vida(dron.x * zoom - camx, dron.y * zoom - camy, dron.vida, dron.vida_max)
			}
	}
}