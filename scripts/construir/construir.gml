function construir(index, dir, mx, my, enemigo = false, _server = false, _cheat = control.cheat, _jugador = jugador){
	with control{
		if enemigo
			_jugador = jugador_IA
		var edificio = control.null_edificio, temp_complex = abtoxy(mx, my), flag = check_colision(mx, my, index, dir)
		var temp_edificio, a, dron, b, temp_jugador
		if flag and not _cheat and not enemigo
			flag = is_comprable(edificio_precio_id[index], edificio_precio_num[index], _jugador)
		//Reemplazar caminos
		if flag and (tag_camino_o_tunel[index] or index = id_cruce) and edificio_bool[# mx, my]{
			temp_edificio = edificio_id[# mx, my]
			if edificio_camino[temp_edificio.index] or temp_edificio.index = id_cruce{
				if index = temp_edificio.index{
					temp_edificio.dir = dir
					calcular_edificios_adyascentes(temp_edificio)
					mover(temp_edificio)
					a = temp_edificio.dir * pi / 3 + pi / 6
					temp_edificio.array_real[0] = cos(a)
					temp_edificio.array_real[1] = -sin(a)
					flag = false
					if in(index, id_enrutador, id_cinta_magnetica){
						if (dir mod 3) = 1
							temp_edificio.yscale = power(-1, dir > 1)
						else{
							temp_edificio.xscale = power(-1, ((dir + 1) mod 6) > 1)
							temp_edificio.yscale = power(-1, dir > 2)
						}
					}
					else
						temp_edificio.draw_rot = (dir - 1) * 60
					if online and not _server{
						server_add_edificio(real(index), real(dir), real(mx), real(my), _cheat)
						if not servidor
							return null_edificio
					}
					break
				}
				else
					delete_edificio(temp_edificio)
			}
		}
		//Detectar enemigos cerca
		if flag and not _cheat and not enemigo{
			for(a = array_length(drones) - 1; a >= 0; a--){
				dron = drones[a]
				if dron.jugador != _jugador and distance_sqr(dron.x, dron.y, temp_complex[0], temp_complex[1]) < 10_000{//100^2
					flag = false
					break
				}
			}
		}
		if not flag
			return null_edificio
		if in(index, id_tunel, id_tunel_salida) and build_able and build_target.index = id_tunel
			index = id_tunel_salida
		if online and not _server{
			server_add_edificio(real(index), real(dir), real(mx), real(my), _cheat)
			if not servidor
				return null_edificio
		}
		if jugador != _jugador
			enemigo = true
		edificio = add_edificio(index, dir, mx, my, _jugador)
		//Algoritmo link de tuneles
		if in(index, id_tunel, id_tunel_salida){
			build_able = false
			a = mx
			b = my
			repeat(10){
				temp_complex = next_to(a, b, dir)
				a = temp_complex[0]
				b = temp_complex[1]
				if a < 0 or b < 0 or a >= xsize or b >= ysize
					break
				if edificio_bool[# a, b]{
					temp_edificio = edificio_id[# a, b]
					if in(temp_edificio.index, id_tunel, id_tunel_salida) and temp_edificio.dir = (dir + 3) mod 6{
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
		//Actualizar recursos
		if not enemigo or (online and servidor){
			if not _cheat{
				for(a = 0; a < array_length(edificio_precio_id[index]); a++)
					jugador_recursos[_jugador, edificio_precio_id[index, a]] -= edificio_precio_num[index, a]
			}
			if not _server and in(index, id_planta_quimica, id_fabrica_de_drones, id_silo_de_misiles, id_fabrica_de_drones_grande){
				clear_edit()
				show_menu = true
				show_menu_build = edificio
			}
		}
		return edificio
	}
}