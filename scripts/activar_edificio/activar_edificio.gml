function activar_edificio(edificio = control.null_edificio){
	with control{
		if not edificio_inerte[edificio.index] and edificio.pointer = -1{
			edificio.pointer = array_length(edificios_activos)
			array_push(edificios_activos, edificio)
		}
	}
}