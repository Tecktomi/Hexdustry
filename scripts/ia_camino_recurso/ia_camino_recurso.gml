function ia_camino_recurso(a = 0, b = 0, rss = array_create(0, 0), _distances){
	with control{
		var i, _tag_rss = array_create(rss_max + 1, false)
		for(i = array_length(rss) - 1; i >= 0; i--)
			_tag_rss[rss[i] + 1] = true
		var aa = 0, bb = 0, j, dis, desj, bmod, maxi = 6, edificio
		var temp_queue = array_create(0, 0), visitado = ds_grid_create(xsize, ysize)
		ds_grid_clear(visitado, false)
		visitado[# a, b] = true
		array_push(temp_queue, a, b, 0, 0)//a, b, dis, dir
		_distances[# a, b] = 0
		for(var counter = 0; array_length(temp_queue) > counter;){
			a = temp_queue[counter++]
			b = temp_queue[counter++]
			dis = temp_queue[counter++] + 1
			desj = temp_queue[counter++] + 5
			bmod = b & 1
			for(i = 0; i < maxi; i++){
				j = (i + desj) mod 6
				aa = a + DESFACE_A[bmod, j]
				bb = b + DESFACE_B[bmod, j]
				if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
					continue
				if _distances[# aa, bb] = infinity and terreno_caminable[terreno[# aa, bb]]{
					_distances[# aa, bb] = dis
					if _tag_rss[ia_grid_camino[# aa, bb] + 1]{
						edificio = edificio_id[# aa, bb]
						if j != edificio.dir{
							if j = (edificio.dir + 5) mod 6
								j = (edificio.dir + 1) mod 6
							else if j = (edificio.dir + 1) mod 6
								j = (edificio.dir + 5) mod 6
							else
								j = edificio.dir
							array_push(ia_build_queue, [id_enrutador, j, aa, bb])
							ds_grid_destroy(visitado)
							return{a : aa, b : bb, done : true, salida_a : a, salida_b : b}
						}
						_distances[# aa, bb] = infinity
					}
					array_push(temp_queue, aa, bb, dis, j)
				}
			}
			maxi = 3
		}
		ds_grid_destroy(visitado)
		return {a : 0, b : 0, done : false, salida_a : 0, salida_b : 0}
	}
}