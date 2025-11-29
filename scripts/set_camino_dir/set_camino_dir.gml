function set_camino_dir(edificio = control.null_edificio){
	if edificio_camino[edificio.index] or in(edificio.index, 6, 16){
		var d = edificio.dir * pi / 3 + pi / 6
		if edificio.index = 16{
			edificio.array_real[0] = -cos(d)
			edificio.array_real[1] = sin(d)
		}
		else{
			edificio.array_real[0] = cos(d)
			edificio.array_real[1] = -sin(d)
		}
	}
}