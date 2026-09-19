function ia_step(){
	with control{
		var t = get_timer()
		if array_length(edificios_jugador_index[jugador_IA, id_nucleo]) = 0{
			IA = false
			exit
		}
		array_set(jugador_recursos[jugador_IA], idr_cobre, 100)
		array_set(jugador_recursos[jugador_IA], idr_hierro, 100)
		var a = 0, b = 0, c = 0, aa = 0, bb = 0, i = 0, j = 0, temp_complex = array_create(0, 0), bmod = 0, dis = 0, dir = 0
		if array_length(ia_build_queue) = 0{
			var instruction = ia_queue[ia_queue_count], nucleo = edificios_jugador_index[jugador_IA, id_nucleo][0]
			var _tiles_usados = usable_grid_bool
			ds_grid_clear(_tiles_usados, false)
			if instruction = ia_queue_cobre or instruction = ia_queue_hierro{
				var _ore = (instruction = ia_queue_cobre ? ido_cobre : ido_hierro)
				ia_build_rss = (instruction = ia_queue_cobre ? idr_cobre : idr_hierro)
				var _struct_find_rss = ia_find_rss(_ore, _tiles_usados)
				if not _struct_find_rss.flag{
					ia_cancelar_proyecto()
					exit
				}
				if not ia_camino_nucleo(_struct_find_rss.a, _struct_find_rss.b, _struct_find_rss.dis, ia_build_rss, _tiles_usados)
					ia_cancelar_proyecto()
			}
			else if instruction = ia_queue_defender{
				var len = array_length(ia_chunk_construidos_array)
				var flag = false, temp_chunk_array = array_shuffle(ia_chunk_construidos_array)
				//Buscar chunks indefensos
				for(i = 0; i < len; i++){
					a = temp_chunk_array[i, 0]
					b = temp_chunk_array[i, 1]
					if not ia_chunk_defendidos[# a, b]{
						flag = true
						break
					}
				}
				if not flag{
					ia_cancelar_proyecto()
					exit
				}
				//Buscar posición libre dentro del chunk
				a *= CHUNK_WIDTH
				b *= CHUNK_HEIGHT
				temp_chunk_array = array_create(0, [0])
				for(aa = 0; aa < CHUNK_WIDTH; aa++)
					for(bb = 0; bb < CHUNK_HEIGHT; bb++)
						array_push(temp_chunk_array, [a + aa, b + bb])
				temp_chunk_array = array_shuffle(temp_chunk_array)
				for(i = array_length(temp_chunk_array) - 1; i >= 0; i--){
					aa = temp_chunk_array[i, 0]
					bb = temp_chunk_array[i, 1]
					if ia_grid_real[# aa, bb] < infinity and check_colision(aa, bb, id_torre_basica, 0){
						array_push(ia_build_queue, [id_torre_basica, 0, aa, bb])
						_tiles_usados[# aa, bb] = true
						temp_complex = abtoxy(aa, bb)
						flag = true
						break
					}
				}
				if not flag{
					ia_cancelar_proyecto()
					exit
				}
				//Crear camino
				var _distances = usable_grid_real
				ds_grid_clear(_distances, infinity)
				var temp_struct = ia_camino_recurso(aa, bb, [idr_cobre, idr_hierro], _distances)
				if not temp_struct.done{
					ia_cancelar_proyecto()
					exit
				}
				if not ia_camino_atob(temp_struct.a, temp_struct.b, aa, bb, _distances, _tiles_usados){
					ia_cancelar_proyecto()
					exit
				}
			}
			else if instruction = ia_queue_bronce{
				//Buscar carbón
				show_debug_message(random(1))
				var _struct_find_rss = ia_find_rss(ido_carbon, _tiles_usados)
				if not _struct_find_rss.flag{
					ia_cancelar_proyecto()
					exit
				}
				//Buscar camino más cercano
				show_debug_message(1 + random(1))
				var _distances = usable_grid_real
				ds_grid_clear(_distances, infinity)
				var _struct_enrutador = ia_camino_recurso(_struct_find_rss.a, _struct_find_rss.b, [idr_cobre], _distances)
				if not _struct_enrutador.done{
					ia_cancelar_proyecto()
					exit
				}
				var enrutador_a = _struct_enrutador.a, enrutador_b = _struct_enrutador.b
				var enrutador_salida_a = _struct_enrutador.salida_a, enrutador_salida_b = _struct_enrutador.salida_b
				//Construir Horno
				show_debug_message(2 + random(1))
				var flag = false, pasos = 6
				dis = _distances[# _struct_enrutador.a, _struct_enrutador.b]
				temp_complex = abtoxy(_struct_find_rss.a, _struct_find_rss.b)
				var temp_complex_2, angle, flag2, temp_array_arround, k, aaa, bbb, len2, flag3
				var ia_check_horno_arround = function(a, b, dir){
					if check_colision(a, b, id_horno, dir){
						var temp_array_arround = get_arround(a, b, dir, 2)
						var len2 = array_length(temp_array_arround)
						var flag3 = true
						for(var k = 0; k < len2;){
							var aaa = temp_array_arround[k++]
							var bbb = temp_array_arround[k++]
							if aaa < 0 or bbb < 0 or aaa >= xsize or bbb >= ysize
								continue
							if ia_grid_camino[# aaa, bbb] != idr_bronce and ia_grid_camino[# aaa, bbb] != -1{
								flag3 = false
								break
							}
						}
						if flag3
							return true
					}
					return false
				}
				while not flag and pasos-- > 0{
					temp_complex_2 = abtoxy(_struct_enrutador.a, _struct_enrutador.b)
					flag2 = true
					angle = floor(point_direction(temp_complex_2[0], temp_complex_2[1], temp_complex[0], temp_complex[1]) / 30)
					bmod = _struct_enrutador.b & 1
					for(i = 0; i < 6; i++){
						j = preset_dir[angle, i]
						aa = _struct_enrutador.a + DESFACE_A[bmod, j]
						bb = _struct_enrutador.b + DESFACE_B[bmod, j]
						if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
							continue
						c = _distances[# aa, bb]
						if c < dis and not edificio_bool[# aa, bb] and not _tiles_usados[# aa, bb]{
							flag2 = false
							dis = c
							if pasos < 5{
								dir = irandom(1)
								if ia_check_horno_arround(_struct_enrutador.a, _struct_enrutador.b, dir){
									flag = true
									break
								}
								else{
									dir = 1 - dir
									if ia_check_horno_arround(_struct_enrutador.a, _struct_enrutador.b, dir){
										flag = true
										break
									}
								}
							}
							_struct_enrutador.a = aa
							_struct_enrutador.b = bb
						}
					}
					if flag2
						break
				}
				if not flag{
					ia_cancelar_proyecto()
					exit
				}
				array_push(ia_build_queue, [id_horno, dir, _struct_enrutador.a, _struct_enrutador.b])
				//Limpiar terreno
				show_debug_message(3 + random(1))
				var temp_list = get_size(_struct_enrutador.a, _struct_enrutador.b, dir, edificio_size[id_horno])
				//Buscar mejor salida
				show_debug_message(4 + random(1))
				var temp_arround = get_arround(_struct_enrutador.a, _struct_enrutador.b, dir, edificio_size[id_horno])
				var len = array_length(temp_arround)
				var dis2 = infinity, nucleo_a, nucleo_b
				flag2 = false
				dis = infinity
				for(i = 0; i < len;){
					a = temp_arround[i++]
					b = temp_arround[i++]
					if a < 0 or b < 0 or a >= xsize or b >= ysize
						continue
					if not edificio_bool[# a, b] and not _tiles_usados[# a, b] and ia_grid_real[# a, b] < dis2{
						dis2 = ia_grid_real[# a, b]
						nucleo_a = a
						nucleo_b = b
						flag2 = true
					}
				}
				if not flag2{
					ia_cancelar_proyecto()
					exit
				}
				//Construir enrutador - horno
				show_debug_message(5 + random(1))
				var struct_bfs = ia_bfs([enrutador_salida_a, enrutador_salida_b], temp_list, _tiles_usados)
				if not struct_bfs.done{
					ia_cancelar_proyecto()
					ds_grid_destroy(struct_bfs.bfs)
					exit
				}
				show_debug_message(6 + random(1))
				array_push(ia_build_queue, [-1, idr_cobre])
				if not ia_camino_atob(struct_bfs.a, struct_bfs.b, enrutador_a, enrutador_b, struct_bfs.bfs, _tiles_usados){
					ia_cancelar_proyecto()
					ds_grid_destroy(struct_bfs.bfs)
					exit
				}
				//Construir carbón - horno
				show_debug_message(7 + random(1))
				var arround_taladro = get_arround(_struct_find_rss.a, _struct_find_rss.b, _struct_find_rss.dir, edificio_size[id_taladro])
				ds_grid_destroy(struct_bfs.bfs)
				struct_bfs = ia_bfs(arround_taladro, temp_list, _tiles_usados)
				if not struct_bfs.done{
					ia_cancelar_proyecto()
					ds_grid_destroy(struct_bfs.bfs)
					exit
				}
				show_debug_message(8 + random(1))
				array_push(ia_build_queue, [-1, idr_carbon])
				if not ia_camino_atob(_struct_find_rss.a, _struct_find_rss.b, aa, bb, struct_bfs.bfs, _tiles_usados){
					ia_cancelar_proyecto()
					ds_grid_destroy(struct_bfs.bfs)
					exit
				}
				//Construir chorno - núcleo
				show_debug_message(9 + random(1))
				len = array_length(temp_list)
				for(i = 0; i < len;){
					aa = temp_list[i++]
					bb = temp_list[i++]
					_tiles_usados[# aa, bb] = true
				}
				array_push(ia_build_queue, [-1, idr_bronce])
				if not ia_camino_nucleo(nucleo_a, nucleo_b, dis2, idr_bronce, _tiles_usados)
					ia_cancelar_proyecto()
				ds_grid_destroy(struct_bfs.bfs)
				show_debug_message(10 + random(1))
			}
		}
		else{
			temp_complex = ia_build_queue[ia_build_pos]
			var index = temp_complex[0]
			if index = -1{
				ia_build_rss = temp_complex[1]
				exit
			}
			if is_comprable(edificio_precio_id[index], edificio_precio_num[index], jugador_IA){
				a = temp_complex[2]
				b = temp_complex[3]
				var edificio = construir(index, temp_complex[1], a, b,,, jugador_IA)
				if edificio != null_edificio{
					if index = id_cinta_transportadora
						ia_grid_camino[# temp_complex[2], temp_complex[3]] = ia_build_rss
					if ++ia_build_pos = array_length(ia_build_queue)
						ia_cancelar_proyecto()
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
		show_debug_message(get_timer() - t)
	}
}