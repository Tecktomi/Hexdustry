function next_to_build(complex = {a : 0, b : 0}, edificio = control.null_edificio){
	if complex.a < 0 or complex.b < 0 or complex.a >= xsize or complex.b >= ysize
		return false
	if not control.terreno[complex.a, complex.b].edificio_bool
		return false
	if control.terreno[complex.a, complex.b].edificio = edificio
		return true
	return false
}