function dron_set_target(dron = control.null_dron, temp_array){
	with control{
		var flag = true, temp_array_edificios = array_create(0, null_edificio), i, j, _jugador = dron.jugador, edificio = null_edificio
		for(i = 0; i < array_length(temp_array); i++) if flag{
			temp_array_edificios = array_shuffle(edificios_index[temp_array[i]])
			for(j = array_length(temp_array_edificios) - 1; j >= 0; j--){
				edificio = temp_array_edificios[j]
				if edificio.jugador != _jugador{
					flag = false
					break
				}
			}
			if not flag
				break
		}
		dron.target = (edificio.jugador = _jugador ? null_edificio : edificio)
	}
}