function ia_camino_atob(origen_a, origen_b, destino_a, destino_b, _distances, _tiles_usados){
	with control{
		var temp_complex = abtoxy(destino_a, destino_b), a = origen_a, b = origen_b, dis = _distances[# a, b]
		var temp_complex_2, angle, pasos = xsize + ysize, flag, bmod, i, j, aa, bb, c
		while dis > 0 and --pasos > 0{
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
				if (aa = destino_a and bb = destino_b) or (c < dis and not edificio_bool[# aa, bb] and not _tiles_usados[# aa, bb]){
					if not edificio_bool[# a, b]{
						array_push(ia_build_queue, [id_cinta_transportadora, j, a, b])
						_tiles_usados[# a, b] = true
						_distances[# a, b] = infinity
					}
					a = aa
					b = bb
					dis = c
					flag = false
					break
				}
			}
			if flag
				return false
		}
		return true
	}
}