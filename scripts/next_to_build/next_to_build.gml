function next_to_build(complex = [0, 0], edificio = control.null_edificio){
	if complex[0] < 0 or complex[1] < 0 or complex[0] >= xsize or complex[1] >= ysize
		return false
	if not control.edificio_bool[# complex[0], complex[1]]
		return false
	if control.edificio_id[# complex[0], complex[1]] = edificio
		return true
	return false
}