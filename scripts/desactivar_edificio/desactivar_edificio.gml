function desactivar_edificio(edificio = control.null_edificio){
	with control{
		if not edificio_inerte[edificio.index] and not edificio.eliminar{
			edificio.eliminar = true
			array_push(edificios_pendientes, edificio)
		}
	}
}