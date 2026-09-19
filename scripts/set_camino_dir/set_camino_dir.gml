function set_camino_dir(edificio = control.null_edificio){
	with control{
		if edificio_camino[edificio.index] or (edificio.index = id_tunel or edificio.index = id_tunel_salida){
			var d = edificio.dir * pi / 3 + pi / 6
			if edificio.index = id_tunel_salida{
				edificio.array_real[0] = -cos(d)
				edificio.array_real[1] = sin(d)
			}
			else{
				edificio.array_real[0] = cos(d)
				edificio.array_real[1] = -sin(d)
			}
		}
	}
}