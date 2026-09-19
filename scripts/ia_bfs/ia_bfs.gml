function ia_bfs(origen, destino, _tiles_usados){
	with control{
		//BFS
		var aa = 0, bb = 0, j, dis, desj, bmod, maxi = 6, a = 0, b = 0, i = 0, len = array_length(destino), len2 = array_length(origen), k, aaa, bbb
		var temp_queue = array_create(0, 0), distancia = ds_grid_create(xsize, ysize)
		ds_grid_clear(distancia, infinity)
		for(i = 0; i < len;){
			aa = destino[i++]
			bb = destino[i++]
			distancia[# aa, bb] = 0
			array_push(temp_queue, aa, bb, 0, 0)
		}
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
				if distancia[# aa, bb] = infinity and not _tiles_usados[# aa, bb] and not edificio_bool[# aa, bb] and terreno_caminable[terreno[# aa, bb]]{
					distancia[# aa, bb] = dis
					array_push(temp_queue, aa, bb, dis, j)
					for(k = 0; k < len2;){
						aaa = origen[k++]
						bbb = origen[k++]
						if aa = aaa and bb = bbb
							return {done : true, bfs : distancia, a : aa, b : bb}
					}
				}
			}
			if dis > 0
				maxi = 3
		}
		return {done : false, bfs : distancia, a : 0, b : 0}
	}
}