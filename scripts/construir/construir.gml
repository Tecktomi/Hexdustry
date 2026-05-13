function construir(index, dir, mx, my, enemigo = false, _server = false, _cheat = control.cheat, _jugador = jugador){
	with control{
		if enemigo
			_jugador = 1
		var edificio = control.null_edificio, temp_complex = abtoxy(mx, my), flag = check_colision(mx, my, index, dir)
		if flag and not _cheat and not enemigo
			flag = is_comprable(edificio_precio_id[index], edificio_precio_num[index])
		//Reemplazar caminos
		if flag and (tag_camino_o_tunel[index] or index = id_cruce) and edificio_bool[# mx, my]{
			var temp_edificio = edificio_id[# mx, my]
			if edificio_camino[temp_edificio.index] or temp_edificio.index = id_cruce{
				if index = temp_edificio.index{
					temp_edificio.dir = dir
					calcular_edificios_adyascentes(temp_edificio)
					mover(temp_edificio)
					var d = temp_edificio.dir * pi / 3 + pi / 6
					temp_edificio.array_real[0] = cos(d)
					temp_edificio.array_real[1] = -sin(d)
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
				//Sobreescribir caminos
				/*
				else if temp_edificio.index = id_cinta_transportadora and index = id_cinta_magnetica{
					var a = -1
					if temp_edificio.carga_total = 1
						a = edificio.carga_id
					delete_edificio(temp_edificio)
					temp_edificio = add_edificio(id_cinta_magnetica, dir, mx, my, _jugador)
					if a != -1{
						temp_edificio.carga_id = a
						temp_edificio.carga_total = 1
						temp_edificio.carga[a] = 1
					}
					break
				}
				*/
				else
					delete_edificio(temp_edificio)
			}
		}
		//Detectar enemigos cerca
		if flag and not _cheat and not enemigo{
			for(var a = array_length(enemigos) - 1; a >= 0; a--){
				var dron = enemigos[a]
				if distance_sqr(dron.x, dron.y, temp_complex[0], temp_complex[1]) < 10_000{//100^2
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
			var a = mx, b = my
			repeat(10){
				var temp_complex_2 = next_to(a, b, dir)
				a = temp_complex_2[0]
				b = temp_complex_2[1]
				if a < 0 or b < 0 or a >= xsize or b >= ysize
					break
				if edificio_bool[# a, b]{
					var edificio_2 = edificio_id[# a, b]
					if in(edificio_2.index, id_tunel, id_tunel_salida) and edificio_2.dir = (dir + 3) mod 6{
						build_target = edificio_2
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
				if online and not servidor
					var temp_jugador = 0
				else
					temp_jugador = _jugador - 2
				for(var a = 0; a < array_length(edificio_precio_id[index]); a++)
					jugador_recursos[temp_jugador, edificio_precio_id[index, a]] -= edificio_precio_num[index, a]
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