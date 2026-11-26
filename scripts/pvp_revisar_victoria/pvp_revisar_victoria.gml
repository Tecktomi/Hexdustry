//PvP: si llegó a haber rivales y solo queda el equipo local con núcleo, mostrar la victoria
function pvp_revisar_victoria(){
	with control{
		if not (online and server_pvp and pvp_rivales) or win != 0
			exit
		var a, vivos = 0
		for(a = 2; a < EQUIPOS; a++)
			if array_length(edificios_jugador_index[a, id_nucleo]) > 0
				vivos++
		if vivos = 1 and array_length(edificios_jugador_index[jugador, id_nucleo]) > 0
			win = 1
	}
}