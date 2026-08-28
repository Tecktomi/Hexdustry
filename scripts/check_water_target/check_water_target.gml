function check_water_target(){
	with control{
		var visited = usable_grid_bool, i, edificio, r, aa, bb, j, pointer, val, bmod, aaa, bbb, next_queue = array_create(0, 0)
		ds_grid_clear(visited, false)
		ds_grid_clear(grid_water_distance, infinity)
		for(i = array_length(edificios_index[id_nucleo]) - 1; i >= 0; i--){
			edificio = edificios_index[id_nucleo][i]
			for(r = 1; r < 15; r++){
				aa = edificio.a
				bb = edificio.b
				repeat(r){
					aa += DESFACE_A[bb & 1, 4]
					bb += DESFACE_B[bb & 1, 4]
				}
				for(j = 0; j < 6; j++)
					repeat(r){
						aa += DESFACE_A[bb & 1, j]
						bb += DESFACE_B[bb & 1, j]
						if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
							continue
						if tag_agua[terreno[# aa, bb]]{
							grid_water_distance[# aa, bb] = 0
							visited[# aa, bb] = true
							array_push(next_queue, aa, bb)
						}
					}
			}
		}
		for(pointer = 0; pointer < array_length(next_queue);){
			aa = next_queue[pointer++]
			bb = next_queue[pointer++]
			val = real(grid_water_distance[# aa, bb] + 1)
			bmod = bb & 1
			visited[# aa, bb] = false
			for(i = 0; i < 6; i++){
				aaa = aa + DESFACE_A[bmod, i]
				bbb = bb + DESFACE_B[bmod, i]
				if aaa < 0 or bbb < 0 or aaa >= xsize or bbb >= ysize
					continue
				if not visited[# aaa, bbb] and tag_agua[terreno[# aaa, bbb]] and val < grid_water_distance[# aaa, bbb]{
					grid_water_distance[# aaa, bbb] = val
					visited[# aaa, bbb] = true
					array_push(next_queue, aaa,  bbb)
				}
			}
		}
	}
}