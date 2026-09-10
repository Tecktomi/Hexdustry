function ia_start(){
	with control{
		if array_length(edificios_jugador_index[jugador_IA, id_nucleo]) > 0{
			IA = true
			ia_build_queue = array_create(0, array_create(0, 0))
			ia_build_pos = 0
			ia_queue_count = 0
			ds_grid_clear(ia_chunk_construidos, false)
			ia_chunk_construidos_array = array_create(0, [0, 0])
			ds_grid_clear(ia_chunk_defendidos, false)
			ds_grid_clear(ia_grid_camino, false)
			ds_grid_clear(ia_grid_real, infinity)
			var nucleo = edificios_jugador_index[jugador_IA, id_nucleo][0]
			var visitado = usable_grid_bool, temp_queue = array_create(0, 0), counter = 0, temp_list = get_size(nucleo.a, nucleo.b, 0, edificio_size[id_nucleo]), size = array_length(temp_list), maxi = 6
			ds_grid_clear(visitado, false)
			var a, aa, bb, dis, desj, i, j, bmod, aaa, bbb
			for(a = 0; a < size; a++){
				temp_complex = temp_list[a]
				aa = temp_complex[0]
				bb = temp_complex[1]
				ds_grid_set(visitado, aa, bb, true)
				array_push(temp_queue, aa, bb, 0, 0)//a, b, dis, dir
				ia_grid_real[# aa, bb] = 0
			}
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
					if not visitado[# aa, bb] and not edificio_bool[# aa, bb]{
						visitado[# aa, bb] = true
						if terreno_caminable[terreno[# aa, bb]]{
							ia_grid_real[# aa, bb] = dis
							a = ore[# aa, bb]
							if a >= 0
								array_push(ia_ores[a], [aa, bb])
							array_push(temp_queue, aa, bb, dis, j)
						}
					}
				}
				if dis > 1
					maxi = 3
			}
		}
		else
			IA = false
	}
}