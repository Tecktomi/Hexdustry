function construir(index, dir, mx, my, manual = false, _cheat = control.cheat, _jugador = jugador){
	with control{
		var edificio = null_edificio, xx = pre_abtox[# mx + 1, my + 1], yy = pre_abtoy[# mx + 1, my + 1], flag = check_colision(mx, my, index, dir)
		var temp_edificio, a, dron, b, temp_jugador
		if flag and not _cheat
			flag = is_comprable(edificio_precio_id[index], edificio_precio_num[index], _jugador)
		//Detectar enemigos cerca
		if flag and not _cheat{
			for(b = 0; b < EQUIPOS; b++) if not aliados[# _jugador, b]{
				for(a = array_length(drones_jugador[b]) - 1; a >= 0; a--){
					dron = drones_jugador[b, a]
					if point_distance(dron.x, dron.y, xx, yy) < ENEMIGO_CERCA{
						flag = false
						break
					}
				}
				if not flag
					break
			}
		}
		//Reemplazar caminos
		if flag and (tag_camino_o_tunel[index] or index = id_cruce) and edificio_bool[# mx, my]{
			temp_edificio = edificio_id[# mx, my]
			if temp_edificio.jugador = _jugador and (edificio_camino[temp_edificio.index] or temp_edificio.index = id_cruce){
				if index = temp_edificio.index{
					if (GRABANDO or online) and manual{
						server_construir(index, dir, mx, my, _cheat, _jugador)
						if online and not servidor
							return null_edificio
					}
					temp_edificio.dir = dir
					calcular_edificios_adyascentes(temp_edificio)
					mover(temp_edificio)
					a = temp_edificio.dir * pi / 3 + pi / 6
					temp_edificio.array_real[0] = cos(a)
					temp_edificio.array_real[1] = -sin(a)
					flag = false
					if index = id_enrutador or index = id_cinta_rapida{
						if (dir mod 3) = 1
							temp_edificio.yscale = power(-1, dir > 1)
						else{
							temp_edificio.xscale = power(-1, ((dir + 1) mod 6) > 1)
							temp_edificio.yscale = power(-1, dir > 2)
						}
					}
					else
						temp_edificio.draw_rot = (dir - 1) * 60
					return temp_edificio
				}
				else
					delete_edificio(temp_edificio)
			}
			else
				flag = false
		}
		if not flag
			return null_edificio
		if tag_edificio_tunel[index] and build_able and build_target.index = id_tunel
			index = id_tunel_salida
		if (online or GRABANDO) and manual{
			server_construir(real(index), real(dir), real(mx), real(my), _cheat, _jugador)
			if online and not servidor
				return null_edificio
		}
		edificio = add_edificio(index, dir, mx, my, _jugador)
		//Algoritmo link de tuneles
		if tag_edificio_tunel[index]{
			build_able = false
			a = mx
			b = my
			repeat(10){
				a = a + DESFACE_A[b & 1, dir]
				b = b + DESFACE_B[b & 1, dir]
				if a < 0 or b < 0 or a >= xsize or b >= ysize
					break
				if edificio_bool[# a, b]{
					temp_edificio = edificio_id[# a, b]
					if temp_edificio.jugador = _jugador and tag_edificio_tunel[temp_edificio.index] and temp_edificio.dir = (dir + 3) mod 6{
						build_target = temp_edificio
						build_able = true
						break
					}
				}
			}
			build_dir = (dir + 3) mod 6
			edificio.idle = not build_able
			if build_able{
				if not build_target.idle{
					build_target.link.idle = true
					build_target.link.link = null_edificio
					if build_target.index = 16{
						array_remove(build_target.inputs, build_target.link)
						array_remove(build_target.link.outputs, build_target)
					}
					else{
						array_remove(build_target.outputs, build_target.link)
						array_remove(build_target.link.inputs, build_target)
					}
				}
				build_target.idle = false
				if index = id_tunel_salida{
					array_push(edificio.inputs, build_target)
					array_push(build_target.outputs, edificio)
				}
				else{
					array_push(edificio.outputs, build_target)
					array_push(build_target.inputs, edificio)
				}
				edificio.link = build_target
				build_target.link = edificio
				if build_target.waiting
					mover(build_target)
			}
		}
		//Algoritmo fábricas de drones
		else if tag_dron_encima[edificio.index]{
			var temp_complex_array = cinta_grande_check(mx, my, dir, index, _jugador)
			build_array_edificios_input = temp_complex_array.inputs
			build_array_edificios_output = temp_complex_array.outputs
			build_agua = temp_complex_array.agua
			build_agua_x = temp_complex_array.agua_x
			build_agua_y = temp_complex_array.agua_y
			edificio.array_real[2] = real(build_agua)
			edificio.array_real[3] = real(build_agua_x)
			edificio.array_real[4] = real(build_agua_y)
			array_copy(edificio.inputs_carga, 0, build_array_edificios_input, 0, array_length(build_array_edificios_input))
			for(a = array_length(edificio.inputs_carga) - 1; a >= 0; a--){
				var temp_edificio_2 = edificio.inputs_carga[a]
				array_push(temp_edificio_2.outputs_carga, edificio)
				if array_contains(edificios_salida_drones, temp_edificio_2)
					array_disorder_remove(edificios_salida_drones, temp_edificio_2, ptre_salida_drones)
			}
			array_copy(edificio.outputs_carga, 0, build_array_edificios_output, 0, array_length(build_array_edificios_output))
			for(a = array_length(edificio.outputs_carga) - 1; a >= 0; a--)
				array_push(edificio.outputs_carga[a].inputs_carga, edificio)
			if array_length(edificio.outputs_carga) = 0
				array_disorder_push(edificios_salida_drones, edificio, ptre_salida_drones)
		}
		//Actualizar recursos
		if not _cheat{
			for(a = 0; a < array_length(edificio_precio_id[index]); a++)
				array_set(jugador_recursos[_jugador], edificio_precio_id[index, a], jugador_recursos[_jugador, edificio_precio_id[index, a]] - edificio_precio_num[index, a])
		}
		if manual and in(index, id_planta_quimica, id_fabrica_de_drones, id_silo_de_misiles, id_fabrica_de_drones_grande){
			clear_edit()
			show_menu = true
			show_menu_build = edificio
		}
		return edificio
	}
}