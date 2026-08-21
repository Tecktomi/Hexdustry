function far_from_nucleus(a, b){
	var temp_complex = abtoxy(a, b), aa = temp_complex[0], bb = temp_complex[1], i
	with control{
		for(i = 0; i < array_length(nucleos); i++)
			if distance_sqr(aa, bb, nucleos[i].center_x, nucleos[i].center_y) < 640_000
				return false
		return true
	}
}