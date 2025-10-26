function activar_edificio(edificio = control.null_edificio){
	with control{
		if not edificio_inerte[edificio.index] and not edificio.agregar{
			edificio.agregar = true
			array_push(edificios_pendientes, edificio)
		}
	}
}