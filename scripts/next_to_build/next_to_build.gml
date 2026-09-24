function next_to_build(complex = [0, 0], edificio = control.null_edificio){
	with control{
		if complex[0] < 0 or complex[1] < 0 or complex[0] >= xsize or complex[1] >= ysize
			return false
		if not edificio_bool[# complex[0], complex[1]]
			return false
		if edificio_id[# complex[0], complex[1]] = edificio
			return true
		return false
	}
}