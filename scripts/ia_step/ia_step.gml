function ia_step(){
	with control{
		if array_length(edificios_jugador_index[jugador_IA, id_nucleo]) = 0{
			IA = false
			exit
		}
		//array_set(jugador_recursos[jugador_IA], idr_cobre, 100)
		//array_set(jugador_recursos[jugador_IA], idr_hierro, 100)
		var instruction = ia_queue[ia_queue_count], nucleo = edificios_jugador_index[jugador_IA, id_nucleo][0]
		var a = 0, b = 0, c = 0, aa = 0, bb = 0, i = 0, j = 0, temp_complex = array_create(0, 0), bmod = 0, dis = 0, dir = 0
		if instruction = ia_queue_cobre or instruction = ia_queue_hierro{
			//Crear plano
			if array_length(ia_build_queue) = 0{
				var _ore = (instruction = ia_queue_cobre ? ido_cobre : ido_hierro)
				c = 0
				dis = infinity
				//Buscar ores
				do{
					temp_complex = ia_ores[_ore, c++]
					a = temp_complex[0]
					b = temp_complex[1]
					dir = irandom(1)
				}
				until check_colision(a, b, id_taladro, dir) or c >= array_length(ia_ores[_ore])
				if c = array_length(ia_ores[_ore])
					show_error($"ERROR IA\nNo se ha podido encontrar {recurso_nombre[ore_recurso[_ore]]}", true)
				array_push(ia_build_queue, [id_taladro, dir, a, b])
				var temp_list = get_size(a, b, dir, edificio_size[id_taladro]), angle, flag
				for(i = array_length(temp_list) - 1; i >= 0; i--){
					temp_complex = temp_list[i]
					aa = temp_complex[0]
					bb = temp_complex[1]
					dis = min(dis, ia_grid_real[# a, b])
					ia_grid_real[# aa, bb] = infinity
					for(j = 0; j < array_length(ia_ores[_ore]); j++)
						if aa = ia_ores[_ore, j][0] and bb = ia_ores[_ore, j][1]
							array_delete(ia_ores[_ore], j--, 1)
				}
				temp_list = get_arround(a, b, dir, edificio_size[id_taladro])
				for(i = array_length(temp_list) - 1; i >= 0; i--){
					temp_complex = temp_list[i]
					a = temp_complex[0]
					b = temp_complex[1]
					if ia_grid_real[# a, b] < dis
						break
				}
				//Crear camino
				while dis > 0{
					temp_complex = abtoxy(a, b)
					angle = floor(point_direction(temp_complex[0], temp_complex[1], nucleo.center_x, nucleo.center_y) / 30)
					bmod = b & 1
					flag = true
					for(i = 0; i < 6; i++){
						j = preset_dir[angle, i]
						aa = a + DESFACE_A[bmod, j]
						bb = b + DESFACE_B[bmod, j]
						if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
							continue
						if ia_grid_camino[# aa, bb]{
							array_push(ia_build_queue, [id_cinta_transportadora, j, a, b])
							flag = false
							dis = 0
							break
						}
					}
					if flag repeat(3){
						for(i = 0; i < 6; i++){
							j = preset_dir[angle, i]
							aa = a + DESFACE_A[bmod, j]
							bb = b + DESFACE_B[bmod, j]
							if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
								continue
							c = ia_grid_real[# aa, bb]
							if c < dis{
								array_push(ia_build_queue, [id_cinta_transportadora, j, a, b])
								ia_grid_real[# a, b] = infinity
								a = aa
								b = bb
								dis = c
								flag = false
								break
							}
						}
						if not flag
							break
						dis++
					}
					if flag{
						array_resize(ia_build_queue, 0)
						if ++ia_queue_count = array_length(ia_queue)
							IA = false
						break
					}
				}
			}
			//Construir
			else{
				temp_complex = ia_build_queue[ia_build_pos]
				var index = temp_complex[0]
				a = temp_complex[2]
				b = temp_complex[3]
				if construir(index, temp_complex[1], a, b,,, jugador_IA) != null_edificio{
					ia_grid_real[# a, b] = infinity
					if ++ia_build_pos = array_length(ia_build_queue){
						for(i = array_length(ia_build_queue) - 1; i >= 0; i--){
							temp_complex = ia_build_queue[i]
							if temp_complex[0] = id_cinta_transportadora
								ia_grid_camino[# temp_complex[2], temp_complex[3]] = true
						}
						array_resize(ia_build_queue, 0)
						ia_build_pos = 0
						if ++ia_queue_count = array_length(ia_queue)
							IA = false
					}
					var chunk_a = floor(a / CHUNK_WIDTH), chunk_b = floor(b / CHUNK_HEIGHT)
					if not ia_chunk_construidos[# chunk_a, chunk_b]{
						array_push(ia_chunk_construidos_array, [chunk_a, chunk_b])
						ia_chunk_construidos[# chunk_a, chunk_b] = true
					}
				}
			}
		}
		else if instruction = ia_queue_defender{
			//Crear plano
			if array_length(ia_build_queue) = 0{
				show_debug_message("Mejorando las defensas")
				var len = array_length(ia_chunk_construidos_array), flag = false, exito = true
				var temp_chunk_array = array_shuffle(ia_chunk_construidos_array)
				//Buscar chunks indefensos
				for(i = 0; i < len; i++){
					temp_complex = temp_chunk_array[i]
					a = temp_complex[0]
					b = temp_complex[1]
					if not ia_chunk_defendidos[# a, b]{
						flag = true
						break
					}
				}
				show_debug_message($"chunk en {a}, {b}")
				if flag{
					//Buscar posición libre dentro del chunk
					flag = false
					a *= CHUNK_WIDTH
					b *= CHUNK_HEIGHT
					array_resize(temp_chunk_array, 0)
					for(aa = 0; aa < CHUNK_WIDTH; aa++)
						for(bb = 0; bb < CHUNK_HEIGHT; bb++)
							array_push(temp_chunk_array, [a + aa, b + bb])
					temp_chunk_array = array_shuffle(temp_chunk_array)
					for(i = array_length(temp_chunk_array) - 1; i >= 0; i--){
						aa = temp_chunk_array[i, 0]
						bb = temp_chunk_array[i, 1]
						if ia_grid_real[# aa, bb] < infinity and check_colision(aa, bb, id_torre_basica, 0){
							array_push(ia_build_queue, [id_torre_basica, 0, aa, bb])
							temp_complex = abtoxy(aa, bb)
							flag = true
							break
						}
					}
					show_debug_message($"torre en {aa}, {bb}")
					//Crear camino
					if flag{
						var visitado = usable_grid_bool, _distances = usable_grid_real, temp_queue = array_create(0, 0), counter = 0, maxi = 6, aaa, bbb, desj, edificio
						ds_grid_clear(visitado, false)
						ds_grid_clear(_distances, infinity)
						ds_grid_set(visitado, aa, bb, true)
						array_push(temp_queue, aa, bb, 0, 0)//a, b, dis, dir
						_distances[# aa, bb] = 0
						for(counter = 0; array_length(temp_queue) > counter;){
							aaa = temp_queue[counter++]
							bbb = temp_queue[counter++]
							dis = temp_queue[counter++] + 1
							desj = temp_queue[counter++] + 5
							bmod = bbb & 1
							for(i = 0; i < maxi; i++){
								j = (i + desj) mod 6
								aa = aaa + DESFACE_A[bmod, j]
								bb = bbb + DESFACE_B[bmod, j]
								if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
									continue
								if not visitado[# aa, bb]{
									visitado[# aa, bb] = true
									if terreno_caminable[terreno[# aa, bb]]{
										_distances[# aa, bb] = dis
										if ia_grid_camino[# aa, bb]{
											edificio = edificio_id[# aa, bb]
											if j != edificio.dir{
												show_debug_message($"Enrutador en {aa}, {bb}")
												if j = (edificio.dir + 5) mod 6
												    j = (edificio.dir + 1) mod 6
												else if j = (edificio.dir + 1) mod 6
												    j = (edificio.dir + 5) mod 6
												else
												    j = edificio.dir
												array_push(ia_build_queue, [id_enrutador, j, aa, bb])
												counter = infinity
												aa = aaa
												bb = bbb
												break
											}
											visitado[# aa, bb] = false
										}
										array_push(temp_queue, aa, bb, dis, j)
									}
								}
							}
							maxi = 3
						}
						show_debug_message($"mapa de {array_length(temp_queue) / 4} tiles")
						//Se creó un camino
						if is_infinity(counter){
							var temp_complex_2, angle
							a = aa
							b = bb
							while dis > 0{
								show_debug_message($"{a}, {b}, {dis}")
								temp_complex_2 = abtoxy(a, b)
								angle = floor(point_direction(temp_complex_2[0], temp_complex_2[1], temp_complex[0], temp_complex[1]) / 30)
								flag = true
								bmod = b & 1
								for(i = 0; i < 6; i++){
									j = preset_dir[angle, i]
									aa = a + DESFACE_A[bmod, j]
									bb = b + DESFACE_B[bmod, j]
									if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
										continue
									c = _distances[# aa, bb]
									if c < dis{
										array_push(ia_build_queue, [id_cinta_transportadora, j, a, b])
										_distances[# a, b] = infinity
										a = aa
										b = bb
										dis = c
										flag = false
										break
									}
								}
								if flag{
									show_debug_message("Construcción cancelada - No pudo generar el camino específico")
									exito = false
									break
								}
							}
						}
						else{
							show_debug_message("Construcción cancelada - No encontró una ruta disponible desde la torre a algún camino")
							exito = false
						}
					}
					else{
						show_debug_message("Construcción cancelada - No encontró una posición disponible para la torre dentro del chunk")
						exito = false
					}
				}
				else{
					show_debug_message("Construcción cancelada - No encontró un chunk disponible")
					exito = false
				}
				if not exito{
					array_resize(ia_build_queue, 0)
					if ++ia_queue_count = array_length(ia_queue)
						IA = false
				}
			}
			//Construir
			else{
				temp_complex = ia_build_queue[ia_build_pos]
				var index = temp_complex[0]
				a = temp_complex[2]
				b = temp_complex[3]
				if construir(index, temp_complex[1], a, b,,, jugador_IA) != null_edificio{
					ia_grid_real[# a, b] = infinity
					if ++ia_build_pos = array_length(ia_build_queue){
						for(i = array_length(ia_build_queue) - 1; i >= 0; i--){
							temp_complex = ia_build_queue[i]
							if temp_complex[0] = id_cinta_transportadora
								ia_grid_camino[# temp_complex[2], temp_complex[3]] = true
						}
						array_resize(ia_build_queue, 0)
						ia_build_pos = 0
						if ++ia_queue_count = array_length(ia_queue)
							IA = false
					}
					var chunk_a = floor(a / CHUNK_WIDTH), chunk_b = floor(b / CHUNK_HEIGHT)
					if not ia_chunk_construidos[# chunk_a, chunk_b]{
						array_push(ia_chunk_construidos_array, [chunk_a, chunk_b])
						ia_chunk_construidos[# chunk_a, chunk_b] = true
					}
					if index = id_torre_basica
						ds_grid_set_region(ia_chunk_defendidos, max(chunk_a - 1, 0), max(chunk_b - 1, 0), min(chunk_a + 1, chunk_xsize - 1), min(chunk_b + 1, chunk_ysize - 1), true)
				}
			}
		}
	}
}