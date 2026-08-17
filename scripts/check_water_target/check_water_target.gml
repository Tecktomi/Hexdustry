function check_water_target(){
	with control{
		var visited = ds_grid_create(xsize, ysize)
		ds_grid_clear(visited, false)
		var next_queue = array_create(0, 0)
		ds_grid_clear(grid_water_distance, infinity)
		for(var i = 0; i < array_length(nucleos); i++){
			var edificio = nucleos[i]
			for(var r = 1; r < 15; r++){
				var aa = edificio.a, bb = edificio.b
				repeat(r){
					aa += DESFACE_A[bb & 1, 4]
					bb += DESFACE_B[bb & 1, 4]
				}
				for(var j = 0; j < 6; j++)
					repeat(r){
						aa += DESFACE_A[bb & 1, j]
						bb += DESFACE_B[bb & 1, j]
						if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
							continue
						if tag_agua[terreno[# aa, bb]]{
							ds_grid_set(grid_water_distance, aa, bb, 0)
							ds_grid_set(visited, aa, bb, true)
							array_push(next_queue, aa)
							array_push(next_queue, bb)
						}
					}
			}
		}
		for(var pointer = 0; pointer < array_length(next_queue); pointer++){
			var aa = next_queue[pointer++], bb = next_queue[pointer], val = real(grid_water_distance[# aa, bb] + 1), bmod = bb & 1
			ds_grid_set(visited, aa, bb, false)
			for(var i = 0; i < 6; i++){
				var aaa = aa + DESFACE_A[bmod, i], bbb = bb + DESFACE_B[bmod, i]
				if aaa < 0 or bbb < 0 or aaa >= xsize or bbb >= ysize
					continue
				if not visited[# aaa, bbb] and tag_agua[terreno[# aaa, bbb]] and val < grid_water_distance[# aaa, bbb]{
					ds_grid_set(grid_water_distance, aaa, bbb, val)
					ds_grid_set(visited, aaa, bbb, true)
					array_push(next_queue, aaa)
					array_push(next_queue, bbb)
				}
			}
		}
	}
}