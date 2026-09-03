function far_from_nucleus(a, b){
	var temp_complex = abtoxy(a, b), aa = temp_complex[0], bb = temp_complex[1], i, edificio
	with control{
		for(i = array_length(edificios_index[id_nucleo]) - 1; i >= 0; i--){
			edificio = edificios_index[id_nucleo, i]
			if point_distance(aa, bb, edificio.center_x, edificio.center_y) < 800
				return false
		}
		return true
	}
}