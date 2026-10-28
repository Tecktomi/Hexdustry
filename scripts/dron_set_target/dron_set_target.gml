function dron_set_target(dron = control.null_dron, temp_array){
	with control{
		var flag = false, temp_array_edificios = array_create(0, null_edificio), i, j, _jugador = dron.jugador, edificio = null_edificio
		for(i = 0; i < array_length(temp_array); i++){
			temp_array_edificios = array_shuffle(edificios_index[temp_array[i]])
			for(j = array_length(temp_array_edificios) - 1; j >= 0; j--){
				edificio = temp_array_edificios[j]
				if not aliados[# _jugador, edificio.jugador]{
					flag = true
					break
				}
			}
			if flag
				break
		}
		dron.target = (aliados[# _jugador, edificio.jugador] ? null_edificio : edificio)
		dron.modo = DRON_TARGET
	}
}