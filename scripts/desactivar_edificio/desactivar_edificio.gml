function desactivar_edificio(edificio = control.null_edificio){
	with control{
		if not edificio_inerte[edificio.index] and edificio.pointer >= 0{
			edificios_activos[edificio.pointer] = edificios_activos[array_length(edificios_activos) - 1]
			edificios_activos[edificio.pointer].pointer = edificio.pointer
			array_pop(edificios_activos)
			edificio.pointer = -1
		}
	}
}