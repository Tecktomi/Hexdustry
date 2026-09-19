function ia_camino_nucleo(a, b, dis, rss, _tiles_usados){
	with control{
		var c, aa, bb, i, j, bmod, temp_complex, angle, flag = true
		var nucleo = edificios_jugador_index[jugador_IA, id_nucleo][0]
		for(var pasos = xsize + ysize; dis > 0 and --pasos > 0;){
			temp_complex = abtoxy(a, b)
			angle = floor(point_direction(temp_complex[0], temp_complex[1], nucleo.center_x, nucleo.center_y) / 30)
			bmod = b & 1
			flag = true
			//Detectar caminos al rededor
			for(i = 0; i < 6; i++){
				j = preset_dir[angle, i]
				aa = a + DESFACE_A[bmod, j]
				bb = b + DESFACE_B[bmod, j]
				if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
					continue
				if ia_grid_camino[# aa, bb] = rss{
					array_push(ia_build_queue, [id_cinta_transportadora, j, a, b])
					flag = false
					dis = 0
					break
				}
			}
			//Detectar ruta más corta
			if flag repeat(3){
				for(i = 0; i < 6; i++){
					j = preset_dir[angle, i]
					aa = a + DESFACE_A[bmod, j]
					bb = b + DESFACE_B[bmod, j]
					if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
						continue
					c = ia_grid_real[# aa, bb]
					if c < dis and (not edificio_bool[# aa, bb] or check_tile_usado(aa, bb, ia_tiles_nucleo)) and not _tiles_usados[# aa, bb]{
						array_push(ia_build_queue, [id_cinta_transportadora, j, a, b])
						_tiles_usados[# aa, bb] = true
						a = aa
						b = bb
						dis = c
						flag = false
						break
					}
				}
				if not flag
					break
				dis++
			}
			if flag
				return false
		}
		return true
	}
}