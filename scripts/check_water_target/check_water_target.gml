function check_water_target(){
	with control{
		var _time = current_time
		var visited = ds_grid_create(xsize, ysize)
		ds_grid_clear(visited, false)
		var next_queue = array_create(0, 0)
		ds_grid_clear(grid_water_distance, infinity)
		for(var i = 0; i < array_length(nucleos); i++){
			var edificio = nucleos[i]
			for(var r = 1; r < 15; r++){
				var aa = edificio.a, bb = edificio.b
				repeat(r){
					var temp_complex = next_to(aa, bb, 4)
					aa = temp_complex[0]
					bb = temp_complex[1]
				}
				for(var j = 0; j < 6; j++)
					repeat(r){
						var temp_complex = next_to(aa, bb, j)
						aa = temp_complex[0]
						bb = temp_complex[1]
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
		show_debug_message(current_time - _time)
		_time = current_time
		while array_length(next_queue) > 0{
			var bb = array_pop(next_queue), aa = array_pop(next_queue), val = real(grid_water_distance[# aa, bb] + 1)
			ds_grid_set(visited, aa, bb, false)
			for(var i = 0; i < 6; i++){
				var temp_complex = next_to(aa, bb, i), aaa = temp_complex[0], bbb = temp_complex[1]
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
		show_debug_message(current_time - _time)
	}
}