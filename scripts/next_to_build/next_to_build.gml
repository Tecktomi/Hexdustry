function next_to_build(complex = {a : 0, b : 0}, edificio = control.null_edificio){
	if complex.a < 0 or complex.b < 0 or complex.a >= xsize or complex.b >= ysize
		return false
	if not control.edificio_bool[# complex.a, complex.b]
		return false
	if control.edificio_id[# complex.a, complex.b] = edificio
		return true
	return false
}