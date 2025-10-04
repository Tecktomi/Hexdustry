function edificio_pathfind(edificio = null_edificio){
	var a = edificio.a, b = edificio.b, dir = edificio.dir, index = edificio.index
	with control{
		var visitado = ds_grid_create(xsize, ysize)
		ds_grid_clear(visitado, false)
		var temp_queue = ds_queue_create()
		var temp_list = get_size(a, b, dir, edificio_size[index]), size = ds_list_size(temp_list)
		for(var c = 0; c < size; c++){
			var temp_complex = temp_list[|c], aa = temp_complex.a, bb = temp_complex.b
			ds_grid_set(visitado, aa, bb, true)
			ds_queue_enqueue(temp_queue, {a : aa, b : bb, dis : 0, dir : 0})
			var temp_priority = ds_grid_get(edificio_cercano_priority, aa, bb)
			ds_priority_add(temp_priority, edificio, 0)
			ds_grid_set(edificio_cercano, aa, bb, edificio)
			ds_grid_set(edificio_cercano_dis, aa, bb, 0)
		}
		while not ds_queue_empty(temp_queue){
			var temp_trio = ds_queue_dequeue(temp_queue), dis = temp_trio.dis + 1, maxi = 3 + 3 * (dis = 1), desj = temp_trio.dir + 5
			for(var i = 0; i < maxi; i++){
				var j = (i + desj) mod 6, temp_complex_2 = next_to(temp_trio.a, temp_trio.b, j), aa = temp_complex_2.a, bb = temp_complex_2.b
				if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
					continue
				if not visitado[# aa, bb] and terreno_caminable[terreno[# aa, bb]]{
					ds_grid_set(visitado, aa, bb, true)
					ds_queue_enqueue(temp_queue, {a : aa, b : bb, dis : dis, dir : j})
					ds_grid_set(edificio.coordenadas_dis, aa, bb, dis)
					var temp_priority = ds_grid_get(edificio_cercano_priority, aa, bb)
					ds_priority_add(temp_priority, edificio, dis)
					if dis < edificio_cercano_dis[# aa, bb]{
						ds_grid_set(edificio_cercano_dis, aa, bb, dis)
						ds_grid_set(edificio_cercano, aa, bb, edificio)
					}
				}
			}
		}
		ds_grid_clear(edificio_cercano_dir, -1)
		size = ds_list_size(edificios_targeteables)
		for(var c = 0; c < size; c++){
			var temp_edificio = edificios_targeteables[|c]
			ds_list_clear(temp_edificio.coordenadas_close)
		}
		for(var c = 0; c < xsize; c++)
			for(var d = 0; d < ysize; d++){
				var temp_edificio = edificio_cercano[# c, d]
				ds_list_add(temp_edificio.coordenadas_close, {a : c, b : d})
			}
		ds_queue_destroy(temp_queue)
		ds_grid_destroy(visitado)
	}
}