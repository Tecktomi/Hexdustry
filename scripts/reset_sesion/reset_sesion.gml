function reset_sesion(){
	with control{
		var a, b, c, flag
		tutorial = 0
		mision_actual = -1
		mision_counter = 0
		modo_misiones = false
		game_mode = GAMEMODE_OLEADAS
		misiones = array_create(0, null_mision)
		oleadas = true
		mapa_editado = false
		edificios_counter = array_create(edificio_max, 0)
		mision_edificios = array_create(edificio_max, true)
		categoria_nombre_disponible = array_create(0, "")
		array_copy(categoria_nombre_disponible, 0, categoria_nombre, 0, array_length(categoria_nombre) - 1)
		categoria_edificios_disponible = array_create(0, array_create(0, 0))
		array_copy(categoria_edificios_disponible, 0, categoria_edificios, 0, array_length(categoria_edificios))
		categoria_index_disponible = array_create(0, 0)
		for(a = 0; a < array_length(categoria_nombre); a++)
			categoria_index_disponible[a] = a
		for(a = 0; a < EQUIPOS; a++){
			edificio_tecnologia[a] = array_create(edificio_max, false)
			edificio_tecnologia_desbloqueable[a] = array_create(edificio_max, false)
			for(b = array_length(tecnologia_nivel_edificios[0]) - 1; b >= 0; b--)
				array_set(edificio_tecnologia[a], tecnologia_nivel_edificios[0, b], true)
		}
		for(a = array_length(tecnologia_nivel_edificios[1]) - 1; a >= 0; a--){
			b = tecnologia_nivel_edificios[1, a]
			flag = true
			for(c = array_length(tecnologia_prev[b]) - 1; c >= 0; c--)
				if not edificio_tecnologia[jugador, tecnologia_prev[b, c]]
					flag = false
			if flag
				array_set(edificio_tecnologia_desbloqueable[jugador], b, true)
		}
	}
}