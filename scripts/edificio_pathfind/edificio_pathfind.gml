function edificio_pathfind(edificio = control.null_edificio){
	with control{
		var visitado = usable_grid_bool, temp_queue = array_create(0, 0), size = array_length(edificio.coordenadas), maxi = 6
		ds_grid_clear(visitado, false)
		ds_grid_clear(edificio.coordenadas_dis, infinity)
		var c, temp_complex, aa, bb, aaa, bbb, dis, desj, i, j, counter, bmod
		for(c = 0; c < size;){
			aa = edificio.coordenadas[c++]
			bb = edificio.coordenadas[c++]
			ds_grid_set(visitado, aa, bb, true)
			array_push(temp_queue, aa, bb, 0, 0)//a, b, dis, dir
			edificio.coordenadas_dis[# aa, bb] = 0
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
				if not visitado[# aa, bb]{
					visitado[# aa, bb] = true
					if terreno_caminable[terreno[# aa, bb]] and dis < edificio.coordenadas_dis[# aa, bb]{
						array_push(temp_queue, aa, bb, dis, j)
						edificio.coordenadas_dis[# aa, bb] = dis
					}
				}
			}
			if dis > 1
				maxi = 3
		}
	}
}