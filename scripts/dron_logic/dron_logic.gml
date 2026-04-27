function dron_logic(){
	with control{
		var cam_center_x = (camx + room_width * zoom / 2), cam_center_y = (camy + room_height * zoom / 2)
		for(var a = array_length(drones) - 1; a >= 0; a--){
			if a > array_length(drones)
				continue
			var dron = drones[a], aa = dron.x, bb = dron.y, index = dron.index, vel = dron_vel[index], enemigo = dron.enemigo
			var edificios_target = enemigo ? edificios : edificios_enemigos
			var drones_target = enemigo ? drones_aliados : enemigos
			var chunk_x = dron.chunk_x, chunk_y = dron.chunk_y
			draw_dron(dron, enemigo)
			if distance_sqr(cam_center_x, cam_center_y, aa, bb) > 250_000{
				draw_set_color(enemigo ? c_red : c_blue)
				var angle = arctan2(cam_center_y - bb, cam_center_x - aa), cosa = cos(angle), sina = sin(angle)
				draw_line(room_width / 2 - 60 * cosa, room_height / 2 - 60 * sina, room_width / 2 - 90 * cosa, room_height / 2 - 90 * sina)
			}
			//Efectos
			for(var b = 0; b < efectos_max; b++)
				if dron.efecto[b] > 0{
					dron.efecto[b]--
					//Shock
					if b = 0
						vel /= 2
					//Fuego
					else if b = 1{
						herir_dron(dron_vida_max[index] / 2000, dron)
						if grafic_humo and (image_index mod 10) = (a mod 10){
							var dir = direccion_viento + random_range(-pi / 4, pi / 4)
							array_push(humos, add_humo(aa, bb, dron.a, dron.b, cos(dir) / 2, sin(dir) / 2, irandom_range(40, 70)))
						}
					}
				}
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
			if enemigo and tag_drones_terrestres[index]{
				if array_length(edificios_target) > 0 and dron.target = null_edificio{
					var temp_complex = xytoab(aa, bb)
					dron.target = edificio_cercano[# temp_complex[0], temp_complex[1]]
				}
			}
			if not dron_aereo[index]{
				if terreno[# dron.a, dron.b] = idt_hielo
					vel *= 1.2
				if edificio_bool[# dron.a, dron.b]{
					var temp_edificio = edificio_id[# dron.a, dron.b]
					if temp_edificio.index = id_mina{
						explosion(temp_edificio.center_x, temp_edificio.center_y,, temp_edificio.enemigo, 10_000, 1000)
						delete_edificio(temp_edificio)
						if dron.vida <= 0
							continue
					}
				}
			}
			if dron.step != dron_step[index]
				dron.step++
			//Dron de Transporte
			if index = idd_mula{
				var temp_puerto_array = enemigo ? puerto_carga_array_enemigo : puerto_carga_array
				if array_length(temp_puerto_array) > 0{
					if dron.modo = 0{
						if enemigo
							puerto_carga_atended_enemigo = (++puerto_carga_atended_enemigo) mod array_length(temp_puerto_array)
						else
							puerto_carga_atended = (++puerto_carga_atended) mod array_length(temp_puerto_array)
						dron.target = temp_puerto_array[enemigo ? puerto_carga_atended_enemigo : puerto_carga_atended]
						dron.modo = 1
					}
					else{
						var edificio = dron.target
						var dis = distance_sqr(aa, bb, edificio.center_x, edificio.center_y)
						if dis > dron_alcance[dron.index]{
							dis = sqrt(dis)
							dron.dir = (9 * dron.dir + radtodeg(arctan2(edificio.center_y - bb, aa - edificio.center_x))) / 10
							dron.x += vel * (edificio.center_x - aa) / dis
							dron.y += vel * (edificio.center_y - bb) / dis
						}
						else{
							if dron.modo = 1{
								for(var b = 0; b < rss_max; b++){
									dron.carga[b] += edificio.carga[b]
									edificio.carga[b] = 0
								}
								edificio.carga_total = 0
								mover_in(edificio)
								dron.target = edificio.link
								dron.modo = 2
							}
							else if dron.modo = 2{
								for(var b = 0; b < rss_max; b++){
									var c = dron.carga[b], d = edificio_carga_max[edificio.index] - edificio.carga_total
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
								if enemigo
									puerto_carga_atended_enemigo = (++puerto_carga_atended_enemigo) mod array_length(temp_puerto_array)
								else
									puerto_carga_atended = (++puerto_carga_atended) mod array_length(temp_puerto_array)
								dron.target = temp_puerto_array[enemigo ? puerto_carga_atended_enemigo : puerto_carga_atended]
								dron.modo = 1
							}
						}
					}
				}
			}
			//Dron Reparador
			else if index = idd_reparador{
				if dron.modo = 0{
					var edificio = array_choose(enemigo ? edificios_enemigos : edificios)
					if edificio.vida < edificio_vida[edificio.index]{
						dron.modo = 1
						dron.target = edificio
					}
				}
				else{
					var edificio = dron.target
					if edificio.vida <= 0{
						dron.modo = 0
						continue
					}
					var dis = distance_sqr(aa, bb, edificio.center_x, edificio.center_y)
					if dis > dron_alcance[dron.index]{
						dron.dir = (9 * dron.dir + radtodeg(arctan2(edificio.center_y - bb, aa - edificio.center_x))) / 10
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
					var i = irandom(xsize - 1), j = irandom(ysize - 1)
					if repair_id[# i, j] > 0{
						dron.move_x = i
						dron.move_y = j
						var temp_complex = abtoxy(i, j)
						dron.move_xmove = temp_complex[0]
						dron.move_ymove = temp_complex[1]
						dron.modo = 1
					}
				}
				//Reconstruir edificios
				else if dron.modo = 1{
					var dis = distance_sqr(aa, bb, dron.move_xmove, dron.move_ymove)
					//Ir al lugar
					if dis > dron_alcance[index]{
						dron.dir = (9 * dron.dir + radtodeg(arctan2(dron.move_ymove - bb, aa - dron.move_xmove))) / 10
						dis = sqrt(dis)
						dron.x += vel * (dron.move_xmove - aa) / dis
						dron.y += vel * (dron.move_ymove - bb) / dis
					}
					//Reconstruir
					else{
						var i = dron.move_x, j = dron.move_y, b = repair_id[# i, j], comprable = (b > 0)
						if comprable and not cheat
							comprable = check_reconstruible(b)
						if comprable{
							var temp_edificio = construir(b, repair_dir[# i, j], i, j)
							if edificio_seteable[b]
								set_edificio(repair_mode[# i, j], repair_select[# i, j], temp_edificio)
						}
						dron.modo = 0
					}
				}
			}
			//Dron Minero
			else if index = idd_minero{
				//Minar
				if dron.modo = 1{
					var temp_complex = xytoab(dron.move_x, dron.move_y)
					if ore[# temp_complex[0], temp_complex[1]] != -1{
						var dis = distance_sqr(dron.x, dron.y, dron.move_x, dron.move_y)
						//Ir al recurso
						if dis > 2500{
							dis = sqrt(dis)
							dron.dir = (9 * dron.dir + point_direction(dron.x, dron.y, dron.move_x, dron.move_y)) / 10
							dron.x += vel * (dron.move_x - dron.x) / dis
							dron.y += vel * (dron.move_y - dron.y) / dis
						}
						//Minar
						else{
							var flag = (dron.carga_total >= 20)
							if not flag and ++dron.step >= dron_step[index]{
								dron.step = 0
								dron.carga_total++
								if ++dron.carga[ore_recurso[ore[# temp_complex[0], temp_complex[1]]]] >= 20
									flag = true
								if minar(temp_complex[0], temp_complex[1]){
									var temp_beta = beta[# temp_complex[0], temp_complex[1]], temp_terreno = array_choose(temp_beta.terrenos), temp_complex_2 = abtoxy(temp_terreno[0], temp_terreno[1])
									dron.move_x = temp_complex_2[0]
									dron.move_y = temp_complex_2[1]
									flag = true
								}
							}
							if flag{
								dron.modo = 0
								var min_dis = infinity, min_puerto = null_edificio, temp_almacenes = enemigo ? almacenes_enemigos : almacenes
								for(var b = 0; b < array_length(temp_almacenes); b++){
									var edificio = temp_almacenes[b]
									if edificio.carga_total < edificio_carga_max[edificio.index]{
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
					var dis = distance_sqr(dron.x, dron.y, dron.target.center_x, dron.target.center_y)
					//Ir al almacén
					if dis > 2500{
						dis = sqrt(dis)
						dron.dir = (9 * dron.dir + point_direction(dron.x, dron.y, dron.target.center_x, dron.target.center_y)) / 10
						dron.x += vel * (dron.target.center_x - dron.x) / dis
						dron.y += vel * (dron.target.center_y - dron.y) / dis
					}
					//Depositar recursos
					else{
						for(var b = 0; b < rss_max; b++){
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
				var minu = max(0, chunk_x - dron_alcance_chunk_x[index]), maxu = min(chunk_xsize - 1, chunk_x + dron_alcance_chunk_x[index])
				var minv = max(0, chunk_y - dron_alcance_chunk_y[index]), maxv = min(chunk_ysize - 1, chunk_y + dron_alcance_chunk_y[index])
				var edificio = dron.target
				if index != idd_bombardero
					dron.dir = (9 * dron.dir + radtodeg(arctan2(edificio.center_y - bb, aa - edificio.center_x))) / 10
				var temp_complex = xytoab(aa, bb), aaa = temp_complex[0], bbb = temp_complex[1], dir = -1, ataque = false
				var dis = distance_sqr(aa, bb, edificio.center_x, edificio.center_y)
				//Seguir instrucciones
				if dron.modo = 1{
					if index = idd_bombardero{
						if dron.step <= dron_step[index]{
							dir = point_direction(dron.x, dron.y, dron.move_xmove, dron.move_ymove)
							var diff = angle_difference(dir, dron.dir)
							diff += random_range(-0.01, 0.01)
							dron.dir += 0.02 * diff
						}
						else
							vel *= 1.2
						dron.x += lengthdir_x(vel, dron.dir)
						dron.y += lengthdir_y(vel, dron.dir)
					}
					else{
						dron.dir = (9 * dron.dir + radtodeg(arctan2(dron.move_ymove, -dron.move_xmove))) / 10
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
							if edificio_cercano_dir[# aaa, bbb] = -1{
								var min_dis = edificio_cercano_dis[# aaa, bbb], min_dis_eu =  infinity
								for(var i = 0; i < 6; i++){
									temp_complex = next_to(aaa, bbb, i)
									var aaaa = temp_complex[0], bbbb = temp_complex[1]
									if aaaa < 0 or bbbb < 0 or aaaa >= xsize or bbbb >= ysize
										continue
									if not terreno_caminable[terreno[# aaaa, bbbb]]
										continue
									var disi = edificio_cercano_dis[# aaaa, bbbb]
									if disi < min_dis{
										min_dis = disi
										dir = i
										ds_grid_set(edificio_cercano_dir, aaa, bbb, i)
										temp_complex = abtoxy(aaaa, bbbb)
										min_dis_eu = distance_sqr(temp_complex[0], temp_complex[1], edificio.center_x, edificio.center_y)
									}
									else if disi = min_dis{
										temp_complex = abtoxy(aaaa, bbbb)
										var c = distance_sqr(temp_complex[0], temp_complex[1], edificio.center_x, edificio.center_y)
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
							if dir = -1
								dir = 0
							dron.x += vel * cos_angle_dir[dir]
							dron.y -= vel * sin_angle_dir[dir]
							if index = idd_tanque
								dron.dir_move += angle_difference(dron.dir_move, radtodeg(arctan2(sin_angle_dir[dir], cos_angle_dir[dir]))) / 100
						}
					}
					else if dron_aereo[index]{
						if index = idd_bombardero{
							if dron.step <= dron_step[index]{
								dir = point_direction(dron.x, dron.y, edificio.center_x, edificio.center_y)
								var diff = angle_difference(dir, dron.dir)
								diff += random_range(-0.01, 0.01)
								dron.dir += 0.02 * diff
							}
							else
								vel *= 1.2
							dron.x += lengthdir_x(vel, dron.dir)
							dron.y += lengthdir_y(vel, dron.dir)
						}
						else if index = 3 or dis > 10_000{//100^2
							var dis_2 = sqrt(dis)
							dron.x += vel * (edificio.center_x - dron.x) / dis_2
							dron.y += vel * (edificio.center_y - dron.y) / dis_2
						}
					}
				}
				if dis < dron_alcance[index]{
					ataque = true
					if atacar_dron(dron, edificio)
						continue
				}
				//Targetear unidades
				else if array_length(drones_target) > 0{
					if dron = null_dron{
						if (image_index mod 10) = (a mod 10){
							var closest_dis = dron_alcance[index]
							for(var u = minu; u <= maxu; u++)
								for(var v = minv; v <= maxv; v++){
									var chunk_dron = enemigo ? chunk_dron_aliado[# u, v] : chunk_dron_enemigo[# u, v], len_2 = array_length(chunk_dron)
									for(var i = 0; i < len_2; i++){
										var temp_dron_2 = chunk_dron[i], temp_dis = distance_sqr(aa, bb, temp_dron_2.x, temp_dron_2.y)
										if temp_dis < closest_dis{
											closest_dis = temp_dis
											dron.target_dron = temp_dron_2
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
						if (image_index mod 10) = (a + 5 mod 10){
							var closest_dis = dron_alcance[index], max_prioridad = -1
							for(var u = minu; u <= maxu; u++)
								for(var v = minv; v <= maxv; v++){
									var chunk = enemigo ? chunk_edificios[# u, v] : chunk_edificios_enemigo[# u, v]
									for(var i = array_length(chunk) - 1; i >= 0; i--){
										edificio = chunk[i]
										if edificio.prioridad >= max_prioridad{
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
								dron.dir = (9 * dron.dir + radtodeg(arctan2(edificio.center_y - bb, aa - edificio.center_x))) / 10
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
			//Alejarse de los enemigos cercanos
			var temp_dron_size = dron_size[index], temp_array = enemigo ? chunk_dron_enemigo[# chunk_x, chunk_y] : chunk_dron_aliado[# chunk_x, chunk_y]
			for(var b = array_length(temp_array) - 1; b >= 0; b--){
				var temp_enemigo = temp_array[b], dis = max(0.01, distance_sqr(aa, bb, temp_enemigo.x, temp_enemigo.y))
				if dis < temp_dron_size{
					var aaa = sign(aa - temp_enemigo.x), bbb = sign(bb - temp_enemigo.y)
					dron.x += aaa
					dron.y += bbb
					temp_enemigo.x -= aaa
					temp_enemigo.y -= bbb
				}
			}
			//Cambiar de chunk
			var temp_complex = xytoab(aa, bb)
			aa = temp_complex[0]
			bb = temp_complex[1]
			if aa != dron.a or bb != dron.b{
				dron.a = aa
				dron.b = bb
				if not dron_aereo[index] and array_length(edificios_target) > 0 and terreno_caminable[terreno[# aa, bb]]
					dron.target = edificio_cercano[# aa, bb]
				chunk_x = clamp(round(aa / chunk_width), 0, chunk_xsize - 1)
				chunk_y = clamp(round(bb / chunk_height), 0, chunk_ysize - 1)
				if chunk_x != dron.chunk_x or chunk_y != dron.chunk_y{
					dron_chunk_remove(dron)
					dron.chunk_x = chunk_x
					dron.chunk_y = chunk_y
					dron_chunk_push(dron)
				}
			}
		}
		for(var a = array_length(drones) - 1; a >= 0; a--){
			var dron = drones[a]
			draw_vida(dron.x * zoom - camx, dron.y * zoom - camy, dron.vida, dron.vida_max)
		}
	}
}